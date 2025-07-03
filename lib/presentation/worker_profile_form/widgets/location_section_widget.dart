import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationSectionWidget extends StatelessWidget {
  final TextEditingController pincodeController;
  final double? latitude;
  final double? longitude;
  final bool isLocationLoading;
  final Function(double, double) onLocationCaptured;
  final Function(bool) onLocationLoading;

  const LocationSectionWidget({
    Key? key,
    required this.pincodeController,
    this.latitude,
    this.longitude,
    required this.isLocationLoading,
    required this.onLocationCaptured,
    required this.onLocationLoading,
  }) : super(key: key);

  Future<void> _captureCurrentLocation(BuildContext context) async {
    onLocationLoading(true);

    try {
      // Simulate location capture delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock location coordinates (Delhi, India)
      const mockLatitude = 28.6139;
      const mockLongitude = 77.2090;

      // Mock pincode based on location
      pincodeController.text = "110001";

      onLocationCaptured(mockLatitude, mockLongitude);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Location captured successfully!',
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
    } catch (e) {
      onLocationLoading(false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to capture location. Please enter pincode manually.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  String get _locationAccuracy {
    if (latitude != null && longitude != null) {
      return "High accuracy (±5m)";
    }
    return "Location not captured";
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
          Text(
            'Location Details',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 3.h),

          // Pincode Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pincode *',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 1.h),
              TextFormField(
                controller: pincodeController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                decoration: InputDecoration(
                  hintText: 'Enter 6-digit pincode',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'location_on',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Pincode is required';
                  }
                  if (value.trim().length != 6) {
                    return 'Pincode must be 6 digits';
                  }
                  return null;
                },
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Current Location Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: isLocationLoading
                  ? null
                  : () => _captureCurrentLocation(context),
              icon: isLocationLoading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    )
                  : CustomIconWidget(
                      iconName: 'my_location',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
              label: Text(
                isLocationLoading
                    ? 'Capturing Location...'
                    : 'Use Current Location',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              style: AppTheme.lightTheme.outlinedButtonTheme.style?.copyWith(
                minimumSize:
                    WidgetStateProperty.all(Size(double.infinity, 6.h)),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Location Status
          if (latitude != null && longitude != null) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Location Captured',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Coordinates: ${latitude!.toStringAsFixed(4)}, ${longitude!.toStringAsFixed(4)}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    'Accuracy: $_locationAccuracy',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Capture location for better service matching',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
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
