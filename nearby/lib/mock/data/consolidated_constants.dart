/// Consolidated constants for mock data generation
class ConsolidatedConstants {
  // Private constructor to prevent instantiation
  ConsolidatedConstants._();

  // ==========================================
  // STORAGE KEYS
  // ==========================================
  static const String usersKey = 'mock_users';
  static const String groupsKey = 'mock_groups';
  static const String firstLaunchKey = 'first_launch';

  // ==========================================
  // USER DISTRIBUTION PERCENTAGES
  // ==========================================
  static const int normalUserPercentage = 60;
  static const int premiumUserPercentage = 25;
  static const int creatorUserPercentage = 10;
  static const int adminUserPercentage = 5;

  // ==========================================
  // USER GENERATION RANGES
  // ==========================================
  static const int minUserAge = 18;
  static const int maxUserAge = 65;
  static const int minPoints = 50;
  static const int maxPoints = 2000;
  static const int premiumMinPoints = 500;
  static const int premiumMaxPoints = 5000;

  // ==========================================
  // GROUP GENERATION RANGES
  // ==========================================
  static const int minGroupMembers = 1;
  static const int maxGroupMembers = 20;
  static const int defaultMaxGroupMembers = 10;
  static const int minGroupPot = 500;
  static const int maxGroupPot = 2000;
  static const int minJoinCost = 50;
  static const int maxJoinCost = 200;
  static const int pointsPerMember = 100;

  // ==========================================
  // LOCATION DATA
  // ==========================================
  static const double baseLatitude = 37.7749;  // San Francisco
  static const double baseLongitude = -122.4194;
  static const double coordinateVariance = 0.05;
  static const double minDistance = 0.5;
  static const double maxDistance = 50.0;

  // San Francisco neighborhoods
  static const List<LocationInfo> sanFranciscoNeighborhoods = [
    LocationInfo('Mission District', 'San Francisco'),
    LocationInfo('SOMA', 'San Francisco'),
    LocationInfo('North Beach', 'San Francisco'),
    LocationInfo('Chinatown', 'San Francisco'),
    LocationInfo('Marina District', 'San Francisco'),
    LocationInfo('Hayes Valley', 'San Francisco'),
    LocationInfo('Castro', 'San Francisco'),
    LocationInfo('Haight-Ashbury', 'San Francisco'),
    LocationInfo('Pacific Heights', 'San Francisco'),
    LocationInfo('Financial District', 'San Francisco'),
    LocationInfo('Union Square', 'San Francisco'),
    LocationInfo('Nob Hill', 'San Francisco'),
    LocationInfo('Russian Hill', 'San Francisco'),
    LocationInfo('Telegraph Hill', 'San Francisco'),
    LocationInfo('Sunset District', 'San Francisco'),
    LocationInfo('Richmond District', 'San Francisco'),
    LocationInfo('Bernal Heights', 'San Francisco'),
    LocationInfo('Potrero Hill', 'San Francisco'),
    LocationInfo('Noe Valley', 'San Francisco'),
    LocationInfo('West Portal', 'San Francisco'),
  ];

  // ==========================================
  // PROBABILITY CONSTANTS
  // ==========================================

  // Verification rates
  static const double normalUserVerificationRate = 0.3;
  static const double premiumUserVerificationRate = 0.8;
  static const double creatorUserVerificationRate = 1.0;
  static const double adminUserVerificationRate = 1.0;

  // Premium user probabilities
  static const double premiumUserRate = 0.25;

  // Profile completion weights
  static const Map<String, double> profileCompletionWeights = {
    'work': 0.7,        // 70% of users have work filled
    'education': 0.6,   // 60% have education filled
    'drinkingHabits': 0.8, // 80% have drinking habits filled
    'mealInterest': 0.9,   // 90% have meal interest filled
    'starSign': 0.4,     // 40% have star sign filled
    'languages': 0.85,   // 85% have languages filled
  };

  // ==========================================
  // GROUP AVAILABILITY DISTRIBUTION
  // ==========================================
  static const int goodAvailabilityGroups = 4;    // First 4 groups: 50%+ available
  static const int limitedAvailabilityGroups = 4;  // Next 4 groups: below 50% available
  static const int fullCapacityGroups = 3;         // Next 3 groups: 0% available

  // ==========================================
  // INTERESTS AND PROFILE RANGES
  // ==========================================
  static const int minWaitingListSize = 1;
  static const int maxWaitingListSize = 3;
  static const int minInterestsPerUser = 3;
  static const int maxInterestsPerUser = 8;
  static const int minInterestsPerGroup = 1;
  static const int maxInterestsPerGroup = 5;
  static const int minBioLength = 20;
  static const int maxBioLength = 100;
  static const int minInterestsCount = 3;
  static const int maxInterestsCount = 6;
  static const int minLanguagesCount = 1;
  static const int maxLanguagesCount = 4;

  // ==========================================
  // ID FORMATS
  // ==========================================
  static const String normalUserIdPrefix = 'normal_user';
  static const String premiumUserIdPrefix = 'premium_user';
  static const String creatorUserIdPrefix = 'creator_user';
  static const String adminUserIdPrefix = 'admin_user';
  static const String genericUserIdPrefix = 'user';
  static const String groupIdPrefix = 'group';

  // ==========================================
  // DEFAULT VALUES
  // ==========================================
  static const String defaultBio = '';
  static const String defaultImageUrl = '';
  static const String defaultUserType = 'normal';
  static const String defaultGender = 'Female';
  static const bool defaultIsAvailable = true;
  static const bool defaultIsPremium = false;
  static const int defaultPoints = 100;
  static const bool defaultIsVerified = false;
  static const List<String> defaultInterests = [];
  static const List<String> defaultIntents = [];
  static const List<String> defaultLanguages = [];

  // ==========================================
  // USER TYPE OPTIONS
  // ==========================================
  static const List<String> userTypeOptions = [
    'normal',
    'premium',
    'creator',
    'admin'
  ];

  static const List<String> subscriptionLevels = [
    'basic',
    'premium',
    'vip',
    'platinum'
  ];

  static const List<String> genderOptions = [
    'Male',
    'Female',
    'LGBTQ+'
  ];

  static const List<String> intentOptions = [
    'dining',
    'friendship',
    'networking',
    'romantic',
    'casual',
    'professional'
  ];

  // ==========================================
  // GROUP CONFIGURATION
  // ==========================================
  static const Map<String, String> groupSizeDescriptions = {
    '2-4': 'Intimate gathering',
    '5-7': 'Small group',
    '8-12': 'Medium group',
    '13-20': 'Large group',
  };

  static const Map<String, String> priceRanges = {
    '\$': 'Budget friendly',
    '\$\$': 'Moderate pricing',
    '\$\$\$': 'Upscale dining',
    '\$\$\$\$': 'Fine dining',
  };

  static const List<String> atmosphereTypes = [
    'Casual and relaxed',
    'Energetic and lively',
    'Quiet and intimate',
    'Social and conversational',
    'Adventure seeking',
    'Romantic',
    'Professional networking',
    'Family friendly',
    'Trendy and modern',
    'Traditional and classic'
  ];

  static const List<String> dietaryAccommodations = [
    'Vegetarian friendly',
    'Vegan options',
    'Gluten-free options',
    'Halal certified',
    'Kosher options',
    'Nut-free environment',
    'Dairy-free alternatives',
    'Low-carb options',
    'Keto-friendly',
    'Paleo options'
  ];

  static const List<String> specialFeatures = [
    'Live music',
    'Outdoor seating',
    'Parking available',
    'Pet-friendly patio',
    'Private dining room',
    'Full bar service',
    'Valet parking',
    'WiFi available',
    'Reservations recommended',
    'Walk-ins welcome',
    'Late night menu',
    'Happy hour specials',
    'Group discounts',
    'Chef\'s table available',
    'Wine pairing available',
    'Cooking classes',
    'Private events',
    'Catering available',
    'Takeout available',
    'Delivery available'
  ];

  // ==========================================
  // UTILITY METHODS
  // ==========================================

  /// Generate a random coordinate within San Francisco area
  static Coordinates generateRandomLocation() {
    final random = DateTime.now().millisecondsSinceEpoch;
    final latVariation = (random % 1000 - 500) / 10000.0 * coordinateVariance;
    final lngVariation = (random % 1000 - 500) / 10000.0 * coordinateVariance;

    return Coordinates(
      baseLatitude + latVariation,
      baseLongitude + lngVariation,
    );
  }

  /// Get a random neighborhood
  static LocationInfo getRandomNeighborhood() {
    final random = DateTime.now().millisecondsSinceEpoch;
    final index = random % sanFranciscoNeighborhoods.length;
    return sanFranciscoNeighborhoods[index];
  }

  /// Get profile completion status based on weights
  static bool shouldFillProfileField(String fieldName) {
    final weight = profileCompletionWeights[fieldName];
    if (weight == null) return false;

    final random = DateTime.now().millisecondsSinceEpoch % 100;
    return (random / 100.0) < weight;
  }

  /// Get random user type based on distribution
  static String getRandomUserType() {
    final random = DateTime.now().millisecondsSinceEpoch % 100;

    if (random < normalUserPercentage) return 'normal';
    if (random < normalUserPercentage + premiumUserPercentage) return 'premium';
    if (random < normalUserPercentage + premiumUserPercentage + creatorUserPercentage) return 'creator';
    return 'admin';
  }
}

/// Supporting data classes
class LocationInfo {
  final String neighborhood;
  final String city;

  const LocationInfo(this.neighborhood, this.city);

  String get fullName => '$neighborhood, $city';
}

class Coordinates {
  final double latitude;
  final double longitude;

  const Coordinates(this.latitude, this.longitude);

  @override
  String toString() => '($latitude, $longitude)';
}