import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/availability_section_widget.dart';
import './widgets/bio_section_widget.dart';
import './widgets/location_section_widget.dart';
import './widgets/personal_details_section_widget.dart';
import './widgets/profile_photo_section_widget.dart';

class WorkerProfileForm extends StatefulWidget {
  const WorkerProfileForm({Key? key}) : super(key: key);

  @override
  State<WorkerProfileForm> createState() => _WorkerProfileFormState();
}

class _WorkerProfileFormState extends State<WorkerProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _bioController = TextEditingController();

  String? _selectedCategory;
  String? _profileImageUrl;
  bool _isAvailable = true;
  bool _isLoading = false;
  bool _isLocationLoading = false;
  String _phoneNumber = "+91 9876543210"; // Mock phone number from auth
  double? _latitude;
  double? _longitude;

  final List<String> _serviceCategories = [
    'Electrician',
    'Plumber',
    'Carpenter',
    'Painter',
    'AC Technician',
    'Appliance Repair',
    'Cleaning Service',
    'Gardening',
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  void _loadExistingProfile() {
    // Mock existing profile data
    setState(() {
      _nameController.text = "Rajesh Kumar";
      _selectedCategory = "Electrician";
      _pincodeController.text = "110001";
      _bioController.text =
          "Experienced electrician with 10+ years in residential and commercial electrical work.";
      _profileImageUrl =
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face";
      _latitude = 28.6139;
      _longitude = 77.2090;
    });
  }

  bool get _isFormValid {
    return _nameController.text.trim().isNotEmpty &&
        _selectedCategory != null &&
        _pincodeController.text.trim().isNotEmpty &&
        _pincodeController.text.trim().length == 6;
  }

  void _handleImageSelected(String imageUrl) {
    setState(() {
      _profileImageUrl = imageUrl;
    });
  }

  void _handleCategoryChanged(String? category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _handleAvailabilityChanged(bool isAvailable) {
    setState(() {
      _isAvailable = isAvailable;
    });
  }

  void _handleLocationCaptured(double latitude, double longitude) {
    setState(() {
      _latitude = latitude;
      _longitude = longitude;
      _isLocationLoading = false;
    });
  }

  void _handleLocationLoading(bool isLoading) {
    setState(() {
      _isLocationLoading = isLoading;
    });
  }

  Future<void> _saveProfile() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock successful save
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Profile saved successfully!',
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

        // Navigate back to worker dashboard
        Navigator.pushReplacementNamed(context, '/worker-dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to save profile. Please try again.',
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pincodeController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: _handleCancel,
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Text(
          'Profile Setup',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          TextButton(
            onPressed: _handleCancel,
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Photo Section
                    ProfilePhotoSectionWidget(
                      imageUrl: _profileImageUrl,
                      onImageSelected: _handleImageSelected,
                    ),

                    SizedBox(height: 3.h),

                    // Personal Details Section
                    PersonalDetailsSectionWidget(
                      nameController: _nameController,
                      phoneNumber: _phoneNumber,
                      selectedCategory: _selectedCategory,
                      serviceCategories: _serviceCategories,
                      onCategoryChanged: _handleCategoryChanged,
                    ),

                    SizedBox(height: 3.h),

                    // Location Section
                    LocationSectionWidget(
                      pincodeController: _pincodeController,
                      latitude: _latitude,
                      longitude: _longitude,
                      isLocationLoading: _isLocationLoading,
                      onLocationCaptured: _handleLocationCaptured,
                      onLocationLoading: _handleLocationLoading,
                    ),

                    SizedBox(height: 3.h),

                    // Availability Section
                    AvailabilitySectionWidget(
                      isAvailable: _isAvailable,
                      onAvailabilityChanged: _handleAvailabilityChanged,
                    ),

                    SizedBox(height: 3.h),

                    // Bio Section
                    BioSectionWidget(
                      bioController: _bioController,
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),

            // Save Button
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: ElevatedButton(
                onPressed: _isFormValid && !_isLoading ? _saveProfile : null,
                style: AppTheme.lightTheme.elevatedButtonTheme.style?.copyWith(
                  minimumSize:
                      WidgetStateProperty.all(Size(double.infinity, 6.h)),
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.disabled)) {
                      return AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3);
                    }
                    return AppTheme.lightTheme.colorScheme.primary;
                  }),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Text(
                        'Save Profile',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontSize: 16.sp,
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
