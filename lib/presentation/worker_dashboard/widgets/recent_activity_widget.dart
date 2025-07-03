import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentActivityWidget extends StatelessWidget {
  final List<Map<String, dynamic>> activities;

  const RecentActivityWidget({
    Key? key,
    required this.activities,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        SizedBox(height: 2.h),
        activities.isEmpty
            ? _buildEmptyState()
            : Card(
                child: Padding(
                  padding: EdgeInsets.all(2.w),
                  child: Column(
                    children: activities
                        .map((activity) => _buildActivityItem(activity))
                        .toList(),
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: 'history',
              color: AppTheme.textSecondaryLight,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'No recent activity',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Your recent interactions will appear here',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    final String type = activity["type"] as String;
    final String userName = activity["userName"] as String;
    final String message = activity["message"] as String;
    final String timestamp = activity["timestamp"] as String;
    final String status = activity["status"] as String;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: _getActivityBackgroundColor(type),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getActivityBorderColor(type),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: _getActivityIconColor(type).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: _getActivityIcon(type),
              color: _getActivityIconColor(type),
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        userName,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getStatusText(status),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: _getStatusColor(status),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  message,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  timestamp,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getActivityIcon(String type) {
    switch (type) {
      case 'contact_request':
        return 'phone';
      case 'profile_view':
        return 'visibility';
      default:
        return 'notifications';
    }
  }

  Color _getActivityIconColor(String type) {
    switch (type) {
      case 'contact_request':
        return AppTheme.primaryLight;
      case 'profile_view':
        return AppTheme.secondaryLight;
      default:
        return AppTheme.textSecondaryLight;
    }
  }

  Color _getActivityBackgroundColor(String type) {
    switch (type) {
      case 'contact_request':
        return AppTheme.primaryLight.withValues(alpha: 0.05);
      case 'profile_view':
        return AppTheme.secondaryLight.withValues(alpha: 0.05);
      default:
        return AppTheme.lightTheme.colorScheme.surface;
    }
  }

  Color _getActivityBorderColor(String type) {
    switch (type) {
      case 'contact_request':
        return AppTheme.primaryLight.withValues(alpha: 0.2);
      case 'profile_view':
        return AppTheme.secondaryLight.withValues(alpha: 0.2);
      default:
        return AppTheme.borderLight;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return AppTheme.accentLight;
      case 'completed':
        return AppTheme.successLight;
      case 'viewed':
        return AppTheme.primaryLight;
      default:
        return AppTheme.textSecondaryLight;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'completed':
        return 'Completed';
      case 'viewed':
        return 'Viewed';
      default:
        return 'Unknown';
    }
  }
}
