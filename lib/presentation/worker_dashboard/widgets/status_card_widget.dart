import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StatusCardWidget extends StatelessWidget {
  final int profileViews;
  final int contactRequests;
  final String activeStatusDuration;
  final double rating;
  final int totalJobs;

  const StatusCardWidget({
    Key? key,
    required this.profileViews,
    required this.contactRequests,
    required this.activeStatusDuration,
    required this.rating,
    required this.totalJobs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Overview',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'Profile Views',
                    profileViews.toString(),
                    'visibility',
                    AppTheme.primaryLight,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    'Contact Requests',
                    contactRequests.toString(),
                    'phone',
                    AppTheme.secondaryLight,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'Active Duration',
                    activeStatusDuration,
                    'schedule',
                    AppTheme.accentLight,
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    'Rating',
                    '$rating ⭐',
                    'star',
                    AppTheme.successLight,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'work',
                    color: AppTheme.primaryLight,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Total Jobs Completed: $totalJobs',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.primaryLight,
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

  Widget _buildMetricItem(
      String label, String value, String iconName, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      margin: EdgeInsets.symmetric(horizontal: 1.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 24,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
