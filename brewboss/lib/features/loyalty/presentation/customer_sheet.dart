import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';
import '../../pos/application/order_rules.dart';
import '../../pos/application/payment_controller.dart';
import '../application/loyalty_providers.dart';
import '../application/loyalty_rules.dart';

/// S15 row: the attached customer with points, or the entry to attach one.
class CustomerRow extends ConsumerWidget {
  const CustomerRow({super.key, required this.order, required this.settings});
  final Order order;
  final ShopSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = order.customerId;
    if (id == null) {
      return OutlineCard(
        onTap: () => showAppSheet<void>(context, (_) => CustomerSheet(order: order)),
        child: const Row(children: [
          Icon(Icons.card_giftcard_outlined, size: 18),
          SizedBox(width: 8),
          Expanded(child: Text('Thêm khách thân thiết')),
          Icon(Icons.chevron_right, size: 20),
        ]),
      );
    }
    final customer = ref.watch(customerProvider(id)).valueOrNull;
    if (customer == null) return const OutlineCard(child: Text('Đang tải khách hàng…'));
    final beforePoints = totalOf(order.subtotal, order.discount, 0, settings.vndPerPoint);
    final max = maxRedeemable(customer.points, beforePoints, settings.vndPerPoint);
    final controller = ref.read(paymentControllerProvider.notifier);
    return OutlineCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Text('${customer.name ?? '(chưa có tên)'} · ${formatPhone(customer.phone)}',
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
          StatusBadge('${customer.points} điểm'),
          IconButton(
            tooltip: 'Bỏ khách',
            icon: const Icon(Icons.close, size: 18),
            onPressed: () => controller.detachCustomer(order),
          ),
        ]),
        Text('${customer.visitCount} lần ghé', style: const TextStyle(color: AppColors.muted, fontSize: 13)),
        if (max > 0) ...[
          const SizedBox(height: 6),
          _PointsInput(order: order, customer: customer, max: max),
        ],
      ]),
    );
  }
}

class _PointsInput extends ConsumerStatefulWidget {
  const _PointsInput({required this.order, required this.customer, required this.max});
  final Order order;
  final Customer customer;
  final int max;
  @override
  ConsumerState<_PointsInput> createState() => _PointsInputState();
}

class _PointsInputState extends ConsumerState<_PointsInput> {
  late final _points = TextEditingController(text: widget.order.pointsRedeemed == 0 ? '' : '${widget.order.pointsRedeemed}');

  Future<void> _apply(int points) async {
    final controller = ref.read(paymentControllerProvider.notifier);
    final ok = await controller.redeemPoints(widget.order, widget.customer, points);
    if (!ok && mounted) showMessage(context, ErrorMapper.message(ref.read(paymentControllerProvider).error));
  }

  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(
          child: TextField(
            controller: _points,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Dùng điểm (tối đa ${widget.max})'),
            onSubmitted: (v) => _apply(int.tryParse(v) ?? 0),
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          style: OutlinedButton.styleFrom(minimumSize: const Size(48, 44), textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          onPressed: () => _apply(int.tryParse(_points.text) ?? 0),
          child: const Text('Dùng'),
        ),
        const SizedBox(width: 4),
        OutlinedButton(
          style: OutlinedButton.styleFrom(minimumSize: const Size(48, 44), textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          onPressed: () {
            _points.text = '${widget.max}';
            _apply(widget.max);
          },
          child: const Text('Dùng tối đa'),
        ),
      ]);
}

/// UC38: phone lookup, or create a customer when the phone is new.
class CustomerSheet extends ConsumerStatefulWidget {
  const CustomerSheet({super.key, required this.order});
  final Order order;
  @override
  ConsumerState<CustomerSheet> createState() => _CustomerSheetState();
}

class _CustomerSheetState extends ConsumerState<CustomerSheet> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _name = TextEditingController();
  Customer? _found;
  bool _searched = false;

  Future<void> _search() async {
    if (!_formKey.currentState!.validate()) return;
    final found = await ref.read(loyaltyRepositoryProvider).findByPhone(_phone.text);
    if (mounted) {
      setState(() {
        _found = found;
        _searched = true;
      });
    }
  }

  Future<void> _attach() async {
    final name = _name.text.trim();
    final ok = await ref
        .read(paymentControllerProvider.notifier)
        .attachCustomer(widget.order, _phone.text, name: name.isEmpty ? null : name);
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
    } else {
      showMessage(context, ErrorMapper.message(ref.read(paymentControllerProvider).error));
    }
  }

  @override
  Widget build(BuildContext context) => Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          const SheetTitle('Khách thân thiết'),
          LabeledField(
            label: 'Số điện thoại',
            child: TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              validator: (v) => validatePhone(normalizePhone(v ?? '')),
              onChanged: (_) => setState(() => _searched = false),
              onFieldSubmitted: (_) => _search(),
            ),
          ),
          if (!_searched) OutlinedButton(onPressed: _search, child: const Text('Tìm')),
          if (_searched && _found != null) ...[
            OutlineCard(
              child: InfoRow('${_found!.name ?? '(chưa có tên)'} · ${_found!.visitCount} lần ghé', '${_found!.points} điểm', bold: true),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: _attach, child: const Text('Gắn khách vào đơn')),
          ],
          if (_searched && _found == null) ...[
            LabeledField(label: 'Tên (không bắt buộc)', child: TextFormField(controller: _name)),
            FilledButton(onPressed: _attach, child: const Text('Tạo khách mới')),
          ],
        ]),
      );
}

