import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../catalog/application/catalog_providers.dart';
import '../application/reviews_providers.dart';
import '../data/reviews_api.dart';

class ReviewsSection extends ConsumerWidget {
  final String productId;
  const ReviewsSection({super.key, required this.productId});

  Future<void> _writeReview(BuildContext context, WidgetRef ref) async {
    int rating = 5;
    final comment = TextEditingController();
    final submitted = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('write_a_review'.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 1; i <= 5; i++)
                    IconButton(
                      icon: Icon(i <= rating ? Icons.star : Icons.star_border, color: AppColors.gold),
                      onPressed: () => setState(() => rating = i),
                    ),
                ],
              ),
              TextField(controller: comment, decoration: InputDecoration(labelText: 'comment_optional'.tr())),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text('cancel'.tr())),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: Text('submit'.tr())),
          ],
        ),
      ),
    );

    if (submitted == true) {
      await ref.read(reviewsApiProvider).create(productId, rating: rating, comment: comment.text.isEmpty ? null : comment.text);
      ref.invalidate(reviewsProvider(productId));
      ref.invalidate(productProvider(productId));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(reviewsProvider(productId));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('reviews'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            TextButton(onPressed: () => _writeReview(context, ref), child: Text('write_a_review'.tr())),
          ],
        ),
        reviews.when(
          loading: () => const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()),
          error: (e, _) => Text('$e'),
          data: (items) => items.isEmpty
              ? Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('no_reviews_yet'.tr(), style: const TextStyle(color: AppColors.muted)))
              : Column(
                  children: [
                    for (final r in items)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          children: [
                            Text(r.userName, style: const TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(width: 8),
                            ...List.generate(5, (i) => Icon(i < r.rating ? Icons.star : Icons.star_border, size: 14, color: AppColors.gold)),
                          ],
                        ),
                        subtitle: r.comment != null ? Text(r.comment!) : null,
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}
