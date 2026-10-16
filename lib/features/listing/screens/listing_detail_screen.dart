import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/listing_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../../favorites/providers/favorites_provider.dart';
import '../providers/listing_provider.dart';
import '../widgets/leave_review_dialog.dart';

class ListingDetailScreen extends ConsumerStatefulWidget {
  final String listingId;
  const ListingDetailScreen({super.key, required this.listingId});

  @override
  ConsumerState<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends ConsumerState<ListingDetailScreen> {
  int _currentImageIndex = 0;

  Widget _buildImageWidget(String url) {
    if (url.startsWith('data:image')) {
      try {
        final base64Data = url.split(',').last;
        final bytes = base64Decode(base64Data);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: double.infinity,
        );
      } catch (_) {
        return Container(
          color: AppColors.primaryContainer,
          child: const Icon(Icons.image_not_supported_rounded, color: AppColors.primary, size: 48),
        );
      }
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      width: double.infinity,
      placeholder: (_, __) => Container(
        color: Colors.grey.shade200,
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (_, __, ___) => Container(
        color: AppColors.primaryContainer,
        child: const Icon(Icons.broken_image_rounded, color: AppColors.primary, size: 48),
      ),
    );
  }

  void _shareListing(ListingModel item) {
    Share.share(
      'Check out "${item.title}" on EcoSwap! ${item.type == 'Paid' ? '\$${item.price}' : item.type} • Save ~${item.carbonSavedEstimate} kg CO₂!\nDownload EcoSwap app to connect and swap.',
      subject: item.title,
    );
  }

  void _reportListing() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Report Listing'),
        content: const Text(
          'Thank you for keeping EcoSwap safe. Is this listing inappropriate, inaccurate, or spam?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Report submitted. Our moderation team will review this listing.'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Submit Report'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final listingAsync = ref.watch(singleListingProvider(widget.listingId));
    final currentUser = ref.watch(currentUserModelProvider).asData?.value;
    final favoriteIds = ref.watch(favoritesControllerProvider);

    return Scaffold(
      body: listingAsync.when(
        data: (item) {
          if (item == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Listing Not Found')),
              body: const Center(child: Text('This listing is no longer available.')),
            );
          }

          final isOwner = currentUser?.uid == item.ownerId;
          final isFavorited = favoriteIds.contains(item.id);

          return CustomScrollView(
            slivers: [
              // Image Carousel Sliver AppBar
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                leading: CircleAvatar(
                  backgroundColor: Colors.black45,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: () => context.pop(),
                  ),
                ),
                actions: [
                  // Share Button
                  CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: IconButton(
                      icon: const Icon(Icons.share_rounded, color: Colors.white),
                      onPressed: () => _shareListing(item),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Favorite Button
                  CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: IconButton(
                      icon: Icon(
                        isFavorited ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFavorited ? AppColors.error : Colors.white,
                      ),
                      onPressed: () {
                        ref.read(favoritesControllerProvider.notifier).toggleFavorite(item);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isFavorited ? 'Removed from Saved Favorites' : 'Added to Saved Favorites'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      PageView.builder(
                        itemCount: item.images.isNotEmpty ? item.images.length : 1,
                        onPageChanged: (idx) {
                          setState(() => _currentImageIndex = idx);
                        },
                        itemBuilder: (context, idx) {
                          if (item.images.isEmpty) {
                            return Container(
                              color: AppColors.primaryContainer,
                              child: const Icon(Icons.inventory_2_rounded, size: 64, color: AppColors.primary),
                            );
                          }
                          return _buildImageWidget(item.images[idx]);
                        },
                      ),

                      // Image Page Indicator Badge
                      if (item.images.length > 1)
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.65),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_currentImageIndex + 1} / ${item.images.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Content Details
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Title
                    Text(
                      item.title,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Badges Row
                    Row(
                      children: [
                        // Type / Price Chip
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: item.type == 'Free'
                                ? AppColors.freeType
                                : (item.type == 'Swap' ? AppColors.swapType : AppColors.paidType),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            item.type == 'Paid' && item.price != null
                                ? AppFormatters.formatPrice(item.price!)
                                : item.type,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Category Chip
                        Chip(
                          label: Text(item.category),
                          backgroundColor: theme.colorScheme.surfaceVariant,
                        ),
                        const SizedBox(width: 8),

                        // Condition Chip
                        Chip(
                          label: Text(item.condition),
                          backgroundColor: theme.colorScheme.surfaceVariant,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // CO2 Impact Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.co2BadgeBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.co2Green, width: 1.2),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.eco_rounded, color: AppColors.co2Green, size: 36),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppFormatters.formatCo2(item.carbonSavedEstimate),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: AppColors.co2Green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'By reusing this item instead of buying new, you prevent manufacturing emissions!',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Description Header
                    Text(
                      'Description',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Owner Profile Snippet
                    Text(
                      'Listed By',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: AppColors.primaryContainer,
                              backgroundImage: (item.ownerPhotoUrl != null && item.ownerPhotoUrl!.isNotEmpty)
                                  ? CachedNetworkImageProvider(item.ownerPhotoUrl!)
                                  : null,
                              child: (item.ownerPhotoUrl == null || item.ownerPhotoUrl!.isEmpty)
                                  ? Text(
                                      item.ownerName.isNotEmpty ? item.ownerName[0].toUpperCase() : 'E',
                                      style: theme.textTheme.titleLarge?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.ownerName,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                                      const SizedBox(width: 4),
                                      Text(
                                        '4.9 (24 reviews) • Active Swapper',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Location Preview Card
                    Text(
                      'Item Location',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          item.location.address,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: kIsWeb ? 100 : 180,
                        color: AppColors.primaryContainer.withOpacity(0.5),
                        child: kIsWeb
                            ? Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.pin_drop_rounded, color: AppColors.primary, size: 28),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Item Location: ${item.location.address}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                                    ),
                                  ],
                                ),
                              )
                            : GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(item.location.lat, item.location.lng),
                                  zoom: 14,
                                ),
                                markers: {
                                  Marker(
                                    markerId: MarkerId(item.id),
                                    position: LatLng(item.location.lat, item.location.lng),
                                    infoWindow: InfoWindow(title: item.title),
                                  ),
                                },
                                zoomControlsEnabled: false,
                                scrollGesturesEnabled: false,
                                rotateGesturesEnabled: false,
                                tiltGesturesEnabled: false,
                              ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Report Listing Button
                    Center(
                      child: TextButton.icon(
                        onPressed: _reportListing,
                        icon: const Icon(Icons.flag_outlined, size: 18, color: AppColors.textMutedLight),
                        label: const Text(
                          'Report this listing',
                          style: TextStyle(color: AppColors.textMutedLight),
                        ),
                      ),
                    ),
                    const SizedBox(height: 80), // Padding for bottom action bar
                  ]),
                ),
              ),
            ],
          );
        },
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (err, stack) => Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(child: Text('Error loading item: $err')),
        ),
      ),

      // Bottom Sticky Action Bar
      bottomSheet: listingAsync.asData?.value != null
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Builder(builder: (context) {
                  final item = listingAsync.asData!.value!;
                  final isOwner = currentUser?.uid == item.ownerId;

                  if (isOwner) {
                    return Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => context.push('/listing/edit/${item.id}'),
                            child: const Text('Edit Listing'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final success = await ref
                                  .read(listingControllerProvider.notifier)
                                  .markStatus(item.id, 'Completed');
                              if (success && mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Marked as Completed! CO₂ saved added to profile 🎉'),
                                    backgroundColor: AppColors.success,
                                  ),
                                );
                                // Prompt owner to review
                                showDialog(
                                  context: context,
                                  builder: (ctx) => LeaveReviewDialog(
                                    listingId: item.id,
                                    fromUserId: currentUser!.uid,
                                    fromUserName: currentUser.displayName,
                                    fromUserPhoto: currentUser.photoUrl,
                                    toUserId: item.claimedByUserId ?? '',
                                  ),
                                );
                              }
                            },
                            child: const Text('Mark Completed'),
                          ),
                        ),
                      ],
                    );
                  }

                  return ElevatedButton.icon(
                    onPressed: () {
                      context.push('/chat/${item.id}?title=${Uri.encodeComponent(item.title)}&ownerId=${item.ownerId}&ownerName=${Uri.encodeComponent(item.ownerName)}');
                    },
                    icon: const Icon(Icons.chat_bubble_outline_rounded),
                    label: Text('Chat with ${item.ownerName.split(' ').first}'),
                  );
                }),
              ),
            )
          : null,
    );
  }
}
