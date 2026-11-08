import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme.dart';
import '../../../core/utils/date_range.dart';
import '../../../core/utils/format.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';
import '../../auth/application/auth_providers.dart';
import '../../pos/application/pos_providers.dart';
import '../../pos/presentation/receipt.dart';
import '../../staff/application/staff_providers.dart';
import '../../staff/presentation/shift_history_screen.dart' show pickRange;
import '../application/report_providers.dart';

/// S20: filters are held locally; [initialRange] comes from a report bar tap.
class OrderHistoryScreen extends ConsumerStatefulWidget {
  const OrderHistoryScreen({super.key, this.initialRange});
  final DateRange? initialRange;
  @override
  ConsumerState<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends ConsumerState<OrderHistoryScreen> {
  late DateRange _range = widget.initialRange ?? DateRange.today();
  OrderStatus? _status;
  String? _cashier;

  String _cashierOf(Order o) => o.paidBy ?? o.confirmedBy ?? o.createdBy;

  @override
  Widget build(BuildContext context) {
    final provider = historyProvider(_range);
    final names = ref.watch(staffNamesProvider);
    final tables = ref.watch(tableNamesProvider);
    final isToday = _range == DateRange.today();
    return Scaffold(
      appBar: AppBar(title: const Text('Lịch sử đơn hàng')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              Pill(
                selected: true,
                label: isToday ? 'Hôm nay' : '${formatDayMonth(_range.from)} – ${formatDayMonth(_range.lastDay)}',
                onTap: () async {
                  final picked = await pickRange(context, _range);
                  if (picked != null) setState(() => _range = picked);
                },
              ),
              const SizedBox(width: 6),
              PopupMenuButton<OrderStatus?>(
                onSelected: (s) => setState(() => _status = s),
                itemBuilder: (_) => [
                  const PopupMenuItem(value: null, child: Text('Tất cả')),
                  for (final s in OrderStatus.values) PopupMenuItem(value: s, child: Text(s.label)),
                ],
                child: IgnorePointer(child: Pill(label: '${_status?.label ?? 'Trạng thái'} ▾')),
              ),
              const SizedBox(width: 6),
              PopupMenuButton<String?>(
                onSelected: (c) => setState(() => _cashier = c),
                itemBuilder: (_) => [
                  const PopupMenuItem(value: null, child: Text('Tất cả')),
                  for (final e in names.entries) PopupMenuItem(value: e.key, child: Text(e.value)),
                ],
                child: IgnorePointer(child: Pill(label: '${names[_cashier] ?? 'Thu ngân'} ▾')),
              ),
            ]),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: AsyncBody(ref.watch(provider), retry: provider, builder: (all) {
              final rows = all
                  .where((o) => _status == null || o.status == _status)
                  .where((o) => _cashier == null || _cashierOf(o) == _cashier)
                  .toList();
              if (rows.isEmpty) return const EmptyView('Không có đơn nào khớp bộ lọc');
              final paidTotal = rows.where((o) => o.status == OrderStatus.paid).fold(0, (s, o) => s + o.total);
              return ListView(children: [
                for (final o in rows)
                  _Row(
                    order: o,
                    place: tables.labelFor(o),
                    cashier: names[_cashierOf(o)] ?? (o.source == OrderSource.customer ? 'Khách đặt' : ''),
                    onTap: () => _showDetail(context, o, tables.labelFor(o), names),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: InfoRow('${rows.length} đơn', formatVnd(paidTotal), bold: true, size: 17),
                ),
              ]);
            }),
          ),
        ]),
      ),
    );
  }

  void _showDetail(BuildContext context, Order o, String place, Map<String, String> names) {
    final shop = ref.read(shopSettingsProvider).valueOrNull ?? const ShopSettings();
    String who(String? uid) => names[uid] ?? '';
    showAppSheet<void>(
      context,
      (ctx) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
        SheetTitle('${o.code} · $place'),
        OutlineCard(
          child: Column(children: [
            for (final i in o.items) InfoRow(i.label, formatVnd(i.lineTotal)),
            const Divider(height: 16),
            if (o.voucherCode != null) InfoRow('Voucher (${o.voucherCode})', '−${formatVnd(o.discount)}'),
            if (o.pointsRedeemed > 0) InfoRow('Đổi điểm', '${o.pointsRedeemed} điểm'),
            if (o.status == OrderStatus.paid) ...[
              InfoRow('Tiền mặt', formatVnd(o.cashAmount)),
              InfoRow('Chuyển khoản', formatVnd(o.qrAmount)),
            ],
            InfoRow('Tổng', formatVnd(o.total), bold: true),
          ]),
        ),
        const SizedBox(height: 8),
        if (o.cancelReason != null) Text('Lý do hủy: ${o.cancelReason} · ${who(o.cancelledBy)}', style: const TextStyle(color: AppColors.red)),
        if (o.createdAt != null) Text('Tạo lúc ${formatDayTime(o.createdAt!)} · ${who(o.createdBy)}', style: const TextStyle(color: AppColors.muted, fontSize: 13)),
        if (o.confirmedAt != null) Text('Xác nhận lúc ${formatDayTime(o.confirmedAt!)} · ${who(o.confirmedBy)}', style: const TextStyle(color: AppColors.muted, fontSize: 13)),
        if (o.paidAt != null) Text('Thanh toán lúc ${formatDayTime(o.paidAt!)} · ${who(o.paidBy)}', style: const TextStyle(color: AppColors.muted, fontSize: 13)),
        if (o.status == OrderStatus.paid) ...[
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              showReceipt(context, o, shop, place);
            },
            child: const Text('Hóa đơn'),
          ),
        ],
      ]),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.order, required this.place, required this.cashier, required this.onTap});
  final Order order;
  final String place;
  final String cashier;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final o = order;
    final method = o.status != OrderStatus.paid
        ? null
        : o.cashAmount > 0 && o.qrAmount > 0
            ? 'Kết hợp'
            : o.qrAmount > 0
                ? 'Chuyển khoản'
                : 'Tiền mặt';
    final parts = [
      if (o.createdAt != null) formatTime(o.createdAt!),
      if (cashier.isNotEmpty) cashier,
      ?method,
      if (o.cancelReason != null) 'Lý do: ${o.cancelReason}',
    ];
    final badge = switch (o.status) {
      OrderStatus.paid => BadgeStyle.dark,
      OrderStatus.cancelled => BadgeStyle.red,
      _ => BadgeStyle.light,
    };
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text.rich(TextSpan(children: [
                TextSpan(text: o.code, style: const TextStyle(fontWeight: FontWeight.w700)),
                TextSpan(text: ' · $place'),
              ])),
              const SizedBox(height: 3),
              Text(parts.join(' · '), style: const TextStyle(color: AppColors.muted, fontSize: 13)),
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(formatVnd(o.total), style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            StatusBadge(o.status.label, style: badge),
          ]),
        ]),
      ),
    );
  }
}
