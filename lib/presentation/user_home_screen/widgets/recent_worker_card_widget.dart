import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentWorkerCardWidget extends StatelessWidget {
  final Map<String, dynamic> worker;
  final VoidCallback onCallTapped;

  const RecentWorkerCardWidget({
    Key? key,
    required this.worker,
    required this.onCallTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String name = worker['name'] ?? '';
    final String service = worker['service'] ?? '';
    final double rating = (worker['rating'] ?? 0.0).toDouble();
    final String distance = worker['distance'] ?? '';
    final String imageUrl = worker['image'] ?? '';
    final String lastContacted = worker['lastContacted'] ?? '';

    return Container(
      width: 45.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Worker Image and Rating
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomImageWidget(
                    imageUrl: imageUrl,
                    width: 12.w,
                    height: 12.w,
                    fit: BoxFit.cover,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'star',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 12,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        rating.toStringAsFixed(1),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),

            // Worker Name
            Text(
              name,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // Service Type
            Text(
              service,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),

            // Distance and Last Contacted
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'location_on',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 12,
                ),
                SizedBox(width: 1.w),
                Text(
                  distance,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),

            Text(
              'Last contacted: $lastContacted',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontSize: 10.sp,
              ),
            ),

            SizedBox(height: 1.h),

            // Call Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onCallTapped,
                icon: CustomIconWidget(
                  iconName: 'phone',
                  color: Colors.white,
                  size: 16,
                ),
                label: const Text('Call'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
