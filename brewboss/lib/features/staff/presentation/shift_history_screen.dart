import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme.dart';
import '../../../core/utils/date_range.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/messages.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';
import '../../auth/application/auth_providers.dart';
import '../application/staff_providers.dart';
import '../application/staff_rules.dart';

final _rangeProvider = StateProvider.autoDispose((_) => DateRange.thisWeek());
final _onlyDiffProvider = StateProvider.autoDispose((_) => false);
final _staffFilterProvider = StateProvider.autoDispose<String?>((_) => null);

/// Opens a Material range picker; the result is converted to a half-open range.
Future<DateRange?> pickRange(BuildContext context, DateRange current) async {
  final picked = await showDateRangePicker(
    context: context,
    firstDate: DateTime(2024),
    lastDate: DateTime.now().add(const Duration(days: 365)),
    initialDateRange: DateTimeRange(start: current.from, end: current.lastDay),
  );
  if (picked == null) return null;
  final end = picked.end;
  return DateRange(picked.start, DateTime(end.year, end.month, end.day + 1));
}

class ShiftHistoryScreen extends ConsumerWidget {
  const ShiftHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isManager = ref.watch(currentUserProvider).valueOrNull?.role == UserRole.manager;
    if (!isManager) {
      return Scaffold(appBar: AppBar(title: const Text('Giao ca')), body: const _Tab(handoverOnly: true));
    }
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lịch sử ca làm'),
          bottom: const TabBar(tabs: [Tab(text: 'Lịch sử ca'), Tab(text: 'Giao ca')]),
        ),
        body: const TabBarView(children: [_Tab(handoverOnly: false), _Tab(handoverOnly: true)]),
      ),
    );
  }
}

class _Tab extends ConsumerWidget {
  const _Tab({required this.handoverOnly});
  final bool handoverOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(_rangeProvider);
    final onlyDiff = ref.watch(_onlyDiffProvider);
    final staffFilter = ref.watch(_staffFilterProvider);
    return AsyncBody(ref.watch(shiftsProvider(range)), retry: shiftsProvider(range), builder: (all) {
      final names = {for (final s in all) s.userId: s.userName};
      var shifts = all.where((s) => staffFilter == null || s.userId == staffFilter).toList();
      if (handoverOnly) {
        shifts = shifts.where((s) => s.userRole.handlesCash).toList();
      }
      if (onlyDiff) {
        shifts = shifts.where((s) => (s.cashDiff ?? 0) != 0).toList()
          ..sort((a, b) => a.cashDiff!.compareTo(b.cashDiff!));
      }
      final closed = shifts.where((s) => s.checkOut != null);
      return ListView(padding: pagePadding, children: [
        Row(children: [
          Expanded(
            child: DropdownButtonFormField<String?>(
              isExpanded: true,
              initialValue: staffFilter,
              items: [
                const DropdownMenuItem(value: null, child: Text('Tất cả nhân viên', overflow: TextOverflow.ellipsis)),
                for (final e in names.entries)
                  DropdownMenuItem(value: e.key, child: Text(e.value, overflow: TextOverflow.ellipsis)),
              ],
              onChanged: (v) => ref.read(_staffFilterProvider.notifier).state = v,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border), textStyle: const TextStyle(fontSize: 14)),
              icon: const Icon(Icons.calendar_month_outlined, size: 18),
              label: Text('${formatDayMonth(range.from)} – ${formatDayMonth(range.lastDay)}'),
              onPressed: () async {
                final picked = await pickRange(context, range);
                if (picked != null) ref.read(_rangeProvider.notifier).state = picked;
              },
            ),
          ),
        ]),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          dense: true,
          title: const Text('Chỉ hiện ca lệch tiền', style: TextStyle(fontSize: 15)),
          value: onlyDiff,
          onChanged: (v) => ref.read(_onlyDiffProvider.notifier).state = v ?? false,
        ),
        if (handoverOnly)
          _PeriodTotals(closed.toList())
        else
          _TotalHours(closed.toList()),
        const SectionLabel('CHI TIẾT'),
        if (shifts.isEmpty) EmptyView(msg('MSG10')),
        for (final s in shifts) _ShiftRow(s),
      ]);
    });
  }
}

class _TotalHours extends StatelessWidget {
  const _TotalHours(this.shifts);
  final List<Shift> shifts;
  @override
  Widget build(BuildContext context) {
    final totals = <String, Duration>{};
    for (final s in shifts) {
      totals[s.userName] = (totals[s.userName] ?? Duration.zero) + shiftDuration(s, DateTime.now());
    }
    if (totals.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionLabel('TỔNG GIỜ LÀM'),
      OutlineCard(
        child: Column(children: [
          for (final e in totals.entries) InfoRow(e.key, formatHours(e.value), bold: true),
        ]),
      ),
    ]);
  }
}

class _PeriodTotals extends StatelessWidget {
  const _PeriodTotals(this.shifts);
  final List<Shift> shifts;
  @override
  Widget build(BuildContext context) => OutlineCard(
        child: Column(children: [
          InfoRow('Tiền mặt', formatVnd(shifts.fold(0, (a, s) => a + s.cashSales))),
          InfoRow('VietQR', formatVnd(shifts.fold(0, (a, s) => a + s.qrSales))),
          InfoRow('Chênh lệch ròng', formatVnd(shifts.fold(0, (a, s) => a + (s.cashDiff ?? 0))), bold: true),
        ]),
      );
}

class _ShiftRow extends StatelessWidget {
  const _ShiftRow(this.s);
  final Shift s;
  @override
  Widget build(BuildContext context) {
    final start = s.checkIn ?? DateTime.now();
    final open = s.checkOut == null;
    final times = open
        ? '${formatDayMonth(start)} · ${formatTime(start)} – đang làm'
        : '${formatDayMonth(start)} · ${formatTime(start)} – ${formatTime(s.checkOut!)}';
    const small = TextStyle(color: AppColors.muted, fontSize: 13);
    final diff = s.cashDiff;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.userName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              Text(times, style: small),
            ]),
          ),
          open
              ? const StatusBadge('Đang trong ca', style: BadgeStyle.dark)
              : Text(formatHours(shiftDuration(s, DateTime.now())), style: const TextStyle(fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 3),
        if (!s.userRole.handlesCash)
          const Text('Pha chế · không giữ tiền', style: small)
        else if (open)
          Text('Đầu ca ${formatVnd(s.openingCash ?? 0)}', style: small)
        else ...[
          Text('Đầu ca ${formatNumber(s.openingCash ?? 0)} · Tiền mặt ${formatNumber(s.cashSales)} · CK ${formatNumber(s.qrSales)}',
              style: small),
          Row(children: [
            Expanded(
              child: Text('Dự kiến ${formatNumber(s.expectedCash ?? 0)} · Đếm được ${formatNumber(s.closingCash ?? 0)}', style: small),
            ),
            Text(
              diff == null || diff == 0 ? 'Khớp' : '${diff < 0 ? 'Thiếu' : 'Thừa'} ${formatVnd(diff.abs())}',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: (diff ?? 0) == 0 ? null : AppColors.red),
            ),
          ]),
          if ((s.handoverNote ?? '').isNotEmpty) Text('Ghi chú: ${s.handoverNote}', style: small),
        ],
      ]),
    );
  }
}
