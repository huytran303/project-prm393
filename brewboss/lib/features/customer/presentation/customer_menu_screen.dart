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
import '../../menu/application/menu_providers.dart';
import '../../menu/application/menu_rules.dart';
import '../../menu/presentation/menu_browser.dart';
import '../../pos/application/order_rules.dart';
import '../application/customer_order_controller.dart';
import '../application/customer_providers.dart';

/// S17: anonymous menu for one table (UC32).
class CustomerMenuScreen extends ConsumerWidget {
  const CustomerMenuScreen({super.key, required this.tableId});
  final String tableId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final table = customerTableProvider(tableId);
    return Scaffold(
      body: AsyncBody(ref.watch(table), retry: table, builder: (t) {
        if (t == null) return EmptyView(msg('MSG37'));
        return _Menu(table: t);
      }),
    );
  }
}

class _Menu extends ConsumerStatefulWidget {
  const _Menu({required this.table});
  final CafeTable table;
  @override
  ConsumerState<_Menu> createState() => _MenuState();
}

class _MenuState extends ConsumerState<_Menu> {
  final List<OrderItem> _cart = [];
  String? _categoryId;
  String _text = '';

  int _qtyOf(String productId) => _cart.where((i) => i.productId == productId).fold(0, (s, i) => s + i.qty);

  Future<void> _add(Product p) async {
    final item = await showItemOptions(context, p);
    if (item != null) setState(() => _cart.add(item));
  }

  void _removeOne(String productId) {
    final index = _cart.lastIndexWhere((i) => i.productId == productId);
    if (index < 0) return;
    setState(() {
      final item = _cart[index];
      item.qty > 1 ? _cart[index] = item.copyWith(qty: item.qty - 1) : _cart.removeAt(index);
    });
  }

  Future<void> _send() async {
    final products = ref.read(productsProvider).valueOrNull ?? const <Product>[];
    final gone = _cart.where((i) => products.where((p) => p.id == i.productId && p.isAvailable).isEmpty).toList();
    if (gone.isNotEmpty) {
      return showMessage(context, '${gone.map((i) => i.name).join(', ')} vừa hết hàng, vui lòng bỏ khỏi giỏ');
    }
    final controller = ref.read(customerOrderControllerProvider.notifier);
    final hadOpenOrder = widget.table.currentOrderId != null;
    final ok = await controller.placeOrder(widget.table.id, _cart);
    if (!mounted) return;
    if (!ok) return showMessage(context, ErrorMapper.message(ref.read(customerOrderControllerProvider).error));
    setState(_cart.clear);
    ref.invalidate(lastCustomerOrderProvider(widget.table.id));
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(hadOpenOrder ? 'Đã gửi món gọi thêm' : 'Đã gửi đơn',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        content: Text(msg(hadOpenOrder ? 'MSG36' : 'MSG35')),
        actions: [
          FilledButton(onPressed: () => Navigator.pop(ctx), child: const Text('Xem trạng thái')),
        ],
      ),
    );
    if (mounted) context.push(Routes.customerOrder(widget.table.id, controller.placedId!));
  }

  void _openCart() {
    showAppSheet<void>(
      context,
      (_) => StatefulBuilder(
        builder: (ctx, setSheet) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          const SheetTitle('Giỏ của bạn'),
          if (_cart.isEmpty) const EmptyView('Giỏ đang trống'),
          for (final (index, i) in _cart.indexed)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(i.label),
                    if (i.note.isNotEmpty)
                      Text(i.note, style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13, color: AppColors.muted)),
                  ]),
                ),
                Text(formatVnd(i.lineTotal)),
                IconButton(
                  tooltip: 'Bỏ món',
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () {
                    setState(() => _cart.removeAt(index));
                    setSheet(() {});
                  },
                ),
              ]),
            ),
          InfoRow('Tạm tính', formatVnd(subtotalOf(_cart)), bold: true),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shop = ref.watch(publicShopProvider).valueOrNull ?? 'BrewBoss';
    final categories = ref.watch(categoriesProvider).valueOrNull ?? const <Category>[];
    final products = ref.watch(menuQueryProvider(MenuQuery(categoryId: _categoryId, text: _text, onlyAvailable: true)));
    final last = ref.watch(lastCustomerOrderProvider(widget.table.id)).valueOrNull;
    final count = _cart.fold(0, (s, i) => s + i.qty);
    final busy = ref.watch(customerOrderControllerProvider).isLoading;
    final verb = widget.table.currentOrderId != null ? 'Gửi thêm món' : 'Đặt món';
    return Column(children: [
      SafeArea(
        bottom: false,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(shop, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                Text('Bạn đang ngồi bàn ${widget.table.name}', style: const TextStyle(color: AppColors.muted, fontSize: 13)),
              ]),
            ),
            if (last != null)
              TextButton(
                onPressed: () => context.push(Routes.customerOrder(widget.table.id, last)),
                child: const Text('Đơn của bạn'),
              ),
          ]),
        ),
      ),
      Expanded(
        child: AsyncBody(ref.watch(productsProvider), retry: productsProvider, builder: (_) {
          return ListView(padding: pagePadding, children: [
            SearchField(hint: 'Tìm món', onChanged: (v) => setState(() => _text = v)),
            const SizedBox(height: 10),
            PillFilter<String?>(
              options: {null: 'Tất cả', for (final c in categories) c.id: c.name},
              selected: _categoryId,
              onSelected: (c) => setState(() => _categoryId = c),
            ),
            const SizedBox(height: 6),
            if (products.isEmpty) EmptyView(msg('MSG12')),
            for (final p in products)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
                child: Row(children: [
                  SizedBox(width: 84, height: 84, child: ProductImage(p.imageUrl)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(p.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                      if (p.description.isNotEmpty)
                        Text(p.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(formatVnd(p.fromPrice)),
                    ]),
                  ),
                  if (_qtyOf(p.id) > 0)
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(10)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(tooltip: 'Giảm', icon: const Icon(Icons.remove, size: 18), onPressed: () => _removeOne(p.id)),
                        Text('${_qtyOf(p.id)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                        IconButton(tooltip: 'Thêm', icon: const Icon(Icons.add, size: 18), onPressed: () => _add(p)),
                      ]),
                    )
                  else
                    IconButton.filled(
                      tooltip: 'Thêm ${p.name}',
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.ink,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () => _add(p),
                    ),
                ]),
              ),
          ]);
        }),
      ),
      BottomBar(
        child: Row(children: [
          OutlinedButton.icon(
            onPressed: _openCart,
            icon: const Icon(Icons.shopping_cart_outlined, size: 18),
            label: Text('$count món'),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FilledButton(
              onPressed: busy || _cart.isEmpty ? null : _send,
              child: Text('$verb · ${formatVnd(subtotalOf(_cart))}', overflow: TextOverflow.ellipsis),
            ),
          ),
        ]),
      ),
    ]);
  }
}
