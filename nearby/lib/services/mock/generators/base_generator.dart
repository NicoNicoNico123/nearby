import 'dart:math';
import 'dart:developer' as developer;
import '../data/mock_constants.dart';

/// Base generator class providing shared utilities for mock data generation
abstract class BaseGenerator {
  final Random _random;

  BaseGenerator({Random? random})
      : _random = random ?? Random();

  /// Get the random instance for subclasses
  Random get random => _random;

  /// Generate a random boolean with optional probability
  bool randomBool([double probability = 0.5]) {
    return _random.nextDouble() < probability;
  }

  /// Generate a random integer between min and max (inclusive)
  int randomInt(int min, int max) {
    return min + _random.nextInt(max - min + 1);
  }

  /// Generate a random double between min and max
  double randomDouble(double min, double max) {
    return min + _random.nextDouble() * (max - min);
  }

  /// Generate a random age within the standard range
  int randomAge([int min = MockConstants.minUserAge, int max = MockConstants.maxUserAge]) {
    return randomInt(min, max);
  }

  /// Generate a random distance in miles
  double randomDistance([double min = MockConstants.minDistance, double max = MockConstants.maxDistance]) {
    return randomDouble(min, max);
  }

  /// Generate random points balance
  int randomPoints({
    int min = MockConstants.minPoints,
    int max = MockConstants.maxPoints,
    bool isPremium = false,
  }) {
    if (isPremium) {
      return randomInt(MockConstants.premiumMinPoints, MockConstants.premiumMaxPoints);
    }
    return randomInt(min, max);
  }

  /// Pick a random item from a list
  T randomItem<T>(List<T> items) {
    if (items.isEmpty) {
      throw ArgumentError('Cannot pick from empty list');
    }
    return items[_random.nextInt(items.length)];
  }

  /// Pick multiple random items from a list without duplicates
  List<T> randomItems<T>(List<T> items, int count) {
    if (count <= 0) return [];
    if (count >= items.length) return List.from(items);

    final shuffled = List<T>.from(items)..shuffle(_random);
    return shuffled.take(count).toList();
  }

  /// Pick multiple random items from a list with possible duplicates
  List<T> randomItemsWithDuplicates<T>(List<T> items, int count) {
    return List.generate(count, (_) => randomItem(items));
  }

  /// Generate a random string from a character set
  String randomString(int length, {
    String charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
  }) {
    return String.fromCharCodes(
      Iterable.generate(length, (_) => charset.codeUnitAt(_random.nextInt(charset.length))),
    );
  }

  /// Generate a random alphanumeric ID with prefix
  String generateId(String prefix) {
    return '${prefix}_${randomInt(10000, 99999)}';
  }

  /// Generate a UUID-based ID
  String generateUuidId() {
    // Generate a simple UUID-like string without using the uuid package
    return '${randomInt(1000, 9999)}${randomInt(1000, 9999)}${randomInt(1000, 9999)}${randomInt(1000, 9999)}'.toLowerCase();
  }

  /// Generate a random date within the last N days
  DateTime randomDateInLastDays(int days) {
    final now = DateTime.now();
    final daysAgo = now.subtract(Duration(days: days));
    final difference = now.millisecondsSinceEpoch - daysAgo.millisecondsSinceEpoch;

    // Ensure the difference is within valid range for nextInt()
    if (difference <= 0 || difference > 2147483647) {
      // Fallback to day-based calculation if difference is too large
      final randomDays = _random.nextInt(days) + 1;
      return now.subtract(Duration(days: randomDays));
    }

    final randomMillis = daysAgo.millisecondsSinceEpoch + _random.nextInt(difference);
    return DateTime.fromMillisecondsSinceEpoch(randomMillis);
  }

  /// Generate a random future date within the next N days
  DateTime randomFutureDate(int days) {
    try {
      final now = DateTime.now();
      final futureDate = now.add(Duration(days: days));
      final difference = futureDate.millisecondsSinceEpoch - now.millisecondsSinceEpoch;

      // Ensure difference is positive and within valid range
      if (difference <= 0 || difference > 2147483647) {
        // Fallback to a simpler date calculation if difference is too large
        final randomDays = _random.nextInt(days) + 1;
        return now.add(Duration(days: randomDays));
      }

      final randomOffset = _random.nextInt(difference);
      final randomMillis = now.millisecondsSinceEpoch + randomOffset;
      return DateTime.fromMillisecondsSinceEpoch(randomMillis);
    } catch (e) {
      // Fallback to a safe future date if anything goes wrong
      return DateTime.now().add(Duration(days: _random.nextInt(days) + 1));
    }
  }

  /// Generate a random date time with specific time constraints
  DateTime randomDateTime({
    DateTime? startDate,
    DateTime? endDate,
    int minHour = 0,
    int maxHour = 23,
    int minMinute = 0,
    int maxMinute = 59,
  }) {
    final start = startDate ?? DateTime.now().subtract(const Duration(days: 30));
    final end = endDate ?? DateTime.now().add(const Duration(days: 90));

    final randomDate = DateTime.fromMillisecondsSinceEpoch(
      start.millisecondsSinceEpoch +
          _random.nextInt(end.millisecondsSinceEpoch - start.millisecondsSinceEpoch),
    );

    return DateTime(
      randomDate.year,
      randomDate.month,
      randomDate.day,
      randomInt(minHour, maxHour),
      randomInt(minMinute, maxMinute),
    );
  }

  /// Generate random coordinates around a base point
  Map<String, double> randomCoordinates({
    double baseLatitude = MockConstants.baseLatitude,
    double baseLongitude = MockConstants.baseLongitude,
    double variance = MockConstants.coordinateVariance,
  }) {
    final latitude = baseLatitude + (_random.nextDouble() - 0.5) * 2 * variance;
    final longitude = baseLongitude + (_random.nextDouble() - 0.5) * 2 * variance;

    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  /// Generate a random image URL
  String generateImageUrl({
    int? width,
    int? height,
    String? seed,
  }) {
    final w = width ?? 200;
    final h = height ?? 200;
    final s = seed ?? randomString(10);
    return 'https://picsum.photos/$w/$h?random=$s';
  }

  /// Generate random bio text
  String generateBio({
    int minLength = MockConstants.minBioLength,
    int maxLength = MockConstants.maxBioLength,
  }) {
    // Generate a simple bio template
    final startAdjective = randomItem(['Passionate', 'Curious', 'Adventurous', 'Social', 'Easygoing']);
    final activity = randomItem(['exploring', 'discovering', 'sharing', 'enjoying', 'creating']);
    final object = randomItem(['food', 'dining experiences', 'culinary adventures', 'great meals', 'food stories']);
    final social = randomItem(['with new friends', 'and great conversation', 'in good company', 'with fellow foodies']);

    final bio = '$startAdjective about $activity $object $social.';

    // Ensure it's within length constraints
    if (bio.length > maxLength) {
      return '${bio.substring(0, maxLength - 3)}...';
    }

    return bio;
  }

  /// Generate random list of interests
  List<String> generateInterests(
    List<String> availableInterests, {
    int min = MockConstants.minInterestsPerUser,
    int max = MockConstants.maxInterestsPerUser,
  }) {
    final count = randomInt(min, max);
    return randomItems(availableInterests, count);
  }

  /// Generate random list of intents
  List<String> generateIntents(
    List<String> availableIntents, {
    int min = 1,
    int max = 3,
  }) {
    final count = randomInt(min, max);
    return randomItems(availableIntents, count);
  }

  /// Generate random list of languages
  List<String> generateLanguages(
    List<String> availableLanguages, {
    int min = MockConstants.minLanguagesCount,
    int max = MockConstants.maxLanguagesCount,
  }) {
    final count = randomInt(min, max);
    final languages = randomItems(availableLanguages, count);
    // Ensure English is always included if available
    if (availableLanguages.contains('English') && !languages.contains('English')) {
      languages[0] = 'English';
    }
    return languages;
  }

  /// Generate random social links
  Map<String, String> generateSocialLinks() {
    final platforms = ['instagram', 'twitter', 'linkedin', 'facebook', 'tiktok'];
    final links = <String, String>{};

    // Randomly include some social links
    final includedPlatforms = randomItems(platforms, randomInt(0, 3));

    for (final platform in includedPlatforms) {
      links[platform] = '@${randomString(randomInt(4, 12)).toLowerCase()}';
    }

    return links;
  }

  /// Generate privacy settings
  Map<String, bool> generatePrivacySettings() {
    return {
      'showAge': randomBool(0.8),
      'showLocation': randomBool(0.7),
      'allowMessages': randomBool(0.6),
      'showOnlineStatus': randomBool(0.5),
      'allowFriendRequests': randomBool(0.8),
      'shareDiningHistory': randomBool(0.3),
    };
  }

  /// Check if a value should be included based on probability
  bool shouldInclude(double probability) {
    return randomBool(probability);
  }

  /// Choose one item based on weights
  T weightedChoice<T>(Map<T, double> options) {
    if (options.isEmpty) {
      throw ArgumentError('Options cannot be empty');
    }

    final totalWeight = options.values.reduce((a, b) => a + b);
    var randomWeight = _random.nextDouble() * totalWeight;

    for (final entry in options.entries) {
      randomWeight -= entry.value;
      if (randomWeight <= 0) {
        return entry.key;
      }
    }

    // Fallback to first option
    return options.keys.first;
  }

  /// Log generation message
  void logGeneration(String message) {
    developer.log('BaseGenerator: $message', name: 'MockData');
  }

  /// Log warning message
  void logWarning(String message) {
    developer.log('BaseGenerator: $message', name: 'MockData', level: 900);
  }

  /// Log error message
  void logError(String message, {Object? error}) {
    developer.log('BaseGenerator: $message', name: 'MockData', level: 1000, error: error);
  }
}