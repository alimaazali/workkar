
class ServiceCategories {
  static const Map<String, String> categories = {
    'electrician': 'Electrician',
    'plumber': 'Plumber',
    'carpenter': 'Carpenter',
    'painter': 'Painter',
    'mechanic': 'Mechanic',
    'cleaner': 'Cleaner',
    'gardener': 'Gardener',
    'handyman': 'Handyman',
    'ac_repair': 'AC Repair',
    'appliance_repair': 'Appliance Repair',
  };

  static const Map<String, String> categoryIcons = {
    'electrician': '⚡',
    'plumber': '🔧',
    'carpenter': '🪚',
    'painter': '🎨',
    'mechanic': '🔩',
    'cleaner': '🧹',
    'gardener': '🌱',
    'handyman': '🛠️',
    'ac_repair': '❄️',
    'appliance_repair': '📱',
  };

  static List<String> get categoryKeys => categories.keys.toList();
  static List<String> get categoryValues => categories.values.toList();

  static String getDisplayName(String key) => categories[key] ?? key;
  static String getIcon(String key) => categoryIcons[key] ?? '🔧';
}

class AvailabilityStatus {
  static const String available = 'available';
  static const String busy = 'busy';
  static const String offline = 'offline';

  static const Map<String, String> statusLabels = {
    available: 'Available',
    busy: 'Busy',
    offline: 'Offline',
  };

  static const Map<String, String> statusColors = {
    available: '#34D399', // Green
    busy: '#FACC15', // Amber
    offline: '#9CA3AF', // Gray
  };

  static String getLabel(String status) => statusLabels[status] ?? status;
  static String getColor(String status) => statusColors[status] ?? '#9CA3AF';
}

class UserRoles {
  static const String user = 'user';
  static const String worker = 'worker';

  static const Map<String, String> roleLabels = {
    user: 'Service User',
    worker: 'Service Provider',
  };

  static String getLabel(String role) => roleLabels[role] ?? role;
}

class AppStrings {
  // App Info
  static const String appName = 'WorkKar';
  static const String appTagline = 'Your Local Service Marketplace';

  // Authentication
  static const String phoneNumberHint = 'Enter your phone number';
  static const String otpHint = 'Enter OTP';
  static const String sendOtp = 'Send OTP';
  static const String verifyOtp = 'Verify OTP';
  static const String resendOtp = 'Resend OTP';

  // Role Selection
  static const String selectRole = 'I am a...';
  static const String userRoleTitle = 'Service User';
  static const String userRoleSubtitle = 'Looking for services';
  static const String workerRoleTitle = 'Service Provider';
  static const String workerRoleSubtitle = 'Offering services';

  // Common
  static const String loading = 'Loading...';
  static const String error = 'Something went wrong';
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String update = 'Update';
  static const String delete = 'Delete';
  static const String confirm = 'Confirm';

  // Location
  static const String locationPermissionTitle = 'Location Permission Required';
  static const String locationPermissionMessage =
      'We need location access to show nearby workers';
  static const String enableLocation = 'Enable Location';
  static const String enterPincode = 'Enter Pincode';

  // Search
  static const String searchHint = 'Search by area or pincode';
  static const String noResultsFound = 'No results found';
  static const String nearbyWorkers = 'Nearby Workers';

  // Worker Profile
  static const String completeProfile = 'Complete Your Profile';
  static const String profileUpdated = 'Profile updated successfully';
  static const String availabilityUpdated = 'Availability updated';
}

class AppValues {
  // Measurements
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;

  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Limits
  static const int defaultPageSize = 20;
  static const int maxSearchResults = 50;
  static const double maxImageSizeMB = 5.0;
  static const int maxBioLength = 500;
  static const int otpLength = 6;

  // Distances
  static const double defaultSearchRadius = 10.0; // kilometers
  static const double maxSearchRadius = 50.0; // kilometers
}
