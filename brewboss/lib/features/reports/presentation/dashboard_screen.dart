import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/messages.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';
import '../../auth/application/auth_providers.dart';
import '../../inventory/application/inventory_providers.dart';
import '../../pos/application/pos_providers.dart';
import '../../pos/presentation/table_map_screen.dart' show staffHomeActions;
import '../application/report_providers.dart';
import '../application/report_rules.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static const _functions = [
    ('Thực đơn', Icons.local_cafe_outlined, Routes.menu),
    ('Kho', Icons.inventory_2_outlined, Routes.inventory),
    ('Nhân viên', Icons.person_outline, Routes.staff),
    ('Ca làm', Icons.timer_outlined, Routes.shifts),
    ('Bàn', Icons.chair_outlined, Routes.tables),
    ('Đơn hàng', Icons.receipt_long_outlined, Routes.orders),
    ('Báo cáo', Icons.show_chart, Routes.reports),
    ('Khách hàng', Icons.card_giftcard_outlined, Routes.loyalty),
  ];

  void _showAlerts(BuildContext context, List<Ingredient> low, List<Order> ready, Map<String, String> tables) {
    showAppSheet<void>(
      context,
      (ctx) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
        const SheetTitle('Thông báo'),
        if (low.isEmpty && ready.isEmpty) const EmptyView('Không có thông báo mới'),
        for (final i in low)
          ListRow(
            title: msg('MSG16', {'name': i.name, 'stock': formatQty(i.stock), 'unit': i.unit}),
            onTap: () {
              Navigator.pop(ctx);
              context.push('${Routes.inventory}/${i.id}');
            },
          ),
        for (final o in ready)
          ListRow(
            title: msg('MSG34', {'shortId': o.code, 'table': tables.labelFor(o)}),
            onTap: () {
              Navigator.pop(ctx);
              context.push(Routes.order(o.id));
            },
          ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).valueOrNull;
    final low = ref.watch(lowStockProvider);
    final open = ref.watch(openOrdersProvider).valueOrNull ?? const <Order>[];
    final ready = open.where((o) => o.status == OrderStatus.ready).toList();
    final names = ref.watch(tableNamesProvider);
    final onShift = ref.watch(onShiftCountProvider).valueOrNull ?? 0;
    final yesterday = ref.watch(yesterdayRevenueProvider).valueOrNull;
    final alerts = low.length + ready.length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tổng quan'),
        actions: [
          IconButton(
            tooltip: 'Thông báo',
            icon: Badge(
              isLabelVisible: alerts > 0,
              label: Text('$alerts'),
              backgroundColor: AppColors.red,
              child: const Icon(Icons.notifications_outlined),
            ),
            onPressed: () => _showAlerts(context, low, ready, names),
          ),
          ...staffHomeActions(context, user),
        ],
      ),
      body: AsyncBody(ref.watch(todayPaidOrdersProvider), retry: todayPaidOrdersProvider, builder: (orders) {
        final sum = summary(orders);
        return ListView(padding: pagePadding, children: [
          Text('Hôm nay · ${formatWeekdayDate(DateTime.now())}',
              style: const TextStyle(color: AppColors.muted, fontSize: 13)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(12)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Doanh thu hôm nay', style: TextStyle(color: Colors.white, fontSize: 13)),
              Text(formatVnd(sum.revenue),
                  style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700)),
              if (yesterday != null) Text(_compare(sum.revenue, yesterday), style: const TextStyle(color: Colors.white, fontSize: 13)),
            ]),
          ),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _Stat('Số đơn', '${sum.count}')),
            const SizedBox(width: 10),
            Expanded(child: _Stat('Giá trị TB / đơn', formatVnd(sum.average))),
          ]),
          const SizedBox(height: 10),
          if (low.isNotEmpty) ...[
            InkWell(
              onTap: () => context.push(Routes.inventory),
              child: DashedBox(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('⚠  ${low.length} nguyên liệu sắp hết', style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text(low.map((i) => i.name).join(', '), style: const TextStyle(fontSize: 13)),
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          Row(children: [
            Expanded(
              child: _Stat('Đơn đang mở', '${open.length}', onTap: () => context.push(Routes.pos)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _Stat('Nhân viên trong ca', '$onShift', onTap: () => context.push(Routes.shifts)),
            ),
          ]),
          const SectionLabel('CHỨC NĂNG'),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.1,
            children: [
              for (final (label, icon, route) in _functions)
                OutlineCard(
                  padding: const EdgeInsets.all(4),
                  onTap: () => context.push(route),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(icon, size: 20),
                    const SizedBox(height: 4),
                    Text(label, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
                  ]),
                ),
            ],
          ),
          const SizedBox(height: 14),
          OutlinedButton(onPressed: () => context.push(Routes.pos), child: const Text('Mở màn hình bán hàng')),
        ]);
      }),
    );
  }

  String _compare(int today, int yesterday) {
    if (yesterday == 0) return 'Hôm qua chưa có doanh thu';
    final percent = ((today - yesterday) * 100 / yesterday).round();
    return '${percent >= 0 ? '▲' : '▼'} ${percent.abs()}% so với hôm qua';
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value, {this.onTap});
  final String label;
  final String value;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => OutlineCard(
        onTap: onTap,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        ]),
      );
}
