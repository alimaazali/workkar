import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  late final SupabaseClient _client;
  bool _isInitialized = false;
  final Future<void> _initFuture;

  // Singleton pattern
  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal() : _initFuture = _initializeSupabase();

  // Use the provided project URL or fallback to environment variables
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL',
      defaultValue: 'https://nipkmkabmaxruapfwerv.supabase.com');
  static const String supabaseAnonKey = String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5pcGtta2FibWF4cnVhcGZ3ZXJ2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQzNjQ4MDAsImV4cCI6MjA0OTk0MDgwMH0.7rCHcIm2ZpXZxjzAoNqYdnhPvQDjXkAGPTEIJBYLVGE');

  // Internal initialization logic
  static Future<void> _initializeSupabase() async {
    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw Exception(
          'SUPABASE_URL and SUPABASE_ANON_KEY must be defined using --dart-define.');
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );

    _instance._client = Supabase.instance.client;
    _instance._isInitialized = true;
  }

  // Client getter (async)
  Future<SupabaseClient> get client async {
    if (!_isInitialized) {
      await _initFuture;
    }
    return _client;
  }

  // Sync client getter (use only after ensuring initialization)
  SupabaseClient get syncClient {
    if (!_isInitialized) {
      throw Exception(
          'SupabaseService not initialized. Call client getter first.');
    }
    return _client;
  }

  // Get current project URL
  static String get currentProjectUrl => supabaseUrl;

  // Get current anon key
  static String get currentAnonKey => supabaseAnonKey;

  // Health check method
  Future<bool> isConnected() async {
    try {
      final client = await this.client;
      await client.from('user_profiles').select('count').count();
      return true;
    } catch (e) {
      return false;
    }
  }
}
