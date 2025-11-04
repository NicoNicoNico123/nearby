import 'dart:math';
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

  List<User> getUsers() {
    if (_users.isEmpty) {
      _generateMockUsers();
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
    ];

    final interests = [
      'Italian', 'Japanese', 'Mexican', 'Thai', 'Indian', 'French',
      'Coffee', 'Wine', 'Cocktails', 'Brunch', 'Desserts', 'BBQ',
      'Vegan', 'GlutenFree', 'SpicyFood', 'Seafood', 'Sushi',
      'Pizza', 'Tacos', 'Ramen', 'Tapas', 'Fusion', 'FarmToTable',
    ];

    final intents = ['dining', 'romantic', 'networking', 'friendship'];

    for (int i = 0; i < names.length; i++) {
      final userInterests = _getRandomItems(interests, _random.nextInt(4) + 2);
      final userIntents = _getRandomItems(intents, _random.nextInt(2) + 1);

      _users.add(User(
        id: 'user_${i + 1}',
        name: names[i],
        age: 22 + _random.nextInt(16), // Ages 22-37
        bio: _getRandomItems(bios, 1).first,
        imageUrl: 'https://picsum.photos/200/200?random=${i + 1}',
        interests: userInterests,
        isAvailable: _random.nextBool(),
        distance: 0.5 + _random.nextDouble() * 24.5, // 0.5-25 miles
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
  List<Group> getGroups() {
    if (_groups.isEmpty) {
      _generateMockGroups();
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
      'Weekend Brunch Club',
      'Tech Talk & Coffee',
      'Pizza Lovers Meetup',
      'Sushi Adventure',
      'Wine Tasting Evening',
      'Casual Friday Drinks',
      'Italian Food Night',
      'Mexican Fiesta',
      'Healthy Food Explorers',
      'Dessert Lovers Anonymous',
    ];

    final venues = [
      'The Cozy Café',
      'Sunset Restaurant',
      'Downtown Bistro',
      'Harbor View Eatery',
      'Mountain View Diner',
      'Urban Kitchen',
      'Green Leaf Restaurant',
      'Blue Moon Café',
      'Golden Gate Grill',
      'Riverside Tavern',
    ];

    final intents = ['dining', 'romantic', 'networking', 'friendship'];
    final interestOptions = [
      ['Italian', 'Wine', 'Coffee'],
      ['Japanese', 'Sushi', 'Seafood'],
      ['Mexican', 'Tacos', 'SpicyFood'],
      ['Thai', 'Asian', 'Healthy'],
      ['American', 'BBQ', 'Casual'],
      ['Indian', 'Curry', 'Vegan'],
      ['French', 'FineDining', 'Wine'],
      ['Coffee', 'Brunch', 'Desserts'],
      ['Pizza', 'Italian', 'Casual'],
      ['Networking', 'Business', 'Cocktails'],
    ];

    for (int i = 0; i < groupNames.length; i++) {
      final createdDate = DateTime.now().subtract(Duration(days: _random.nextInt(30)));
      final mealTime = DateTime.now().add(Duration(hours: _random.nextInt(48) + 1));
      final memberCount = _random.nextInt(8) + 2; // 2-10 members
      final selectedInterest = interestOptions[_random.nextInt(interestOptions.length)];

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
        maxMembers: 10,
        memberIds: ['creator_user'], // In real app, this would contain actual user IDs
        waitingList: _random.nextBool() ? ['user_${_random.nextInt(10) + 11}'] : [],
        createdAt: createdDate,
        location: 'San Francisco, CA',
      ));
    }

    Logger.info('Generated ${_groups.length} mock groups');
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
}