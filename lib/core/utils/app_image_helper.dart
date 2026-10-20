import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../constants/app_colors.dart';

class AppImageHelper {
  AppImageHelper._();

  static ImageProvider? getImageProvider(String? url) {
    if (url == null || url.trim().isEmpty) return null;

    if (url.startsWith('data:image')) {
      try {
        final base64Data = url.split(',').last;
        final bytes = base64Decode(base64Data);
        return MemoryImage(bytes);
      } catch (_) {
        return null;
      }
    }

    if (url.startsWith('http://') || url.startsWith('https://')) {
      return CachedNetworkImageProvider(url);
    }

    // Attempt raw base64 decode if string length is large
    if (url.length > 100) {
      try {
        final bytes = base64Decode(url);
        return MemoryImage(bytes);
      } catch (_) {
        return null;
      }
    }

    return null;
  }

  static Widget buildImageWidget(
    String? url, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? fallbackWidget,
  }) {
    if (url == null || url.trim().isEmpty) {
      return fallbackWidget ??
          Container(
            width: width,
            height: height,
            color: AppColors.primaryContainer,
            child: const Icon(Icons.image_rounded, color: AppColors.primary),
          );
    }

    if (url.startsWith('data:image') || url.length > 200 && !url.startsWith('http')) {
      try {
        final base64Data = url.startsWith('data:image') ? url.split(',').last : url;
        final bytes = base64Decode(base64Data);
        return Image.memory(
          bytes,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, __, ___) => fallbackWidget ?? Container(color: AppColors.primaryContainer),
        );
      } catch (_) {
        return fallbackWidget ?? Container(color: AppColors.primaryContainer);
      }
    }

    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, __) => Container(
        width: width,
        height: height,
        color: Colors.grey.shade200,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      errorWidget: (_, __, ___) => fallbackWidget ?? Container(color: AppColors.primaryContainer),
    );
  }
}
