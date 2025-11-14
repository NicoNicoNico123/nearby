/// Centralized constants for mock data generation
class MockConstants {
  // Private constructor to prevent instantiation
  MockConstants._();

  // Storage keys
  static const String usersKey = 'mock_users';
  static const String groupsKey = 'mock_groups';
  static const String firstLaunchKey = 'first_launch';

  // User distribution percentages
  static const int normalUserPercentage = 60;
  static const int premiumUserPercentage = 25;
  static const int creatorUserPercentage = 10;
  static const int adminUserPercentage = 5;

  // User generation ranges
  static const int minUserAge = 18;
  static const int maxUserAge = 65;
  static const int minPoints = 50;
  static const int maxPoints = 2000;
  static const int premiumMinPoints = 500;
  static const int premiumMaxPoints = 5000;

  // Group generation ranges
  static const int minGroupMembers = 1;
  static const int maxGroupMembers = 20;
  static const int defaultMaxGroupMembers = 10;
  static const int minGroupPot = 500;
  static const int maxGroupPot = 2000;
  static const int minJoinCost = 50;
  static const int maxJoinCost = 200;
  static const int pointsPerMember = 100;

  // Location bounds (San Francisco area)
  static const double baseLatitude = 37.7749;
  static const double baseLongitude = -122.4194;
  static const double coordinateVariance = 0.05;

  // Distance ranges (in miles)
  static const double minDistance = 0.5;
  static const double maxDistance = 50.0;

  // Verification probabilities
  static const double normalUserVerificationRate = 0.3;
  static const double premiumUserVerificationRate = 0.8;
  static const double creatorUserVerificationRate = 1.0;
  static const double adminUserVerificationRate = 1.0;

  // Premium user probabilities
  static const double premiumUserRate = 0.25;

  // Group availability distribution
  static const int goodAvailabilityGroups = 4;    // First 4 groups: 50%+ available
  static const int limitedAvailabilityGroups = 4;  // Next 4 groups: below 50% available
  static const int fullCapacityGroups = 3;         // Next 3 groups: 0% available

  // Waiting list
  static const int minWaitingListSize = 1;
  static const int maxWaitingListSize = 3;

  // Interests per user
  static const int minInterestsPerUser = 3;
  static const int maxInterestsPerUser = 8;

  // Interests per group
  static const int minInterestsPerGroup = 1;
  static const int maxInterestsPerGroup = 5;

  // Mock user ID formats
  static const String normalUserIdPrefix = 'normal_user';
  static const String premiumUserIdPrefix = 'premium_user';
  static const String creatorUserIdPrefix = 'creator_user';
  static const String adminUserIdPrefix = 'admin_user';
  static const String genericUserIdPrefix = 'user';

  // Group ID format
  static const String groupIdPrefix = 'group';

  // Default values
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

  // Profile data ranges
  static const int minBioLength = 20;
  static const int maxBioLength = 100;
  static const int minInterestsCount = 3;
  static const int maxInterestsCount = 6;
  static const int minLanguagesCount = 1;
  static const int maxLanguagesCount = 4;
}