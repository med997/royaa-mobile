import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/cart/application/cart_controller.dart';
import 'theme.dart';

class MainShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartControllerProvider).value?.items.length ?? 0;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.line))),
        child: SafeArea(
          child: SizedBox(
            height: 62,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'home'.tr(), index: 0, current: navigationShell.currentIndex, onTap: _goBranch),
                _NavItem(icon: Icons.shopping_bag_outlined, activeIcon: Icons.shopping_bag, label: 'cart'.tr(), index: 1, current: navigationShell.currentIndex, badge: cartCount, onTap: _goBranch),
                _NavItem(icon: Icons.favorite_border, activeIcon: Icons.favorite, label: 'favorites'.tr(), index: 2, current: navigationShell.currentIndex, onTap: _goBranch),
                _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'account'.tr(), index: 3, current: navigationShell.currentIndex, onTap: _goBranch),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goBranch(int index) {
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  final int current;
  final int badge;
  final void Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
    this.badge = 0,
  });

  @override
  Widget build(BuildContext context) {
    final active = index == current;
    final color = active ? AppColors.red : const Color(0xFF9AA2AB);

    return InkWell(
      onTap: () => onTap(index),
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(active ? activeIcon : icon, color: color, size: 22),
                if (badge > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
                      child: Text('$badge', style: const TextStyle(fontSize: 8, color: Colors.white)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: active ? FontWeight.w700 : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}
