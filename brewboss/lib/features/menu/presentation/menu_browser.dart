import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/messages.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';
import '../application/menu_providers.dart';
import '../application/menu_rules.dart';

/// Reusable search + category filter + product grid (S14).
class MenuBrowser extends ConsumerStatefulWidget {
  const MenuBrowser({super.key, required this.onPick, this.onLongPress, this.showSearch = true});
  final void Function(OrderItem item) onPick;
  final void Function(Product product)? onLongPress;
  final bool showSearch;
  @override
  ConsumerState<MenuBrowser> createState() => _MenuBrowserState();
}

class _MenuBrowserState extends ConsumerState<MenuBrowser> {
  String? _categoryId;
  String _text = '';

  Future<void> _pick(Product p) async {
    final item = await showItemOptions(context, p);
    if (item != null) widget.onPick(item);
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider).valueOrNull ?? const <Category>[];
    final products = ref.watch(menuQueryProvider(MenuQuery(categoryId: _categoryId, text: _text)));
    return AsyncBody(ref.watch(productsProvider), retry: productsProvider, builder: (_) {
      return Column(children: [
        if (widget.showSearch) ...[
          SearchField(hint: 'Tìm món', onChanged: (v) => setState(() => _text = v)),
          const SizedBox(height: 10),
        ],
        Align(
          alignment: Alignment.centerLeft,
          child: PillFilter<String?>(
            options: {null: 'Tất cả', for (final c in categories) c.id: c.name},
            selected: _categoryId,
            onSelected: (c) => setState(() => _categoryId = c),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: products.isEmpty
              ? EmptyView(msg('MSG12'))
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 160,
                    mainAxisExtent: 148,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: products.length,
                  itemBuilder: (_, i) {
                    final p = products[i];
                    return _ProductCell(
                      product: p,
                      onTap: p.isAvailable ? () => _pick(p) : null,
                      onLongPress: widget.onLongPress == null ? null : () => widget.onLongPress!(p),
                    );
                  },
                ),
        ),
      ]);
    });
  }
}

class _ProductCell extends StatelessWidget {
  const _ProductCell({required this.product, this.onTap, this.onLongPress});
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  @override
  Widget build(BuildContext context) {
    final available = product.isAvailable;
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: available ? AppColors.border : AppColors.fill)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        // Sold-out cells stay long-pressable so they can be switched back on.
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Opacity(opacity: available ? 1 : 0.5, child: ProductImage(product.imageUrl))),
            const SizedBox(height: 6),
            Text(product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: available ? AppColors.text : AppColors.disabled)),
            const SizedBox(height: 2),
            Text(available ? formatVnd(product.fromPrice) : 'Hết hàng',
                style: TextStyle(fontSize: 13, color: available ? AppColors.text : AppColors.red)),
          ]),
        ),
      ),
    );
  }
}

/// Item options sheet (S14b): size, toppings, note and quantity. [initial]
/// edits an existing line; the returned item has its unit price recomputed.
Future<OrderItem?> showItemOptions(BuildContext context, Product product, {OrderItem? initial}) =>
    showAppSheet<OrderItem>(context, (_) => _ItemOptions(product: product, initial: initial));

class _ItemOptions extends StatefulWidget {
  const _ItemOptions({required this.product, this.initial});
  final Product product;
  final OrderItem? initial;
  @override
  State<_ItemOptions> createState() => _ItemOptionsState();
}

class _ItemOptionsState extends State<_ItemOptions> {
  late String _size = widget.initial?.size ??
      (widget.product.sizes.isEmpty ? '' : widget.product.sizes.first.code);
  late final Set<String> _toppings = {...?widget.initial?.toppings.map((t) => t.name)};
  late int _qty = widget.initial?.qty ?? 1;
  late final _note = TextEditingController(text: widget.initial?.note);

  OrderItem _build() {
    final p = widget.product;
    final toppings = [
      for (final t in p.toppings)
        if (_toppings.contains(t.name)) ItemTopping(name: t.name, price: t.price),
    ];
    return OrderItem(
      productId: p.id,
      name: p.name,
      size: _size,
      toppings: toppings,
      unitPrice: unitPrice(p, _size, toppings),
      qty: _qty,
      note: _note.text.trim(),
      batch: widget.initial?.batch ?? 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
      Row(children: [
        Expanded(child: Text(p.name, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700))),
        Text(formatVnd(p.basePrice)),
      ]),
      if (p.sizes.isNotEmpty) ...[
        const SectionLabel('SIZE'),
        SegmentBar<String>(
          options: {
            for (final s in p.sizes) s.code: '${s.code} +${formatNumber(s.priceDelta)}',
          },
          selected: _size,
          onSelected: (s) => setState(() => _size = s),
        ),
      ],
      if (p.toppings.isNotEmpty) ...[
        const SectionLabel('TOPPING'),
        for (final t in p.toppings)
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: _toppings.contains(t.name),
            title: Row(children: [
              Expanded(child: Text(t.name, style: const TextStyle(fontSize: 15))),
              Text('+${formatVnd(t.price)}'),
            ]),
            onChanged: (v) => setState(() => v == true ? _toppings.add(t.name) : _toppings.remove(t.name)),
          ),
      ],
      const SectionLabel('GHI CHÚ'),
      TextField(controller: _note, maxLength: 100, decoration: const InputDecoration(hintText: 'Ít đá, ít ngọt...')),
      Center(
        child: QuantityStepper(
          qty: _qty,
          onChanged: (q) => setState(() => _qty = q),
        ),
      ),
      const SizedBox(height: 12),
      FilledButton(
        onPressed: () => Navigator.pop(context, _build()),
        child: Text('${widget.initial == null ? 'Thêm' : 'Lưu'} · ${formatVnd(_build().lineTotal)}'),
      ),
    ]);
  }
}

/// "−  1  +" outlined control.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({super.key, required this.qty, required this.onChanged, this.min = 1});
  final int qty;
  final int min;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(10)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(
            tooltip: 'Giảm',
            icon: const Icon(Icons.remove, size: 18),
            onPressed: qty > min ? () => onChanged(qty - 1) : null,
          ),
          Text('$qty', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          IconButton(tooltip: 'Tăng', icon: const Icon(Icons.add, size: 18), onPressed: () => onChanged(qty + 1)),
        ]),
      );
}
