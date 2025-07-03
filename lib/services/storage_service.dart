import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_service.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final SupabaseService _supabaseService = SupabaseService();
  static const String profileImagesBucket = 'profile-images';

  // Upload profile image
  Future<String> uploadProfileImage(File imageFile, String userId) async {
    try {
      final client = await _supabaseService.client;
      final String fileName =
          '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = 'profiles/$fileName';

      // Upload file to Supabase Storage
      await client.storage.from(profileImagesBucket).upload(filePath, imageFile,
          fileOptions: const FileOptions(
            cacheControl: '3600',
            upsert: true,
          ));

      // Get public URL
      final String publicUrl =
          client.storage.from(profileImagesBucket).getPublicUrl(filePath);

      return publicUrl;
    } catch (error) {
      throw Exception('Failed to upload profile image: $error');
    }
  }

  // Delete profile image
  Future<void> deleteProfileImage(String imageUrl) async {
    try {
      final client = await _supabaseService.client;

      // Extract file path from URL
      final uri = Uri.parse(imageUrl);
      final segments = uri.pathSegments;
      final bucketIndex = segments.indexOf(profileImagesBucket);

      if (bucketIndex != -1 && bucketIndex < segments.length - 1) {
        final filePath = segments.sublist(bucketIndex + 1).join('/');

        await client.storage.from(profileImagesBucket).remove([filePath]);
      }
    } catch (error) {
      throw Exception('Failed to delete profile image: $error');
    }
  }

  // Get public URL for profile image
  String getProfileImageUrl(String filePath) {
    final client = _supabaseService.syncClient;
    return client.storage.from(profileImagesBucket).getPublicUrl(filePath);
  }

  // List files in profile images bucket
  Future<List<FileObject>> listProfileImages(String userId) async {
    try {
      final client = await _supabaseService.client;
      final List<FileObject> files =
          await client.storage.from(profileImagesBucket).list(
              path: 'profiles/',
              searchOptions: const SearchOptions(
                limit: 100,
                offset: 0,
              ));

      // Filter files for specific user
      return files.where((file) => file.name.startsWith(userId)).toList();
    } catch (error) {
      throw Exception('Failed to list profile images: $error');
    }
  }

  // Create storage bucket if it doesn't exist (for admin use)
  Future<void> createProfileImagesBucket() async {
    try {
      final client = await _supabaseService.client;
      await client.storage.createBucket(
        profileImagesBucket,
        BucketOptions(
          public: true,
          allowedMimeTypes: ['image/jpeg', 'image/png', 'image/webp'],
          fileSizeLimit: '5242880', // 5MB limit as string
        ),
      );
    } catch (error) {
      // Bucket might already exist, ignore error
      print('Bucket creation info: $error');
    }
  }

  // Update profile image for worker
  Future<String> updateWorkerProfileImage(File imageFile) async {
    try {
      final client = await _supabaseService.client;
      final user = client.auth.currentUser;

      if (user == null) {
        throw Exception('No authenticated user found');
      }

      // Upload new image
      final String imageUrl = await uploadProfileImage(imageFile, user.id);

      // Update worker profile with new image URL
      await client.from('workers').update({
        'profile_image_url': imageUrl,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('user_id', user.id);

      return imageUrl;
    } catch (error) {
      throw Exception('Failed to update worker profile image: $error');
    }
  }
}
