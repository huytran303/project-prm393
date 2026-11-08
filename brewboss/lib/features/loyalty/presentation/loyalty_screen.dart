import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../core/utils/format.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';
import '../../reports/application/report_providers.dart';
import '../application/loyalty_providers.dart';
import '../application/voucher_controller.dart';

class LoyaltyScreen extends ConsumerStatefulWidget {
  const LoyaltyScreen({super.key});
  @override
  ConsumerState<LoyaltyScreen> createState() => _LoyaltyScreenState();
}

class _LoyaltyScreenState extends ConsumerState<LoyaltyScreen> with SingleTickerProviderStateMixin {
  late final _tabs = TabController(length: 2, vsync: this)..addListener(() => setState(() {}));

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Khách hàng & Voucher'),
          bottom: TabBar(controller: _tabs, tabs: const [Tab(text: 'Khách hàng'), Tab(text: 'Voucher')]),
        ),
        floatingActionButton: _tabs.index == 0
            ? null
            : FloatingActionButton(
                tooltip: 'Thêm voucher',
                onPressed: () => showAppSheet<void>(context, (_) => const _VoucherForm()),
                child: const Icon(Icons.add),
              ),
        body: TabBarView(controller: _tabs, children: const [_CustomerTab(), _VoucherTab()]),
      );
}

class _CustomerTab extends ConsumerStatefulWidget {
  const _CustomerTab();
  @override
  ConsumerState<_CustomerTab> createState() => _CustomerTabState();
}

class _CustomerTabState extends ConsumerState<_CustomerTab> {
  String _text = '';
  bool _byVisits = false;

  @override
  Widget build(BuildContext context) => AsyncBody(ref.watch(customersProvider), retry: customersProvider, builder: (all) {
        final q = foldAccents(_text);
        final rows = all.where((c) => foldAccents('${c.phone} ${c.name ?? ''}').contains(q)).toList()
          ..sort((a, b) => _byVisits ? b.visitCount.compareTo(a.visitCount) : b.points.compareTo(a.points));
        return ListView(padding: pagePadding, children: [
          SearchField(hint: 'Tìm theo SĐT, tên', onChanged: (v) => setState(() => _text = v)),
          const SizedBox(height: 10),
          PillFilter<bool>(
            options: const {false: 'Theo điểm', true: 'Theo lần ghé'},
            selected: _byVisits,
            onSelected: (v) => setState(() => _byVisits = v),
          ),
          const SizedBox(height: 6),
          if (rows.isEmpty) const EmptyView('Không tìm thấy khách hàng'),
          for (final c in rows)
            ListRow(
              title: c.name ?? '(chưa có tên)',
              subtitle: '${formatPhone(c.phone)} · ${c.visitCount} lần ghé',
              leading: InitialAvatar(c.name ?? ''),
              trailing: StatusBadge('${c.points} điểm'),
              onTap: () => showAppSheet<void>(context, (_) => _CustomerDetail(customer: c)),
            ),
        ]);
      });
}

class _CustomerDetail extends ConsumerStatefulWidget {
  const _CustomerDetail({required this.customer});
  final Customer customer;
  @override
  ConsumerState<_CustomerDetail> createState() => _CustomerDetailState();
}

class _CustomerDetailState extends ConsumerState<_CustomerDetail> {
  late final _name = TextEditingController(text: widget.customer.name);

  Future<void> _save() async {
    final name = _name.text.trim();
    final ok = await ref.read(voucherControllerProvider.notifier).updateCustomerName(widget.customer.id, name.isEmpty ? null : name);
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
    } else {
      showMessage(context, ErrorMapper.message(ref.read(voucherControllerProvider).error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = customerOrdersProvider(widget.customer.id);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
      SheetTitle(formatPhone(widget.customer.phone)),
      LabeledField(label: 'Tên', child: TextField(controller: _name)),
      FilledButton(onPressed: _save, child: const Text('Lưu')),
      const SectionLabel('ĐƠN ĐÃ THANH TOÁN'),
      AsyncBody(ref.watch(orders), retry: orders, builder: (list) {
        if (list.isEmpty) return const EmptyView('Chưa có đơn nào');
        return Column(children: [
          for (final o in list)
            InfoRow('${o.code} · ${o.paidAt == null ? '' : formatDayTime(o.paidAt!)}', formatVnd(o.total)),
        ]);
      }),
    ]);
  }
}

class _VoucherTab extends ConsumerWidget {
  const _VoucherTab();

  String _terms(Voucher v) {
    final amount = v.type == VoucherType.percent
        ? 'Giảm ${v.value}%${v.maxDiscount == null ? '' : ', tối đa ${formatVnd(v.maxDiscount!)}'}'
        : 'Giảm ${formatVnd(v.value)}';
    return '$amount · Đơn từ ${formatVnd(v.minOrder)}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      AsyncBody(ref.watch(vouchersProvider), retry: vouchersProvider, builder: (vouchers) {
        if (vouchers.isEmpty) return const EmptyView('Chưa có voucher nào');
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
          itemCount: vouchers.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            final v = vouchers[i];
            final expired = v.expiresAt?.isBefore(DateTime.now()) ?? false;
            final dim = !v.isActive || expired;
            final expiry = v.expiresAt == null ? '' : formatDate(v.expiresAt!);
            return OutlineCard(
              onTap: () => showAppSheet<void>(context, (_) => _VoucherForm(voucher: v)),
              child: Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(v.code, style: TextStyle(fontWeight: FontWeight.w700, color: dim ? AppColors.muted : null)),
                    Text(_terms(v), style: TextStyle(color: dim ? AppColors.muted : null, fontSize: 14)),
                    Text(
                      expired ? 'Hết hạn $expiry' : 'HSD $expiry · Đã dùng ${v.usedCount}/${v.usageLimit}',
                      style: TextStyle(fontSize: 13, color: expired ? AppColors.red : AppColors.muted),
                    ),
                  ]),
                ),
                Switch(
                  value: v.isActive,
                  onChanged: (active) async {
                    if (!active && !await confirmDialog(context, title: 'Tắt voucher ${v.code}?', confirm: 'Tắt')) return;
                    await ref.read(voucherControllerProvider.notifier).setActive(v.code, active);
                  },
                ),
              ]),
            );
          },
        );
      });
}

class _VoucherForm extends ConsumerStatefulWidget {
  const _VoucherForm({this.voucher});
  final Voucher? voucher;
  @override
  ConsumerState<_VoucherForm> createState() => _VoucherFormState();
}

class _VoucherFormState extends ConsumerState<_VoucherForm> {
  final _formKey = GlobalKey<FormState>();
  late final _code = TextEditingController(text: widget.voucher?.code);
  late VoucherType _type = widget.voucher?.type ?? VoucherType.percent;
  late final _value = TextEditingController(text: widget.voucher == null ? '' : formatNumber(widget.voucher!.value));
  late final _min = TextEditingController(text: formatNumber(widget.voucher?.minOrder ?? 0));
  late final _cap = TextEditingController(
      text: widget.voucher?.maxDiscount == null ? '' : formatNumber(widget.voucher!.maxDiscount!));
  late final _limit = TextEditingController(text: '${widget.voucher?.usageLimit ?? 100}');
  late DateTime? _expires = widget.voucher?.expiresAt;
  late bool _active = widget.voucher?.isActive ?? true;

  bool get _isNew => widget.voucher == null;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_expires == null) return showMessage(context, 'Vui lòng chọn ngày hết hạn');
    final v = (widget.voucher ?? Voucher(code: '', type: _type, value: 0)).copyWith(
      code: _code.text.trim().toUpperCase(),
      type: _type,
      value: parseMoney(_value.text)!,
      minOrder: parseMoney(_min.text)!,
      maxDiscount: _type == VoucherType.percent ? parseMoney(_cap.text) : null,
      expiresAt: _expires,
      usageLimit: parseMoney(_limit.text)!,
      isActive: _active,
    );
    final ok = await ref.read(voucherControllerProvider.notifier).save(v, isNew: _isNew);
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
    } else {
      showMessage(context, ErrorMapper.message(ref.read(voucherControllerProvider).error));
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final initial = _expires != null && !_expires!.isBefore(today) ? _expires! : today;
    final picked = await showDatePicker(
      context: context,
      firstDate: today,
      lastDate: today.add(const Duration(days: 3650)),
      initialDate: initial,
    );
    if (picked != null) {
      setState(() => _expires = DateTime(picked.year, picked.month, picked.day, 23, 59, 59));
    }
  }

  @override
  Widget build(BuildContext context) => Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          SheetTitle(_isNew ? 'Thêm voucher' : 'Sửa voucher'),
          LabeledField(
            label: 'Mã *',
            child: TextFormField(
              controller: _code,
              readOnly: !_isNew,
              textCapitalization: TextCapitalization.characters,
              validator: (v) => RegExp(r'^[A-Za-z0-9]+$').hasMatch(v ?? '') ? null : 'Mã chỉ gồm A–Z và 0–9',
            ),
          ),
          SegmentBar<VoucherType>(
            options: const {VoucherType.percent: 'Phần trăm', VoucherType.fixed: 'Số tiền'},
            selected: _type,
            onSelected: (t) => setState(() => _type = t),
          ),
          const SizedBox(height: 12),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: LabeledField(
                label: _type == VoucherType.percent ? 'Giảm (%) *' : 'Giảm (₫) *',
                child: MoneyField(controller: _value, validator: (v) => (parseMoney(v) ?? 0) > 0 ? null : 'Không hợp lệ'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: LabeledField(label: 'Đơn tối thiểu (₫) *', child: MoneyField(controller: _min, validator: validateMoney)),
            ),
          ]),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (_type == VoucherType.percent) ...[
              Expanded(child: LabeledField(label: 'Giảm tối đa (₫)', child: MoneyField(controller: _cap))),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: LabeledField(
                label: 'Số lượt *',
                child: TextFormField(
                  controller: _limit,
                  keyboardType: TextInputType.number,
                  validator: (v) => (parseMoney(v) ?? 0) >= 1 ? null : 'Tối thiểu 1',
                ),
              ),
            ),
          ]),
          LabeledField(
            label: 'Hết hạn *',
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border), textStyle: const TextStyle(fontSize: 15)),
              icon: const Icon(Icons.calendar_month_outlined, size: 18),
              label: Text(_expires == null ? 'Chọn ngày' : formatDate(_expires!)),
              onPressed: _pickDate,
            ),
          ),
          Row(children: [
            const Expanded(child: Text('Đang hoạt động', style: TextStyle(fontWeight: FontWeight.w700))),
            Switch(value: _active, onChanged: (v) => setState(() => _active = v)),
          ]),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: ref.watch(voucherControllerProvider).isLoading ? null : _save,
            child: const Text('Lưu'),
          ),
        ]),
      );
}
