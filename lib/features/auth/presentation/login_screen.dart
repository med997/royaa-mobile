import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../application/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _mobile = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      await ref.read(authControllerProvider.notifier).login(
            mobileNo: _mobile.text.trim(),
            password: _password.text,
          );
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(20)),
                alignment: Alignment.center,
                child: const Text('◉', style: TextStyle(color: Colors.white, fontSize: 26)),
              ),
              const SizedBox(height: 24),
              Text('welcome_back'.tr(), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text('login_subtitle'.tr(), style: const TextStyle(color: AppColors.muted, fontSize: 13, height: 1.6)),
              const SizedBox(height: 28),
              TextField(
                controller: _mobile,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(prefixIcon: const Icon(Icons.person_outline, size: 20), labelText: 'mobile_number'.tr()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _password,
                obscureText: _obscure,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                  labelText: 'password'.tr(),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(onPressed: () {}, child: Text('forgot_password'.tr())),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text('login'.tr()),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text('or_continue_with'.tr(), style: const TextStyle(color: AppColors.muted, fontSize: 12))),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Google'))),
                  const SizedBox(width: 10),
                  Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Apple'))),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${'no_account_yet'.tr()} ', style: const TextStyle(color: AppColors.muted)),
                  GestureDetector(onTap: () => context.push('/register'), child: Text('create_account'.tr())),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
