import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../domain/product.dart';

class Product3dScreen extends StatefulWidget {
  final Product product;
  const Product3dScreen({super.key, required this.product});

  @override
  State<Product3dScreen> createState() => _Product3dScreenState();
}

class _Product3dScreenState extends State<Product3dScreen> {
  double _angle = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('preview_3d'.tr())),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onHorizontalDragUpdate: (d) => setState(() => _angle += d.delta.dx * 0.01),
              child: Container(
                color: AppColors.bg,
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(_angle),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: widget.product.images.isNotEmpty
                            ? CachedNetworkImage(imageUrl: widget.product.images.first.url, width: 280, fit: BoxFit.cover)
                            : Container(width: 280, height: 200, color: AppColors.fieldFill),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text('drag_to_rotate'.tr(), style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
