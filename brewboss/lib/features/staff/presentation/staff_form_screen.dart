import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../../../models/models.dart';
import '../../auth/application/auth_providers.dart';
import '../application/staff_controller.dart';

class StaffFormScreen extends ConsumerStatefulWidget {
  const StaffFormScreen({super.key, this.user});
  final AppUser? user;
  @override
  ConsumerState<StaffFormScreen> createState() => _StaffFormScreenState();
}

class _StaffFormScreenState extends ConsumerState<StaffFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.user?.name);
  late final _email = TextEditingController(text: widget.user?.email);
  late final _phone = TextEditingController(text: widget.user?.phone);
  final _password = TextEditingController();
  late UserRole _role = widget.user?.role ?? UserRole.cashier;
  late bool _active = widget.user?.isActive ?? true;

  bool get _isNew => widget.user == null;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final controller = ref.read(staffControllerProvider.notifier);
    final phone = _phone.text.replaceAll(' ', '');
    var ok = _isNew
        ? await controller.create(
            name: _name.text.trim(), email: _email.text.trim(), phone: phone, role: _role, tempPassword: _password.text)
        : await controller.updateStaff(widget.user!.copyWith(name: _name.text.trim(), phone: phone, role: _role));
    if (ok && !_isNew && _active != widget.user!.isActive) {
      ok = await controller.setActive(widget.user!.id, _active);
    }
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
    } else {
      showMessage(context, ErrorMapper.message(ref.read(staffControllerProvider).error));
    }
  }

  Future<void> _toggleActive(bool value) async {
    if (!value) {
      final yes = await confirmDialog(context,
          title: 'Khóa tài khoản?', message: 'Nhân viên sẽ không đăng nhập được.', confirm: 'Khóa', destructive: true);
      if (!yes) return;
    }
    setState(() => _active = value);
  }

  @override
  Widget build(BuildContext context) {
    final isSelf = widget.user?.id == ref.watch(currentUidProvider);
    final busy = ref.watch(staffControllerProvider).isLoading;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), tooltip: 'Đóng', onPressed: () => Navigator.pop(context)),
        title: Text(_isNew ? 'Thêm nhân viên' : 'Sửa nhân viên'),
        actions: [TextButton(onPressed: busy ? null : _save, child: const Text('Lưu'))],
      ),
      body: Form(
        key: _formKey,
        child: ListView(padding: pagePadding, children: [
          LabeledField(label: 'Họ tên *', child: TextFormField(controller: _name, validator: validateRequired)),
          LabeledField(
            label: 'Email *',
            child: TextFormField(controller: _email, readOnly: !_isNew, keyboardType: TextInputType.emailAddress, validator: validateEmail),
          ),
          LabeledField(
            label: 'Số điện thoại *',
            child: TextFormField(controller: _phone, keyboardType: TextInputType.phone, validator: validatePhone),
          ),
          LabeledField(
            label: 'Vai trò *',
            child: OutlineCard(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: RadioGroup<UserRole>(
                groupValue: _role,
                onChanged: (r) {
                  if (r != null && !isSelf) setState(() => _role = r);
                },
                child: Column(children: [
                  for (final r in UserRole.values)
                    RadioListTile<UserRole>(dense: true, value: r, enabled: !isSelf, title: Text(r.label, style: const TextStyle(fontSize: 15))),
                ]),
              ),
            ),
          ),
          if (_isNew)
            LabeledField(
              label: 'Mật khẩu tạm *',
              child: TextFormField(
                controller: _password,
                obscureText: true,
                validator: (v) => (v?.length ?? 0) < 6 ? 'Mật khẩu tối thiểu 6 ký tự' : null,
              ),
            )
          else
            OutlineCard(
              child: Row(children: [
                const Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Đang hoạt động', style: TextStyle(fontWeight: FontWeight.w700)),
                    Text('Tắt để khóa tài khoản, không cho đăng nhập', style: TextStyle(fontSize: 13, color: AppColors.muted)),
                  ]),
                ),
                Switch(value: _active, onChanged: isSelf ? null : _toggleActive),
              ]),
            ),
        ]),
      ),
    );
  }
}
