import '../generators/base_generator.dart';
import '../data/mock_constants.dart';
import '../data/mock_user_data.dart';
import '../../../models/user_model.dart';

/// User generator class for creating realistic mock users
class UserGenerator extends BaseGenerator {
  UserGenerator({super.random});

  /// Generate a normal user
  User generateNormalUser(int index) {
    final name = MockUserData.normalUserNames[index % MockUserData.normalUserNames.length];
    final bio = randomItem(MockUserData.normalBios);
    final interests = generateInterests(MockUserData.interestCategories.values.expand((i) => i).toList());
    final intents = generateIntents(MockUserData.intentOptions);
    final languages = generateLanguages(MockUserData.languageOptions);

    return _createUser(
      id: '${MockConstants.normalUserIdPrefix}_$index',
      name: name,
      bio: bio,
      interests: interests,
      intents: intents,
      languages: languages,
      userType: MockConstants.defaultUserType,
      isPremium: false,
      isVerified: randomBool(MockConstants.normalUserVerificationRate),
      points: randomPoints(isPremium: false),
      work: shouldInclude(0.7) ? randomItem(MockUserData.workOptions) : null,
      education: shouldInclude(0.6) ? randomItem(MockUserData.educationOptions) : null,
      drinkingHabits: shouldInclude(0.8) ? randomItem(MockUserData.drinkingHabitsOptions) : null,
      mealInterest: shouldInclude(0.9) ? randomItem(MockUserData.mealInterestOptions) : null,
      starSign: shouldInclude(0.4) ? randomItem(MockUserData.starSignOptions) : null,
    );
  }

  /// Generate a premium user
  User generatePremiumUser(int index) {
    final name = MockUserData.premiumUserNames[index % MockUserData.premiumUserNames.length];
    final bio = randomItem(MockUserData.premiumBios);
    final interests = generateInterests(MockUserData.interestCategories.values.expand((i) => i).toList());
    final intents = generateIntents(MockUserData.intentOptions);
    final languages = generateLanguages(MockUserData.languageOptions);

    return _createUser(
      id: '${MockConstants.premiumUserIdPrefix}_$index',
      name: name,
      bio: bio,
      interests: interests,
      intents: intents,
      languages: languages,
      userType: 'premium',
      isPremium: true,
      isVerified: randomBool(MockConstants.premiumUserVerificationRate),
      points: randomPoints(isPremium: true),
      subscriptionLevel: randomItem(['premium', 'vip']),
      work: shouldInclude(0.9) ? randomItem(MockUserData.workOptions) : null,
      education: shouldInclude(0.8) ? randomItem(MockUserData.educationOptions) : null,
      drinkingHabits: shouldInclude(0.9) ? randomItem(MockUserData.drinkingHabitsOptions) : null,
      mealInterest: shouldInclude(0.95) ? randomItem(MockUserData.mealInterestOptions) : null,
      starSign: shouldInclude(0.6) ? randomItem(MockUserData.starSignOptions) : null,
    );
  }

  /// Generate a creator user
  User generateCreatorUser(int index) {
    final name = MockUserData.creatorUserNames[index % MockUserData.creatorUserNames.length];
    final bio = randomItem(MockUserData.creatorBios);
    final interests = generateInterests(MockUserData.interestCategories.values.expand((i) => i).toList());
    final intents = generateIntents(MockUserData.intentOptions);
    final languages = generateLanguages(MockUserData.languageOptions);

    return _createUser(
      id: '${MockConstants.creatorUserIdPrefix}_$index',
      name: name,
      bio: bio,
      interests: interests,
      intents: intents,
      languages: languages,
      userType: 'creator',
      isPremium: shouldInclude(0.7), // Creators often have premium features
      isVerified: randomBool(MockConstants.creatorUserVerificationRate),
      points: randomInt(MockConstants.premiumMinPoints, MockConstants.premiumMaxPoints),
      subscriptionLevel: shouldInclude(0.6) ? randomItem(['premium', 'vip']) : null,
      work: shouldInclude(0.95) ? randomItem(MockUserData.workOptions) : null,
      education: shouldInclude(0.85) ? randomItem(MockUserData.educationOptions) : null,
      drinkingHabits: shouldInclude(0.9) ? randomItem(MockUserData.drinkingHabitsOptions) : null,
      mealInterest: shouldInclude(0.98) ? randomItem(MockUserData.mealInterestOptions) : null,
      starSign: shouldInclude(0.5) ? randomItem(MockUserData.starSignOptions) : null,
    );
  }

  /// Generate an admin user
  User generateAdminUser(int index) {
    final name = MockUserData.adminUserNames[index % MockUserData.adminUserNames.length];
    final bio = randomItem(MockUserData.adminBios);
    final interests = generateInterests(MockUserData.interestCategories.values.expand((i) => i).toList());
    final intents = generateIntents(MockUserData.intentOptions);
    final languages = generateLanguages(MockUserData.languageOptions);

    return _createUser(
      id: '${MockConstants.adminUserIdPrefix}_$index',
      name: name,
      bio: bio,
      interests: interests,
      intents: intents,
      languages: languages,
      userType: 'admin',
      isPremium: true,
      isVerified: randomBool(MockConstants.adminUserVerificationRate),
      points: randomInt(MockConstants.premiumMinPoints, MockConstants.premiumMaxPoints),
      subscriptionLevel: 'platinum',
      work: 'System Administrator',
      education: randomItem(MockUserData.educationOptions),
      drinkingHabits: shouldInclude(0.7) ? randomItem(MockUserData.drinkingHabitsOptions) : null,
      mealInterest: shouldInclude(0.8) ? randomItem(MockUserData.mealInterestOptions) : null,
      starSign: shouldInclude(0.3) ? randomItem(MockUserData.starSignOptions) : null,
    );
  }

  /// Generate a generic user (for consistent ID format)
  User generateGenericUser(String id, String? name) {
    final userName = name ?? 'User $id';
    final bio = generateBio();
    final interests = generateInterests(MockUserData.interestCategories.values.expand((i) => i).toList());
    final intents = generateIntents(MockUserData.intentOptions);
    final languages = generateLanguages(MockUserData.languageOptions);

    return _createUser(
      id: id,
      name: userName,
      bio: bio,
      interests: interests,
      intents: intents,
      languages: languages,
      userType: MockConstants.defaultUserType,
      isPremium: randomBool(MockConstants.premiumUserRate),
      isVerified: randomBool(0.5),
      points: randomPoints(),
    );
  }

  /// Generate the current user (for app usage)
  User generateCurrentUser() {
    return const User(
      id: 'current_user',
      name: 'Alexandra Davis',
      username: 'alexandra_d',
      age: 28,
      bio: 'Lover of coffee and minimalist design. Exploring the world one city at a time.',
      imageUrl: 'https://picsum.photos/200/200?random=current',
      interests: ['#Design', '#Travel', '#Photography', '#Coffee', '#Minimalism'],
      isAvailable: true,
      userType: 'premium',
      isPremium: true,
      subscriptionLevel: 'premium',
      points: 750,
      isVerified: true,
      gender: 'Female',
      languages: ['English', 'Spanish'],
      intents: ['dining', 'friendship'],
    );
  }

  /// Generate a batch of users
  List<User> generateUserBatch({
    required int normalCount,
    required int premiumCount,
    required int creatorCount,
    required int adminCount,
  }) {
    final users = <User>[];

    // Generate normal users
    for (int i = 0; i < normalCount; i++) {
      users.add(generateNormalUser(i));
    }

    // Generate premium users
    for (int i = 0; i < premiumCount; i++) {
      users.add(generatePremiumUser(i));
    }

    // Generate creator users
    for (int i = 0; i < creatorCount; i++) {
      users.add(generateCreatorUser(i));
    }

    // Generate admin users
    for (int i = 0; i < adminCount; i++) {
      users.add(generateAdminUser(i));
    }

    logGeneration('Generated ${users.length} users ($normalCount normal, $premiumCount premium, $creatorCount creators, $adminCount admins)');
    return users;
  }

  /// Create a user with the specified parameters
  User _createUser({
    required String id,
    required String name,
    required String bio,
    required List<String> interests,
    required List<String> intents,
    required List<String> languages,
    required String userType,
    required bool isPremium,
    required bool isVerified,
    required int points,
    String? subscriptionLevel,
    String? work,
    String? education,
    String? drinkingHabits,
    String? mealInterest,
    String? starSign,
  }) {
    final username = '${name.toLowerCase().replaceAll(' ', '_')}_${randomInt(10, 99)}';

    // Add hashtags to interests for some users
    final formattedInterests = interests.map((interest) {
      return shouldInclude(0.3) && !interest.startsWith('#') ? '#$interest' : interest;
    }).toList();

    return User(
      id: id,
      name: name,
      username: username,
      age: randomAge(),
      bio: bio,
      imageUrl: generateImageUrl(width: 200, height: 200, seed: id),
      interests: formattedInterests,
      isAvailable: randomBool(0.8), // 80% of users are available
      distance: randomDistance(),
      lastSeen: randomDateInLastDays(7), // Active within last week
      intents: intents,
      work: work,
      education: education,
      drinkingHabits: drinkingHabits,
      mealInterest: mealInterest,
      starSign: starSign,
      languages: languages,
      gender: randomItem(MockUserData.genderOptions),
      userType: userType,
      isPremium: isPremium,
      subscriptionLevel: subscriptionLevel,
      subscriptionExpiry: isPremium ? randomFutureDate(365) : null, // Expire in 1 year if premium
      points: points,
      isVerified: isVerified,
    );
  }

  /// Generate a fallback user for missing IDs
  User generateFallbackUser(String id, {String? name, bool isCurrentUser = false}) {
    logWarning('Creating fallback user for ID: $id');

    return User(
      id: id,
      name: name ?? (isCurrentUser ? 'You' : 'User $id'),
      username: id,
      age: randomAge(),
      bio: isCurrentUser ? 'Your bio here' : 'Dining enthusiast and social explorer',
      imageUrl: generateImageUrl(width: 200, height: 200, seed: id),
      interests: generateInterests(MockUserData.interestCategories.values.expand((i) => i).toList()),
      isAvailable: true,
      distance: randomDistance(),
      lastSeen: DateTime.now(),
      intents: ['dining', 'friendship'],
      work: isCurrentUser ? null : randomItem(MockUserData.workOptions),
      education: isCurrentUser ? null : randomItem(MockUserData.educationOptions),
      drinkingHabits: isCurrentUser ? null : randomItem(MockUserData.drinkingHabitsOptions),
      mealInterest: isCurrentUser ? null : randomItem(MockUserData.mealInterestOptions),
      starSign: isCurrentUser ? null : randomItem(MockUserData.starSignOptions),
      languages: ['English'],
      gender: randomItem(MockUserData.genderOptions),
      userType: isCurrentUser ? 'normal' : randomItem([MockConstants.defaultUserType, 'premium']),
      isPremium: isCurrentUser ? false : randomBool(0.3),
      subscriptionLevel: isCurrentUser ? null : (randomBool(0.2) ? 'premium' : null),
      subscriptionExpiry: isCurrentUser ? null : (randomBool(0.2) ? randomFutureDate(365) : null),
      points: isCurrentUser ? 100 : randomPoints(),
      isVerified: isCurrentUser ? true : randomBool(0.4),
    );
  }
}