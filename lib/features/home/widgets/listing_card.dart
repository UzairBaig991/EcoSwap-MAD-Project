import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/listing_model.dart';
import '../providers/home_provider.dart';

class ListingCard extends StatelessWidget {
  final ListingModel listing;
  final double userLat;
  final double userLng;
  final bool isFavorited;
  final VoidCallback? onFavoriteToggle;

  const ListingCard({
    super.key,
    required this.listing,
    required this.userLat,
    required this.userLng,
    this.isFavorited = false,
    this.onFavoriteToggle,
  });

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Free':
        return AppColors.freeType;
      case 'Swap':
        return AppColors.swapType;
      case 'Paid':
        return AppColors.paidType;
      default:
        return AppColors.primary;
    }
  }

  Widget _buildImage(String url) {
    if (url.startsWith('data:image')) {
      try {
        final base64Data = url.split(',').last;
        final bytes = base64Decode(base64Data);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      } catch (_) {
        return Container(
          color: AppColors.primaryContainer,
          child: const Icon(Icons.image_not_supported_rounded, color: AppColors.primary),
        );
      }
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (context, url) => Container(
        color: Colors.grey.shade200,
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColors.primaryContainer,
        child: const Icon(Icons.broken_image_rounded, color: AppColors.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final distanceKm = calculateDistanceKm(
      userLat,
      userLng,
      listing.location.lat,
      listing.location.lng,
    );

    final typeColor = _getTypeColor(listing.type);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => context.push('/listing/${listing.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: listing.images.isNotEmpty
                      ? _buildImage(listing.images.first)
                      : Container(
                          color: AppColors.primaryContainer,
                          child: const Icon(Icons.inventory_2_rounded, size: 48, color: AppColors.primary),
                        ),
                ),

                // Type Badge (Top Left)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: typeColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      listing.type == 'Paid' && listing.price != null
                          ? AppFormatters.formatPrice(listing.price!)
                          : listing.type,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Category Badge (Top Left - beside type)
                Positioned(
                  top: 12,
                  left: listing.type == 'Paid' ? 80 : 70,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      listing.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                // Favorite Heart Button (Top Right)
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    onTap: onFavoriteToggle,
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.85),
                      radius: 18,
                      child: Icon(
                        isFavorited ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFavorited ? AppColors.error : AppColors.textSecondaryLight,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content Padding
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          listing.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Distance & Location
                  Row(
                    children: [
                      const Icon(
                        Icons.near_me_rounded,
                        size: 15,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppFormatters.formatDistance(distanceKm),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('•', style: TextStyle(color: theme.colorScheme.outline)),
                      const SizedBox(width: 8),
                      Text(
                        listing.condition,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // CO2 Impact Badge Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.co2BadgeBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.eco_rounded,
                          size: 16,
                          color: AppColors.co2Green,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          AppFormatters.formatCo2(listing.carbonSavedEstimate),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: AppColors.co2Green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
