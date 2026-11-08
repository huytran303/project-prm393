import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/messages.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/application/login_controller.dart';
import '../application/my_shift_controller.dart';
import '../application/staff_providers.dart';
import '../application/staff_rules.dart';
import 'handover_screen.dart';

class MyShiftScreen extends ConsumerWidget {
  const MyShiftScreen({super.key, this.logoutAfter = false});

  /// Set by "Check-out và đăng xuất" (UC02).
  final bool logoutAfter;

  Future<void> _end(BuildContext context, WidgetRef ref, Shift shift, AppUser user) async {
    bool done;
    if (user.role.handlesCash) {
      done = await Navigator.of(context).push<bool>(
              MaterialPageRoute(builder: (_) => HandoverScreen(shift: shift))) ??
          false;
    } else {
      done = await confirmDialog(context, title: 'Kết thúc ca?', confirm: 'Kết thúc ca') &&
          await ref.read(myShiftControllerProvider.notifier).checkOut(shift.id, null, null);
    }
    if (done && logoutAfter) await ref.read(loginControllerProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).valueOrNull;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: const Text('Ca làm của tôi'),
      ),
      body: AsyncBody(ref.watch(openShiftProvider), retry: openShiftProvider, builder: (open) {
        if (user == null) return const LoadingView();
        return ListView(padding: pagePadding, children: [
          if (open != null) ...[
            _InShiftCard(shift: open),
            const SizedBox(height: 12),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.red),
              onPressed: () => _end(context, ref, open, user),
              child: const Text('Kết thúc ca'),
            ),
          ] else
            _CheckInCard(user: user),
          const SectionLabel('CÁC CA GẦN ĐÂY'),
          AsyncBody(ref.watch(recentShiftsProvider), retry: recentShiftsProvider, builder: (shifts) {
            final closed = shifts.where((s) => s.checkOut != null && s.checkIn != null).toList();
            if (closed.isEmpty) return EmptyView(msg('MSG10'));
            return Column(children: [
              for (final s in closed)
                ListRow(
                  title: formatDate(s.checkIn!),
                  subtitle: '${formatTime(s.checkIn!)} – ${formatTime(s.checkOut!)}',
                  trailing: Text(formatHours(shiftDuration(s, DateTime.now())),
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
            ]);
          }),
        ]);
      }),
    );
  }
}

class _InShiftCard extends StatefulWidget {
  const _InShiftCard({required this.shift});
  final Shift shift;
  @override
  State<_InShiftCard> createState() => _InShiftCardState();
}

class _InShiftCardState extends State<_InShiftCard> {
  late final Timer _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.shift;
    final now = DateTime.now();
    final opening = s.openingCash == null ? '' : ' · Đầu ca ${formatVnd(s.openingCash!)}';
    return OutlineCard(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        const StatusBadge('Đang trong ca', style: BadgeStyle.dark),
        const SizedBox(height: 10),
        Text('Vào ca lúc ${formatTime(s.checkIn ?? now)}$opening',
            textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted)),
        const SizedBox(height: 6),
        Text(formatClock(shiftDuration(s, now)), style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text(formatWeekdayDate(now), style: const TextStyle(color: AppColors.muted, fontSize: 13)),
      ]),
    );
  }
}

class _CheckInCard extends ConsumerStatefulWidget {
  const _CheckInCard({required this.user});
  final AppUser user;
  @override
  ConsumerState<_CheckInCard> createState() => _CheckInCardState();
}

class _CheckInCardState extends ConsumerState<_CheckInCard> {
  final _formKey = GlobalKey<FormState>();
  final _cash = TextEditingController();

  Future<void> _checkIn() async {
    final cashRole = widget.user.role.handlesCash;
    if (cashRole && !_formKey.currentState!.validate()) return;
    final controller = ref.read(myShiftControllerProvider.notifier);
    final ok = await controller.checkIn(cashRole ? parseMoney(_cash.text) : null);
    if (!ok && mounted) showMessage(context, ErrorMapper.message(ref.read(myShiftControllerProvider).error));
  }

  @override
  Widget build(BuildContext context) => Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          OutlineCard(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              const StatusBadge('Chưa vào ca'),
              const SizedBox(height: 8),
              const Text('--:--:--', style: TextStyle(fontSize: 42, fontWeight: FontWeight.w700, color: AppColors.muted)),
              const SizedBox(height: 6),
              Text(formatWeekdayDate(DateTime.now()), style: const TextStyle(color: AppColors.muted, fontSize: 13)),
            ]),
          ),
          const SizedBox(height: 12),
          if (widget.user.role.handlesCash) ...[
            LabeledField(
              label: 'Tiền đầu ca (tiền trong két)',
              child: MoneyField(controller: _cash, validator: validateMoney),
            ),
            Wrap(spacing: 6, runSpacing: 6, children: [
              for (final v in const [0, 300000, 500000, 1000000])
                Pill(label: formatNumber(v), onTap: () => _cash.text = formatNumber(v)),
            ]),
            const SizedBox(height: 8),
            const Text('Đếm tiền trong két trước khi vào ca. Tài khoản Pha chế không cần nhập.',
                style: TextStyle(color: AppColors.muted, fontSize: 13)),
            const SizedBox(height: 12),
          ],
          FilledButton(
            onPressed: ref.watch(myShiftControllerProvider).isLoading ? null : _checkIn,
            child: const Text('Vào ca'),
          ),
        ]),
      );
}
