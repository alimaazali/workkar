class Worker {
  final String id;
  final String userId;
  final String serviceCategory;
  final String pincode;
  final double? latitude;
  final double? longitude;
  final String availability;
  final String? bio;
  final double? hourlyRate;
  final int? experienceYears;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  // From joined user_profiles table
  final String? fullName;
  final String? phone;

  Worker({
    required this.id,
    required this.userId,
    required this.serviceCategory,
    required this.pincode,
    this.latitude,
    this.longitude,
    required this.availability,
    this.bio,
    this.hourlyRate,
    this.experienceYears,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.fullName,
    this.phone,
  });

  factory Worker.fromJson(Map<String, dynamic> json) {
    // Handle nested user_profiles data
    final userProfile = json['user_profiles'] as Map<String, dynamic>?;

    return Worker(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      serviceCategory: json['service_category'] as String,
      pincode: json['pincode'] as String,
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      availability: json['availability'] as String,
      bio: json['bio'] as String?,
      hourlyRate: json['hourly_rate'] != null
          ? (json['hourly_rate'] as num).toDouble()
          : null,
      experienceYears: json['experience_years'] as int?,
      profileImageUrl: json['profile_image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      fullName: userProfile?['full_name'] as String?,
      phone: userProfile?['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'service_category': serviceCategory,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'availability': availability,
      'bio': bio,
      'hourly_rate': hourlyRate,
      'experience_years': experienceYears,
      'profile_image_url': profileImageUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Worker copyWith({
    String? id,
    String? userId,
    String? serviceCategory,
    String? pincode,
    double? latitude,
    double? longitude,
    String? availability,
    String? bio,
    double? hourlyRate,
    int? experienceYears,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? fullName,
    String? phone,
  }) {
    return Worker(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      serviceCategory: serviceCategory ?? this.serviceCategory,
      pincode: pincode ?? this.pincode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      availability: availability ?? this.availability,
      bio: bio ?? this.bio,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      experienceYears: experienceYears ?? this.experienceYears,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
    );
  }

  // Get formatted category name
  String get formattedCategory {
    switch (serviceCategory) {
      case 'electrician':
        return 'Electrician';
      case 'plumber':
        return 'Plumber';
      case 'carpenter':
        return 'Carpenter';
      case 'painter':
        return 'Painter';
      case 'mechanic':
        return 'Mechanic';
      case 'cleaner':
        return 'Cleaner';
      case 'gardener':
        return 'Gardener';
      case 'handyman':
        return 'Handyman';
      case 'ac_repair':
        return 'AC Repair';
      case 'appliance_repair':
        return 'Appliance Repair';
      default:
        return serviceCategory;
    }
  }

  // Get formatted availability status
  String get formattedAvailability {
    switch (availability) {
      case 'available':
        return 'Available';
      case 'busy':
        return 'Busy';
      case 'offline':
        return 'Offline';
      default:
        return availability;
    }
  }

  // Check if worker is available
  bool get isAvailable => availability == 'available';

  // Get display name
  String get displayName => fullName ?? 'Worker';

  // Get formatted hourly rate
  String get formattedHourlyRate {
    if (hourlyRate == null) return 'Rate not specified';
    return '₹${hourlyRate!.toStringAsFixed(0)}/hr';
  }

  // Get formatted experience
  String get formattedExperience {
    if (experienceYears == null || experienceYears == 0) {
      return 'New to platform';
    }
    return '${experienceYears!} year${experienceYears! > 1 ? 's' : ''} experience';
  }

  @override
  String toString() {
    return 'Worker(id: $id, fullName: $fullName, serviceCategory: $serviceCategory, availability: $availability)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Worker && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
