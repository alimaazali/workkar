import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/profile_completion_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/recent_activity_widget.dart';
import './widgets/status_card_widget.dart';

class WorkerDashboard extends StatefulWidget {
  const WorkerDashboard({Key? key}) : super(key: key);

  @override
  State<WorkerDashboard> createState() => _WorkerDashboardState();
}

class _WorkerDashboardState extends State<WorkerDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isAvailable = true;
  bool _isLoading = false;

  // Mock worker data
  final Map<String, dynamic> workerData = {
    "id": 1,
    "name": "Rajesh Kumar",
    "profilePhoto":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
    "serviceCategory": "Electrician",
    "phone": "+91 9876543210",
    "pincode": "110001",
    "isAvailable": true,
    "profileViews": 45,
    "contactRequests": 12,
    "activeStatusDuration": "2 hours",
    "profileCompletion": 85,
    "rating": 4.5,
    "totalJobs": 127
  };

  final List<Map<String, dynamic>> recentActivities = [
    {
      "id": 1,
      "type": "contact_request",
      "userName": "Priya Sharma",
      "message": "Requested contact for electrical work",
      "timestamp": "2 hours ago",
      "status": "pending"
    },
    {
      "id": 2,
      "type": "profile_view",
      "userName": "Amit Singh",
      "message": "Viewed your profile",
      "timestamp": "4 hours ago",
      "status": "viewed"
    },
    {
      "id": 3,
      "type": "contact_request",
      "userName": "Sunita Devi",
      "message": "Called for home wiring work",
      "timestamp": "1 day ago",
      "status": "completed"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _isAvailable = workerData["isAvailable"] as bool;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  void _toggleAvailability(bool value) async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call to update availability
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _isAvailable = value;
      workerData["isAvailable"] = value;
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value ? 'You are now available for work' : 'You are now unavailable',
        ),
        backgroundColor: value ? AppTheme.successLight : AppTheme.errorLight,
      ),
    );
  }

  void _navigateToProfile() {
    Navigator.pushNamed(context, '/worker-profile-form');
  }

  void _updateLocation() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate location update
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location updated successfully'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDashboardTab(),
                  _buildProfileTab(),
                  _buildSettingsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomTabBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    _isAvailable ? AppTheme.successLight : AppTheme.errorLight,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: CustomImageWidget(
                imageUrl: workerData["profilePhoto"] as String,
                width: 15.w,
                height: 15.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workerData["name"] as String,
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  workerData["serviceCategory"] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Container(
                      width: 2.w,
                      height: 2.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isAvailable
                            ? AppTheme.successLight
                            : AppTheme.errorLight,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      _isAvailable ? 'Available' : 'Unavailable',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: _isAvailable
                            ? AppTheme.successLight
                            : AppTheme.errorLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Switch(
            value: _isAvailable,
            onChanged: _isLoading ? null : _toggleAvailability,
            activeColor: AppTheme.successLight,
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusCardWidget(
              profileViews: workerData["profileViews"] as int,
              contactRequests: workerData["contactRequests"] as int,
              activeStatusDuration:
                  workerData["activeStatusDuration"] as String,
              rating: workerData["rating"] as double,
              totalJobs: workerData["totalJobs"] as int,
            ),
            SizedBox(height: 4.h),
            QuickActionsWidget(
              onEditProfile: _navigateToProfile,
              onUpdateLocation: _updateLocation,
              onManageAvailability: () => _toggleAvailability(!_isAvailable),
              onViewAnalytics: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Analytics feature coming soon')),
                );
              },
            ),
            SizedBox(height: 4.h),
            ProfileCompletionWidget(
              completionPercentage: workerData["profileCompletion"] as int,
              onEditProfile: _navigateToProfile,
            ),
            SizedBox(height: 4.h),
            RecentActivityWidget(activities: recentActivities),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile Information',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 2.h),
          Card(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  _buildProfileInfoRow('Name', workerData["name"] as String),
                  _buildProfileInfoRow(
                      'Service', workerData["serviceCategory"] as String),
                  _buildProfileInfoRow('Phone', workerData["phone"] as String),
                  _buildProfileInfoRow(
                      'Pincode', workerData["pincode"] as String),
                  _buildProfileInfoRow('Rating', '${workerData["rating"]} ⭐'),
                  _buildProfileInfoRow(
                      'Total Jobs', '${workerData["totalJobs"]}'),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _navigateToProfile,
              child: const Text('Edit Profile'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25.w,
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 2.h),
          Card(
            child: Column(
              children: [
                _buildSettingsItem(
                  'Notification Preferences',
                  'notifications',
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Notification settings coming soon')),
                    );
                  },
                ),
                _buildSettingsItem(
                  'Privacy Controls',
                  'privacy_tip',
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Privacy settings coming soon')),
                    );
                  },
                ),
                _buildSettingsItem(
                  'Account Management',
                  'manage_accounts',
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Account management coming soon')),
                    );
                  },
                ),
                _buildSettingsItem(
                  'Help & Support',
                  'help',
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Help & support coming soon')),
                    );
                  },
                ),
                _buildSettingsItem(
                  'Logout',
                  'logout',
                  () {
                    _showLogoutDialog();
                  },
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(String title, String iconName, VoidCallback onTap,
      {bool isDestructive = false}) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color:
            isDestructive ? AppTheme.errorLight : AppTheme.textSecondaryLight,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          color: isDestructive ? AppTheme.errorLight : null,
        ),
      ),
      trailing: CustomIconWidget(
        iconName: 'chevron_right',
        color: AppTheme.textSecondaryLight,
        size: 20,
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/splash-screen',
                  (route) => false,
                );
              },
              child: Text(
                'Logout',
                style: TextStyle(color: AppTheme.errorLight),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _tabController.index == 0
                  ? AppTheme.primaryLight
                  : AppTheme.textSecondaryLight,
              size: 24,
            ),
            text: 'Dashboard',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _tabController.index == 1
                  ? AppTheme.primaryLight
                  : AppTheme.textSecondaryLight,
              size: 24,
            ),
            text: 'Profile',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'settings',
              color: _tabController.index == 2
                  ? AppTheme.primaryLight
                  : AppTheme.textSecondaryLight,
              size: 24,
            ),
            text: 'Settings',
          ),
        ],
      ),
    );
  }
}
