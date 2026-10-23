import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:t3afy/app/resources/app_icons.dart';

/// One fullscreen zoomable image viewer (replaces 4 copies).
Future<void> openPhotoViewer(BuildContext context, String url, {String? heroTag}) {
  return Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.black,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, _, _) => _PhotoViewerPage(url: url, heroTag: heroTag),
      transitionsBuilder: (_, a, _, child) =>
          FadeTransition(opacity: a, child: child),
    ),
  );
}

class _PhotoViewerPage extends StatelessWidget {
  const _PhotoViewerPage({required this.url, this.heroTag});
  final String url;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoView(
            imageProvider: CachedNetworkImageProvider(url),
            heroAttributes: heroTag == null
                ? null
                : PhotoViewHeroAttributes(tag: heroTag!),
            minScale: PhotoViewComputedScale.contained,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            loadingBuilder: (_, _) => const Center(
              child: CircularProgressIndicator(color: Colors.white54),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: IconButton(
                tooltip: 'إغلاق',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(AppIcons.x, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
