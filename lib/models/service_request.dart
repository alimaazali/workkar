class ServiceRequest {
  final String id;
  final String userId;
  final String workerId;
  final String serviceCategory;
  final String description;
  final double? latitude;
  final double? longitude;
  final String? address;
  final String status;
  final DateTime createdAt;

  ServiceRequest({
    required this.id,
    required this.userId,
    required this.workerId,
    required this.serviceCategory,
    required this.description,
    this.latitude,
    this.longitude,
    this.address,
    required this.status,
    required this.createdAt,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      workerId: json['worker_id'] as String,
      serviceCategory: json['service_category'] as String,
      description: json['description'] as String,
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      address: json['address'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'worker_id': workerId,
      'service_category': serviceCategory,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ServiceRequest copyWith({
    String? id,
    String? userId,
    String? workerId,
    String? serviceCategory,
    String? description,
    double? latitude,
    double? longitude,
    String? address,
    String? status,
    DateTime? createdAt,
  }) {
    return ServiceRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      workerId: workerId ?? this.workerId,
      serviceCategory: serviceCategory ?? this.serviceCategory,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'ServiceRequest(id: $id, serviceCategory: $serviceCategory, status: $status)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceRequest &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
