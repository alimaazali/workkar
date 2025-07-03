import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BioSectionWidget extends StatefulWidget {
  final TextEditingController bioController;

  const BioSectionWidget({
    Key? key,
    required this.bioController,
  }) : super(key: key);

  @override
  State<BioSectionWidget> createState() => _BioSectionWidgetState();
}

class _BioSectionWidgetState extends State<BioSectionWidget> {
  static const int maxCharacters = 300;

  int get currentCharacters => widget.bioController.text.length;
  int get remainingCharacters => maxCharacters - currentCharacters;

  @override
  void initState() {
    super.initState();
    widget.bioController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.bioController.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  Color get _counterColor {
    if (remainingCharacters < 20) {
      return AppTheme.lightTheme.colorScheme.error;
    } else if (remainingCharacters < 50) {
      return AppTheme.lightTheme.colorScheme.tertiary;
    }
    return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Professional Bio',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(width: 2.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Optional',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Tell users about your experience and expertise',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),

          // Bio Text Field
          TextFormField(
            controller: widget.bioController,
            maxLines: 5,
            maxLength: maxCharacters,
            decoration: InputDecoration(
              hintText:
                  'Describe your experience, specializations, and what makes you the best choice for customers...',
              counterText: '', // Hide default counter
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.all(4.w),
            ),
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),

          SizedBox(height: 1.h),

          // Character Counter and Tips
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Tip: Mention your years of experience and key skills',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Text(
                '$currentCharacters/$maxCharacters',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: _counterColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          if (currentCharacters > 0) ...[
            SizedBox(height: 2.h),

            // Bio Preview
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'preview',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Preview',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    widget.bioController.text.isNotEmpty
                        ? widget.bioController.text
                        : 'Your bio will appear here...',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontStyle: widget.bioController.text.isEmpty
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
