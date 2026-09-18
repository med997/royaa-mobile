import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../application/addresses_providers.dart';
import '../data/addresses_api.dart';

class AddressesScreen extends ConsumerWidget {
  const AddressesScreen({super.key});

  Future<void> _addAddress(BuildContext context, WidgetRef ref) async {
    final label = TextEditingController();
    final line1 = TextEditingController();
    final city = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('new_address'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: label, decoration: InputDecoration(labelText: 'label_hint'.tr())),
            TextField(controller: line1, decoration: InputDecoration(labelText: 'address'.tr())),
            TextField(controller: city, decoration: InputDecoration(labelText: 'city'.tr())),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('cancel'.tr())),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text('save'.tr())),
        ],
      ),
    );
    if (saved == true && label.text.isNotEmpty && line1.text.isNotEmpty && city.text.isNotEmpty) {
      await ref.read(addressesApiProvider).create(label: label.text, line1: line1.text, city: city.text);
      ref.invalidate(addressesProvider);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(addressesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('addresses'.tr()),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () => _addAddress(context, ref))],
      ),
      body: addresses.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (items) => items.isEmpty
            ? Center(child: Text('no_addresses_yet'.tr(), style: const TextStyle(color: AppColors.muted)))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final a = items[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.location_on_outlined, color: AppColors.red),
                    title: Text(a.label, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text('${a.line1}, ${a.city}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.muted),
                      onPressed: () async {
                        await ref.read(addressesApiProvider).remove(a.id);
                        ref.invalidate(addressesProvider);
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
