import '../generators/group_generator.dart';
import '../storage/mock_storage.dart';
import '../../../models/group_model.dart';
import '../../../models/user_model.dart';
import 'dart:developer' as developer;

/// Repository for group data management
class GroupRepository {
  final GroupGenerator _generator;
  final MockStorageInterface _storage;

  GroupRepository({
    required GroupGenerator generator,
    required MockStorageInterface storage,
  })  : _generator = generator,
        _storage = storage;

  /// Get all groups
  List<Group> getAllGroups() {
    return _storage.getGroups();
  }

  /// Get group by ID
  Group? getGroupById(String groupId) {
    final groups = _storage.getGroups();

    try {
      return groups.firstWhere((group) => group.id == groupId);
    } catch (e) {
      developer.log('Group not found: $groupId', name: 'GroupRepository');
      return null;
    }
  }

  /// Search groups by name or description
  List<Group> searchGroups(String query) {
    if (query.trim().isEmpty) {
      return [];
    }

    final groups = _storage.getGroups();
    final lowercaseQuery = query.toLowerCase();

    return groups.where((group) {
      return group.name.toLowerCase().contains(lowercaseQuery) ||
             group.description.toLowerCase().contains(lowercaseQuery) ||
             group.venue.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  /// Filter groups by criteria
  List<Group> filterGroups({
    String? category,
    String? creatorId,
    List<String>? interests,
    List<String>? allowedGenders,
    int? minAge,
    int? maxAge,
    List<String>? allowedLanguages,
    int? minJoinCost,
    int? maxJoinCost,
    int? minMaxMembers,
    int? maxMaxMembers,
    bool? isActive,
    bool? isFull,
    bool? hasAvailableSpots,
    String? location,
    DateTime? mealTimeAfter,
    DateTime? mealTimeBefore,
  }) {
    final groups = _storage.getGroups();

    return groups.where((group) {
      if (category != null && group.category != category) return false;
      if (creatorId != null && group.creatorId != creatorId) return false;
      if (isActive != null && group.isActive != isActive) return false;
      if (isFull != null && group.isFull != isFull) return false;
      if (hasAvailableSpots != null && (group.availableSpots > 0) != hasAvailableSpots) return false;
      if (location != null && !(group.location?.toLowerCase().contains(location.toLowerCase()) ?? false)) return false;

      if (minJoinCost != null && group.joinCost < minJoinCost) return false;
      if (maxJoinCost != null && group.joinCost > maxJoinCost) return false;
      if (minMaxMembers != null && group.maxMembers < minMaxMembers) return false;
      if (maxMaxMembers != null && group.maxMembers > maxMaxMembers) return false;

      if (minAge != null && group.ageRangeMin < minAge) return false;
      if (maxAge != null && group.ageRangeMax > maxAge) return false;

      if (mealTimeAfter != null && group.mealTime.isBefore(mealTimeAfter)) return false;
      if (mealTimeBefore != null && group.mealTime.isAfter(mealTimeBefore)) return false;

      if (interests != null && interests.isNotEmpty) {
        final groupInterests = group.interests.map((i) => i.toLowerCase()).toSet();
        final searchInterests = interests.map((i) => i.toLowerCase()).toSet();
        if (!searchInterests.any((interest) => groupInterests.contains(interest))) {
          return false;
        }
      }

      if (allowedGenders != null && allowedGenders.isNotEmpty) {
        if (!allowedGenders.any((gender) => group.allowedGenders.contains(gender))) {
          return false;
        }
      }

      if (allowedLanguages != null && allowedLanguages.isNotEmpty) {
        if (!allowedLanguages.any((lang) => group.allowedLanguages.contains(lang))) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  /// Get groups by category
  List<Group> getGroupsByCategory(String category) {
    return filterGroups(category: category);
  }

  /// Get groups created by a specific user
  List<Group> getGroupsByCreator(String creatorId) {
    return filterGroups(creatorId: creatorId);
  }

  /// Get active groups
  List<Group> getActiveGroups() {
    return filterGroups(isActive: true);
  }

  /// Get groups with available spots
  List<Group> getGroupsWithAvailableSpots() {
    return filterGroups(hasAvailableSpots: true);
  }

  /// Get full groups
  List<Group> getFullGroups() {
    return filterGroups(isFull: true);
  }

  /// Get groups by interests
  List<Group> getGroupsByInterests(List<String> interests) {
    return filterGroups(interests: interests);
  }

  /// Get affordable groups (within join cost range)
  List<Group> getAffordableGroups({int maxCost = 200}) {
    return filterGroups(maxJoinCost: maxCost);
  }

  /// Get groups by size
  List<Group> getGroupsBySize({int minSize = 2, int maxSize = 20}) {
    return filterGroups(minMaxMembers: minSize, maxMaxMembers: maxSize);
  }

  /// Get groups by location
  List<Group> getGroupsByLocation(String location) {
    return filterGroups(location: location);
  }

  /// Get upcoming groups (meal time in the future)
  List<Group> getUpcomingGroups() {
    return filterGroups(mealTimeAfter: DateTime.now());
  }

  /// Get groups by age requirements
  List<Group> getGroupsForAge(int userAge) {
    return filterGroups(
      minAge: 18,
      maxAge: userAge + 10, // Allow some flexibility
    );
  }

  /// Get random groups
  List<Group> getRandomGroups(int count) {
    final groups = _storage.getGroups();
    if (groups.length <= count) {
      return List.from(groups);
    }

    final shuffled = List<Group>.from(groups)..shuffle();
    return shuffled.take(count).toList();
  }

  /// Get groups by IDs
  List<Group> getGroupsByIds(List<String> groupIds) {
    final groups = _storage.getGroups();
    final groupIdSet = groupIds.toSet();

    return groups.where((group) => groupIdSet.contains(group.id)).toList();
  }

  /// Generate and save groups
  Future<void> generateGroups({
    required int count,
    required List<User> availableUsers,
  }) async {
    final groups = _generator.generateGroupBatch(
      count: count,
      availableUsers: availableUsers,
    );

    await _storage.saveGroups(groups);
    developer.log('Generated ${groups.length} groups', name: 'GroupRepository');
  }

  /// Add a group
  Future<void> addGroup(Group group) async {
    final groups = _storage.getGroups();
    groups.add(group);
    await _storage.saveGroups(groups);
  }

  /// Update a group
  Future<void> updateGroup(Group updatedGroup) async {
    final groups = _storage.getGroups();
    final index = groups.indexWhere((group) => group.id == updatedGroup.id);

    if (index != -1) {
      groups[index] = updatedGroup;
      await _storage.saveGroups(groups);
      developer.log('Updated group: ${updatedGroup.id}', name: 'GroupRepository');
    } else {
      developer.log('Group not found for update: ${updatedGroup.id}', name: 'GroupRepository', level: 900);
    }
  }

  /// Delete a group
  Future<void> deleteGroup(String groupId) async {
    final groups = _storage.getGroups();
    final updatedGroups = groups.where((group) => group.id != groupId).toList();

    if (updatedGroups.length < groups.length) {
      await _storage.saveGroups(updatedGroups);
      developer.log('Deleted group: $groupId', name: 'GroupRepository');
    } else {
      developer.log('Group not found for deletion: $groupId', name: 'GroupRepository', level: 900);
    }
  }

  /// Get group statistics
  Map<String, dynamic> getGroupStatistics() {
    final groups = _storage.getGroups();

    if (groups.isEmpty) {
      return {
        'total': 0,
        'active': 0,
        'full': 0,
        'averageMembers': 0,
        'averageJoinCost': 0,
        'byCategory': {},
        'bySize': {},
      };
    }

    final byCategory = <String, int>{};
    final bySize = <String, int>{};
    int totalMembers = 0;
    int totalJoinCost = 0;
    int activeCount = 0;
    int fullCount = 0;

    for (final group in groups) {
      // By category
      final category = group.category ?? 'Other';
      byCategory[category] = (byCategory[category] ?? 0) + 1;

      // By size
      String sizeCategory;
      if (group.maxMembers <= 4) {
        sizeCategory = 'Small (2-4)';
      } else if (group.maxMembers <= 8) {
        sizeCategory = 'Medium (5-8)';
      } else if (group.maxMembers <= 15) {
        sizeCategory = 'Large (9-15)';
      } else {
        sizeCategory = 'Extra Large (16+)';
      }
      bySize[sizeCategory] = (bySize[sizeCategory] ?? 0) + 1;

      // Totals
      totalMembers += group.memberCount;
      totalJoinCost += group.joinCost;
      if (group.isActive) activeCount++;
      if (group.isFull) fullCount++;
    }

    return {
      'total': groups.length,
      'active': activeCount,
      'full': fullCount,
      'averageMembers': groups.isEmpty ? 0 : totalMembers / groups.length,
      'averageJoinCost': groups.isEmpty ? 0 : totalJoinCost / groups.length,
      'byCategory': byCategory,
      'bySize': bySize,
    };
  }

  /// Create fallback group for missing IDs
  Group createFallbackGroup(String groupId, List<User> availableUsers) {
    return _generator.generateFallbackGroup(groupId, availableUsers);
  }

  /// Validate group data integrity
  bool validateGroupData() {
    final groups = _storage.getGroups();
    return MockStorageUtils.validateGroups(groups);
  }

  /// Get popular groups (by member count)
  List<Group> getPopularGroups({int limit = 10}) {
    final groups = _storage.getGroups();
    final sortedGroups = List<Group>.from(groups)
      ..sort((a, b) => b.memberCount.compareTo(a.memberCount));

    return sortedGroups.take(limit).toList();
  }

  /// Get recent groups (by creation date)
  List<Group> getRecentGroups({int limit = 10}) {
    final groups = _storage.getGroups();
    final sortedGroups = List<Group>.from(groups)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return sortedGroups.take(limit).toList();
  }

  /// Get groups starting soon
  List<Group> getGroupsStartingSoon({Duration within = const Duration(hours: 24)}) {
    final now = DateTime.now();
    final cutoff = now.add(within);

    return filterGroups(
      mealTimeAfter: now,
      mealTimeBefore: cutoff,
      isActive: true,
      hasAvailableSpots: true,
    );
  }
}