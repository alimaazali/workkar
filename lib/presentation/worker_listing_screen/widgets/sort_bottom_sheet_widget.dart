import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SortBottomSheetWidget extends StatelessWidget {
  final String selectedSort;
  final Function(String) onSortSelected;

  const SortBottomSheetWidget({
    Key? key,
    required this.selectedSort,
    required this.onSortSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> sortOptions = [
      {
        'title': 'Distance',
        'subtitle': 'Nearest workers first',
        'icon': 'near_me',
      },
      {
        'title': 'Rating',
        'subtitle': 'Highest rated first',
        'icon': 'star',
      },
      {
        'title': 'Availability',
        'subtitle': 'Available workers first',
        'icon': 'schedule',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  'Sort by',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.textSecondaryLight,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),

          // Sort Options
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sortOptions.length,
            itemBuilder: (context, index) {
              final option = sortOptions[index];
              final isSelected = selectedSort == option['title'];

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    onSortSelected(option['title'] as String);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Row(
                      children: [
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryLight.withValues(alpha: 0.1)
                                : AppTheme.borderLight.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: option['icon'] as String,
                              color: isSelected
                                  ? AppTheme.primaryLight
                                  : AppTheme.textSecondaryLight,
                              size: 6.w,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option['title'] as String,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: isSelected
                                      ? AppTheme.primaryLight
                                      : AppTheme.textPrimaryLight,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                option['subtitle'] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.textSecondaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          CustomIconWidget(
                            iconName: 'check_circle',
                            color: AppTheme.primaryLight,
                            size: 6.w,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
