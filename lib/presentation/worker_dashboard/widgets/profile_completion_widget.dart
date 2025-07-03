import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileCompletionWidget extends StatelessWidget {
  final int completionPercentage;
  final VoidCallback onEditProfile;

  const ProfileCompletionWidget({
    Key? key,
    required this.completionPercentage,
    required this.onEditProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> actionableItems = [
      {
        "title": "Add profile photo",
        "completed": completionPercentage >= 20,
        "icon": "photo_camera"
      },
      {
        "title": "Complete service details",
        "completed": completionPercentage >= 40,
        "icon": "work"
      },
      {
        "title": "Add work samples",
        "completed": completionPercentage >= 60,
        "icon": "photo_library"
      },
      {
        "title": "Verify phone number",
        "completed": completionPercentage >= 80,
        "icon": "verified"
      },
      {
        "title": "Enable location services",
        "completed": completionPercentage >= 100,
        "icon": "location_on"
      },
    ];

    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profile Completion',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                Text(
                  '$completionPercentage%',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: _getCompletionColor(completionPercentage),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            LinearProgressIndicator(
              value: completionPercentage / 100,
              backgroundColor: AppTheme.borderLight,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getCompletionColor(completionPercentage),
              ),
            ),
            SizedBox(height: 2.h),
            completionPercentage < 100
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Complete these items to improve your profile:',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      ...actionableItems
                          .where((item) => !(item["completed"] as bool))
                          .map(
                            (item) => _buildActionableItem(
                              item["title"] as String,
                              item["icon"] as String,
                              item["completed"] as bool,
                            ),
                          ),
                      SizedBox(height: 2.h),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: onEditProfile,
                          child: const Text('Complete Profile'),
                        ),
                      ),
                    ],
                  )
                : Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.successLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.successLight,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Profile Complete! Great job!',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.successLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionableItem(String title, String iconName, bool completed) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: completed ? 'check_circle' : 'radio_button_unchecked',
            color:
                completed ? AppTheme.successLight : AppTheme.textSecondaryLight,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                decoration: completed ? TextDecoration.lineThrough : null,
                color: completed ? AppTheme.textSecondaryLight : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCompletionColor(int percentage) {
    if (percentage >= 80) return AppTheme.successLight;
    if (percentage >= 50) return AppTheme.accentLight;
    return AppTheme.errorLight;
  }
}
