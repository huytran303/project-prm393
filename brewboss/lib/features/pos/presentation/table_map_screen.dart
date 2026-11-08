import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/messages.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';
import '../../auth/application/auth_providers.dart';
import '../application/order_controller.dart';
import '../application/pos_providers.dart';

String _minutes(Order o) {
  final at = o.createdAt;
  return at == null ? '0 phút' : '${DateTime.now().difference(at).inMinutes} phút';
}

/// App bar actions shared by every staff home: my shift and profile (SRS 3.1.1).
List<Widget> staffHomeActions(BuildContext context, AppUser? user) => [
      IconButton(
        tooltip: 'Ca làm của tôi',
        icon: const Icon(Icons.timer_outlined),
        onPressed: () => context.push(Routes.shift),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 12),
        child: InitialAvatar(user?.name ?? '', size: 40, onTap: () => context.push(Routes.profile)),
      ),
    ];

class TableMapScreen extends ConsumerStatefulWidget {
  const TableMapScreen({super.key});
  @override
  ConsumerState<TableMapScreen> createState() => _TableMapScreenState();
}

class _TableMapScreenState extends ConsumerState<TableMapScreen> {
  late final Timer _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }

  void _newTakeaway() => context.push('${Routes.order('new')}?takeaway=1');

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).valueOrNull;
    final orders = ref.watch(openOrdersProvider).valueOrNull ?? const <Order>[];
    return AsyncBody(ref.watch(tablesProvider), retry: tablesProvider, builder: (tables) {
      final areas = tables.map((t) => t.area).toSet().toList();
      final takeaways = orders.where((o) => o.isTakeaway).toList();
      return DefaultTabController(
        key: ValueKey(areas.join('|')),
        length: areas.length + 1,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Sơ đồ bàn'),
            actions: staffHomeActions(context, user),
            bottom: TabBar(
              isScrollable: areas.length > 2,
              tabs: [for (final a in areas) Tab(text: a), Tab(text: 'Mang đi (${takeaways.length})')],
            ),
          ),
          bottomNavigationBar: BottomBar(
            child: FilledButton.icon(
              onPressed: _newTakeaway,
              icon: const Icon(Icons.local_cafe_outlined),
              label: const Text('Đơn mang đi'),
            ),
          ),
          body: Column(children: [
            const OfflineBanner(),
            _Alerts(orders: orders, tables: tables),
            Expanded(
              child: TabBarView(children: [
                for (final a in areas)
                  _AreaGrid(tables: tables.where((t) => t.area == a).toList(), orders: orders),
                _TakeawayList(orders: takeaways, onCreate: _newTakeaway),
              ]),
            ),
          ]),
        ),
      );
    });
  }
}

/// Awaiting QR requests and ready orders: the in-app fallback of UC31.
class _Alerts extends StatelessWidget {
  const _Alerts({required this.orders, required this.tables});
  final List<Order> orders;
  final List<CafeTable> tables;

  @override
  Widget build(BuildContext context) {
    final names = {for (final t in tables) t.id: t.name};
    String place(Order o) => o.tableId == null ? 'Mang đi' : 'Bàn ${names[o.tableId] ?? ''}';
    final awaiting = orders.where((o) => o.status == OrderStatus.awaiting).toList();
    final ready = orders.where((o) => o.status == OrderStatus.ready).toList();
    if (awaiting.isEmpty && ready.isEmpty) return const SizedBox.shrink();
    Widget banner(Color color, IconData icon, InlineSpan text, Order o) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: DashedBox(
            color: color,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(children: [
              Icon(icon, size: 18),
              const SizedBox(width: 6),
              Expanded(child: Text.rich(text, style: const TextStyle(fontSize: 14))),
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: const Size(56, 38)),
                onPressed: () => context.push(Routes.order(o.id)),
                child: const Text('Xem', style: TextStyle(fontSize: 14)),
              ),
            ]),
          ),
        );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(children: [
        for (final o in awaiting)
          banner(
            AppColors.ink,
            Icons.notifications_outlined,
            TextSpan(children: [
              TextSpan(text: '${place(o)} · Khách tự đặt', style: const TextStyle(fontWeight: FontWeight.w700)),
              const TextSpan(text: ' — chờ xác nhận'),
            ]),
            o,
          ),
        for (final o in ready)
          banner(AppColors.ink, Icons.check_circle_outline,
              TextSpan(text: msg('MSG34', {'shortId': o.code, 'table': place(o)})), o),
      ]),
    );
  }
}

class _AreaGrid extends StatelessWidget {
  const _AreaGrid({required this.tables, required this.orders});
  final List<CafeTable> tables;
  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
    final byId = {for (final o in orders) o.id: o};
    return ListView(padding: pagePadding, children: [
      const Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(children: [
          _Legend(color: Colors.white, label: 'Trống'),
          SizedBox(width: 16),
          _Legend(color: AppColors.busy, label: 'Có khách'),
          SizedBox(width: 16),
          _Legend(color: AppColors.ink, label: 'Chờ thanh toán'),
        ]),
      ),
      GridView.count(
        crossAxisCount: MediaQuery.sizeOf(context).width >= 600 ? 5 : 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.25,
        children: [
          for (final t in tables)
            _TableTile(
              table: t,
              order: byId[t.currentOrderId],
              awaiting: orders.where((o) => o.tableId == t.id && o.status == OrderStatus.awaiting).firstOrNull,
            ),
        ],
      ),
    ]);
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});
  final Color color;
  final String label;
  @override
  Widget build(BuildContext context) => Row(children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
              color: color, border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
      ]);
}

class _TableTile extends StatelessWidget {
  const _TableTile({required this.table, this.order, this.awaiting});
  final CafeTable table;
  final Order? order;
  final Order? awaiting;

  @override
  Widget build(BuildContext context) {
    final o = order;
    final waitingPay = o?.status == OrderStatus.served;
    final bg = o == null ? Colors.white : (waitingPay ? AppColors.ink : AppColors.busy);
    final fg = waitingPay ? Colors.white : AppColors.text;
    final onlyAwaiting = o == null && awaiting != null;
    final title = TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: onlyAwaiting ? AppColors.red : fg);
    final small = TextStyle(fontSize: 13, color: onlyAwaiting ? AppColors.red : fg);
    final content = Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(table.name, style: title),
      if (onlyAwaiting)
        Text('Chờ xác nhận', style: small)
      else if (o == null)
        Text('Trống', style: small)
      else ...[
        Text(o.code, style: small),
        Text(waitingPay ? formatVnd(o.total) : _minutes(o), style: small),
        if (o.status == OrderStatus.ready)
          const Text('Sẵn sàng', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        if (awaiting != null) Text('+ Chờ xác nhận', style: TextStyle(fontSize: 11, color: waitingPay ? Colors.white : AppColors.red)),
      ],
    ]);
    void open() {
      if (onlyAwaiting) {
        context.push(Routes.order(awaiting!.id));
      } else if (o != null && awaiting != null) {
        // Add-on request waiting on an occupied table: review it first.
        context.push(Routes.order(awaiting!.id));
      } else if (o != null) {
        context.push(Routes.order(o.id));
      } else {
        context.push('${Routes.order('new')}?table=${table.id}');
      }
    }

    if (onlyAwaiting) {
      return InkWell(
        onTap: open,
        child: DashedBox(color: AppColors.red, padding: EdgeInsets.zero, child: SizedBox.expand(child: content)),
      );
    }
    return Material(
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: o == null ? AppColors.border : AppColors.ink),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: open, child: FittedBox(fit: BoxFit.scaleDown, child: content)),
    );
  }
}

class _TakeawayList extends ConsumerWidget {
  const _TakeawayList({required this.orders, required this.onCreate});
  final List<Order> orders;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(padding: pagePadding, children: [
        const SectionLabel('ĐƠN MANG ĐI ĐANG MỞ'),
        if (orders.isEmpty) const EmptyView('Chưa có đơn mang đi'),
        for (final o in orders)
          ListRow(
            title: o.code,
            subtitle: '${o.itemCount} món · ${formatVnd(o.total)} · ${o.status.label} · ${_minutes(o)}',
            onTap: () => context.push(Routes.order(o.id)),
            trailing: switch (o.status) {
              OrderStatus.ready => OutlinedButton(
                  style: OutlinedButton.styleFrom(minimumSize: const Size(48, 40)),
                  onPressed: () async {
                    final ok = await ref.read(orderControllerProvider.notifier).markServed(o.id);
                    if (!ok && context.mounted) {
                      showMessage(context, ErrorMapper.message(ref.read(orderControllerProvider).error));
                    }
                  },
                  child: const Text('Đã giao', style: TextStyle(fontSize: 14)),
                ),
              OrderStatus.served => FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size(48, 40)),
                  onPressed: () => context.push(Routes.pay(o.id)),
                  child: const Text('Thanh toán', style: TextStyle(fontSize: 14)),
                ),
              _ => null,
            },
          ),
        const SizedBox(height: 10),
        const Text('Chạm một đơn để mở Order editor (S14). Đơn đã thanh toán hoặc đã hủy không hiện ở đây.',
            style: TextStyle(color: AppColors.muted, fontSize: 13)),
      ]);
}
