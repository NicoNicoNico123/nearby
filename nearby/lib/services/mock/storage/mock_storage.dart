import 'dart:convert';
import 'dart:developer' as developer;
import '../data/mock_constants.dart';
import '../../../models/user_model.dart';
import '../../../models/group_model.dart';

/// Abstract interface for mock data storage
abstract class MockStorageInterface {
  Future<void> saveUsers(List<User> users);
  List<User> getUsers();
  Future<void> saveGroups(List<Group> groups);
  List<Group> getGroups();
  Future<void> clearAllData();
  Future<bool> isFirstLaunch();
  Future<void> setFirstLaunch(bool isFirstLaunch);
}

/// In-memory storage implementation for mock data
class MockStorage implements MockStorageInterface {
  List<User> _cachedUsers = [];
  List<Group> _cachedGroups = [];

  @override
  Future<void> saveUsers(List<User> users) async {
    _cachedUsers = users;
    developer.log('Saved ${users.length} users to memory storage', name: 'MockStorage');
  }

  @override
  List<User> getUsers() {
    return _cachedUsers;
  }

  @override
  Future<void> saveGroups(List<Group> groups) async {
    _cachedGroups = groups;
    developer.log('Saved ${groups.length} groups to memory storage', name: 'MockStorage');
  }

  @override
  List<Group> getGroups() {
    return _cachedGroups;
  }

  @override
  Future<void> clearAllData() async {
    _cachedUsers.clear();
    _cachedGroups.clear();
    developer.log('Cleared all data from memory storage', name: 'MockStorage');
  }

  @override
  Future<bool> isFirstLaunch() async {
    // For in-memory storage, we'll use a simple check
    // In a real app, this would use SharedPreferences
    return _cachedUsers.isEmpty && _cachedGroups.isEmpty;
  }

  @override
  Future<void> setFirstLaunch(bool isFirstLaunch) async {
    // In a real app, this would save to SharedPreferences
    developer.log('Set first launch to: $isFirstLaunch', name: 'MockStorage');
  }
}

/// Persistent storage implementation using file system (for web/desktop)
class FileMockStorage implements MockStorageInterface {
  static final String _usersKey = MockConstants.usersKey;
  static final String _groupsKey = MockConstants.groupsKey;
  static final String _firstLaunchKey = MockConstants.firstLaunchKey;

  // This would use dart:io or file_picker for file persistence
  // For now, it's a placeholder that falls back to memory storage
  final MockStorage _fallback = MockStorage();

  @override
  Future<void> saveUsers(List<User> users) async {
    try {
      // In a real implementation, this would save to a file
      // For now, we'll just use the fallback
      await _fallback.saveUsers(users);
      developer.log('File storage: saved ${users.length} users (using fallback)', name: 'FileMockStorage');
    } catch (e) {
      developer.log('Failed to save users to file storage: $e', name: 'FileMockStorage', level: 1000);
      await _fallback.saveUsers(users);
    }
  }

  @override
  List<User> getUsers() {
    try {
      // In a real implementation, this would load from a file
      return _fallback.getUsers();
    } catch (e) {
      developer.log('Failed to load users from file storage: $e', name: 'FileMockStorage', level: 1000);
      return [];
    }
  }

  @override
  Future<void> saveGroups(List<Group> groups) async {
    try {
      // In a real implementation, this would save to a file
      await _fallback.saveGroups(groups);
      developer.log('File storage: saved ${groups.length} groups (using fallback)', name: 'FileMockStorage');
    } catch (e) {
      developer.log('Failed to save groups to file storage: $e', name: 'FileMockStorage', level: 1000);
      await _fallback.saveGroups(groups);
    }
  }

  @override
  List<Group> getGroups() {
    try {
      // In a real implementation, this would load from a file
      return _fallback.getGroups();
    } catch (e) {
      developer.log('Failed to load groups from file storage: $e', name: 'FileMockStorage', level: 1000);
      return [];
    }
  }

  @override
  Future<void> clearAllData() async {
    await _fallback.clearAllData();
    developer.log('File storage: cleared all data', name: 'FileMockStorage');
  }

  @override
  Future<bool> isFirstLaunch() async {
    return await _fallback.isFirstLaunch();
  }

  @override
  Future<void> setFirstLaunch(bool isFirstLaunch) async {
    await _fallback.setFirstLaunch(isFirstLaunch);
  }
}

/// Factory for creating appropriate storage implementation
class MockStorageFactory {
  static MockStorageInterface createStorage({bool usePersistentStorage = false}) {
    if (usePersistentStorage) {
      return FileMockStorage();
    } else {
      return MockStorage();
    }
  }
}

/// Utility methods for working with mock data
class MockStorageUtils {
  /// Serialize users to JSON
  static String usersToJson(List<User> users) {
    final jsonList = users.map((user) => user.toJson()).toList();
    return jsonEncode(jsonList);
  }

  /// Deserialize users from JSON
  static List<User> usersFromJson(String jsonString) {
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => User.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      developer.log('Failed to deserialize users from JSON: $e', name: 'MockStorageUtils', level: 1000);
      return [];
    }
  }

  /// Serialize groups to JSON
  static String groupsToJson(List<Group> groups) {
    final jsonList = groups.map((group) => group.toJson()).toList();
    return jsonEncode(jsonList);
  }

  /// Deserialize groups from JSON
  static List<Group> groupsFromJson(String jsonString) {
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Group.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      developer.log('Failed to deserialize groups from JSON: $e', name: 'MockStorageUtils', level: 1000);
      return [];
    }
  }

  /// Validate user data integrity
  static bool validateUsers(List<User> users) {
    for (final user in users) {
      if (user.id.isEmpty || user.name.isEmpty || (user.username?.isEmpty ?? true)) {
        developer.log('Invalid user found: ${user.id}', name: 'MockStorageUtils', level: 900);
        return false;
      }
    }

    // Check for duplicate IDs
    final ids = users.map((u) => u.id).toSet();
    if (ids.length != users.length) {
      developer.log('Duplicate user IDs found', name: 'MockStorageUtils', level: 900);
      return false;
    }

    return true;
  }

  /// Validate group data integrity
  static bool validateGroups(List<Group> groups) {
    for (final group in groups) {
      if (group.id.isEmpty || group.name.isEmpty || group.creatorId.isEmpty) {
        developer.log('Invalid group found: ${group.id}', name: 'MockStorageUtils', level: 900);
        return false;
      }
    }

    // Check for duplicate IDs
    final ids = groups.map((g) => g.id).toSet();
    if (ids.length != groups.length) {
      developer.log('Duplicate group IDs found', name: 'MockStorageUtils', level: 900);
      return false;
    }

    return true;
  }

  /// Get storage statistics
  static Map<String, dynamic> getStorageStats(List<User> users, List<Group> groups) {
    return {
      'users': {
        'total': users.length,
        'premium': users.where((u) => u.isPremium).length,
        'verified': users.where((u) => u.isVerified).length,
        'available': users.where((u) => u.isAvailable).length,
      },
      'groups': {
        'total': groups.length,
        'active': groups.where((g) => g.isActive).length,
        'full': groups.where((g) => g.isFull).length,
        'averageMembers': groups.isEmpty ? 0 : groups.fold(0, (sum, g) => sum + g.memberCount) / groups.length,
      },
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }
}