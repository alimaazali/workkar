import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_profile.dart';
import './supabase_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final SupabaseService _supabaseService = SupabaseService();

  // Get current user
  User? get currentUser => _supabaseService.syncClient.auth.currentUser;

  // Auth state stream
  Stream<AuthState> get authStateStream =>
      _supabaseService.syncClient.auth.onAuthStateChange;

  // Sign up with phone and OTP
  Future<AuthResponse> signUpWithPhone(String phone) async {
    try {
      final client = await _supabaseService.client;
      await client.auth.signInWithOtp(
        phone: phone,
        shouldCreateUser: true,
      );
      // Return a mock AuthResponse since signInWithOtp returns void
      return AuthResponse(
        user: null,
        session: null,
      );
    } catch (error) {
      throw Exception('Sign-up failed: $error');
    }
  }

  // Sign in with phone and OTP
  Future<AuthResponse> signInWithPhone(String phone) async {
    try {
      final client = await _supabaseService.client;
      await client.auth.signInWithOtp(
        phone: phone,
      );
      // Return a mock AuthResponse since signInWithOtp returns void
      return AuthResponse(
        user: null,
        session: null,
      );
    } catch (error) {
      throw Exception('Sign-in failed: $error');
    }
  }

  // Verify OTP
  Future<AuthResponse> verifyOTP(String phone, String token) async {
    try {
      final client = await _supabaseService.client;
      final response = await client.auth.verifyOTP(
        type: OtpType.sms,
        token: token,
        phone: phone,
      );
      return response;
    } catch (error) {
      throw Exception('OTP verification failed: $error');
    }
  }

  // Complete user profile after OTP verification
  Future<UserProfile> completeProfile({
    required String fullName,
    required String role,
    required String phone,
  }) async {
    try {
      final client = await _supabaseService.client;
      final user = currentUser;

      if (user == null) {
        throw Exception('No authenticated user found');
      }

      // Update user metadata
      await client.auth.updateUser(
        UserAttributes(
          data: {
            'full_name': fullName,
            'role': role,
            'phone': phone,
          },
        ),
      );

      // Update user profile in database
      final response = await client
          .from('user_profiles')
          .update({
            'full_name': fullName,
            'role': role,
            'phone': phone,
          })
          .eq('id', user.id)
          .select()
          .single();

      return UserProfile.fromJson(response);
    } catch (error) {
      throw Exception('Profile completion failed: $error');
    }
  }

  // Get user profile
  Future<UserProfile?> getUserProfile() async {
    try {
      final client = await _supabaseService.client;
      final user = currentUser;

      if (user == null) return null;

      final response = await client
          .from('user_profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      return response != null ? UserProfile.fromJson(response) : null;
    } catch (error) {
      throw Exception('Failed to get user profile: $error');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      final client = await _supabaseService.client;
      await client.auth.signOut();
    } catch (error) {
      throw Exception('Sign-out failed: $error');
    }
  }

  // Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  // Check if user is a worker
  Future<bool> isWorker() async {
    try {
      final profile = await getUserProfile();
      return profile?.role == 'worker';
    } catch (error) {
      return false;
    }
  }

  // Check if user is a regular user
  Future<bool> isRegularUser() async {
    try {
      final profile = await getUserProfile();
      return profile?.role == 'user';
    } catch (error) {
      return false;
    }
  }
}
