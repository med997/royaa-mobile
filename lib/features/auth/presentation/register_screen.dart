import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/auth_controller.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _userName = TextEditingController();
  final _mobile = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      await ref.read(authControllerProvider.notifier).register(
            userName: _userName.text.trim(),
            mobileNo: _mobile.text.trim(),
            password: _password.text,
          );
      if (mounted) context.push('/otp?mobileNo=${_mobile.text.trim()}');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('create_account'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(controller: _userName, decoration: InputDecoration(labelText: 'full_name'.tr())),
            const SizedBox(height: 12),
            TextField(controller: _mobile, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: 'mobile_number'.tr())),
            const SizedBox(height: 12),
            TextField(controller: _password, obscureText: true, decoration: InputDecoration(labelText: 'password'.tr())),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text('continue_action'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
