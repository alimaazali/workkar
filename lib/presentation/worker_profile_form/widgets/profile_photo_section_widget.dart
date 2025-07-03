import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfilePhotoSectionWidget extends StatelessWidget {
  final String? imageUrl;
  final Function(String) onImageSelected;

  const ProfilePhotoSectionWidget({
    Key? key,
    this.imageUrl,
    required this.onImageSelected,
  }) : super(key: key);

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Select Profile Photo',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPickerOption(
                  context,
                  icon: 'camera_alt',
                  label: 'Camera',
                  onTap: () => _handleCameraSelection(context),
                ),
                _buildPickerOption(
                  context,
                  icon: 'photo_library',
                  label: 'Gallery',
                  onTap: () => _handleGallerySelection(context),
                ),
              ],
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerOption(
    BuildContext context, {
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 25.w,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 32,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCameraSelection(BuildContext context) {
    Navigator.pop(context);
    // Mock camera capture - in real app, use image_picker package
    const mockCameraImage =
        "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop&crop=face";
    onImageSelected(mockCameraImage);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Photo captured successfully!',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _handleGallerySelection(BuildContext context) {
    Navigator.pop(context);
    // Mock gallery selection - in real app, use image_picker package
    const mockGalleryImage =
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face";
    onImageSelected(mockGalleryImage);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Photo selected from gallery!',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
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
        children: [
          Text(
            'Profile Photo',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),
          GestureDetector(
            onTap: () => _showImagePickerOptions(context),
            child: Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: imageUrl != null
                    ? CustomImageWidget(
                        imageUrl: imageUrl!,
                        width: 30.w,
                        height: 30.w,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'add_a_photo',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 32,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Add Photo',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Tap to change photo',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
