import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_export.dart';
import './widgets/location_header_widget.dart';
import './widgets/recent_worker_card_widget.dart';
import './widgets/service_category_card_widget.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen>
    with TickerProviderStateMixin {
  int _selectedTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  bool _isRefreshing = false;
  String _currentLocation = "Koramangala, Bangalore";
  bool _locationPermissionGranted = true;

  // Mock data for service categories
  final List<Map<String, dynamic>> _serviceCategories = [
    {
      "id": 1,
      "name": "Electrician",
      "icon": "electrical_services",
      "availableWorkers": 12,
      "color": Color(0xFF38BDF8),
    },
    {
      "id": 2,
      "name": "Plumber",
      "icon": "plumbing",
      "availableWorkers": 8,
      "color": Color(0xFF34D399),
    },
    {
      "id": 3,
      "name": "Carpenter",
      "icon": "carpenter",
      "availableWorkers": 15,
      "color": Color(0xFFFACC15),
    },
    {
      "id": 4,
      "name": "Cleaner",
      "icon": "cleaning_services",
      "availableWorkers": 20,
      "color": Color(0xFF8B5CF6),
    },
    {
      "id": 5,
      "name": "Painter",
      "icon": "format_paint",
      "availableWorkers": 6,
      "color": Color(0xFFEF4444),
    },
    {
      "id": 6,
      "name": "Handyman",
      "icon": "handyman",
      "availableWorkers": 10,
      "color": Color(0xFF10B981),
    },
  ];

  // Mock data for recent workers
  final List<Map<String, dynamic>> _recentWorkers = [
    {
      "id": 1,
      "name": "Rajesh Kumar",
      "service": "Electrician",
      "rating": 4.8,
      "distance": "0.5 km",
      "phone": "+91 9876543210",
      "image":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
      "lastContacted": "2 days ago",
    },
    {
      "id": 2,
      "name": "Suresh Patel",
      "service": "Plumber",
      "rating": 4.6,
      "distance": "1.2 km",
      "phone": "+91 9876543211",
      "image":
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
      "lastContacted": "1 week ago",
    },
    {
      "id": 3,
      "name": "Amit Singh",
      "service": "Carpenter",
      "rating": 4.9,
      "distance": "0.8 km",
      "phone": "+91 9876543212",
      "image":
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face",
      "lastContacted": "3 days ago",
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _checkLocationPermission() {
    // Mock location permission check
    setState(() {
      _locationPermissionGranted = true;
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        // Navigate to search (placeholder)
        break;
      case 2:
        // Navigate to profile (placeholder)
        break;
    }
  }

  void _onCategoryTapped(Map<String, dynamic> category) {
    Navigator.pushNamed(
      context,
      '/worker-listing-screen',
      arguments: {
        'category': category['name'],
        'categoryId': category['id'],
      },
    );
  }

  void _onLocationEditTapped() {
    _showLocationEditDialog();
  }

  void _showLocationEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController locationController =
            TextEditingController(text: _currentLocation);

        return AlertDialog(
          title: Text(
            'Edit Location',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: TextField(
            controller: locationController,
            decoration: const InputDecoration(
              labelText: 'Enter area or pincode',
              hintText: 'e.g., Koramangala or 560034',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentLocation = locationController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Options',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 3.h),
              Text(
                'Distance Radius',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 1.h),
              Wrap(
                spacing: 2.w,
                children: ['1km', '5km', '10km'].map((distance) {
                  return FilterChip(
                    label: Text(distance),
                    selected: distance == '5km',
                    onSelected: (selected) {},
                  );
                }).toList(),
              ),
              SizedBox(height: 2.h),
              Text(
                'Availability',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 1.h),
              Wrap(
                spacing: 2.w,
                children:
                    ['Available Now', 'Available Today', 'All'].map((status) {
                  return FilterChip(
                    label: Text(status),
                    selected: status == 'Available Now',
                    onSelected: (selected) {},
                  );
                }).toList(),
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Reset'),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _openLocationSettings() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Settings'),
          content: const Text(
            'Enable location services for better service recommendations and accurate distance calculations.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Open device location settings
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch phone dialer'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Row(
          children: [
            CustomIconWidget(
              iconName:
                  _locationPermissionGranted ? 'location_on' : 'location_off',
              color: _locationPermissionGranted
                  ? AppTheme.lightTheme.colorScheme.secondary
                  : AppTheme.lightTheme.colorScheme.error,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'WorkKar',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: CustomIconWidget(
              iconName: 'notifications_outlined',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location Header
              LocationHeaderWidget(
                currentLocation: _currentLocation,
                onLocationEditTapped: _onLocationEditTapped,
              ),

              // Search Bar and Filter
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search by area or pincode',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: CustomIconWidget(
                              iconName: 'search',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.outline,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.outline,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: _showFilterOptions,
                        icon: CustomIconWidget(
                          iconName: 'tune',
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Service Categories Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  'Service Categories',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 2.h),

              // Service Categories Grid
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 3.w,
                    mainAxisSpacing: 2.h,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: _serviceCategories.length,
                  itemBuilder: (context, index) {
                    final category = _serviceCategories[index];
                    return ServiceCategoryCardWidget(
                      category: category,
                      onTap: () => _onCategoryTapped(category),
                    );
                  },
                ),
              ),

              SizedBox(height: 4.h),

              // Recent Workers Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Workers',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('View All'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1.h),

              // Recent Workers Horizontal List
              SizedBox(
                height: 25.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: _recentWorkers.length,
                  itemBuilder: (context, index) {
                    final worker = _recentWorkers[index];
                    return Padding(
                      padding: EdgeInsets.only(right: 3.w),
                      child: RecentWorkerCardWidget(
                        worker: worker,
                        onCallTapped: () => _makePhoneCall(worker['phone']),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 10.h), // Bottom padding for FAB
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.backgroundColor,
        selectedItemColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.unselectedItemColor,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _selectedTabIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'search',
              color: _selectedTabIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _selectedTabIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openLocationSettings,
        backgroundColor:
            AppTheme.lightTheme.floatingActionButtonTheme.backgroundColor,
        child: CustomIconWidget(
          iconName: 'my_location',
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
