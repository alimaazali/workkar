import './supabase_service.dart';

class CategoryService {
  static final CategoryService _instance = CategoryService._internal();
  factory CategoryService() => _instance;
  CategoryService._internal();

  final SupabaseService _supabaseService = SupabaseService();

  // Get all available service categories
  List<Map<String, dynamic>> getServiceCategories() {
    return [
      {
        'id': 'electrician',
        'name': 'Electrician',
        'description': 'Electrical repairs and installations',
        'icon': '⚡',
        'color': '#FF9800',
      },
      {
        'id': 'plumber',
        'name': 'Plumber',
        'description': 'Pipe repairs and water systems',
        'icon': '🔧',
        'color': '#2196F3',
      },
      {
        'id': 'carpenter',
        'name': 'Carpenter',
        'description': 'Wood work and furniture repair',
        'icon': '🔨',
        'color': '#795548',
      },
      {
        'id': 'painter',
        'name': 'Painter',
        'description': 'Interior and exterior painting',
        'icon': '🎨',
        'color': '#E91E63',
      },
      {
        'id': 'mechanic',
        'name': 'Mechanic',
        'description': 'Vehicle and machinery repair',
        'icon': '🔧',
        'color': '#607D8B',
      },
      {
        'id': 'cleaner',
        'name': 'Cleaner',
        'description': 'House and office cleaning',
        'icon': '🧹',
        'color': '#4CAF50',
      },
      {
        'id': 'gardener',
        'name': 'Gardener',
        'description': 'Garden maintenance and landscaping',
        'icon': '🌱',
        'color': '#8BC34A',
      },
      {
        'id': 'handyman',
        'name': 'Handyman',
        'description': 'General repair and maintenance',
        'icon': '🛠️',
        'color': '#9C27B0',
      },
      {
        'id': 'ac_repair',
        'name': 'AC Repair',
        'description': 'Air conditioning service and repair',
        'icon': '❄️',
        'color': '#00BCD4',
      },
      {
        'id': 'appliance_repair',
        'name': 'Appliance Repair',
        'description': 'Home appliance repair and service',
        'icon': '🔌',
        'color': '#FF5722',
      },
    ];
  }

  // Get category by ID
  Map<String, dynamic>? getCategoryById(String categoryId) {
    final categories = getServiceCategories();
    return categories.firstWhere(
      (category) => category['id'] == categoryId,
      orElse: () => {
        'id': categoryId,
        'name': categoryId,
        'description': '',
        'icon': '🛠️',
        'color': '#9E9E9E',
      },
    );
  }

  // Get worker count by category
  Future<Map<String, int>> getWorkerCountByCategory() async {
    try {
      final client = await _supabaseService.client;
      final response = await client.rpc('get_worker_count_by_category');

      Map<String, int> counts = {};
      for (var item in response) {
        counts[item['service_category']] = item['worker_count'];
      }
      return counts;
    } catch (error) {
      // Return empty map if RPC function doesn't exist
      return {};
    }
  }

  // Get categories with worker availability
  Future<List<Map<String, dynamic>>> getCategoriesWithAvailability() async {
    try {
      final categories = getServiceCategories();
      final workerCounts = await getWorkerCountByCategory();

      return categories.map((category) {
        final count = workerCounts[category['id']] ?? 0;
        return {
          ...category,
          'available_workers': count,
          'has_workers': count > 0,
        };
      }).toList();
    } catch (error) {
      // Return categories without counts if database call fails
      return getServiceCategories().map((category) {
        return {
          ...category,
          'available_workers': 0,
          'has_workers': false,
        };
      }).toList();
    }
  }

  // Search categories
  List<Map<String, dynamic>> searchCategories(String query) {
    final categories = getServiceCategories();
    final lowerQuery = query.toLowerCase();

    return categories.where((category) {
      final name = category['name'].toString().toLowerCase();
      final description = category['description'].toString().toLowerCase();
      return name.contains(lowerQuery) || description.contains(lowerQuery);
    }).toList();
  }
}
