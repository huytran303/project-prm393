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
import '../../auth/presentation/profile_screen.dart' show vietQrBanks;
import '../../loyalty/presentation/customer_sheet.dart';
import '../../staff/application/staff_providers.dart';
import '../application/order_rules.dart';
import '../application/payment_controller.dart';
import '../application/pos_providers.dart';
import 'receipt.dart';

enum _Method { cash, transfer, split }

class PaymentScreen extends ConsumerWidget {
  const PaymentScreen({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(orderProvider(orderId));
    return value.when(
      skipLoadingOnReload: true,
      loading: () => const Scaffold(body: LoadingView()),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: ErrorView(error: e, onRetry: () => ref.invalidate(orderProvider(orderId))),
      ),
      data: (o) => _Payment(key: ValueKey(orderId), order: o),
    );
  }
}

class _Payment extends ConsumerStatefulWidget {
  const _Payment({super.key, required this.order});
  final Order order;
  @override
  ConsumerState<_Payment> createState() => _PaymentState();
}

class _PaymentState extends ConsumerState<_Payment> {
  _Method _method = _Method.cash;
  final _received = TextEditingController();
  final _transfer = TextEditingController();
  final _voucher = TextEditingController();
  String? _error;
  bool _paid = false;

  Order get _o => widget.order;
  int get _total => _o.total;
  int get _qrAmount => switch (_method) {
        _Method.cash => 0,
        _Method.transfer => _total,
        _Method.split => parseMoney(_transfer.text) ?? 0,
      };
  int get _cashPortion => _total - _qrAmount;
  int get _receivedAmount => parseMoney(_received.text) ?? 0;

  /// Why the entered amounts cannot be accepted yet, or null.
  String? get _inputError {
    if (_total == 0) return null;
    if (_method == _Method.split && (_qrAmount <= 0 || _qrAmount >= _total)) return msg('MSG44');
    if (_method != _Method.transfer && _receivedAmount < _cashPortion) return msg('MSG27');
    return null;
  }

  Future<void> _confirm() async {
    final inputError = _inputError;
    if (inputError != null) return setState(() => _error = inputError);
    setState(() => _error = null);
    final paidBefore = _o;
    final change = _method == _Method.transfer ? null : changeDue(_receivedAmount, _cashPortion);
    final input = PaymentInput(cash: _total == 0 ? 0 : _cashPortion, qr: _total == 0 ? 0 : _qrAmount);
    final ok = await ref.read(paymentControllerProvider.notifier).pay(paidBefore, input);
    if (!mounted) return;
    if (!ok) {
      return setState(() => _error = ErrorMapper.message(ref.read(paymentControllerProvider).error));
    }
    setState(() => _paid = true);
    showMessage(context, msg('MSG26'));
    final settings = ref.read(shopSettingsProvider).valueOrNull ?? const ShopSettings();
    final place = ref.read(tableNamesProvider).labelFor(paidBefore);
    final fresh = await ref.read(orderRepositoryProvider).watchOrder(paidBefore.id).first;
    if (!mounted) return;
    await showReceipt(context, fresh, settings, place, change: change);
    if (mounted) context.go(Routes.pos);
  }

  Future<void> _applyVoucher() async {
    final ok = await ref.read(paymentControllerProvider.notifier).applyVoucher(_o, _voucher.text);
    if (!mounted) return;
    setState(() => _error = ok ? null : ErrorMapper.message(ref.read(paymentControllerProvider).error));
  }

  @override
  Widget build(BuildContext context) {
    final o = _o;
    final settings = ref.watch(shopSettingsProvider).valueOrNull ?? const ShopSettings();
    final user = ref.watch(currentUserProvider).valueOrNull;
    final openShift = ref.watch(openShiftProvider).valueOrNull;
    final hasShift = ref.watch(openShiftProvider).isLoading || openShift != null;
    final busy = ref.watch(paymentControllerProvider).isLoading;
    final serveBlocked = o.status != OrderStatus.served && !_paid;
    final needsBank = _method != _Method.cash && !settings.hasBankAccount && _total > 0;
    final pointsValue = o.pointsRedeemed * settings.vndPerPoint;

    return Scaffold(
      appBar: AppBar(title: Text('Thanh toán · ${o.code}')),
      bottomNavigationBar: BottomBar(
        child: _method == _Method.transfer && _total > 0
            ? Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: busy ? null : () => setState(() => _method = _Method.cash),
                    child: const Text('Hủy'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: busy || serveBlocked || !hasShift || needsBank ? null : _confirm,
                    child: const Text('Đã nhận tiền'),
                  ),
                ),
              ])
            : FilledButton(
                onPressed: busy || serveBlocked || !hasShift || needsBank ? null : _confirm,
                child: const Text('Xác nhận thanh toán'),
              ),
      ),
      body: ListView(padding: pagePadding, children: [
        if (serveBlocked)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('Đơn đang ở trạng thái "${o.status.label}", chỉ thanh toán được khi đã phục vụ.',
                style: const TextStyle(color: AppColors.red)),
          ),
        if (!hasShift)
          _Blocker(text: msg('MSG28'), action: 'Vào ca', onTap: () => context.push(Routes.shift)),
        if (needsBank)
          _Blocker(
            text: msg('MSG29'),
            action: user?.role == UserRole.manager ? 'Cấu hình' : null,
            onTap: () => context.push(Routes.profile),
          ),
        OutlineCard(
          child: Column(children: [for (final i in o.items) InfoRow(i.label, formatVnd(i.lineTotal))]),
        ),
        const SizedBox(height: 10),
        CustomerRow(order: o, settings: settings),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(
            child: TextField(
              controller: _voucher,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(hintText: 'Mã voucher'),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(onPressed: busy ? null : _applyVoucher, child: const Text('Áp dụng')),
        ]),
        const SizedBox(height: 10),
        InfoRow('Tạm tính', formatVnd(o.subtotal)),
        if (o.voucherCode != null)
          Row(children: [
            Expanded(child: InfoRow('Voucher (${o.voucherCode})', '−${formatVnd(o.discount)}')),
            IconButton(
              tooltip: 'Bỏ voucher',
              icon: const Icon(Icons.close, size: 18),
              onPressed: () => ref.read(paymentControllerProvider.notifier).removeVoucher(o),
            ),
          ]),
        if (o.pointsRedeemed > 0) InfoRow('Đổi ${o.pointsRedeemed} điểm', '−${formatVnd(pointsValue)}'),
        const SizedBox(height: 4),
        InfoRow('Tổng cộng', formatVnd(_total), bold: true, size: 20),
        const SizedBox(height: 10),
        if (_total > 0) ...[
          SegmentBar<_Method>(
            options: const {_Method.cash: 'Tiền mặt', _Method.transfer: 'Chuyển khoản', _Method.split: 'Kết hợp'},
            selected: _method,
            onSelected: (m) => setState(() {
              _method = m;
              _error = null;
            }),
          ),
          const SizedBox(height: 12),
          if (_method == _Method.split)
            LabeledField(
              label: 'Phần chuyển khoản (VietQR)',
              child: MoneyField(controller: _transfer, onChanged: (_) => setState(() {})),
            ),
          if (_method != _Method.cash && _qrAmount > 0 && settings.hasBankAccount)
            _VietQrBlock(order: o, settings: settings, amount: _qrAmount, isSplit: _method == _Method.split),
          if (_method != _Method.transfer) ...[
            if (_method == _Method.split) ...[
              const Divider(height: 24),
              InfoRow('Phần tiền mặt', formatVnd(_cashPortion), bold: true),
              const SizedBox(height: 8),
            ],
            LabeledField(
              label: 'Khách đưa',
              child: MoneyField(controller: _received, onChanged: (_) => setState(() {})),
            ),
            Wrap(spacing: 6, runSpacing: 6, children: [
              for (final v in _presets(_cashPortion))
                Pill(
                  label: formatNumber(v),
                  onTap: () => setState(() => _received.text = formatNumber(v)),
                ),
            ]),
            const SizedBox(height: 10),
            if (_receivedAmount >= _cashPortion)
              InfoRow('Tiền thừa', formatVnd(changeDue(_receivedAmount, _cashPortion)), bold: true, size: 17),
          ],
        ],
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(_error!, style: const TextStyle(color: AppColors.red)),
          ),
      ]),
    );
  }

  /// The exact amount followed by the next round bills.
  List<int> _presets(int amount) {
    final options = <int>{amount};
    for (final step in const [50000, 100000, 200000, 500000]) {
      options.add(((amount + step - 1) ~/ step) * step);
    }
    return (options.where((v) => v > 0).toList()..sort()).take(4).toList();
  }
}

class _Blocker extends StatelessWidget {
  const _Blocker({required this.text, this.action, required this.onTap});
  final String text;
  final String? action;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: DashedBox(
          color: AppColors.red,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(children: [
            Expanded(child: Text(text, style: const TextStyle(color: AppColors.red))),
            if (action != null) TextButton(onPressed: onTap, child: Text(action!)),
          ]),
        ),
      );
}

class _VietQrBlock extends StatelessWidget {
  const _VietQrBlock({required this.order, required this.settings, required this.amount, required this.isSplit});
  final Order order;
  final ShopSettings settings;
  final int amount;
  final bool isSplit;

  @override
  Widget build(BuildContext context) {
    final url = vietQrUrl(settings, amount, order.code)!;
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        width: 130,
        height: 130,
        child: Image.network(
          url,
          fit: BoxFit.contain,
          webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
          errorBuilder: (_, _, _) => const ImagePlaceholder(),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _BankRow('Ngân hàng', vietQrBanks[settings.bankBin] ?? settings.bankBin),
          _BankRow('Số tài khoản', settings.bankAccountNo),
          _BankRow('Chủ tài khoản', settings.bankAccountName),
          _BankRow('Số tiền', formatVnd(amount)),
          _BankRow('Nội dung', transferNote(order.code)),
          const SizedBox(height: 4),
          Text(
            isSplit
                ? 'QR chỉ gồm phần chuyển khoản. Kiểm tra app ngân hàng trước khi xác nhận.'
                : 'Kiểm tra app ngân hàng, sau đó bấm xác nhận đã nhận tiền.',
            style: const TextStyle(fontSize: 12, color: AppColors.muted),
          ),
        ]),
      ),
    ]);
  }
}

class _BankRow extends StatelessWidget {
  const _BankRow(this.label, this.value);
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, textAlign: TextAlign.end, style: const TextStyle(fontSize: 13))),
        ]),
      );
}
