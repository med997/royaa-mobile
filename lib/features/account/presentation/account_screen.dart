import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../auth/application/auth_controller.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider.select((s) => s.user));

    return Scaffold(
      appBar: AppBar(title: Text('account'.tr())),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(18)),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFFE7DED3),
                  child: Text(
                    user?.userName.isNotEmpty == true ? user!.userName[0] : '?',
                    style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.userName ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text(user?.mobileNo ?? '', textDirection: TextDirection.ltr, style: const TextStyle(color: Color(0xFFCBD3D9), fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _MenuTile(icon: Icons.receipt_long_outlined, label: 'my_orders'.tr(), onTap: () => context.push('/orders')),
          _MenuTile(icon: Icons.location_on_outlined, label: 'addresses'.tr(), onTap: () => context.push('/addresses')),
          _MenuTile(icon: Icons.description_outlined, label: 'my_prescriptions'.tr(), onTap: () => _comingSoon(context)),
          _MenuTile(icon: Icons.notifications_outlined, label: 'notifications'.tr(), onTap: () => context.push('/notifications')),
          _MenuTile(icon: Icons.chat_bubble_outline, label: 'help_and_support'.tr(), onTap: () => _comingSoon(context)),
          _MenuTile(icon: Icons.info_outline, label: 'about_us'.tr(), onTap: () => _comingSoon(context)),
          const SizedBox(height: 12),
          _MenuTile(
            icon: Icons.logout,
            label: 'logout'.tr(),
            onTap: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
    );
  }

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('coming_soon'.tr())));
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(color: AppColors.fieldFill, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, size: 18, color: AppColors.red),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_left, color: AppColors.muted),
    );
  }
}
