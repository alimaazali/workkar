import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onUpdateLocation;
  final VoidCallback onManageAvailability;
  final VoidCallback onViewAnalytics;

  const QuickActionsWidget({
    Key? key,
    required this.onEditProfile,
    required this.onUpdateLocation,
    required this.onManageAvailability,
    required this.onViewAnalytics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'Edit Profile',
                'edit',
                AppTheme.primaryLight,
                onEditProfile,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildActionButton(
                'Update Location',
                'location_on',
                AppTheme.secondaryLight,
                onUpdateLocation,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'Manage Availability',
                'toggle_on',
                AppTheme.accentLight,
                onManageAvailability,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildActionButton(
                'View Analytics',
                'analytics',
                AppTheme.successLight,
                onViewAnalytics,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
      String title, String iconName, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: color,
                  size: 28,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
