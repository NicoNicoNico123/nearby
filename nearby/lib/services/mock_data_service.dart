import 'dart:math';
import '../models/user_model.dart';
import '../utils/logger.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  final List<User> _users = [];
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
}