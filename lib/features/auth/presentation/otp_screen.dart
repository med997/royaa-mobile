import 'dart:async';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _digits = List.generate(4, (_) => TextEditingController());
  final _nodes = List.generate(4, (_) => FocusNode());
  bool _loading = false;
  int _secondsLeft = 42;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = 42);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 0) {
        t.cancel();
        return;
      }
      setState(() => _secondsLeft--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _digits) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  Future<void> _verify() async {
    final code = _digits.map((c) => c.text).join();
    if (code.length != 4) return;
    setState(() => _loading = true);
    try {
      await ref.read(authControllerProvider.notifier).verifyOtp(mobileNo: widget.mobileNo, code: code);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resend() async {
    try {
      await ref.read(authControllerProvider.notifier).requestOtp(widget.mobileNo);
      _startTimer();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('verify'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('enter_verification_code'.tr(), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                text: '${'otp_sent_to'.tr()} ',
                style: const TextStyle(color: AppColors.muted, fontSize: 13),
                children: [TextSpan(text: widget.mobileNo, style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.bold))],
              ),
            ),
            const SizedBox(height: 28),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var i = 0; i < 4; i++)
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: TextField(
                        controller: _digits[i],
                        focusNode: _nodes[i],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(counterText: ''),
                        onChanged: (v) {
                          if (v.isNotEmpty && i < 3) _nodes[i + 1].requestFocus();
                          if (v.isEmpty && i > 0) _nodes[i - 1].requestFocus();
                          if (i == 3 && v.isNotEmpty) _verify();
                        },
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _loading ? null : _verify,
              child: _loading
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text('verify'.tr()),
            ),
            const SizedBox(height: 14),
            Center(
              child: _secondsLeft > 0
                  ? Text(
                      '${'resend_in'.tr()} 00:${_secondsLeft.toString().padLeft(2, '0')}',
                      style: const TextStyle(color: AppColors.muted, fontSize: 12),
                    )
                  : TextButton(onPressed: _resend, child: Text('resend_code'.tr())),
            ),
          ],
        ),
      ),
    );
  }
}
