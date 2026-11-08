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
import '../../menu/application/menu_controller.dart';
import '../../menu/application/menu_providers.dart';
import '../../menu/application/menu_rules.dart';
import '../../menu/presentation/menu_browser.dart';
import '../application/order_controller.dart';
import '../application/order_rules.dart';
import '../application/pos_providers.dart';

/// S14 route wrapper: `new` builds an unsaved order; otherwise the live order.
class OrderEditorScreen extends ConsumerWidget {
  const OrderEditorScreen({super.key, required this.orderId, this.tableId});
  final String orderId;
  final String? tableId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (orderId == 'new') return _Editor(order: null, tableId: tableId);
    final value = ref.watch(orderProvider(orderId));
    return value.when(
      skipLoadingOnReload: true,
      loading: () => const Scaffold(body: LoadingView()),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: ErrorView(error: e, onRetry: () => ref.invalidate(orderProvider(orderId))),
      ),
      data: (o) => _Editor(key: ValueKey(orderId), order: o, tableId: o.tableId),
    );
  }
}

class _Editor extends ConsumerStatefulWidget {
  const _Editor({super.key, required this.order, required this.tableId});
  final Order? order;
  final String? tableId;
  @override
  ConsumerState<_Editor> createState() => _EditorState();
}

class _EditorState extends ConsumerState<_Editor> {
  /// Items not yet sent.
  final List<OrderItem> _cart = [];

  /// Local edits of saved lines (awaiting / pending only); null = no edits.
  List<OrderItem>? _edited;

  Order? get _order => widget.order;
  OrderStatus? get _status => _order?.status;
  bool get _editable => _status == OrderStatus.awaiting || _status == OrderStatus.pending;
  List<OrderItem> get _saved => _edited ?? _order?.items ?? const [];
  bool get _dirty => _edited != null || _cart.isNotEmpty;

  void _update(VoidCallback change) => setState(change);
  void _toast(String text) => showMessage(context, text);
  void _showError() => _toast(ErrorMapper.message(ref.read(orderControllerProvider).error));

  void _editDraft(int index) async {
    final item = _cart[index];
    final product = _productOf(item);
    if (product == null) return;
    final next = await showItemOptions(context, product, initial: item);
    if (next != null) setState(() => _cart[index] = next);
  }

  void _editSaved(int index) async {
    final item = _saved[index];
    final product = _productOf(item);
    if (product == null) return _toast('Món không còn trong thực đơn');
    final next = await showItemOptions(context, product, initial: item);
    if (next == null) return;
    setState(() => _edited = [..._saved]..[index] = next);
  }

  void _removeSaved(int index) => setState(() => _edited = [..._saved]..removeAt(index));

  Product? _productOf(OrderItem item) =>
      (ref.read(productsProvider).valueOrNull ?? const <Product>[]).where((p) => p.id == item.productId).firstOrNull;

  Future<void> _toggleAvailable(Product p) async {
    final yes = await confirmDialog(context,
        title: p.isAvailable ? 'Đánh dấu "${p.name}" hết hàng?' : 'Mở bán lại "${p.name}"?');
    if (!yes) return;
    await ref.read(menuControllerProvider.notifier).setAvailable(p.id, !p.isAvailable);
  }

  Future<void> _send() async {
    final controller = ref.read(orderControllerProvider.notifier);
    final o = _order;
    if (o == null) {
      if (await controller.create(widget.tableId, _cart)) {
        if (mounted) context.pushReplacement(Routes.order(controller.createdId!));
      } else {
        _showError();
      }
      return;
    }
    final lines = [..._saved, ..._cart];
    if (_status == OrderStatus.pending && lines.isEmpty) return _cancel();
    final ok = _editable ? await controller.updateItems(o.id, lines) : await controller.addItems(o.id, _cart);
    if (!ok) return _showError();
    if (mounted) {
      setState(() {
        _cart.clear();
        _edited = null;
      });
    }
  }

  Future<void> _confirmCustomer() async {
    final controller = ref.read(orderControllerProvider.notifier);
    final o = _order!;
    if (_dirty && !await controller.updateItems(o.id, [..._saved, ..._cart])) return _showError();
    if (!await controller.confirmCustomerOrder(o.id)) return _showError();
    if (!mounted) return;
    if (controller.mergedInto != null) _toast(msg('MSG21', {'shortId': controller.mergedInto!}));
    context.pop();
  }

  Future<void> _cancel() async {
    final o = _order;
    if (o == null) return context.pop();
    final role = ref.read(currentUserProvider).valueOrNull?.role;
    if (role == null || !canCancel(o.status, role)) return _toast(msg('MSG33'));
    final result = await showDialog<(String, bool)>(
      context: context,
      builder: (_) => _CancelDialog(status: o.status, isReject: o.status == OrderStatus.awaiting),
    );
    if (result == null) return;
    if (!await ref.read(orderControllerProvider.notifier).cancel(o.id, result.$1, result.$2)) return _showError();
    if (mounted) context.pop();
  }

  Future<void> _serve() async {
    if (!await ref.read(orderControllerProvider.notifier).markServed(_order!.id)) _showError();
  }

  Future<void> _transfer(bool merge) async {
    final o = _order!;
    await showAppSheet<void>(context, (_) => merge ? _MergeSheet(source: o) : _MoveSheet(order: o));
  }

  String _subtitle(Order? o) {
    if (o == null) return 'Đơn mới';
    return switch (o.status) {
      OrderStatus.awaiting => 'Khách tự đặt · chờ xác nhận',
      OrderStatus.pending => '${o.code} · Chờ pha · sửa được',
      _ => '${o.code} · ${o.status.label}',
    };
  }

  @override
  Widget build(BuildContext context) {
    final o = _order;
    final names = ref.watch(tableNamesProvider);
    final title = widget.tableId == null ? 'Mang đi' : 'Bàn ${names[widget.tableId] ?? ''}';
    final closed = _status == OrderStatus.paid || _status == OrderStatus.cancelled;
    final canUseTables = o != null && !o.isTakeaway && !closed && _status != OrderStatus.awaiting;
    final role = ref.watch(currentUserProvider).valueOrNull?.role;
    final showMenu = !closed;
    final menu = MenuBrowser(
      showSearch: _status != OrderStatus.awaiting,
      onPick: (item) => setState(() => _cart.add(item)),
      onLongPress: role == null || role == UserRole.barista ? null : _toggleAvailable,
    );
    final panel = _CartPanel(state: this);
    final isTablet = MediaQuery.sizeOf(context).width >= 600;
    return Scaffold(
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title),
          Text(_subtitle(o),
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: _status == OrderStatus.awaiting ? AppColors.red : AppColors.muted)),
        ]),
        actions: [
          if (o != null && !closed)
            PopupMenuButton<String>(
              tooltip: 'Thao tác đơn',
              onSelected: (a) => switch (a) {
                'move' => _transfer(false),
                'merge' => _transfer(true),
                _ => _cancel(),
              },
              itemBuilder: (_) => [
                if (canUseTables) const PopupMenuItem(value: 'move', child: Text('Chuyển bàn')),
                if (canUseTables) const PopupMenuItem(value: 'merge', child: Text('Gộp bàn')),
                const PopupMenuItem(value: 'cancel', child: Text('Hủy đơn')),
              ],
            ),
        ],
      ),
      body: Column(children: [
        const OfflineBanner(),
        if (_status == OrderStatus.awaiting)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: DashedBox(
              color: AppColors.red,
              padding: const EdgeInsets.all(8),
              child: Text(
                  o!.tableId != null && ref.watch(_openOrderOfTable(o.tableId!)) != null
                      ? 'Bàn đang có đơn ${ref.watch(_openOrderOfTable(o.tableId!))!.code}. Món khách gọi thêm sẽ được thêm vào đơn đó.'
                      : 'Đơn chưa vào pha chế. Sửa, đổi hoặc thêm món như đơn thường; giá đổi hoặc hết món thì báo lại khách.',
                  style: const TextStyle(fontSize: 13)),
            ),
          ),
        Expanded(
          child: isTablet
              ? Row(children: [
                  if (showMenu) Expanded(child: Padding(padding: pagePadding, child: menu)),
                  SizedBox(width: 380, child: panel),
                ])
              : Column(children: [
                  if (showMenu) Expanded(child: Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 8), child: menu)),
                  if (showMenu)
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.5),
                      child: panel,
                    )
                  else
                    Expanded(child: panel),
                ]),
        ),
      ]),
    );
  }
}

/// The table's current open order, used for the customer add-on review.
final _openOrderOfTable = Provider.autoDispose.family<Order?, String>((ref, tableId) {
  final tables = ref.watch(tablesProvider).valueOrNull ?? const <CafeTable>[];
  final orderId = tables.where((t) => t.id == tableId).firstOrNull?.currentOrderId;
  if (orderId == null) return null;
  final orders = ref.watch(openOrdersProvider).valueOrNull ?? const <Order>[];
  return orders.where((o) => o.id == orderId).firstOrNull;
});

class _CartPanel extends ConsumerWidget {
  const _CartPanel({required this.state});
  final _EditorState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final o = state._order;
    final status = state._status;
    final saved = state._saved;
    final cart = state._cart;
    final closed = status == OrderStatus.paid || status == OrderStatus.cancelled;
    final isReview = status == OrderStatus.awaiting;
    final open = isReview && o!.tableId != null ? ref.watch(_openOrderOfTable(o.tableId!)) : null;
    final products = {for (final p in ref.watch(productsProvider).valueOrNull ?? const <Product>[]) p.id: p};
    final count = [...saved, ...cart].fold(0, (s, i) => s + i.qty);
    final sum = subtotalOf([...saved, ...cart]);
    final busy = ref.watch(orderControllerProvider).isLoading;
    final unavailable = !isReview ? 0 : saved.where((i) => products[i.productId]?.isAvailable != true).length;

    return Container(
      color: AppColors.fill,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Flexible(
          child: ListView(shrinkWrap: true, padding: const EdgeInsets.fromLTRB(16, 12, 16, 4), children: [
            if (open != null) ...[
              SectionLabel('ĐƠN ĐANG MỞ · ${open.code} · ${open.status.label.toUpperCase()} · CHỈ ĐỌC'),
              for (final i in open.items) _ReadOnlyLine(i),
            ],
            if (isReview) SectionLabel(open != null ? 'MÓN KHÁCH GỌI THÊM' : 'MÓN KHÁCH ĐẶT'),
            if (isReview)
              for (final (index, i) in saved.indexed)
                _ReviewLine(
                  item: i,
                  product: products[i.productId],
                  onEdit: () => state._editSaved(index),
                  onRemove: () => state._removeSaved(index),
                )
            else if (state._editable)
              for (final (index, i) in saved.indexed)
                Dismissible(
                  key: ValueKey('saved-$index-${i.productId}-${i.size}'),
                  direction: DismissDirection.endToStart,
                  background: const _SwipeDelete(),
                  onDismissed: (_) => state._removeSaved(index),
                  child: _ReadOnlyLine(i, onEdit: () => state._editSaved(index)),
                )
            else
              ..._batches(saved, status),
            if (cart.isNotEmpty && o != null && !isReview) const SectionLabel('MỚI THÊM'),
            for (final (index, i) in cart.indexed)
              Dismissible(
                key: ValueKey('cart-$index-${i.productId}-${i.size}-${i.qty}'),
                direction: DismissDirection.endToStart,
                background: const _SwipeDelete(),
                onDismissed: (_) => state._update(() => cart.removeAt(index)),
                child: _ReadOnlyLine(i, onEdit: () => state._editDraft(index)),
              ),
            if (cart.isEmpty && saved.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('Chọn món ở trên để thêm vào đơn', style: TextStyle(color: AppColors.muted)),
              ),
            if (state._editable && !isReview && saved.isNotEmpty)
              const Text('Chạm ✎ để sửa size / topping / số lượng / ghi chú · vuốt trái để xoá',
                  style: TextStyle(fontSize: 12, color: AppColors.muted)),
            if ((status == OrderStatus.ready || status == OrderStatus.served) && cart.isNotEmpty)
              Text('Lượt ${maxBatch(saved)} chỉ đọc; lượt ${maxBatch(saved) + 1} gửi đi thì đơn quay về chờ pha',
                  style: const TextStyle(fontSize: 12, color: AppColors.muted)),
          ]),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: SafeArea(
            top: false,
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              InfoRow(isReview && open != null ? 'Món gọi thêm · $count món' : 'Tạm tính · $count món', formatVnd(sum), bold: true),
              if (open != null) InfoRow('Tổng đơn ${open.code} sau khi thêm', formatVnd(open.subtotal + sum)),
              if (open != null)
                Text(
                  open.status == OrderStatus.ready || open.status == OrderStatus.served
                      ? 'Món thêm thành lượt mới, đơn quay về chờ pha. Yêu cầu này đóng với lý do "Gộp vào ${open.code}".'
                      : 'Món thêm vào lượt hiện tại. Yêu cầu này đóng với lý do "Gộp vào ${open.code}".',
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              if (unavailable > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('Còn $unavailable món hết hàng — đổi hoặc bỏ trước khi xác nhận',
                      style: const TextStyle(color: AppColors.red, fontSize: 13)),
                ),
              if (status == OrderStatus.cancelled && o?.cancelReason != null)
                Text('Lý do hủy: ${o!.cancelReason}', style: const TextStyle(color: AppColors.red)),
              const SizedBox(height: 8),
              if (!closed) _actions(busy, unavailable, saved, cart, open),
            ]),
          ),
        ),
      ]),
    );
  }

  List<Widget> _batches(List<OrderItem> items, OrderStatus? status) {
    final batches = items.map((i) => i.batch).toSet().toList()..sort();
    final label = (status ?? OrderStatus.pending).label.toUpperCase();
    return [
      for (final b in batches) ...[
        SectionLabel('LƯỢT $b · $label · CHỈ ĐỌC'),
        for (final i in items.where((i) => i.batch == b)) _ReadOnlyLine(i),
      ],
    ];
  }

  Widget _actions(bool busy, int unavailable, List<OrderItem> saved, List<OrderItem> cart, Order? open) {
    final status = state._status;
    Widget primary(String label, VoidCallback? onTap) => FilledButton(onPressed: busy ? null : onTap, child: Text(label));
    Widget secondary(String label, VoidCallback onTap) => OutlinedButton(onPressed: busy ? null : onTap, child: Text(label));
    final hasNew = cart.isNotEmpty;

    final (Widget left, Widget right) = switch (status) {
      null => (secondary('Hủy đơn', state._cancel), primary('Gửi pha chế', hasNew ? state._send : null)),
      OrderStatus.awaiting => (
          secondary('Từ chối', state._cancel),
          primary(open != null ? 'Thêm vào ${open.code}' : 'Xác nhận',
              unavailable == 0 && [...saved, ...cart].isNotEmpty ? state._confirmCustomer : null),
        ),
      OrderStatus.pending => (secondary('Hủy đơn', state._cancel), primary('Cập nhật', state._dirty ? state._send : null)),
      OrderStatus.preparing => (secondary('Hủy đơn', state._cancel), primary('Gửi món thêm', hasNew ? state._send : null)),
      OrderStatus.ready when hasNew => (
          secondary('Bỏ món thêm', () => state._update(cart.clear)),
          primary('Gửi pha chế lượt ${maxBatch(saved) + 1}', state._send),
        ),
      OrderStatus.ready => (secondary('Hủy đơn', state._cancel), primary('Đã phục vụ', state._serve)),
      OrderStatus.served when hasNew => (
          secondary('Bỏ món thêm', () => state._update(cart.clear)),
          primary('Gửi pha chế lượt ${maxBatch(saved) + 1}', state._send),
        ),
      _ => (
          secondary('Hủy đơn', state._cancel),
          Builder(builder: (context) => primary('Thanh toán', () => context.push(Routes.pay(state._order!.id)))),
        ),
    };
    return Row(children: [Expanded(child: left), const SizedBox(width: 10), Expanded(child: right)]);
  }
}

class _SwipeDelete extends StatelessWidget {
  const _SwipeDelete();
  @override
  Widget build(BuildContext context) => Container(
        color: AppColors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Text('Xoá', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      );
}

class _ReadOnlyLine extends StatelessWidget {
  const _ReadOnlyLine(this.item, {this.onEdit});
  final OrderItem item;
  final VoidCallback? onEdit;
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(item.label)),
              Text(formatVnd(item.lineTotal)),
              if (onEdit != null) ...[const SizedBox(width: 6), const Icon(Icons.edit_outlined, size: 16)],
            ]),
            if (item.note.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text('Ghi chú: ${item.note}',
                    style: const TextStyle(fontStyle: FontStyle.italic, color: AppColors.muted, fontSize: 13)),
              ),
          ]),
        ),
      );
}

/// QR review card with the price comparison of UC22.
class _ReviewLine extends StatelessWidget {
  const _ReviewLine({required this.item, required this.product, required this.onEdit, required this.onRemove});
  final OrderItem item;
  final Product? product;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final p = product;
    final unavailable = p == null || !p.isAvailable;
    final current = p == null ? item.unitPrice : currentUnitPrice(p, item);
    final changed = !unavailable && current != item.unitPrice;
    final warn = unavailable || changed;
    Widget small(String label, VoidCallback onTap) => OutlinedButton(
          style: OutlinedButton.styleFrom(minimumSize: const Size(44, 34), textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          onPressed: onTap,
          child: Text(label),
        );
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: warn ? AppColors.red : AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Text(item.label,
                style: TextStyle(fontWeight: FontWeight.w700, color: unavailable ? AppColors.disabled : AppColors.text)),
          ),
          Text(formatVnd(unavailable ? item.lineTotal : current * item.qty),
              style: TextStyle(color: unavailable ? AppColors.disabled : AppColors.text)),
        ]),
        const SizedBox(height: 4),
        Row(children: [
          Expanded(
            child: Text(
              unavailable
                  ? 'Hết hàng · hỏi khách đổi món'
                  : changed
                      ? '⚠ Giá đổi ${formatNumber(item.unitPrice)} → ${formatVnd(current)}, báo lại khách'
                      : item.note.isNotEmpty
                          ? 'Ghi chú: ${item.note}'
                          : 'Giá khớp menu hiện tại',
              style: TextStyle(fontSize: 13, color: warn ? AppColors.red : AppColors.muted),
            ),
          ),
          const SizedBox(width: 6),
          if (unavailable) ...[
            small('Đổi', () {
              onRemove();
              showMessage(context, 'Chọn món thay thế ở thực đơn phía trên');
            }),
            const SizedBox(width: 4),
            small('Bỏ', onRemove),
          ] else
            small('✎ Sửa', onEdit),
        ]),
      ]),
    );
  }
}

class _CancelDialog extends StatefulWidget {
  const _CancelDialog({required this.status, required this.isReject});
  final OrderStatus status;
  final bool isReject;
  @override
  State<_CancelDialog> createState() => _CancelDialogState();
}

class _CancelDialogState extends State<_CancelDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reason = TextEditingController();
  late bool? _made = madeDefault(widget.status);

  static const _presets = ['Khách đổi ý', 'Hết nguyên liệu', 'Nhập nhầm đơn'];

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.isReject ? 'Từ chối đơn' : 'Hủy đơn',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        content: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Wrap(spacing: 6, runSpacing: 6, children: [
              for (final p in _presets) Pill(label: p, onTap: () => setState(() => _reason.text = p)),
            ]),
            const SizedBox(height: 10),
            TextFormField(
              controller: _reason,
              maxLength: 200,
              decoration: const InputDecoration(hintText: 'Lý do hủy *'),
              validator: (v) => validateRequired(v, msg('MSG32')),
            ),
            if (_made != null)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Đã pha (trừ kho nguyên liệu)'),
                value: _made,
                onChanged: (v) => setState(() => _made = v),
              ),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.pop(context, (_reason.text.trim(), _made ?? false));
              }
            },
            child: const Text('Xác nhận hủy'),
          ),
        ],
      );
}

class _MoveSheet extends ConsumerWidget {
  const _MoveSheet({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tables = (ref.watch(tablesProvider).valueOrNull ?? const <CafeTable>[])
        .where((t) => t.currentOrderId == null && t.id != order.tableId)
        .toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
      const SheetTitle('Chuyển sang bàn trống'),
      if (tables.isEmpty) const EmptyView('Không còn bàn trống'),
      for (final t in tables)
        ListRow(
          title: t.name,
          subtitle: '${t.area} · ${t.capacity} chỗ',
          onTap: () async {
            final ok = await ref.read(orderControllerProvider.notifier).moveTable(order.id, t.id);
            if (!context.mounted) return;
            Navigator.pop(context);
            if (!ok) showMessage(context, ErrorMapper.message(ref.read(orderControllerProvider).error));
          },
        ),
    ]);
  }
}

class _MergeSheet extends ConsumerStatefulWidget {
  const _MergeSheet({required this.source});
  final Order source;
  @override
  ConsumerState<_MergeSheet> createState() => _MergeSheetState();
}

class _MergeSheetState extends ConsumerState<_MergeSheet> {
  Order? _target;

  @override
  Widget build(BuildContext context) {
    final s = widget.source;
    final names = ref.watch(tableNamesProvider);
    final others = (ref.watch(openOrdersProvider).valueOrNull ?? const <Order>[])
        .where((o) => o.id != s.id && o.tableId != null && o.status != OrderStatus.awaiting)
        .toList();
    final sourceBlock = mergeBlock(s);
    final t = _target;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
      SheetTitle('Gộp bàn ${names.labelFor(s)} vào…'),
      const Text('Chỉ gộp được đơn đã phục vụ, chưa áp voucher, chưa gắn khách thân thiết hay đổi điểm.',
          style: TextStyle(color: AppColors.muted, fontSize: 13)),
      if (sourceBlock != null)
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text('Đơn này: $sourceBlock', style: const TextStyle(color: AppColors.red, fontSize: 13)),
        ),
      if (others.isEmpty) const EmptyView('Không có bàn nào để gộp'),
      RadioGroup<String>(
        groupValue: t?.id,
        onChanged: (id) => setState(() => _target = others.firstWhere((o) => o.id == id)),
        child: Column(children: [
          for (final o in others)
            Builder(builder: (_) {
              final block = mergeBlock(o);
              final blocked = block != null || sourceBlock != null;
              return RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                value: o.id,
                enabled: !blocked,
                title: Text('${names.labelFor(o)} · ${o.code}',
                    style: TextStyle(fontWeight: FontWeight.w700, color: blocked ? AppColors.disabled : null)),
                subtitle: Text(block ?? '${o.status.label} · ${formatVnd(o.total)}',
                    style: TextStyle(color: blocked ? AppColors.disabled : AppColors.muted, fontSize: 13)),
              );
            }),
        ]),
      ),
      if (t != null) ...[
        Text(
          'Đơn ${s.code} sẽ bị hủy với lý do "Gộp vào ${t.code}" (không trừ kho), bàn ${names.labelFor(s)} trở về trống.',
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 10),
        FilledButton(
          onPressed: () async {
            final ok = await ref.read(orderControllerProvider.notifier).merge(s.id, t.id);
            if (!context.mounted) return;
            if (ok) {
              Navigator.pop(context);
              context.pop();
            } else {
              showMessage(context, ErrorMapper.message(ref.read(orderControllerProvider).error));
            }
          },
          child: Text('Gộp vào ${names.labelFor(t)} · ${formatVnd(t.total + s.subtotal)}'),
        ),
      ],
    ]);
  }
}

