import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/formatters.dart';
import '../providers/listing_provider.dart';

class CreateListingScreen extends ConsumerStatefulWidget {
  const CreateListingScreen({super.key});

  @override
  ConsumerState<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends ConsumerState<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _addressController = TextEditingController(text: 'San Francisco, CA');

  String _selectedCategory = AppConstants.categories.first;
  String _selectedCondition = AppConstants.conditions[2]; // Good
  String _selectedType = AppConstants.listingTypes.first; // Free
  List<File> _images = [];

  double _lat = AppConstants.defaultLatitude;
  double _lng = AppConstants.defaultLongitude;
  bool _isLocating = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    if (_images.length >= AppConstants.maxListingImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 5 images allowed per listing.')),
      );
      return;
    }

    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(
      imageQuality: 80,
      maxWidth: 1024,
      maxHeight: 1024,
    );

    if (pickedFiles.isNotEmpty) {
      setState(() {
        final remainingSlots = AppConstants.maxListingImages - _images.length;
        final newFiles = pickedFiles.take(remainingSlots).map((x) => File(x.path));
        _images.addAll(newFiles);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLocating = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          _lat = position.latitude;
          _lng = position.longitude;
          _addressController.text = 'Current Location (${_lat.toStringAsFixed(2)}, ${_lng.toStringAsFixed(2)})';
        });
      }
    } catch (_) {
      // Keep default location if permission denied
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least 1 image of the item.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final price = _selectedType == 'Paid' ? double.tryParse(_priceController.text) : null;

    final success = await ref.read(listingControllerProvider.notifier).createListing(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          category: _selectedCategory,
          condition: _selectedCondition,
          type: _selectedType,
          price: price,
          imageFiles: _images,
          lat: _lat,
          lng: _lng,
          address: _addressController.text.trim(),
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Listing created successfully! Eco points awarded 🌱'),
          backgroundColor: AppColors.success,
        ),
      );
      context.go('/home');
    } else if (mounted) {
      final error = ref.read(listingControllerProvider).errorMessage;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final listingState = ref.watch(listingControllerProvider);
    final isLoading = listingState.status == ListingOperationStatus.loading;

    final co2Estimate = AppConstants.co2SavedPerCategory[_selectedCategory] ?? 10.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post New Item'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image Selector Section
                Text(
                  'Photos (Min 1, Max 5)',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _images.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _images.length) {
                        return InkWell(
                          onTap: _pickImages,
                          child: Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.primary, width: 1.5),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo_rounded, color: AppColors.primary, size: 28),
                                SizedBox(height: 4),
                                Text(
                                  'Add Photo',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final file = _images[index];
                      return Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: FileImage(file),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 16,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.black70,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close_rounded, color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Item Title
                TextFormField(
                  controller: _titleController,
                  maxLength: 60,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Item Title',
                    hintText: 'e.g., Vintage Wooden Dining Chair',
                    prefixIcon: Icon(Icons.title_rounded),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Please enter a title';
                    if (val.trim().length < 3) return 'Title must be at least 3 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Category & Condition Row
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category_rounded),
                  ),
                  items: AppConstants.categories
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedCategory = val);
                  },
                ),
                const SizedBox(height: 16),

                // Item Condition
                Text(
                  'Condition',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: AppConstants.conditions.map((cond) {
                    final isSelected = _selectedCondition == cond;
                    return ChoiceChip(
                      label: Text(cond),
                      selected: isSelected,
                      selectedColor: AppColors.primaryContainer,
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedCondition = cond);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Listing Type (Free / Swap / Paid)
                Text(
                  'Listing Type',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'Free', label: Text('Free 🎁')),
                    ButtonSegment(value: 'Swap', label: Text('Swap 🔄')),
                    ButtonSegment(value: 'Paid', label: Text('Paid 💵')),
                  ],
                  selected: {_selectedType},
                  onSelectionChanged: (set) {
                    setState(() => _selectedType = set.first);
                  },
                ),
                const SizedBox(height: 16),

                if (_selectedType == 'Paid') ...[
                  TextFormField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Price (\$ USD)',
                      prefixIcon: Icon(Icons.attach_money_rounded),
                    ),
                    validator: (val) {
                      if (_selectedType == 'Paid') {
                        if (val == null || val.isEmpty) return 'Please enter a price';
                        if (double.tryParse(val) == null) return 'Please enter a valid amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Estimated CO2 Impact Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.co2BadgeBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.co2Green, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.eco_rounded, color: AppColors.co2Green, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Estimated Environmental Impact',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: AppColors.co2Green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Reusing this ${_selectedCategory.toLowerCase()} item saves ~${AppFormatters.formatCo2(co2Estimate)} from landfills!',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  maxLength: 500,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Describe condition, dimensions, pick-up preferences...',
                    prefixIcon: Icon(Icons.notes_rounded),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Please enter a description';
                    if (val.trim().length < 10) return 'Description must be at least 10 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Location Picker
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Location / Address',
                    prefixIcon: const Icon(Icons.location_on_rounded),
                    suffixIcon: IconButton(
                      icon: _isLocating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.my_location_rounded, color: AppColors.primary),
                      onPressed: _getCurrentLocation,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button
                ElevatedButton(
                  onPressed: isLoading ? null : _handleSubmit,
                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Publish Listing (+10 pts)'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
