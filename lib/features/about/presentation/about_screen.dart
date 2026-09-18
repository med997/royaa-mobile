import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../app/theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.ink,
            foregroundColor: Colors.white,
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('app_name'.tr()),
              background: Container(
                color: AppColors.ink,
                alignment: Alignment.center,
                child: const Text('◉', style: TextStyle(color: Colors.white, fontSize: 44)),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('about_tagline'.tr(), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 12),
                  Text('about_body'.tr(), style: const TextStyle(color: AppColors.muted, height: 1.8)),
                  const SizedBox(height: 20),
                  _InfoTile(icon: Icons.call_outlined, label: 'contact_us'.tr(), value: '+967 1 000 000'),
                  _InfoTile(icon: Icons.email_outlined, label: 'email'.tr(), value: 'hello@royaa.example'),
                  _InfoTile(icon: Icons.location_on_outlined, label: 'our_branches'.tr(), value: 'branches_hint'.tr()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(color: AppColors.fieldFill, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, size: 18, color: AppColors.red),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(value, textDirection: TextDirection.ltr, textAlign: TextAlign.start),
    );
  }
}
