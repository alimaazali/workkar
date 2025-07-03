import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const FilterChipWidget({
    Key? key,
    required this.label,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 2.w, top: 1.h, bottom: 1.h),
      child: Chip(
        label: Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: AppTheme.primaryLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        deleteIcon: CustomIconWidget(
          iconName: 'close',
          color: AppTheme.primaryLight,
          size: 4.w,
        ),
        onDeleted: onRemove,
        backgroundColor: AppTheme.primaryLight.withValues(alpha: 0.1),
        side: BorderSide(
          color: AppTheme.primaryLight.withValues(alpha: 0.3),
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        deleteIconColor: AppTheme.primaryLight,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
