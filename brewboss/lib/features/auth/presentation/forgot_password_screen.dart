import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme.dart';
import '../../../core/utils/messages.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../application/login_controller.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(loginControllerProvider.notifier).sendReset(_email.text);
    if (mounted) setState(() => _sent = true);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () => context.go(Routes.login)),
          title: const Text('Quên mật khẩu'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const Text('Nhập email tài khoản. Chúng tôi sẽ gửi liên kết đặt lại mật khẩu vào email này.',
                  style: TextStyle(color: AppColors.muted)),
              const SizedBox(height: 20),
              LabeledField(
                label: 'Email *',
                child: TextFormField(
                    controller: _email, keyboardType: TextInputType.emailAddress, validator: validateEmail),
              ),
              FilledButton(onPressed: _send, child: const Text('Gửi liên kết')),
              if (_sent) ...[const SizedBox(height: 16), Text(msg('MSG06'))],
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                    onPressed: () => context.go(Routes.login), child: const Text('Quay lại đăng nhập')),
              ),
            ]),
          ),
        ),
      );
}
