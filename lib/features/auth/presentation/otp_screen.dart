import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../application/auth_controller.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String mobileNo;
  const OtpScreen({super.key, required this.mobileNo});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _code = TextEditingController();
  bool _loading = false;

  Future<void> _verify() async {
    setState(() => _loading = true);
    try {
      await ref.read(authControllerProvider.notifier).verifyOtp(mobileNo: widget.mobileNo, code: _code.text.trim());
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('verify'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('${'otp_sent_to'.tr()} ', style: const TextStyle(color: AppColors.muted)),
            Text(widget.mobileNo, textDirection: TextDirection.ltr, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: _code,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 4,
              style: const TextStyle(fontSize: 22, letterSpacing: 8, fontWeight: FontWeight.bold),
              decoration: InputDecoration(labelText: 'otp_code'.tr(), counterText: ''),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _loading ? null : _verify,
              child: _loading
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text('verify'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
