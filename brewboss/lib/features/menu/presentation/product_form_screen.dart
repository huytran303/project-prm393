import 'package:flutter/foundation.dart' show Uint8List;
import 'package:flutter/material.dart' hide MenuController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';
import '../../inventory/application/inventory_providers.dart';
import '../application/menu_controller.dart';
import '../application/menu_providers.dart';

/// S09 product form (UC08, UC14).
class ProductFormScreen extends ConsumerWidget {
  const ProductFormScreen({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (productId == 'new') return const _Form(product: null);
    return AsyncBody(ref.watch(productsProvider), retry: productsProvider, builder: (products) {
      final match = products.where((p) => p.id == productId);
      return match.isEmpty
          ? Scaffold(appBar: AppBar(), body: const EmptyView('Món không tồn tại'))
          : _Form(key: ValueKey(productId), product: match.first);
    });
  }
}

class _Form extends ConsumerStatefulWidget {
  const _Form({super.key, required this.product});
  final Product? product;
  @override
  ConsumerState<_Form> createState() => _FormState();
}

class _FormState extends ConsumerState<_Form> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.product?.name);
  late final _price = TextEditingController(text: widget.product == null ? '' : formatNumber(widget.product!.basePrice));
  late final _description = TextEditingController(text: widget.product?.description);
  late String? _categoryId = widget.product?.categoryId;
  late final List<ProductSize> _sizes = [...?widget.product?.sizes];
  late final List<Topping> _toppings = [...?widget.product?.toppings];
  late final Map<String, List<RecipeItem>> _recipe = {
    for (final e in (widget.product?.recipe ?? const <String, List<RecipeItem>>{}).entries) e.key: [...e.value],
  };
  late String _recipeSize = _sizes.isEmpty ? 'S' : _sizes.first.code;
  XFile? _image;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    if (widget.product == null) _sizes.add(const ProductSize(code: 'S'));
  }

  Future<void> _pickImage() async {
    // image_picker resizes and compresses natively, on every platform (≤ 1024 px).
    final file = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1024, imageQuality: 80);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    setState(() {
      _image = file;
      _imageBytes = bytes;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final codes = _sizes.map((s) => s.code).toSet();
    final product = (widget.product ?? const Product(id: '', categoryId: '', name: '')).copyWith(
      name: _name.text.trim(),
      categoryId: _categoryId!,
      basePrice: parseMoney(_price.text)!,
      description: _description.text.trim(),
      sizes: _sizes,
      toppings: _toppings,
      recipe: {for (final e in _recipe.entries) if (codes.contains(e.key) && e.value.isNotEmpty) e.key: e.value},
    );
    final ok = await ref.read(menuControllerProvider.notifier).saveProduct(product, _image);
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
    } else {
      showMessage(context, ErrorMapper.message(ref.read(menuControllerProvider).error));
    }
  }

  Future<void> _delete() async {
    final yes = await confirmDialog(context,
        title: 'Xóa món?', message: 'Đơn đã có vẫn giữ nguyên tên và giá cũ.', confirm: 'Xóa', destructive: true);
    if (!yes || !mounted) return;
    final ok = await ref.read(menuControllerProvider.notifier).deleteProduct(widget.product!.id);
    if (!mounted) return;
    if (ok) Navigator.pop(context);
  }

  Future<void> _editSize([ProductSize? size]) async {
    final free = ['S', 'M', 'L'].where((c) => c == size?.code || !_sizes.any((s) => s.code == c)).toList();
    if (free.isEmpty) return;
    final result = await showAppSheet<ProductSize>(context, (_) => _SizeSheet(codes: free, initial: size));
    if (result == null) return;
    setState(() {
      final i = size == null ? -1 : _sizes.indexOf(size);
      i >= 0 ? _sizes[i] = result : _sizes.add(result);
      _sizes.sort((a, b) => 'SML'.indexOf(a.code).compareTo('SML'.indexOf(b.code)));
    });
  }

  Future<void> _addTopping() async {
    final result = await showAppSheet<Topping>(context, (_) => const _ToppingSheet());
    if (result != null) setState(() => _toppings.add(result));
  }

  Future<void> _addRecipeItem() async {
    final used = (_recipe[_recipeSize] ?? const <RecipeItem>[]).map((r) => r.ingredientId).toSet();
    final options = (ref.read(ingredientsProvider).valueOrNull ?? const <Ingredient>[])
        .where((i) => !used.contains(i.id))
        .toList();
    final result = await showAppSheet<RecipeItem>(context, (_) => _RecipeSheet(options: options));
    if (result != null) setState(() => (_recipe[_recipeSize] ??= []).add(result));
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider).valueOrNull ?? const <Category>[];
    final ingredients = {for (final i in ref.watch(ingredientsProvider).valueOrNull ?? const <Ingredient>[]) i.id: i};
    final recipe = _recipe[_recipeSize] ?? const <RecipeItem>[];
    if (!_sizes.any((s) => s.code == _recipeSize) && _sizes.isNotEmpty) _recipeSize = _sizes.first.code;
    final copyFrom = _sizes.where((s) => s.code != _recipeSize && (_recipe[s.code] ?? const []).isNotEmpty).toList();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), tooltip: 'Đóng', onPressed: () => Navigator.pop(context)),
        title: Text(widget.product == null ? 'Thêm món' : 'Sửa món'),
        actions: [
          TextButton(
            onPressed: ref.watch(menuControllerProvider).isLoading ? null : _save,
            child: const Text('Lưu'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(padding: pagePadding, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            InkWell(
              onTap: _pickImage,
              child: Column(children: [
                SizedBox(
                  width: 110,
                  height: 110,
                  child: _imageBytes != null
                      ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                      : ProductImage(widget.product?.imageUrl),
                ),
                const SizedBox(height: 4),
                const Text('Đổi ảnh', style: TextStyle(fontSize: 12, color: AppColors.muted)),
              ]),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(children: [
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(hintText: 'Tên món *'),
                  validator: validateRequired,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: categories.any((c) => c.id == _categoryId) ? _categoryId : null,
                  hint: const Text('Danh mục *'),
                  items: [for (final c in categories) DropdownMenuItem(value: c.id, child: Text(c.name))],
                  validator: (v) => v == null ? 'Vui lòng chọn danh mục' : null,
                  onChanged: (v) => setState(() => _categoryId = v),
                ),
              ]),
            ),
          ]),
          const SizedBox(height: 8),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              flex: 2,
              child: LabeledField(label: 'Giá cơ bản (₫) *', child: MoneyField(controller: _price, validator: validateMoney)),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: LabeledField(label: 'Mô tả', child: TextFormField(controller: _description, maxLength: 500, buildCounter: _noCounter)),
            ),
          ]),
          SectionLabel('SIZE',
              trailing: _sizes.length < 3 ? _LinkButton('+ Thêm', () => _editSize()) : null),
          if (_sizes.isEmpty)
            const Text('Cần ít nhất một size', style: TextStyle(color: AppColors.red, fontSize: 13)),
          Row(children: [
            for (final s in _sizes)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: OutlineCard(
                    onTap: () => _editSize(s),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(children: [
                      Text(s.code, style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text('+${formatVnd(s.priceDelta)}', style: const TextStyle(fontSize: 13)),
                      if (_sizes.length > 1)
                        InkWell(
                          onTap: () => setState(() => _sizes.remove(s)),
                          child: const Text('Xóa', style: TextStyle(fontSize: 12, color: AppColors.muted, decoration: TextDecoration.underline)),
                        ),
                    ]),
                  ),
                ),
              ),
          ]),
          SectionLabel('TOPPING', trailing: _LinkButton('+ Thêm', _addTopping)),
          OutlineCard(
            child: Column(children: [
              if (_toppings.isEmpty) const Text('Chưa có topping', style: TextStyle(color: AppColors.muted)),
              for (final t in _toppings)
                _RemovableRow(left: t.name, right: '+${formatVnd(t.price)}', onRemove: () => setState(() => _toppings.remove(t))),
            ]),
          ),
          const SizedBox(height: 8),
          Row(children: [
            const Expanded(child: SectionLabel('CÔNG THỨC')),
            SizedBox(
              width: 150,
              child: SegmentBar<String>(
                options: {for (final s in _sizes) s.code: s.code},
                selected: _recipeSize,
                onSelected: (c) => setState(() => _recipeSize = c),
              ),
            ),
          ]),
          const SizedBox(height: 8),
          OutlineCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (recipe.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: StatusBadge('Chưa có công thức — thanh toán sẽ không trừ kho', style: BadgeStyle.red),
                ),
              for (final r in recipe)
                _RemovableRow(
                  left: ingredients[r.ingredientId]?.name ?? r.ingredientId,
                  right: '${formatQty(r.qty)} ${ingredients[r.ingredientId]?.unit ?? ''}',
                  onRemove: () => setState(() => _recipe[_recipeSize]!.remove(r)),
                ),
              _LinkButton('+ Thêm nguyên liệu', _addRecipeItem),
              for (final s in copyFrom)
                _LinkButton('Sao chép từ size ${s.code}', () => setState(() => _recipe[_recipeSize] = [..._recipe[s.code]!])),
            ]),
          ),
          if (widget.product != null) ...[
            const SizedBox(height: 16),
            OutlinedButton(
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.red, side: const BorderSide(color: AppColors.red)),
              onPressed: _delete,
              child: const Text('Xóa món'),
            ),
          ],
        ]),
      ),
    );
  }
}

Widget? _noCounter(BuildContext _, {required int currentLength, required bool isFocused, required int? maxLength}) => null;

class _LinkButton extends StatelessWidget {
  const _LinkButton(this.text, this.onTap);
  final String text;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(text, style: const TextStyle(fontSize: 14, decoration: TextDecoration.underline)),
        ),
      );
}

class _RemovableRow extends StatelessWidget {
  const _RemovableRow({required this.left, required this.right, required this.onRemove});
  final String left;
  final String right;
  final VoidCallback onRemove;
  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(child: Text(left)),
        Text(right),
        IconButton(
          tooltip: 'Xóa',
          icon: const Icon(Icons.close, size: 18),
          visualDensity: VisualDensity.compact,
          onPressed: onRemove,
        ),
      ]);
}

class _SizeSheet extends StatefulWidget {
  const _SizeSheet({required this.codes, this.initial});
  final List<String> codes;
  final ProductSize? initial;
  @override
  State<_SizeSheet> createState() => _SizeSheetState();
}

class _SizeSheetState extends State<_SizeSheet> {
  late String _code = widget.initial?.code ?? widget.codes.first;
  late final _delta = TextEditingController(text: formatNumber(widget.initial?.priceDelta ?? 0));
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) => Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          const SheetTitle('Size'),
          SegmentBar<String>(
            options: {for (final c in widget.codes) c: c},
            selected: _code,
            onSelected: (c) => setState(() => _code = c),
          ),
          const SizedBox(height: 12),
          LabeledField(label: 'Phụ thu (₫) *', child: MoneyField(controller: _delta, validator: validateMoney)),
          FilledButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.pop(context, ProductSize(code: _code, priceDelta: parseMoney(_delta.text)!));
              }
            },
            child: const Text('Lưu'),
          ),
        ]),
      );
}

class _ToppingSheet extends StatefulWidget {
  const _ToppingSheet();
  @override
  State<_ToppingSheet> createState() => _ToppingSheetState();
}

class _ToppingSheetState extends State<_ToppingSheet> {
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) => Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          const SheetTitle('Thêm topping'),
          LabeledField(label: 'Tên *', child: TextFormField(controller: _name, validator: validateRequired)),
          LabeledField(label: 'Giá (₫) *', child: MoneyField(controller: _price, validator: validateMoney)),
          FilledButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.pop(
                  context,
                  Topping(id: DateTime.now().microsecondsSinceEpoch.toString(), name: _name.text.trim(), price: parseMoney(_price.text)!),
                );
              }
            },
            child: const Text('Lưu'),
          ),
        ]),
      );
}

class _RecipeSheet extends StatefulWidget {
  const _RecipeSheet({required this.options});
  final List<Ingredient> options;
  @override
  State<_RecipeSheet> createState() => _RecipeSheetState();
}

class _RecipeSheetState extends State<_RecipeSheet> {
  String? _id;
  final _qty = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) => Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          const SheetTitle('Thêm nguyên liệu'),
          LabeledField(
            label: 'Nguyên liệu *',
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              items: [
                for (final i in widget.options) DropdownMenuItem(value: i.id, child: Text('${i.name} (${i.unit})')),
              ],
              validator: (v) => v == null ? 'Vui lòng chọn nguyên liệu' : null,
              onChanged: (v) => setState(() => _id = v),
            ),
          ),
          LabeledField(
            label: 'Định lượng *',
            child: TextFormField(
              controller: _qty,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => (parseQty(v) ?? 0) > 0 ? null : 'Định lượng phải lớn hơn 0',
            ),
          ),
          FilledButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.pop(context, RecipeItem(ingredientId: _id!, qty: parseQty(_qty.text)!));
              }
            },
            child: const Text('Lưu'),
          ),
        ]),
      );
}
