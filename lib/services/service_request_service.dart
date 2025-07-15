import '../models/service_request.dart';
import './supabase_service.dart';

class ServiceRequestService {
  static final ServiceRequestService _instance =
      ServiceRequestService._internal();
  factory ServiceRequestService() => _instance;
  ServiceRequestService._internal();

  final SupabaseService _supabaseService = SupabaseService();

  // Create a new service request
  Future<ServiceRequest> createServiceRequest({
    required String workerId,
    required String serviceCategory,
    required String description,
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    try {
      final client = await _supabaseService.client;
      final user = client.auth.currentUser;

      if (user == null) {
        throw Exception('No authenticated user found');
      }

      final requestData = {
        'user_id': user.id,
        'worker_id': workerId,
        'service_category': serviceCategory,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'status': 'pending',
      };

      final response = await client
          .from('service_requests')
          .insert(requestData)
          .select()
          .single();

      return ServiceRequest.fromJson(response);
    } catch (error) {
      throw Exception('Failed to create service request: $error');
    }
  }

  // Get user's service requests
  Future<List<ServiceRequest>> getUserServiceRequests() async {
    try {
      final client = await _supabaseService.client;
      final user = client.auth.currentUser;

      if (user == null) {
        throw Exception('No authenticated user found');
      }

      final response = await client
          .from('service_requests')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      return response
          .map<ServiceRequest>((json) => ServiceRequest.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get service requests: $error');
    }
  }

  // Get worker's service requests
  Future<List<ServiceRequest>> getWorkerServiceRequests() async {
    try {
      final client = await _supabaseService.client;
      final user = client.auth.currentUser;

      if (user == null) {
        throw Exception('No authenticated user found');
      }

      // Get worker ID from workers table
      final workerResponse = await client
          .from('workers')
          .select('id')
          .eq('user_id', user.id)
          .single();

      final workerId = workerResponse['id'];

      final response = await client
          .from('service_requests')
          .select()
          .eq('worker_id', workerId)
          .order('created_at', ascending: false);

      return response
          .map<ServiceRequest>((json) => ServiceRequest.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to get worker service requests: $error');
    }
  }

  // Update service request status
  Future<ServiceRequest> updateServiceRequestStatus({
    required String requestId,
    required String status,
  }) async {
    try {
      final client = await _supabaseService.client;

      final response = await client
          .from('service_requests')
          .update({'status': status})
          .eq('id', requestId)
          .select()
          .single();

      return ServiceRequest.fromJson(response);
    } catch (error) {
      throw Exception('Failed to update service request status: $error');
    }
  }

  // Get service request by ID
  Future<ServiceRequest?> getServiceRequestById(String requestId) async {
    try {
      final client = await _supabaseService.client;

      final response = await client
          .from('service_requests')
          .select()
          .eq('id', requestId)
          .maybeSingle();

      return response != null ? ServiceRequest.fromJson(response) : null;
    } catch (error) {
      throw Exception('Failed to get service request: $error');
    }
  }

  // Delete service request
  Future<void> deleteServiceRequest(String requestId) async {
    try {
      final client = await _supabaseService.client;

      await client.from('service_requests').delete().eq('id', requestId);
    } catch (error) {
      throw Exception('Failed to delete service request: $error');
    }
  }
}
