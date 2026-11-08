import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme.dart';
import '../../../core/utils/date_range.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/messages.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';
import '../../staff/application/staff_providers.dart';
import '../../staff/presentation/shift_history_screen.dart' show pickRange;
import '../application/inventory_controller.dart';
import '../application/inventory_providers.dart';
import '../application/inventory_rules.dart';
import 'ingredient_screen.dart';

class StockHistoryScreen extends ConsumerStatefulWidget {
  const StockHistoryScreen({super.key, required this.ingredientId});
  final String ingredientId;
  @override
  ConsumerState<StockHistoryScreen> createState() => _StockHistoryScreenState();
}

class _StockHistoryScreenState extends ConsumerState<StockHistoryScreen> {
  MovementType? _type;
  DateRange? _range;

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(ingredientsProvider).valueOrNull ?? const <Ingredient>[];
    final match = all.where((i) => i.id == widget.ingredientId);
    final ingredient = match.isEmpty ? null : match.first;
    final movements = movementsProvider(widget.ingredientId);
    final names = ref.watch(staffNamesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(ingredient?.name ?? ''),
        actions: [
          if (ingredient != null)
            IconButton(
              tooltip: 'Sửa nguyên liệu',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => showIngredientForm(context, ingredient),
            ),
        ],
      ),
      body: ingredient == null
          ? const LoadingView()
          : ListView(padding: pagePadding, children: [
              _StockCard(ingredient),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () => showAppSheet<void>(context, (_) => _StockInSheet(ingredient)),
                    child: const Text('+ Nhập kho'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => showAppSheet<void>(context, (_) => _AdjustSheet(ingredient)),
                    child: const Text('Điều chỉnh'),
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              PillFilter<MovementType?>(
                options: {null: 'Tất cả', for (final t in MovementType.values) t: t.label},
                selected: _type,
                onSelected: (t) => setState(() => _type = t),
              ),
              SectionLabel(
                'LỊCH SỬ',
                trailing: InkWell(
                  onTap: () async {
                    final picked = await pickRange(context, _range ?? DateRange.thisWeek());
                    setState(() => _range = picked);
                  },
                  child: Text(
                    _range == null ? 'Mọi ngày' : '${formatDayMonth(_range!.from)} – ${formatDayMonth(_range!.lastDay)}',
                    style: const TextStyle(fontSize: 13, decoration: TextDecoration.underline),
                  ),
                ),
              ),
              AsyncBody(ref.watch(movements), retry: movements, builder: (list) {
                final rows = list.where((m) => _type == null || m.type == _type).where((m) {
                  final at = m.createdAt;
                  return _range == null || (at != null && !at.isBefore(_range!.from) && at.isBefore(_range!.to));
                }).toList();
                if (rows.isEmpty) return const EmptyView('Chưa có biến động kho');
                return Column(children: [
                  for (final m in rows)
                    ListRow(
                      title: m.type.label,
                      subtitle: [
                        if (m.reason != null) m.reason!,
                        if (m.reason == null && m.orderId != null) 'Đơn hàng',
                        if (m.cost != null) formatVnd(m.cost!),
                        if (m.createdAt != null) formatDayTime(m.createdAt!),
                        names[m.byUserId] ?? '',
                      ].where((s) => s.isNotEmpty).join(' · '),
                      onTap: m.orderId == null ? null : () => context.push(Routes.orders),
                      trailing: Text('${m.qty > 0 ? '+' : ''}${formatQty(m.qty)} ${ingredient.unit}',
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                ]);
              }),
            ]),
    );
  }
}

class _StockCard extends StatelessWidget {
  const _StockCard(this.i);
  final Ingredient i;
  @override
  Widget build(BuildContext context) {
    final content = Row(children: [
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Tồn kho', style: TextStyle(fontSize: 13)),
          Text('${formatQty(i.stock)} ${i.unit}', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
        ]),
      ),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        const Text('Tối thiểu', style: TextStyle(fontSize: 13)),
        Text('${formatQty(i.minStock)} ${i.unit}'),
      ]),
    ]);
    return isLowStock(i) ? DashedBox(color: AppColors.red, child: content) : OutlineCard(child: content);
  }
}

class _StockInSheet extends ConsumerStatefulWidget {
  const _StockInSheet(this.i);
  final Ingredient i;
  @override
  ConsumerState<_StockInSheet> createState() => _StockInSheetState();
}

class _StockInSheetState extends ConsumerState<_StockInSheet> {
  final _formKey = GlobalKey<FormState>();
  final _qty = TextEditingController();
  final _cost = TextEditingController();
  final _note = TextEditingController();

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref
        .read(inventoryControllerProvider.notifier)
        .stockIn(widget.i.id, parseQty(_qty.text)!, parseMoney(_cost.text), _note.text.trim());
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
    } else {
      showMessage(context, ErrorMapper.message(ref.read(inventoryControllerProvider).error));
    }
  }

  @override
  Widget build(BuildContext context) => Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          SheetTitle('Nhập kho · ${widget.i.name}'),
          LabeledField(
            label: 'Số lượng (${widget.i.unit}) *',
            child: TextFormField(
              controller: _qty,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => (parseQty(v) ?? 0) > 0 ? null : msg('MSG42'),
            ),
          ),
          LabeledField(label: 'Giá nhập (₫)', child: MoneyField(controller: _cost)),
          LabeledField(label: 'Nhà cung cấp / ghi chú', child: TextFormField(controller: _note)),
          const Text('Giá nhập là tổng tiền của lần nhập này, dùng cho báo cáo chi phí.',
              style: TextStyle(color: AppColors.muted, fontSize: 13)),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: ref.watch(inventoryControllerProvider).isLoading ? null : _save,
            child: const Text('Lưu'),
          ),
        ]),
      );
}

class _AdjustSheet extends ConsumerStatefulWidget {
  const _AdjustSheet(this.i);
  final Ingredient i;
  @override
  ConsumerState<_AdjustSheet> createState() => _AdjustSheetState();
}

class _AdjustSheetState extends ConsumerState<_AdjustSheet> {
  final _formKey = GlobalKey<FormState>();
  final _qty = TextEditingController();
  final _reason = TextEditingController();
  bool _isCount = false;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final entered = parseQty(_qty.text)!;
    final change = _isCount ? stocktakeDiff(entered, widget.i.stock) : -entered;
    final ok = await ref.read(inventoryControllerProvider.notifier).adjust(widget.i.id, change, _reason.text);
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
    } else {
      showMessage(context, ErrorMapper.message(ref.read(inventoryControllerProvider).error));
    }
  }

  @override
  Widget build(BuildContext context) => Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          SheetTitle('Điều chỉnh · ${widget.i.name}'),
          SegmentBar<bool>(
            options: const {false: 'Hao hụt', true: 'Kiểm kê'},
            selected: _isCount,
            onSelected: (v) => setState(() => _isCount = v),
          ),
          const SizedBox(height: 12),
          LabeledField(
            label: '${_isCount ? 'Số đếm thực tế' : 'Số lượng hao hụt'} (${widget.i.unit}) *',
            child: TextFormField(
              controller: _qty,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => (parseQty(v) ?? -1) < 0 ? msg('MSG42') : null,
            ),
          ),
          LabeledField(
            label: 'Lý do *',
            child: TextFormField(controller: _reason, validator: (v) => validateRequired(v, msg('MSG14'))),
          ),
          FilledButton(
            onPressed: ref.watch(inventoryControllerProvider).isLoading ? null : _save,
            child: const Text('Lưu'),
          ),
        ]),
      );
}
