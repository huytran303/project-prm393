import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';
import '../../auth/application/auth_providers.dart';
import '../../pos/application/pos_providers.dart';
import '../application/barista_controller.dart';
import '../application/barista_providers.dart';
import '../application/barista_rules.dart';

class BaristaQueueScreen extends ConsumerStatefulWidget {
  const BaristaQueueScreen({super.key});
  @override
  ConsumerState<BaristaQueueScreen> createState() => _BaristaQueueScreenState();
}

class _BaristaQueueScreenState extends ConsumerState<BaristaQueueScreen> {
  late final Timer _ticker;
  final _player = AudioPlayer();
  final Set<String> _finishedHere = {};

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) => setState(() {}));
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(const []);
    _ticker.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _start(Order o) async {
    final ok = await ref.read(baristaControllerProvider.notifier).start(o.id);
    if (!ok) _showError();
  }

  Future<void> _done(Order o) async {
    final controller = ref.read(baristaControllerProvider.notifier);
    _finishedHere.add(o.id);
    if (!await controller.done(o.id)) return _showError();
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        duration: const Duration(seconds: 5),
        content: Text('Đơn ${o.code} đã xong'),
        action: SnackBarAction(label: 'Hoàn tác', onPressed: () => controller.undoDone(o.id)),
      ));
  }

  void _showError() {
    if (mounted) showMessage(context, ErrorMapper.message(ref.read(baristaControllerProvider).error));
  }

  /// An order that left the queue without "Xong" here may have been cancelled.
  Future<void> _noticeRemoved(List<Order> prev, List<Order> next) async {
    final ids = next.map((o) => o.id).toSet();
    for (final o in prev.where((o) => !ids.contains(o.id) && !_finishedHere.remove(o.id))) {
      final fresh = await ref.read(orderRepositoryProvider).watchOrder(o.id).first;
      if (fresh.status == OrderStatus.cancelled && mounted) {
        showMessage(context, 'Đơn ${o.code}: Đã hủy');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(queueProvider, (previous, next) {
      final prev = previous?.valueOrNull;
      final list = next.valueOrNull;
      if (prev == null || list == null) return;
      if (shouldBeep(prev, list)) _player.play(AssetSource('sounds/beep.wav'));
      _noticeRemoved(prev, list);
    });
    final user = ref.watch(currentUserProvider).valueOrNull;
    final late = ref.watch(shopSettingsProvider).valueOrNull?.lateOrderMinutes ?? 10;
    final names = ref.watch(tableNamesProvider);
    final isWide = MediaQuery.sizeOf(context).width >= 600;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(isWide ? 1.3 : 1)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hàng đợi pha chế'),
          actions: [
            if (isWide)
              Center(
                child: Text('🔈 Âm báo bật · ${user?.name.split(' ').last ?? ''}',
                    style: const TextStyle(color: AppColors.muted, fontSize: 13)),
              ),
            IconButton(
              tooltip: 'Ca làm của tôi',
              icon: const Icon(Icons.timer_outlined),
              onPressed: () => context.push(Routes.shift),
            ),
            IconButton(
              tooltip: 'Tài khoản',
              icon: const Icon(Icons.person_outline),
              onPressed: () => context.push(Routes.profile),
            ),
          ],
        ),
        body: Column(children: [
          const OfflineBanner(),
          Expanded(
            child: AsyncBody(ref.watch(queueProvider), retry: queueProvider, builder: (orders) {
              final pending = orders.where((o) => o.status == OrderStatus.pending).toList();
              final preparing = orders.where((o) => o.status == OrderStatus.preparing).toList();
              Widget column(String title, List<Order> list, String action, void Function(Order) onTap, bool filled) =>
                  _QueueColumn(
                    title: title,
                    orders: list,
                    names: names,
                    lateMinutes: late,
                    action: action,
                    filled: filled,
                    onAction: onTap,
                  );
              final left = column('Chờ pha', pending, 'Bắt đầu', _start, true);
              final right = column('Đang pha', preparing, 'Xong', _done, false);
              return Padding(
                padding: pagePadding,
                child: Flex(
                  direction: isWide ? Axis.horizontal : Axis.vertical,
                  children: [Expanded(child: left), const SizedBox(width: 12, height: 12), Expanded(child: right)],
                ),
              );
            }),
          ),
        ]),
      ),
    );
  }
}

class _QueueColumn extends StatelessWidget {
  const _QueueColumn({
    required this.title,
    required this.orders,
    required this.names,
    required this.lateMinutes,
    required this.action,
    required this.filled,
    required this.onAction,
  });
  final String title;
  final List<Order> orders;
  final Map<String, String> names;
  final int lateMinutes;
  final String action;
  final bool filled;
  final void Function(Order) onAction;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(color: AppColors.fill, borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16))),
            Text('${orders.length}', style: const TextStyle(color: AppColors.muted)),
          ]),
          const SizedBox(height: 8),
          Expanded(
            child: orders.isEmpty
                ? const EmptyView('Không có đơn')
                : ListView.separated(
                    itemCount: orders.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (_, i) => _OrderCard(
                      order: orders[i],
                      place: names.labelFor(orders[i]),
                      lateMinutes: lateMinutes,
                      action: action,
                      filled: filled,
                      onAction: () => onAction(orders[i]),
                    ),
                  ),
          ),
        ]),
      );
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.place,
    required this.lateMinutes,
    required this.action,
    required this.filled,
    required this.onAction,
  });
  final Order order;
  final String place;
  final int lateMinutes;
  final String action;
  final bool filled;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final (current, earlier) = visibleItems(order);
    final isAddOn = earlier.isNotEmpty;
    final overdue = isLate(order, now, lateMinutes);
    final minutes = order.createdAt == null ? 0 : now.difference(order.createdAt!).inMinutes;
    final content = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: Text('$place · ${order.code}${isAddOn ? ' · Món thêm' : ''}',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        ),
        Text('⏱ $minutes phút${overdue ? ' — trễ' : ''}',
            style: TextStyle(
                fontWeight: overdue ? FontWeight.w700 : null, color: overdue ? AppColors.red : null, fontSize: 13)),
      ]),
      const SizedBox(height: 4),
      if (isAddOn)
        Text(
          '▸ Lượt trước (${earlier.map((i) => '${i.qty}× ${i.name} ${i.size}').join(', ')})',
          style: const TextStyle(fontStyle: FontStyle.italic, color: AppColors.muted, fontSize: 13),
        ),
      for (final i in current)
        Text.rich(TextSpan(children: [
          TextSpan(text: '${i.qty}× ${i.name} '),
          TextSpan(text: i.size, style: const TextStyle(fontWeight: FontWeight.w700)),
          if (i.toppings.isNotEmpty) TextSpan(text: ' + ${i.toppings.map((t) => t.name).join(', ')}'),
          if (i.note.isNotEmpty) TextSpan(text: ' — ${i.note}', style: const TextStyle(fontStyle: FontStyle.italic)),
        ])),
      const SizedBox(height: 8),
      if (filled)
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(48, 44)),
          onPressed: onAction,
          child: Text(action),
        )
      else
        OutlinedButton(
          style: OutlinedButton.styleFrom(minimumSize: const Size(48, 44)),
          onPressed: onAction,
          child: Text(action),
        ),
    ]);
    return isAddOn
        ? Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: DashedBox(child: content),
          )
        : OutlineCard(child: content);
  }
}
