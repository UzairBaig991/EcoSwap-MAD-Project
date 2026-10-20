import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dart_geohash/dart_geohash.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_image_helper.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _cityController;
  Uint8List? _selectedImageBytes;

  double _lat = 37.7749;
  double _lng = -122.4194;

  // Comprehensive Worldwide City Directory Covering All Continents
  final List<Map<String, dynamic>> _globalCities = [
    // Asia & South Asia
    {'city': 'Tokyo, Japan 🇯🇵', 'lat': 35.6762, 'lng': 139.6503},
    {'city': 'Mumbai, India 🇮🇳', 'lat': 19.0760, 'lng': 72.8777},
    {'city': 'Delhi, India 🇮🇳', 'lat': 28.6139, 'lng': 77.2090},
    {'city': 'Singapore 🇸🇬', 'lat': 1.3521, 'lng': 103.8198},
    {'city': 'Beijing, China 🇨🇳', 'lat': 39.9042, 'lng': 116.4074},
    {'city': 'Bangkok, Thailand 🇹🇭', 'lat': 13.7563, 'lng': 100.5018},
    {'city': 'Seoul, South Korea 🇰🇷', 'lat': 37.5665, 'lng': 126.9780},
    {'city': 'Jakarta, Indonesia 🇮🇩', 'lat': -6.2088, 'lng': 106.8456},
    {'city': 'Manila, Philippines 🇵🇭', 'lat': 14.5995, 'lng': 120.9842},
    {'city': 'Kuala Lumpur, Malaysia 🇲🇾', 'lat': 3.1390, 'lng': 101.6869},
    {'city': 'Karachi, Pakistan 🇵🇰', 'lat': 24.8607, 'lng': 67.0011},
    {'city': 'Dhaka, Bangladesh 🇧🇩', 'lat': 23.8103, 'lng': 90.4125},

    // Middle East
    {'city': 'Dubai, UAE 🇦🇪', 'lat': 25.2048, 'lng': 55.2708},
    {'city': 'Riyadh, Saudi Arabia 🇸🇦', 'lat': 24.7136, 'lng': 46.6753},
    {'city': 'Istanbul, Turkey 🇹🇷', 'lat': 41.0082, 'lng': 28.9784},

    // Africa
    {'city': 'Cairo, Egypt 🇪🇬', 'lat': 30.0444, 'lng': 31.2357},
    {'city': 'Lagos, Nigeria 🇳🇬', 'lat': 6.5244, 'lng': 3.3792},
    {'city': 'Nairobi, Kenya 🇰🇪', 'lat': -1.2921, 'lng': 36.8219},
    {'city': 'Johannesburg, South Africa 🇿🇦', 'lat': -26.2041, 'lng': 28.0473},
    {'city': 'Casablanca, Morocco 🇲🇦', 'lat': 33.5731, 'lng': -7.5898},

    // Europe
    {'city': 'London, UK 🇬🇧', 'lat': 51.5074, 'lng': -0.1278},
    {'city': 'Paris, France 🇫🇷', 'lat': 48.8566, 'lng': 2.3522},
    {'city': 'Berlin, Germany 🇩🇪', 'lat': 52.5200, 'lng': 13.4050},
    {'city': 'Rome, Italy 🇮🇹', 'lat': 41.9028, 'lng': 12.4964},
    {'city': 'Madrid, Spain 🇪🇸', 'lat': 40.4168, 'lng': -3.7038},

    // North America & Latin America
    {'city': 'New York, USA 🇺🇸', 'lat': 40.7128, 'lng': -74.0060},
    {'city': 'San Francisco, USA 🇺🇸', 'lat': 37.7749, 'lng': -122.4194},
    {'city': 'Toronto, Canada 🇨🇦', 'lat': 43.6532, 'lng': -79.3832},
    {'city': 'Mexico City, Mexico 🇲🇽', 'lat': 19.4326, 'lng': -99.1332},
    {'city': 'São Paulo, Brazil 🇧🇷', 'lat': -23.5505, 'lng': -46.6333},
    {'city': 'Buenos Aires, Argentina 🇦🇷', 'lat': -34.6037, 'lng': -58.3816},

    // Oceania
    {'city': 'Sydney, Australia 🇦🇺', 'lat': -33.8688, 'lng': 151.2093},
    {'city': 'Melbourne, Australia 🇦🇺', 'lat': -37.8136, 'lng': 144.9631},
    {'city': 'Auckland, New Zealand 🇳🇿', 'lat': -36.8485, 'lng': 174.7633},
  ];

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserModelProvider).asData?.value;
    _nameController = TextEditingController(text: user?.displayName ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
    _cityController = TextEditingController(text: user?.location.city ?? 'San Francisco, USA');
    if (user != null) {
      _lat = user.location.lat != 0.0 ? user.location.lat : 37.7749;
      _lng = user.location.lng != 0.0 ? user.location.lng : -122.4194;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
      });
    }
  }

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Profile Picture',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded, color: AppColors.primary),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded, color: AppColors.primary),
              title: const Text('Take Photo with Camera'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showGlobalLocationPickerModal() {
    String filterQuery = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredCities = _globalCities.where((c) {
              final name = (c['city'] as String).toLowerCase();
              return name.contains(filterQuery.toLowerCase());
            }).toList();

            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.public_rounded, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'Worldwide City Directory',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Search Filter
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search city or country worldwide...',
                      prefixIcon: Icon(Icons.search_rounded),
                    ),
                    onChanged: (val) {
                      setModalState(() => filterQuery = val);
                    },
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 280,
                    child: ListView.builder(
                      itemCount: filteredCities.length,
                      itemBuilder: (context, idx) {
                        final cityData = filteredCities[idx];
                        return ListTile(
                          leading: const Icon(Icons.location_city_rounded, color: AppColors.primary),
                          title: Text(cityData['city'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Lat: ${cityData['lat']}, Lng: ${cityData['lng']}'),
                          onTap: () {
                            setState(() {
                              _cityController.text = cityData['city'];
                              _lat = cityData['lat'];
                              _lng = cityData['lng'];
                            });
                            Navigator.pop(ctx);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final currentUser = ref.read(currentUserModelProvider).asData?.value;
    if (currentUser == null) return;

    final hasher = GeoHasher();
    final updatedGeohash = hasher.encode(_lng, _lat, precision: 6);

    final updatedLocation = currentUser.location.copyWith(
      city: _cityController.text.trim(),
      lat: _lat,
      lng: _lng,
      geohash: updatedGeohash,
    );

    final updatedModel = currentUser.copyWith(location: updatedLocation);

    final success = await ref.read(profileControllerProvider.notifier).updateProfile(
          currentModel: updatedModel,
          displayName: _nameController.text.trim(),
          bio: _bioController.text.trim(),
          city: _cityController.text.trim(),
          newImageBytes: _selectedImageBytes,
        );

    if (success && mounted) {
      ref.invalidate(currentUserModelProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile & Photo updated successfully! 🎉'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    } else if (mounted) {
      final error = ref.read(profileControllerProvider).errorMessage;
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
    final userAsync = ref.watch(currentUserModelProvider);
    final profileState = ref.watch(profileControllerProvider);
    final isLoading = profileState.status == ProfileStatus.loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: isLoading ? null : _handleSave,
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('User profile not found'));
          }

          final currentImageProvider = AppImageHelper.getImageProvider(user.photoUrl);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Avatar Picker
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 54,
                          backgroundColor: AppColors.primaryContainer,
                          backgroundImage: _selectedImageBytes != null
                              ? MemoryImage(_selectedImageBytes!) as ImageProvider
                              : currentImageProvider,
                          child: (_selectedImageBytes == null && currentImageProvider == null)
                              ? Text(
                                  user.displayName.isNotEmpty
                                      ? user.displayName[0].toUpperCase()
                                      : 'E',
                                  style: theme.textTheme.displaySmall?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: _showImageSourcePicker,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _showImageSourcePicker,
                    icon: const Icon(Icons.edit_rounded, size: 16),
                    label: const Text('Change Profile Photo'),
                  ),
                  const SizedBox(height: 24),

                  // Display Name
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Display Name',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Display name cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // City / Location Field with Worldwide Directory
                  TextFormField(
                    controller: _cityController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'City / Region (Worldwide)',
                      prefixIcon: const Icon(Icons.public_rounded),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.map_rounded, color: AppColors.primary),
                        tooltip: 'Select Worldwide Location',
                        onPressed: _showGlobalLocationPickerModal,
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'City cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton.icon(
                      onPressed: _showGlobalLocationPickerModal,
                      icon: const Icon(Icons.public_rounded, size: 16),
                      label: const Text('Select Worldwide Location 🌎'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Bio
                  TextFormField(
                    controller: _bioController,
                    maxLines: 3,
                    maxLength: 150,
                    decoration: const InputDecoration(
                      labelText: 'Bio / Short Intro',
                      hintText: 'Share a little about your sustainability goals...',
                      prefixIcon: Icon(Icons.notes_rounded),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading profile: $err')),
      ),
    );
  }
}
