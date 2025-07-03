import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WorkerCardWidget extends StatelessWidget {
  final Map<String, dynamic> worker;
  final VoidCallback onCall;
  final VoidCallback onFavoriteToggle;

  const WorkerCardWidget({
    Key? key,
    required this.worker,
    required this.onCall,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isAvailable = worker['isAvailable'] as bool;
    final bool isFavorite = worker['isFavorite'] as bool;
    final double distance = worker['distance'] as double;
    final double rating = worker['rating'] as double;

    return Dismissible(
      key: Key('worker_${worker['id']}'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.primaryLight,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'favorite',
              color: Colors.white,
              size: 6.w,
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Save',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        onFavoriteToggle();
        return false;
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              // Navigate to worker detail screen if needed
            },
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  // Profile Image with Availability Indicator
                  Stack(
                    children: [
                      Container(
                        width: 15.w,
                        height: 15.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isAvailable
                                ? AppTheme.secondaryLight
                                : AppTheme.borderLight,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: CustomImageWidget(
                            imageUrl: worker['profileImage'] as String,
                            width: 15.w,
                            height: 15.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 4.w,
                          height: 4.w,
                          decoration: BoxDecoration(
                            color: isAvailable
                                ? AppTheme.secondaryLight
                                : AppTheme.textSecondaryLight,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppTheme.surfaceLight, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(width: 4.w),

                  // Worker Information
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                worker['name'] as String,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              onPressed: onFavoriteToggle,
                              icon: CustomIconWidget(
                                iconName:
                                    isFavorite ? 'favorite' : 'favorite_border',
                                color: isFavorite
                                    ? AppTheme.errorLight
                                    : AppTheme.textSecondaryLight,
                                size: 5.w,
                              ),
                              constraints: BoxConstraints(
                                minWidth: 8.w,
                                minHeight: 8.w,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),

                        SizedBox(height: 0.5.h),

                        // Category Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            worker['category'] as String,
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.primaryLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        SizedBox(height: 1.h),

                        // Location and Distance
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'location_on',
                              color: AppTheme.textSecondaryLight,
                              size: 4.w,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              worker['pincode'] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.textSecondaryLight,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            CustomIconWidget(
                              iconName: 'near_me',
                              color: AppTheme.textSecondaryLight,
                              size: 4.w,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              '${distance.toStringAsFixed(1)} km',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 0.5.h),

                        // Rating and Availability
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'star',
                              color: AppTheme.accentLight,
                              size: 4.w,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              rating.toStringAsFixed(1),
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.3.h),
                              decoration: BoxDecoration(
                                color: isAvailable
                                    ? AppTheme.secondaryLight
                                        .withValues(alpha: 0.1)
                                    : AppTheme.textSecondaryLight
                                        .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                isAvailable ? 'Available' : 'Busy',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: isAvailable
                                      ? AppTheme.secondaryLight
                                      : AppTheme.textSecondaryLight,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 3.w),

                  // Call Button
                  ElevatedButton(
                    onPressed: onCall,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryLight,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 4.w, vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'call',
                          color: Colors.white,
                          size: 4.w,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Call',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
