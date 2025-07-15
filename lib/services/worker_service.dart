import 'dart:math' as math;

import '../models/worker.dart';
import './supabase_service.dart';

class WorkerService {
  static final WorkerService _instance = WorkerService._internal();
  factory WorkerService() => _instance;
  WorkerService._internal();

  final SupabaseService _supabaseService = SupabaseService();

  // Get workers by category and location
  Future<List<Worker>> getWorkersByCategory({
    required String category,
    double? userLatitude,
    double? userLongitude,
    String? pincode,
    int limit = 20,
  }) async {
    try {
      final client = await _supabaseService.client;

      var query = client.from('workers').select('''
            id, user_id, service_category, pincode, latitude, longitude,
            availability, bio, hourly_rate, experience_years, profile_image_url,
            created_at, updated_at,
            user_profiles!workers_user_id_fkey(full_name, phone)
          ''').eq('service_category', category).eq('availability', 'available');

      if (pincode != null && pincode.isNotEmpty) {
        query = query.eq('pincode', pincode);
      }

      final response = await query.limit(limit);

      List<Worker> workers =
          response.map<Worker>((json) => Worker.fromJson(json)).toList();

      // Sort by distance if user location is provided
      if (userLatitude != null && userLongitude != null) {
        workers.sort((a, b) {
          final distanceA = _calculateDistance(
              userLatitude, userLongitude, a.latitude ?? 0, a.longitude ?? 0);
          final distanceB = _calculateDistance(
              userLatitude, userLongitude, b.latitude ?? 0, b.longitude ?? 0);
          return distanceA.compareTo(distanceB);
        });
      }

      return workers;
    } catch (error) {
      throw Exception('Failed to get workers: $error');
    }
  }

  // Search workers by area name or pincode
  Future<List<Worker>> searchWorkers({
    required String searchQuery,
    String? category,
    double? userLatitude,
    double? userLongitude,
  }) async {
    try {
      final client = await _supabaseService.client;

      var query = client
          .from('workers')
          .select('''
            id, user_id, service_category, pincode, latitude, longitude,
            availability, bio, hourly_rate, experience_years, profile_image_url,
            created_at, updated_at,
            user_profiles!workers_user_id_fkey(full_name, phone)
          ''')
          .eq('availability', 'available')
          .ilike('pincode', '%$searchQuery%');

      if (category != null && category.isNotEmpty) {
        query = query.eq('service_category', category);
      }

      final response = await query;

      List<Worker> workers =
          response.map<Worker>((json) => Worker.fromJson(json)).toList();

      // Sort by distance if user location is provided
      if (userLatitude != null && userLongitude != null) {
        workers.sort((a, b) {
          final distanceA = _calculateDistance(
              userLatitude, userLongitude, a.latitude ?? 0, a.longitude ?? 0);
          final distanceB = _calculateDistance(
              userLatitude, userLongitude, b.latitude ?? 0, b.longitude ?? 0);
          return distanceA.compareTo(distanceB);
        });
      }

      return workers;
    } catch (error) {
      throw Exception('Failed to search workers: $error');
    }
  }

  // Create or update worker profile
  Future<Worker> createOrUpdateWorkerProfile({
    required String serviceCategory,
    required String pincode,
    required double latitude,
    required double longitude,
    String? bio,
    double? hourlyRate,
    int? experienceYears,
    String? profileImageUrl,
  }) async {
    try {
      final client = await _supabaseService.client;
      final user = client.auth.currentUser;

      if (user == null) {
        throw Exception('No authenticated user found');
      }

      final workerData = {
        'user_id': user.id,
        'service_category': serviceCategory,
        'pincode': pincode,
        'latitude': latitude,
        'longitude': longitude,
        'availability': 'available',
        'bio': bio,
        'hourly_rate': hourlyRate,
        'experience_years': experienceYears,
        'profile_image_url': profileImageUrl,
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Check if worker profile exists
      final existingWorker = await client
          .from('workers')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      final response = existingWorker != null
          ? await client
              .from('workers')
              .update(workerData)
              .eq('user_id', user.id)
              .select('''
                id, user_id, service_category, pincode, latitude, longitude,
                availability, bio, hourly_rate, experience_years, profile_image_url,
                created_at, updated_at,
                user_profiles!workers_user_id_fkey(full_name, phone)
              ''').single()
          : await client.from('workers').insert(workerData).select('''
                id, user_id, service_category, pincode, latitude, longitude,
                availability, bio, hourly_rate, experience_years, profile_image_url,
                created_at, updated_at,
                user_profiles!workers_user_id_fkey(full_name, phone)
              ''').single();

      return Worker.fromJson(response);
    } catch (error) {
      throw Exception('Failed to create/update worker profile: $error');
    }
  }

  // Update worker availability
  Future<void> updateAvailability(String availability) async {
    try {
      final client = await _supabaseService.client;
      final user = client.auth.currentUser;

      if (user == null) {
        throw Exception('No authenticated user found');
      }

      await client.from('workers').update({
        'availability': availability,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('user_id', user.id);
    } catch (error) {
      throw Exception('Failed to update availability: $error');
    }
  }

  // Get current worker profile
  Future<Worker?> getCurrentWorkerProfile() async {
    try {
      final client = await _supabaseService.client;
      final user = client.auth.currentUser;

      if (user == null) return null;

      final response = await client.from('workers').select('''
            id, user_id, service_category, pincode, latitude, longitude,
            availability, bio, hourly_rate, experience_years, profile_image_url,
            created_at, updated_at,
            user_profiles!workers_user_id_fkey(full_name, phone)
          ''').eq('user_id', user.id).maybeSingle();

      return response != null ? Worker.fromJson(response) : null;
    } catch (error) {
      throw Exception('Failed to get worker profile: $error');
    }
  }

  // Calculate distance between two points (Haversine formula)
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth radius in kilometers

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }
}
