import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/messages.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';
import '../../auth/application/auth_providers.dart';
import '../application/inventory_controller.dart';
import '../application/inventory_providers.dart';
import '../application/inventory_rules.dart';

final _textProvider = StateProvider.autoDispose((_) => '');
final _lowOnlyProvider = StateProvider.autoDispose((_) => false);

class IngredientScreen extends ConsumerWidget {
  const IngredientScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isManager = ref.watch(currentUserProvider).valueOrNull?.role == UserRole.manager;
    final text = foldAccents(ref.watch(_textProvider));
    final lowOnly = ref.watch(_lowOnlyProvider);
    final lowCount = ref.watch(lowStockProvider).length;
    return Scaffold(
      appBar: AppBar(title: const Text('Kho nguyên liệu')),
      bottomNavigationBar: BottomBar(
        child: Row(children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => showAppSheet<void>(context, (_) => const _StocktakeSheet()),
              child: const Text('Kiểm kho'),
            ),
          ),
          if (isManager) ...[
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton(
                onPressed: () => showIngredientForm(context),
                child: const Text('Thêm nguyên liệu', overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        ]),
      ),
      body: AsyncBody(ref.watch(ingredientsProvider), retry: ingredientsProvider, builder: (all) {
        final rows = all
            .where((i) => !lowOnly || isLowStock(i))
            .where((i) => foldAccents(i.name).contains(text))
            .toList();
        return ListView(padding: pagePadding, children: [
          SearchField(hint: 'Tìm nguyên liệu', onChanged: (v) => ref.read(_textProvider.notifier).state = v),
          const SizedBox(height: 10),
          PillFilter<bool>(
            options: {false: 'Tất cả', true: 'Sắp hết ($lowCount)'},
            selected: lowOnly,
            onSelected: (v) => ref.read(_lowOnlyProvider.notifier).state = v,
          ),
          const SizedBox(height: 6),
          if (rows.isEmpty) const EmptyView('Không có nguyên liệu nào'),
          for (final i in rows)
            ListRow(
              title: i.name,
              subtitle: 'Tối thiểu ${formatQty(i.minStock)} ${i.unit}',
              onTap: isManager ? () => context.push('${Routes.inventory}/${i.id}') : null,
              trailing: StatusBadge('${formatQty(i.stock)} ${i.unit}',
                  style: isLowStock(i) ? BadgeStyle.red : BadgeStyle.light),
            ),
        ]);
      }),
    );
  }
}

Future<void> showIngredientForm(BuildContext context, [Ingredient? ingredient]) =>
    showAppSheet<void>(context, (_) => _IngredientForm(ingredient));

class _IngredientForm extends ConsumerStatefulWidget {
  const _IngredientForm(this.ingredient);
  final Ingredient? ingredient;
  @override
  ConsumerState<_IngredientForm> createState() => _IngredientFormState();
}

class _IngredientFormState extends ConsumerState<_IngredientForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.ingredient?.name);
  late String _unit = widget.ingredient?.unit ?? 'g';
  final _stock = TextEditingController();
  late final _min = TextEditingController(text: widget.ingredient == null ? '' : formatQty(widget.ingredient!.minStock));

  bool get _isNew => widget.ingredient == null;

  num? _readQty(String text) => parseQty(text.replaceAll('.', ''));

  String? _validateQty(String? v) => (_readQty(v ?? '') ?? -1) < 0 ? msg('MSG42') : null;

  void _finish(bool ok) {
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
    } else {
      showMessage(context, ErrorMapper.message(ref.read(inventoryControllerProvider).error));
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref.read(inventoryControllerProvider.notifier).saveIngredient(Ingredient(
          id: widget.ingredient?.id ?? '',
          name: _name.text.trim(),
          unit: _unit,
          stock: _isNew ? _readQty(_stock.text)! : widget.ingredient!.stock,
          minStock: _readQty(_min.text)!,
        ));
    _finish(ok);
  }

  Future<void> _delete() async {
    final yes = await confirmDialog(context, title: 'Xóa nguyên liệu?', confirm: 'Xóa', destructive: true);
    if (!yes) return;
    _finish(await ref.read(inventoryControllerProvider.notifier).deleteIngredient(widget.ingredient!.id));
  }

  @override
  Widget build(BuildContext context) => Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          SheetTitle(_isNew ? 'Thêm nguyên liệu' : 'Sửa nguyên liệu'),
          LabeledField(label: 'Tên *', child: TextFormField(controller: _name, validator: validateRequired)),
          LabeledField(
            label: 'Đơn vị *',
            child: SegmentBar<String>(
              options: const {'g': 'g', 'ml': 'ml', 'pcs': 'pcs'},
              selected: _unit,
              onSelected: (u) => setState(() => _unit = u),
            ),
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (_isNew) ...[
              Expanded(
                child: LabeledField(
                  label: 'Tồn hiện tại *',
                  child: TextFormField(controller: _stock, keyboardType: TextInputType.number, validator: _validateQty),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: LabeledField(
                label: 'Tồn tối thiểu *',
                child: TextFormField(controller: _min, keyboardType: TextInputType.number, validator: _validateQty),
              ),
            ),
          ]),
          FilledButton(
            onPressed: ref.watch(inventoryControllerProvider).isLoading ? null : _save,
            child: const Text('Lưu'),
          ),
          if (!_isNew) ...[
            const SizedBox(height: 8),
            TextButton(onPressed: _delete, child: const Text('Xóa nguyên liệu')),
          ],
        ]),
      );
}

/// UC42: blank entries leave stock unchanged.
class _StocktakeSheet extends ConsumerStatefulWidget {
  const _StocktakeSheet();
  @override
  ConsumerState<_StocktakeSheet> createState() => _StocktakeSheetState();
}

class _StocktakeSheetState extends ConsumerState<_StocktakeSheet> {
  final Map<String, num> _stocktake = {};
  bool _invalid = false;

  Future<void> _save() async {
    if (_invalid) {
      showMessage(context, msg('MSG42'));
      return;
    }
    final controller = ref.read(inventoryControllerProvider.notifier);
    final ok = await controller.stocktake(_stocktake);
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
      showMessage(context, msg('MSG41', {'count': controller.lastAdjusted}));
    } else {
      showMessage(context, ErrorMapper.message(ref.read(inventoryControllerProvider).error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(ingredientsProvider).valueOrNull ?? const <Ingredient>[];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
      const SheetTitle('Kiểm kho'),
      for (final i in all)
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(i.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text('Hệ thống ${formatQty(i.stock)} ${i.unit}', style: const TextStyle(color: AppColors.muted, fontSize: 13)),
                if (_stocktake[i.id] != null)
                  Builder(builder: (_) {
                    final diff = stocktakeDiff(_stocktake[i.id]!, i.stock);
                    return Text('Lệch ${diff > 0 ? '+' : ''}${formatQty(diff)} ${i.unit}',
                        style: TextStyle(fontSize: 13, color: diff == 0 ? AppColors.muted : AppColors.red));
                  }),
              ]),
            ),
            SizedBox(
              width: 110,
              child: TextField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(hintText: 'Thực tế'),
                onChanged: (v) => setState(() {
                  final qty = parseQty(v);
                  _invalid = v.trim().isNotEmpty && (qty == null || qty < 0);
                  qty == null || qty < 0 ? _stocktake.remove(i.id) : _stocktake[i.id] = qty;
                }),
              ),
            ),
          ]),
        ),
      const SizedBox(height: 12),
      FilledButton(
        onPressed: ref.watch(inventoryControllerProvider).isLoading ? null : _save,
        child: const Text('Lưu'),
      ),
    ]);
  }
}
