import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class CloudinaryService {
  CloudinaryService._();

  // Free Cloudinary Unsigned Upload Endpoint
  static const String defaultCloudName = 'demo';
  static const String defaultUploadPreset = 'unsigned_preset';

  static Future<String?> uploadImage(
    File imageFile, {
    String? cloudName,
    String? uploadPreset,
  }) async {
    try {
      final activeCloud = (cloudName != null && cloudName.isNotEmpty) ? cloudName : defaultCloudName;
      final activePreset = (uploadPreset != null && uploadPreset.isNotEmpty) ? uploadPreset : defaultUploadPreset;

      final url = Uri.parse('https://api.cloudinary.com/v1_1/$activeCloud/image/upload');

      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = activePreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send().timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final jsonMap = jsonDecode(utf8.decode(responseData));
        return jsonMap['secure_url'] as String?;
      }
      return null;
    } catch (e) {
      debugPrint("Cloudinary upload info: $e");
      return null;
    }
  }
}
