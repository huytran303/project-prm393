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
import '../../staff/application/staff_providers.dart';
import '../application/auth_providers.dart';
import '../application/login_controller.dart';
import '../application/settings_controller.dart';

/// VietQR banks offered in shop settings: BIN → display name.
const vietQrBanks = {
  '970436': 'Vietcombank',
  '970415': 'VietinBank',
  '970418': 'BIDV',
  '970405': 'Agribank',
  '970422': 'MB Bank',
  '970407': 'Techcombank',
  '970416': 'ACB',
  '970432': 'VPBank',
  '970423': 'TPBank',
  '970403': 'Sacombank',
};

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final open = ref.read(openShiftProvider).valueOrNull;
    final action = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đăng xuất', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        content: Text(open != null ? msg('MSG05') : 'Bạn có chắc muốn đăng xuất?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          if (open != null)
            TextButton(onPressed: () => Navigator.pop(ctx, 'checkout'), child: const Text('Check-out và đăng xuất')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () => Navigator.pop(ctx, 'logout'),
            child: Text(open != null ? 'Vẫn đăng xuất' : 'Đăng xuất'),
          ),
        ],
      ),
    );
    if (!context.mounted || action == null) return;
    if (action == 'checkout') {
      context.push('${Routes.shift}?logout=1');
      return;
    }
    final ok = await ref.read(loginControllerProvider.notifier).signOut();
    if (!ok && context.mounted) {
      showMessage(context, ErrorMapper.message(ref.read(loginControllerProvider).error));
    }
  }

  void _edit(BuildContext context, ShopSettings s, Widget Function(ShopSettings) form) {
    showAppSheet<void>(context, (_) => form(s));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userValue = ref.watch(currentUserProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Tài khoản')),
      body: AsyncBody(userValue, retry: currentUserProvider, builder: (user) {
        if (user == null) return const LoadingView();
        final settings = ref.watch(shopSettingsProvider).valueOrNull ?? const ShopSettings();
        return Column(children: [
          Expanded(
            child: ListView(padding: pagePadding, children: [
              Row(children: [
                InitialAvatar(user.name, size: 72),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(user.name, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
                    Text(user.email, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
                    const SizedBox(height: 4),
                    StatusBadge(user.role.label, style: BadgeStyle.dark),
                  ]),
                ),
              ]),
              const SizedBox(height: 16),
              _NavRow(title: 'Đổi mật khẩu', plain: true, onTap: () => showAppSheet<void>(context, (_) => const _ChangePasswordForm())),
              if (user.role == UserRole.manager)
                _NavRow(title: 'Hàng đợi pha chế', plain: true, onTap: () => context.push(Routes.barista)),
              if (user.role == UserRole.supervisor) ...[
                const SectionLabel('TRƯỞNG CA'),
                _NavRow(title: 'Hàng đợi pha chế', plain: true, onTap: () => context.push(Routes.barista)),
                _NavRow(title: 'Giao ca', plain: true, onTap: () => context.push(Routes.shifts)),
                _NavRow(title: 'Kiểm kho', plain: true, onTap: () => context.push(Routes.inventory)),
              ],
              if (user.role == UserRole.manager) ...[
                const SectionLabel('CÀI ĐẶT QUÁN (CHỈ QUẢN LÝ)'),
                _NavRow(
                  title: 'Thông tin quán',
                  subtitle: '${settings.name} · ${settings.address}',
                  onTap: () => _edit(context, settings, (s) => _ShopInfoForm(s)),
                ),
                _NavRow(
                  title: 'Tài khoản nhận VietQR',
                  subtitle: settings.hasBankAccount
                      ? '${vietQrBanks[settings.bankBin] ?? settings.bankBin} · ${settings.bankAccountNo}'
                      : 'Chưa cấu hình',
                  onTap: () => _edit(context, settings, (s) => _BankForm(s)),
                ),
                _NavRow(
                  title: 'Cảnh báo đơn trễ',
                  subtitle: 'Sau ${settings.lateOrderMinutes} phút',
                  onTap: () => _edit(context, settings, (s) => _LateOrderForm(s)),
                ),
                _NavRow(
                  title: 'Tích điểm',
                  subtitle: '${formatVnd(settings.pointsPerVnd)} = 1 điểm · 1 điểm = ${formatVnd(settings.vndPerPoint)}',
                  onTap: () => _edit(context, settings, (s) => _LoyaltyForm(s)),
                ),
              ],
            ]),
          ),
          Padding(
            padding: pagePadding,
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.red, side: const BorderSide(color: AppColors.red)),
                onPressed: () => _confirmLogout(context, ref),
                child: const Text('Đăng xuất'),
              ),
            ),
          ),
        ]);
      }),
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({required this.title, this.subtitle, this.onTap, this.plain = false});
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool plain;
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: TextStyle(fontWeight: plain ? null : FontWeight.w700, fontSize: 15)),
                if (subtitle != null)
                  Text(subtitle!, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
              ]),
            ),
            const Icon(Icons.chevron_right, size: 20),
          ]),
        ),
      );
}

class _ChangePasswordForm extends ConsumerStatefulWidget {
  const _ChangePasswordForm();
  @override
  ConsumerState<_ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends ConsumerState<_ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _next = TextEditingController();

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref.read(loginControllerProvider.notifier).changePassword(_current.text, _next.text);
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
      showMessage(context, 'Đã đổi mật khẩu');
    } else {
      showMessage(context, ErrorMapper.message(ref.read(loginControllerProvider).error));
    }
  }

  @override
  Widget build(BuildContext context) => Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          const SheetTitle('Đổi mật khẩu'),
          LabeledField(
            label: 'Mật khẩu hiện tại *',
            child: TextFormField(controller: _current, obscureText: true, validator: validateRequired),
          ),
          LabeledField(
            label: 'Mật khẩu mới *',
            child: TextFormField(
              controller: _next,
              obscureText: true,
              validator: (v) => (v?.length ?? 0) < 6 ? 'Mật khẩu tối thiểu 6 ký tự' : null,
            ),
          ),
          FilledButton(
            onPressed: ref.watch(loginControllerProvider).isLoading ? null : _save,
            child: const Text('Lưu'),
          ),
        ]),
      );
}

/// Shared sheet shell for the four shop-settings forms.
class _SettingsSheet extends ConsumerStatefulWidget {
  const _SettingsSheet({required this.title, required this.fields, required this.build});
  final String title;
  final List<Widget> fields;
  final ShopSettings Function() build;
  @override
  ConsumerState<_SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends ConsumerState<_SettingsSheet> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref.read(settingsControllerProvider.notifier).save(widget.build());
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
    } else {
      showMessage(context, ErrorMapper.message(ref.read(settingsControllerProvider).error));
    }
  }

  @override
  Widget build(BuildContext context) => Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
          SheetTitle(widget.title),
          ...widget.fields,
          FilledButton(
            onPressed: ref.watch(settingsControllerProvider).isLoading ? null : _save,
            child: const Text('Lưu'),
          ),
        ]),
      );
}

class _ShopInfoForm extends StatelessWidget {
  _ShopInfoForm(ShopSettings s)
      : _s = s,
        _name = TextEditingController(text: s.name),
        _address = TextEditingController(text: s.address);
  final ShopSettings _s;
  final TextEditingController _name, _address;
  @override
  Widget build(BuildContext context) => _SettingsSheet(
        title: 'Thông tin quán',
        build: () => _s.copyWith(name: _name.text.trim(), address: _address.text.trim()),
        fields: [
          LabeledField(label: 'Tên quán *', child: TextFormField(controller: _name, validator: validateRequired)),
          LabeledField(label: 'Địa chỉ *', child: TextFormField(controller: _address, validator: validateRequired)),
        ],
      );
}

class _BankForm extends StatefulWidget {
  const _BankForm(this.s);
  final ShopSettings s;
  @override
  State<_BankForm> createState() => _BankFormState();
}

class _BankFormState extends State<_BankForm> {
  late String? _bin = widget.s.bankBin.isEmpty ? null : widget.s.bankBin;
  late final _no = TextEditingController(text: widget.s.bankAccountNo);
  late final _holder = TextEditingController(text: widget.s.bankAccountName);

  @override
  Widget build(BuildContext context) => _SettingsSheet(
        title: 'Tài khoản nhận VietQR',
        build: () => widget.s.copyWith(
            bankBin: _bin ?? '', bankAccountNo: _no.text.trim(), bankAccountName: _holder.text.trim()),
        fields: [
          LabeledField(
            label: 'Ngân hàng *',
            child: DropdownButtonFormField<String>(
              initialValue: _bin,
              items: [
                for (final e in vietQrBanks.entries) DropdownMenuItem(value: e.key, child: Text(e.value)),
              ],
              validator: (v) => v == null ? 'Vui lòng chọn ngân hàng' : null,
              onChanged: (v) => setState(() => _bin = v),
            ),
          ),
          LabeledField(
            label: 'Số tài khoản *',
            child: TextFormField(
              controller: _no,
              keyboardType: TextInputType.number,
              validator: (v) => RegExp(r'^\d+$').hasMatch(v ?? '') ? null : 'Chỉ gồm chữ số',
            ),
          ),
          LabeledField(label: 'Chủ tài khoản *', child: TextFormField(controller: _holder, validator: validateRequired)),
        ],
      );
}

String? _positive(String? v) => (parseMoney(v) ?? 0) > 0 ? null : 'Nhập số nguyên dương';

class _LateOrderForm extends StatelessWidget {
  _LateOrderForm(ShopSettings s)
      : _s = s,
        _minutes = TextEditingController(text: '${s.lateOrderMinutes}');
  final ShopSettings _s;
  final TextEditingController _minutes;
  @override
  Widget build(BuildContext context) => _SettingsSheet(
        title: 'Cảnh báo đơn trễ',
        build: () => _s.copyWith(lateOrderMinutes: parseMoney(_minutes.text)!),
        fields: [
          LabeledField(
            label: 'Số phút *',
            child: TextFormField(controller: _minutes, keyboardType: TextInputType.number, validator: _positive),
          ),
        ],
      );
}

class _LoyaltyForm extends StatelessWidget {
  _LoyaltyForm(ShopSettings s)
      : _s = s,
        _earn = TextEditingController(text: formatNumber(s.pointsPerVnd)),
        _redeem = TextEditingController(text: formatNumber(s.vndPerPoint));
  final ShopSettings _s;
  final TextEditingController _earn, _redeem;
  @override
  Widget build(BuildContext context) => _SettingsSheet(
        title: 'Tích điểm',
        build: () => _s.copyWith(pointsPerVnd: parseMoney(_earn.text)!, vndPerPoint: parseMoney(_redeem.text)!),
        fields: [
          LabeledField(label: 'Số tiền cho 1 điểm (₫) *', child: MoneyField(controller: _earn, validator: _positive)),
          LabeledField(label: 'Giá trị 1 điểm (₫) *', child: MoneyField(controller: _redeem, validator: _positive)),
        ],
      );
}
