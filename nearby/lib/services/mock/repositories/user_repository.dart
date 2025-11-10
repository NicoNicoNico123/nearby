import '../generators/user_generator.dart';
import '../storage/mock_storage.dart';
import '../../../models/user_model.dart';
import 'dart:developer' as developer;

/// Repository for user data management
class UserRepository {
  final UserGenerator _generator;
  final MockStorageInterface _storage;

  UserRepository({
    required UserGenerator generator,
    required MockStorageInterface storage,
  })  : _generator = generator,
        _storage = storage;

  /// Get all users
  List<User> getAllUsers() {
    return _storage.getUsers();
  }

  /// Get user by ID
  User? getUserById(String userId) {
    final users = _storage.getUsers();

    try {
      return users.firstWhere((user) => user.id == userId);
    } catch (e) {
      developer.log('User not found: $userId', name: 'UserRepository');
      return null;
    }
  }

  /// Get current user
  User getCurrentUser() {
    return _generator.generateCurrentUser();
  }

  /// Search users by name or username
  List<User> searchUsers(String query) {
    if (query.trim().isEmpty) {
      return [];
    }

    final users = _storage.getUsers();
    final lowercaseQuery = query.toLowerCase();

    return users.where((user) {
      return user.name.toLowerCase().contains(lowercaseQuery) ||
             (user.username?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }

  /// Filter users by criteria
  List<User> filterUsers({
    int? minAge,
    int? maxAge,
    String? gender,
    String? userType,
    bool? isPremium,
    bool? isVerified,
    List<String>? interests,
    List<String>? intents,
    double? maxDistance,
    bool? isAvailable,
  }) {
    final users = _storage.getUsers();

    return users.where((user) {
      if (minAge != null && (user.age ?? 0) < minAge) return false;
      if (maxAge != null && (user.age ?? 0) > maxAge) return false;
      if (gender != null && user.gender != gender) return false;
      if (userType != null && user.userType != userType) return false;
      if (isPremium != null && user.isPremium != isPremium) return false;
      if (isVerified != null && user.isVerified != isVerified) return false;
      if (maxDistance != null && (user.distance ?? 0) > maxDistance) return false;
      if (isAvailable != null && user.isAvailable != isAvailable) return false;

      if (interests != null && interests.isNotEmpty) {
        final userInterests = user.interests.map((i) => i.toLowerCase()).toSet();
        final searchInterests = interests.map((i) => i.toLowerCase()).toSet();
        if (!searchInterests.any((interest) => userInterests.any((userInterest) => userInterest.contains(interest)))) {
          return false;
        }
      }

      if (intents != null && intents.isNotEmpty) {
        final userIntents = user.intents.toSet();
        final searchIntents = intents.toSet();
        if (!searchIntents.any((intent) => userIntents.contains(intent))) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  /// Get users by type
  List<User> getUsersByType(String userType) {
    return filterUsers(userType: userType);
  }

  /// Get premium users
  List<User> getPremiumUsers() {
    return filterUsers(isPremium: true);
  }

  /// Get verified users
  List<User> getVerifiedUsers() {
    return filterUsers(isVerified: true);
  }

  /// Get available users
  List<User> getAvailableUsers() {
    return filterUsers(isAvailable: true);
  }

  /// Get users by interests
  List<User> getUsersByInterests(List<String> interests) {
    return filterUsers(interests: interests);
  }

  /// Get users by intents
  List<User> getUsersByIntents(List<String> intents) {
    return filterUsers(intents: intents);
  }

  /// Get users near a location
  List<User> getNearbyUsers({double maxDistance = 10.0}) {
    return filterUsers(maxDistance: maxDistance);
  }

  /// Get users in age range
  List<User> getUsersInAgeRange(int minAge, int maxAge) {
    return filterUsers(minAge: minAge, maxAge: maxAge);
  }

  /// Get random users
  List<User> getRandomUsers(int count) {
    final users = _storage.getUsers();
    if (users.length <= count) {
      return List.from(users);
    }

    final shuffled = List<User>.from(users)..shuffle();
    return shuffled.take(count).toList();
  }

  /// Get users by IDs
  List<User> getUsersByIds(List<String> userIds) {
    final users = _storage.getUsers();
    final userIdSet = userIds.toSet();

    return users.where((user) => userIdSet.contains(user.id)).toList();
  }

  /// Generate and save users
  Future<void> generateUsers({
    int normalCount = 12,
    int premiumCount = 5,
    int creatorCount = 2,
    int adminCount = 1,
  }) async {
    final users = _generator.generateUserBatch(
      normalCount: normalCount,
      premiumCount: premiumCount,
      creatorCount: creatorCount,
      adminCount: adminCount,
    );

    await _storage.saveUsers(users);
    developer.log('Generated ${users.length} users', name: 'UserRepository');
  }

  /// Add a user
  Future<void> addUser(User user) async {
    final users = _storage.getUsers();
    users.add(user);
    await _storage.saveUsers(users);
  }

  /// Update a user
  Future<void> updateUser(User updatedUser) async {
    final users = _storage.getUsers();
    final index = users.indexWhere((user) => user.id == updatedUser.id);

    if (index != -1) {
      users[index] = updatedUser;
      await _storage.saveUsers(users);
      developer.log('Updated user: ${updatedUser.id}', name: 'UserRepository');
    } else {
      developer.log('User not found for update: ${updatedUser.id}', name: 'UserRepository', level: 900);
    }
  }

  /// Delete a user
  Future<void> deleteUser(String userId) async {
    final users = _storage.getUsers();
    final updatedUsers = users.where((user) => user.id != userId).toList();

    if (updatedUsers.length < users.length) {
      await _storage.saveUsers(updatedUsers);
      developer.log('Deleted user: $userId', name: 'UserRepository');
    } else {
      developer.log('User not found for deletion: $userId', name: 'UserRepository', level: 900);
    }
  }

  /// Get user statistics
  Map<String, dynamic> getUserStatistics() {
    final users = _storage.getUsers();

    if (users.isEmpty) {
      return {
        'total': 0,
        'byType': {},
        'byGender': {},
        'byAgeRange': {},
        'premium': 0,
        'verified': 0,
        'available': 0,
      };
    }

    final byType = <String, int>{};
    final byGender = <String, int>{};
    final byAgeRange = <String, int>{};

    for (final user in users) {
      // By type
      byType[user.userType] = (byType[user.userType] ?? 0) + 1;

      // By gender
      byGender[user.gender] = (byGender[user.gender] ?? 0) + 1;

      // By age range
      String ageRange;
      final age = user.age ?? 0;
      if (age < 25) {
        ageRange = '18-24';
      } else if (age < 35) {
        ageRange = '25-34';
      } else if (age < 45) {
        ageRange = '35-44';
      } else if (age < 55) {
        ageRange = '45-54';
      } else {
        ageRange = '55+';
      }
      byAgeRange[ageRange] = (byAgeRange[ageRange] ?? 0) + 1;
    }

    return {
      'total': users.length,
      'byType': byType,
      'byGender': byGender,
      'byAgeRange': byAgeRange,
      'premium': users.where((u) => u.isPremium).length,
      'verified': users.where((u) => u.isVerified).length,
      'available': users.where((u) => u.isAvailable).length,
    };
  }

  /// Create fallback user for missing IDs
  User createFallbackUser(String userId, {String? name, bool isCurrentUser = false}) {
    return _generator.generateFallbackUser(userId, name: name, isCurrentUser: isCurrentUser);
  }
}