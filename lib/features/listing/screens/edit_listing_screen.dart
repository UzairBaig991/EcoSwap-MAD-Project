import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/listing_model.dart';
import '../providers/listing_provider.dart';

class EditListingScreen extends ConsumerStatefulWidget {
  final String listingId;
  const EditListingScreen({super.key, required this.listingId});

  @override
  ConsumerState<EditListingScreen> createState() => _EditListingScreenState();
}

class _EditListingScreenState extends ConsumerState<EditListingScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;

  late String _selectedCategory;
  late String _selectedCondition;
  late String _selectedType;

  List<String> _retainedImages = [];
  List<File> _newImageFiles = [];
  ListingModel? _originalListing;
  bool _initialized = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _initFields(ListingModel item) {
    if (_initialized) return;
    _originalListing = item;
    _titleController = TextEditingController(text: item.title);
    _descriptionController = TextEditingController(text: item.description);
    _priceController = TextEditingController(text: item.price?.toString() ?? '');
    _selectedCategory = item.category;
    _selectedCondition = item.condition;
    _selectedType = item.type;
    _retainedImages = List.from(item.images);
    _initialized = true;
  }

  Future<void> _pickImages() async {
    final totalCount = _retainedImages.length + _newImageFiles.length;
    if (totalCount >= AppConstants.maxListingImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 5 images allowed.')),
      );
      return;
    }

    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(imageQuality: 80);

    if (picked.isNotEmpty) {
      setState(() {
        final remaining = AppConstants.maxListingImages - totalCount;
        _newImageFiles.addAll(picked.take(remaining).map((x) => File(x.path)));
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate() || _originalListing == null) return;

    if (_retainedImages.isEmpty && _newImageFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listing must have at least 1 image.')),
      );
      return;
    }

    final price = _selectedType == 'Paid' ? double.tryParse(_priceController.text) : null;

    final success = await ref.read(listingControllerProvider.notifier).updateListing(
          currentListing: _originalListing!,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          category: _selectedCategory,
          condition: _selectedCondition,
          type: _selectedType,
          price: price,
          newImageFiles: _newImageFiles,
          retainedImages: _retainedImages,
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Listing updated successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final listingAsync = ref.watch(singleListingProvider(widget.listingId));
    final listingState = ref.watch(listingControllerProvider);
    final isLoading = listingState.status == ListingOperationStatus.loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Listing'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Listing'),
                  content: const Text('Are you sure you want to delete this listing?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Delete', style: TextStyle(color: AppColors.error)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                final delSuccess = await ref
                    .read(listingControllerProvider.notifier)
                    .deleteListing(widget.listingId);
                if (delSuccess && mounted) {
                  context.go('/home');
                }
              }
            },
          ),
        ],
      ),
      body: listingAsync.when(
        data: (item) {
          if (item == null) {
            return const Center(child: Text('Listing not found'));
          }
          _initFields(item);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Images Grid
                  Text('Images', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ..._retainedImages.map((url) => Stack(
                              children: [
                                Container(
                                  width: 90,
                                  height: 90,
                                  margin: const EdgeInsets.only(right: 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(imageUrl: url, fit: BoxFit.cover),
                                  ),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 10,
                                  child: InkWell(
                                    onTap: () => setState(() => _retainedImages.remove(url)),
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.black.withOpacity(0.80),
                                      child: const Icon(Icons.close, size: 14, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        ..._newImageFiles.map((file) => Stack(
                              children: [
                                Container(
                                  width: 90,
                                  height: 90,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(image: FileImage(file), fit: BoxFit.cover),
                                  ),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 10,
                                  child: InkWell(
                                    onTap: () => setState(() => _newImageFiles.remove(file)),
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.black.withOpacity(0.80),
                                      child: const Icon(Icons.close, size: 14, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        InkWell(
                          onTap: _pickImages,
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.primary),
                            ),
                            child: const Icon(Icons.add_a_photo_rounded, color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Title required' : null,
                  ),
                  const SizedBox(height: 16),

                  // Category
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: AppConstants.categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Description required' : null,
                  ),
                  const SizedBox(height: 24),

                  // Save Button
                  ElevatedButton(
                    onPressed: isLoading ? null : _handleSave,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Save Changes'),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
