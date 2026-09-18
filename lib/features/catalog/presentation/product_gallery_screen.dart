import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../domain/product.dart';

class ProductGalleryScreen extends StatefulWidget {
  final Product product;
  final int initialIndex;
  const ProductGalleryScreen({super.key, required this.product, this.initialIndex = 0});

  @override
  State<ProductGalleryScreen> createState() => _ProductGalleryScreenState();
}

class _ProductGalleryScreenState extends State<ProductGalleryScreen> {
  late final PageController _controller = PageController(initialPage: widget.initialIndex);
  late int _page = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    final images = widget.product.images;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text('${_page + 1} / ${images.length}', style: const TextStyle(color: Colors.white)),
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: images.length,
        onPageChanged: (i) => setState(() => _page = i),
        itemBuilder: (context, index) => Center(
          child: InteractiveViewer(
            child: CachedNetworkImage(imageUrl: images[index].url, fit: BoxFit.contain),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < images.length; i++)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _page ? 10 : 7,
                  height: i == _page ? 10 : 7,
                  decoration: BoxDecoration(color: i == _page ? Colors.white : Colors.white38, shape: BoxShape.circle),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
