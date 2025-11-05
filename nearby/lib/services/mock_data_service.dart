import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/group_model.dart';
import '../utils/logger.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  final List<User> _users = [];
  final List<Group> _groups = [];
  final Random _random = Random();
  static const String _usersKey = 'mock_users';
  static const String _groupsKey = 'mock_groups';
  static const String _firstLaunchKey = 'first_launch';

  List<User> getUsers() {
    if (_users.isEmpty) {
      _loadUsersFromStorage();
      if (_users.isEmpty) {
        _generateMockUsers();
        _saveUsersToStorage();
      }
    }
    return _users;
  }

  List<User> getAvailableUsers({double? maxDistance}) {
    final users = getUsers();
    final available = users.where((user) => user.isAvailable).toList();

    if (maxDistance != null) {
      return available
          .where((user) => (user.distance ?? 0) <= maxDistance)
          .toList();
    }

    return available;
  }

  List<User> getUsersByIntent(String intent) {
    return getUsers()
        .where((user) => user.intents.contains(intent) && user.isAvailable)
        .toList();
  }

  User? getUserById(String id) {
    try {
      return getUsers().firstWhere((user) => user.id == id);
    } catch (e) {
      Logger.warning('User not found: $id');
      return null;
    }
  }

  User getCurrentUser() {
    // Return the current user (in a real app, this would come from auth service)
    return const User(
      id: 'current_user',
      name: 'Alexandra Davis',
      username: 'alexandra_d',
      age: 28,
      bio: 'Lover of coffee and minimalist design. Exploring the world one city at a time.',
      imageUrl: 'https://picsum.photos/200/200?random=current',
      interests: ['#Design', '#Travel', '#Photography', '#Coffee', '#Minimalism'],
      isAvailable: true,
    );
  }

  void _generateMockUsers() {
    final names = [
      'Alex Johnson', 'Sarah Chen', 'Mike Williams', 'Emma Davis',
      'James Wilson', 'Olivia Brown', 'Daniel Garcia', 'Sophia Martinez',
      'Chris Anderson', 'Isabella Taylor', 'Ryan Thomas', 'Mia Jackson',
      'David White', 'Charlotte Harris', 'Kevin Martin', 'Amelia Thompson',
      'Jason Garcia', 'Harper Robinson', 'Brian Clark', 'Evelyn Rodriguez',
      'Marcus Kim', 'Lisa Wang', 'Tyler Brown', 'Nina Patel', 'Sam Lee',
      'Rachel Green', 'Tom Anderson', 'Julia Smith', 'Carlos Rodriguez',
      'Emily Johnson', 'Ben Davis', 'Sophie Turner', 'Mark Wilson',
      'Anna Lee', 'Jake Chen', 'Maya Patel', 'Oliver Smith', 'Zoe Johnson'
    ];

    final bios = [
      'Love trying new restaurants and meeting interesting people!',
      'Food enthusiast looking for dining companions',
      'Exploring the city one meal at a time',
      'Coffee addict and brunch lover',
      'Always hungry for good food and great conversation',
      'Wine lover and aspiring foodie',
      'Let\'s find the best hidden gems together',
      'Adventure seeker with a passion for food',
      'Weekend warrior seeking culinary adventures',
      'Michelin guide follower and food blogger',
      'Spicy food challenge survivor',
      'Vegan foodie on a mission',
      'BBQ pitmaster in training',
      'Sushi enthusiast and sake lover',
      'Farm-to-table advocate',
      'Late-night food critic',
      'Brunch connoisseur',
      'Craft beer snob',
      'Taco Tuesday evangelist',
      'Dim sum expert',
      'Dessert specialist'
    ];

    final interests = [
      'Italian', 'Japanese', 'Mexican', 'Thai', 'Indian', 'French',
      'Coffee', 'Wine', 'Cocktails', 'Brunch', 'Desserts', 'BBQ',
      'Vegan', 'GlutenFree', 'SpicyFood', 'Seafood', 'Sushi',
      'Pizza', 'Tacos', 'Ramen', 'Tapas', 'Fusion', 'FarmToTable',
      'HappyHour', 'LateNight', 'Breakfast', 'Lunch', 'Dinner',
      'Vegetarian', 'Keto', 'Paleo', 'Organic', 'Local', 'CraftBeer',
      'Whiskey', 'Tequila', 'Gin', 'Rum', 'Champagne', 'Mocktails'
    ];

    final intents = ['dining', 'romantic', 'networking', 'friendship'];

    for (int i = 0; i < names.length; i++) {
      final userInterests = _getRandomItems(interests, _random.nextInt(5) + 3); // 3-7 interests
      final userIntents = _getRandomItems(intents, _random.nextInt(3) + 1); // 1-3 intents

      _users.add(User(
        id: 'user_${i + 1}',
        name: names[i],
        age: 21 + _random.nextInt(19), // Ages 21-39
        bio: _getRandomItems(bios, 1).first,
        imageUrl: 'https://picsum.photos/200/200?random=${i + 1}',
        interests: userInterests,
        isAvailable: _random.nextBool(),
        distance: 0.1 + _random.nextDouble() * 49.9, // 0.1-50 miles
        lastSeen: _getRandomLastSeen(),
        intents: userIntents,
      ));
    }

    Logger.info('Generated ${_users.length} mock users');
  }

  List<String> _getRandomItems(List<String> items, int count) {
    final shuffled = List<String>.from(items)..shuffle(_random);
    return shuffled.take(count).toList();
  }

  DateTime _getRandomLastSeen() {
    final now = DateTime.now();
    final hoursAgo = _random.nextInt(72); // 0-72 hours ago
    return now.subtract(Duration(hours: hoursAgo));
  }

  // Simulate network delay
  Future<List<User>> getUsersAsync({Duration delay = const Duration(milliseconds: 500)}) async {
    Logger.debug('Fetching users with simulated delay');
    await Future.delayed(delay);
    return getUsers();
  }

  // Search users by name or interests
  List<User> searchUsers(String query) {
    if (query.isEmpty) return getUsers();

    final lowerQuery = query.toLowerCase();
    return getUsers().where((user) =>
      user.name.toLowerCase().contains(lowerQuery) ||
      user.bio.toLowerCase().contains(lowerQuery) ||
      user.interests.any((interest) => interest.toLowerCase().contains(lowerQuery))
    ).toList();
  }

  // Get users sorted by distance
  List<User> getNearbyUsers({double maxDistance = 25.0}) {
    return getAvailableUsers(maxDistance: maxDistance)
      ..sort((a, b) => (a.distance ?? 0).compareTo(b.distance ?? 0));
  }

  // Get recently active users
  List<User> getRecentlyActiveUsers({Duration within = const Duration(hours: 24)}) {
    final cutoff = DateTime.now().subtract(within);
    return getUsers()
        .where((user) =>
            user.isAvailable &&
            user.lastSeen != null &&
            user.lastSeen!.isAfter(cutoff))
        .toList();
  }

  // Group related methods
  List<Group> getGroups({bool forceRefresh = false}) {
    if (forceRefresh || _groups.isEmpty) {
      _loadGroupsFromStorage();
      if (forceRefresh || _groups.isEmpty) {
        _generateMockGroups();
        _saveGroupsToStorage();
      }
    }
    return _groups;
  }

  Group? getGroupById(String id) {
    try {
      return getGroups().firstWhere((group) => group.id == id);
    } catch (e) {
      Logger.warning('Group not found: $id');
      return null;
    }
  }

  void _generateMockGroups() {
    final groupNames = [
      'Weekend Brunch Club', 'Tech Talk & Coffee', 'Pizza Lovers Meetup',
      'Sushi Adventure', 'Wine Tasting Evening', 'Casual Friday Drinks',
      'Italian Food Night', 'Mexican Fiesta', 'Healthy Food Explorers',
      'Dessert Lovers Anonymous', 'Taco Tuesday Warriors', 'Ramen Lovers Union',
      'BBQ Pitmaster Society', 'Vegan Food Tribe', 'Cocktail Connoisseurs',
      'Seafood Appreciation Club', 'Spicy Food Challenge', 'Farm-to-Table Collective',
      'Coffee Connoisseurs', 'Craft Beer Enthusiasts', 'Happy Hour Heroes',
      'Late Night Munchies', 'Breakfast Club', 'Baking Buddies'
    ];

    final venues = [
      'The Cozy Café', 'Sunset Restaurant', 'Downtown Bistro', 'Harbor View Eatery',
      'Mountain View Diner', 'Urban Kitchen', 'Green Leaf Restaurant', 'Blue Moon Café',
      'Golden Gate Grill', 'Riverside Tavern', 'The Secret Garden', 'Rooftop Lounge',
      'Underground Speakeasy', 'Beachside Bistro', 'Historic Inn', 'Modern Eatery',
      'Artisan Bakery', 'Local Brew House', 'Fusion Kitchen', 'The Hidden Gem'
    ];

    final intents = ['dining', 'romantic', 'networking', 'friendship'];
    final interestOptions = [
      ['Italian', 'Wine', 'Coffee'], ['Japanese', 'Sushi', 'Seafood'],
      ['Mexican', 'Tacos', 'SpicyFood'], ['Thai', 'Asian', 'Healthy'],
      ['American', 'BBQ', 'Casual'], ['Indian', 'Curry', 'Vegan'],
      ['French', 'FineDining', 'Wine'], ['Coffee', 'Brunch', 'Desserts'],
      ['Pizza', 'Italian', 'Casual'], ['Networking', 'Business', 'Cocktails'],
      ['FarmToTable', 'Organic', 'Local'], ['Vegan', 'Vegetarian', 'Healthy'],
      ['CraftBeer', 'Pub', 'Casual'], ['Cocktails', 'HappyHour', 'Social'],
      ['Seafood', 'Fresh', 'FineDining'], ['BBQ', 'Grilling', 'Outdoor'],
      ['Breakfast', 'Brunch', 'Coffee'], ['LateNight', 'StreetFood', 'Casual'],
      ['Ramen', 'Japanese', 'Comfort'], ['Tapas', 'Spanish', 'Social']
    ];

    for (int i = 0; i < groupNames.length; i++) {
      final createdDate = DateTime.now().subtract(Duration(days: _random.nextInt(30)));
      final mealTime = DateTime.now().add(Duration(hours: _random.nextInt(48) + 1));
      final selectedInterest = interestOptions[_random.nextInt(interestOptions.length)];

      // Create variety of availability states
      int memberCount;
      int maxMembers = 10;

      // Ensure we have different availability scenarios
      if (i < 4) {
        // First 4 groups: Good availability (50%+ available)
        memberCount = _random.nextInt(4) + 1; // 1-4 members (60-90% available)
      } else if (i < 8) {
        // Next 4 groups: Limited availability (below 50% available)
        memberCount = _random.nextInt(3) + 6; // 6-8 members (20-40% available)
      } else if (i < 11) {
        // Next 3 groups: Full capacity
        memberCount = maxMembers; // 10 members (0% available)
      } else {
        // Remaining groups: Random availability
        memberCount = _random.nextInt(8) + 2; // 2-10 members
      }

      // Generate pot and cost information
      final basePot = 500 + (_random.nextInt(1500)); // 500-2000 points base pot
      final groupPot = basePot + (memberCount * 100); // Add 100 points per member
      final joinCost = 50 + (_random.nextInt(150)); // 50-200 points to join

      // Generate mock coordinates around San Francisco area
      final baseLatitude = 37.7749; // San Francisco
      final baseLongitude = -122.4194; // San Francisco
      final latitude = baseLatitude + (_random.nextDouble() - 0.5) * 0.1; // ±0.05 degrees
      final longitude = baseLongitude + (_random.nextDouble() - 0.5) * 0.1; // ±0.05 degrees

      _groups.add(Group(
        id: 'group_${i + 1}',
        name: groupNames[i],
        description: _generateGroupDescription(groupNames[i]),
        subtitle: '$memberCount people attending',
        imageUrl: 'https://picsum.photos/400/300?random=group${i + 1}',
        interests: selectedInterest,
        memberCount: memberCount,
        category: selectedInterest.first,
        creatorId: 'user_${_random.nextInt(10) + 1}',
        creatorName: 'Host User',
        venue: venues[_random.nextInt(venues.length)],
        mealTime: mealTime,
        intent: intents[_random.nextInt(intents.length)],
        maxMembers: maxMembers,
        memberIds: ['creator_user'], // In real app, this would contain actual user IDs
        waitingList: _random.nextBool() ? ['user_${_random.nextInt(10) + 11}'] : [],
        createdAt: createdDate,
        location: 'San Francisco, CA',
        latitude: latitude,
        longitude: longitude,
        groupPot: groupPot,
        joinCost: joinCost,
      ));
    }

    Logger.info('Generated ${_groups.length} mock groups');
    // Debug: Log the first few groups' availability
    for (int i = 0; i < _groups.length && i < 5; i++) {
      final group = _groups[i];
      Logger.info('Group ${i + 1}: ${group.name} - ${group.memberCount}/${group.maxMembers} (${group.availableSpots} available)');
    }
  }

  String _generateGroupDescription(String groupName) {
    final descriptions = [
      'Join us for an amazing dining experience with great food and even better company!',
      'A perfect opportunity to meet new people while enjoying delicious food.',
      'Come and explore new culinary experiences with fellow food enthusiasts.',
      'An evening of great conversation and fantastic cuisine awaits you.',
      'Food, friends, and fun - what more could you ask for?',
      'Discover new flavors and make new connections in a welcoming atmosphere.',
    ];
    return descriptions[_random.nextInt(descriptions.length)];
  }

  // Data persistence methods
  Future<void> _loadUsersFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey);

      if (usersJson != null) {
        final usersList = jsonDecode(usersJson) as List;
        _users.clear();
        for (final userJson in usersList) {
          _users.add(User.fromJson(userJson));
        }
        Logger.info('Loaded ${_users.length} users from storage');
      }
    } catch (e) {
      Logger.warning('Failed to load users from storage: $e');
    }
  }

  Future<void> _saveUsersToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = _users.map((user) => user.toJson()).toList();
      await prefs.setString(_usersKey, jsonEncode(usersJson));
      Logger.info('Saved ${_users.length} users to storage');
    } catch (e) {
      Logger.warning('Failed to save users to storage: $e');
    }
  }

  Future<void> _loadGroupsFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final groupsJson = prefs.getString(_groupsKey);

      if (groupsJson != null) {
        final groupsList = jsonDecode(groupsJson) as List;
        _groups.clear();
        for (final groupJson in groupsList) {
          _groups.add(Group.fromJson(groupJson));
        }
        Logger.info('Loaded ${_groups.length} groups from storage');
      }
    } catch (e) {
      Logger.warning('Failed to load groups from storage: $e');
    }
  }

  Future<void> _saveGroupsToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final groupsJson = _groups.map((group) => group.toJson()).toList();
      await prefs.setString(_groupsKey, jsonEncode(groupsJson));
      Logger.info('Saved ${_groups.length} groups to storage');
    } catch (e) {
      Logger.warning('Failed to save groups to storage: $e');
    }
  }

  // Check if this is the first launch
  Future<bool> isFirstLaunch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return !prefs.containsKey(_firstLaunchKey);
    } catch (e) {
      Logger.warning('Failed to check first launch: $e');
      return true; // Assume first launch on error
    }
  }

  // Mark app as launched
  Future<void> markLaunched() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_firstLaunchKey, true);
      Logger.info('Marked app as launched');
    } catch (e) {
      Logger.warning('Failed to mark app as launched: $e');
    }
  }

  // Update user availability (for realistic activity patterns)
  Future<void> updateUserAvailability(String userId, bool isAvailable) async {
    try {
      final userIndex = _users.indexWhere((user) => user.id == userId);
      if (userIndex != -1) {
        _users[userIndex] = _users[userIndex].copyWith(
          isAvailable: isAvailable,
          lastSeen: DateTime.now(),
        );
        await _saveUsersToStorage();
        Logger.info('Updated availability for user $userId to $isAvailable');
      }
    } catch (e) {
      Logger.warning('Failed to update user availability: $e');
    }
  }

  // Simulate user activity over time
  Future<void> simulateUserActivity() async {
    final firstLaunch = await isFirstLaunch();

    if (firstLaunch) {
      await markLaunched();
      Logger.info('First launch - initializing realistic user activity');
      _initializeRealisticActivity();
    } else {
      _updateRecentActivity();
    }
  }

  void _initializeRealisticActivity() {
    // Set some users as unavailable (offline) initially
    for (final user in _users) {
      if (_random.nextDouble() < 0.3) { // 30% chance of being offline
        final index = _users.indexOf(user);
        _users[index] = user.copyWith(
          isAvailable: false,
          lastSeen: DateTime.now().subtract(Duration(hours: _random.nextInt(24) + 1)),
        );
      }
    }

    // Set some groups as full or cancelled
    for (final group in _groups) {
      if (_random.nextDouble() < 0.2) { // 20% chance of being full
        final index = _groups.indexOf(group);
        _groups[index] = group.copyWith(
          memberCount: group.maxMembers,
          memberIds: List.generate(group.maxMembers, (i) => 'user_${i + 1}'),
        );
      }
    }
  }

  void _updateRecentActivity() {
    // Randomly update some users' availability and last seen
    final usersToUpdate = _random.nextInt(5) + 1; // 1-5 users

    for (int i = 0; i < usersToUpdate; i++) {
      if (_users.isNotEmpty) {
        final randomUser = _users[_random.nextInt(_users.length)];
        final index = _users.indexOf(randomUser);

        _users[index] = randomUser.copyWith(
          isAvailable: _random.nextBool(),
          lastSeen: DateTime.now().subtract(Duration(minutes: _random.nextInt(120))),
        );
      }
    }
  }

  // Clear all stored data (for testing/reset)
  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_usersKey);
      await prefs.remove(_groupsKey);
      await prefs.remove(_firstLaunchKey);
      _users.clear();
      _groups.clear();
      Logger.info('Cleared all stored data');
    } catch (e) {
      Logger.warning('Failed to clear data: $e');
    }
  }

  // Force regenerate mock data with new availability distribution
  Future<void> regenerateMockData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_groupsKey); // Clear groups cache only
      _groups.clear();
      Logger.info('Regenerating mock data with new availability distribution');
      getGroups(forceRefresh: true); // Force regeneration
    } catch (e) {
      Logger.warning('Failed to regenerate mock data: $e');
    }
  }
}