import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../auth/application/auth_controller.dart';
import '../../auth/application/auth_status.dart';
import '../../home/presentation/home_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(authControllerProvider.select((s) => s.status));
    if (status == AuthStatus.unknown) {
      return Scaffold(
        backgroundColor: AppColors.ink,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                alignment: Alignment.center,
                child: const Text('◉', style: TextStyle(color: AppColors.ink, fontSize: 34)),
              ),
              const SizedBox(height: 18),
              Text('app_name'.tr(), style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              const Text('اختيارك. مقاسك. رؤيتك.', style: TextStyle(color: Color(0xFFAEB4B6), fontSize: 13)),
            ],
          ),
        ),
      );
    }
    return const HomeScreen();
  }
}
