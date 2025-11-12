import 'dart:developer' as developer;
import '../generators/base_generator.dart';
import '../data/mock_constants.dart';
import '../data/mock_group_data.dart';
import '../../../models/group_model.dart';
import '../../../models/user_model.dart';
import '../mock_user.dart';

/// Group generator class for creating realistic mock groups
class GroupGenerator extends BaseGenerator {
  GroupGenerator({super.random});

  /// Generate a single group with random properties
  Group generateGroup(
    String groupId,
    List<User> availableUsers, {
    String? currentUserIdToExclude,
    String? creatorIdToExclude,
    User? forcedCreator,
    List<User>? forcedMembers,
  }) {
    final groupIndex = _extractGroupIndex(groupId);
    final name = randomItem(MockGroupData.groupNames);
    final description = randomItem(MockGroupData.groupDescriptions);
    final interest = randomItem(MockGroupData.groupInterests);
    final venue = randomItem(MockGroupData.venues);
    final location = randomItem(MockGroupData.locationDescriptions);
    final mealType = randomItem(MockGroupData.mealTypes);

    // Calculate capacity and availability
    var maxMembers = _calculateMaxMembers(groupIndex);
    final forcedMemberCount = (forcedMembers ?? [])
        .where((member) => forcedCreator == null || member.id != forcedCreator.id)
        .length;
    if (forcedMemberCount > 0 && forcedMemberCount + 1 > maxMembers) {
      maxMembers = forcedMemberCount + 1;
    }
    final additionalMembersCount = _calculateAvailableMembers(groupIndex, maxMembers);
    final requiredMembersCount = forcedMemberCount > additionalMembersCount
        ? forcedMemberCount
        : additionalMembersCount;
    final waitingListSize = randomInt(MockConstants.minWaitingListSize, MockConstants.maxWaitingListSize);

    // Select creator from available users (prefer premium/creator users)
    final creator = forcedCreator ?? _selectCreator(
      availableUsers,
      excludeUserId: creatorIdToExclude,
    );
    final members = _selectMembers(
      availableUsers,
      requiredMembersCount,
      creator,
      currentUserIdToExclude,
      forcedMembers: forcedMembers,
    );
    final limitedMembers = members.take((maxMembers - 1).clamp(0, members.length)).toList();

    // Generate group-specific data
    final joinCost = randomInt(MockConstants.minJoinCost, MockConstants.maxJoinCost);
    final joinCostFees = (joinCost * 0.1).round(); // 10% fee
    final pointsPerMember = MockConstants.pointsPerMember;
    final hostAdditionalPoints = randomInt(0, 500);
    final groupPot = limitedMembers.length * pointsPerMember + joinCost + hostAdditionalPoints;
    final imageUrl = generateImageUrl(width: 400, height: 300, seed: groupId);

    // Generate meeting details
    final meetingTime = randomDateTime(
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      minHour: 17, // 5 PM
      maxHour: 21, // 9 PM
    );

    // Generate coordinates around San Francisco
    final coordinates = randomCoordinates();
    final createdAt = randomDateInLastDays(90); // Created within last 90 days

    // Generate age and gender limits
    final ageRangeMin = randomInt(21, 35);
    final ageRangeMax = randomInt(ageRangeMin + 5, 65);
    final allowedGenders = _generateAllowedGenders();
    final genderLimits = _generateGenderLimits(maxMembers, allowedGenders);
    final allowedLanguages = _generateAllowedLanguages();

    final memberIds = ([creator.id, ...limitedMembers.map((m) => m.id)]).take(maxMembers).toList();

    // Debug: Log member selection
    if (currentUserIdToExclude != null) {
      developer.log('Group $groupId generation:', name: 'GroupGenerator');
      developer.log('  Current user to exclude: $currentUserIdToExclude', name: 'GroupGenerator');
      developer.log('  Creator: ${creator.id}', name: 'GroupGenerator');
      developer.log('  Members: ${members.map((m) => m.id).toList()}', name: 'GroupGenerator');
      developer.log('  Final memberIds: $memberIds', name: 'GroupGenerator');
      developer.log('  Contains current user: ${memberIds.contains(currentUserIdToExclude)}', name: 'GroupGenerator');
    }

    return Group(
      id: groupId,
      name: name,
      description: description,
      subtitle: '$mealType • $location • ${(maxMembers - (limitedMembers.length + 1)) > 0 ? "${maxMembers - (limitedMembers.length + 1)} spots left" : "Full"}',
      imageUrl: imageUrl,
      interests: [interest, mealType],
      memberCount: (limitedMembers.length + 1).clamp(1, maxMembers), // +1 for creator, ensure within limits
      category: interest,
      creatorId: creator.id,
      creatorName: creator.name,
      venue: venue,
      mealTime: meetingTime,
      maxMembers: maxMembers,
      memberIds: memberIds,
      waitingList: _generateWaitingList(availableUsers, waitingListSize, limitedMembers + [creator]),
      isActive: true,
      createdAt: createdAt,
      location: location,
      latitude: coordinates['latitude'],
      longitude: coordinates['longitude'],
      groupPot: groupPot,
      joinCost: joinCost,
      // Enhanced group features
      title: randomItem(MockGroupData.groupTitles),
      allowedGenders: allowedGenders,
      genderLimits: genderLimits,
      allowedLanguages: allowedLanguages,
      ageRangeMin: ageRangeMin,
      ageRangeMax: ageRangeMax,
      joinCostFees: joinCostFees,
      hostAdditionalPoints: hostAdditionalPoints,
    );
  }

  /// Generate a batch of groups
  List<Group> generateGroupBatch({
    required int count,
    required List<User> availableUsers,
    String? currentUserIdToExclude,
    MockUser? currentMockUser,
  }) {
    final groups = <Group>[];
    final users = List<User>.from(availableUsers);
    User? mockUser;
    int forcedCreatorCount = 0;
    int forcedMemberCount = 0;

    if (currentMockUser != null) {
      final user = currentMockUser.user;
      mockUser = user;
      if (!users.any((candidate) => candidate.id == user.id)) {
        users.add(user);
      }
      forcedCreatorCount = currentMockUser.activity.groupsCreated.clamp(0, count);
      forcedMemberCount = currentMockUser.activity.groupsJoined.clamp(0, count - forcedCreatorCount);
    }

    for (int i = 0; i < count; i++) {
      final groupId = '${MockConstants.groupIdPrefix}_${i + 1}';
      User? forcedCreator;
      List<User>? forcedMembers;
      String? memberExclusionId = currentUserIdToExclude;
      String? creatorExclusionId = currentUserIdToExclude;

      if (mockUser != null) {
        if (i < forcedCreatorCount) {
          forcedCreator = mockUser;
          memberExclusionId = null;
          creatorExclusionId = null;
        } else if (i < forcedCreatorCount + forcedMemberCount) {
          forcedMembers = [mockUser];
          memberExclusionId = null;
          creatorExclusionId = mockUser.id;
        } else {
          creatorExclusionId = mockUser.id;
        }
      }

      final group = generateGroup(
        groupId,
        users,
        currentUserIdToExclude: memberExclusionId,
        creatorIdToExclude: creatorExclusionId,
        forcedCreator: forcedCreator,
        forcedMembers: forcedMembers,
      );
      groups.add(group);
    }

    logGeneration('Generated $groups.length groups');
    return groups;
  }

  /// Generate a fallback group for missing IDs
  Group generateFallbackGroup(String groupId, List<User> availableUsers) {
    logWarning('Creating fallback group for ID: $groupId');

    final creator = availableUsers.isNotEmpty
        ? availableUsers.first
        : _createFallbackUser();

    final coordinates = randomCoordinates();

    return Group(
      id: groupId,
      name: 'Dining Group ${groupId.split('_').last}',
      description: 'A great group for dining experiences',
      subtitle: 'Dinner • San Francisco, CA • 8 spots left',
      imageUrl: generateImageUrl(width: 400, height: 300, seed: groupId),
      interests: ['Dining', 'Dinner'],
      memberCount: 1,
      category: 'Dining',
      creatorId: creator.id,
      creatorName: creator.name,
      venue: 'Local Restaurant',
      mealTime: randomDateTime(minHour: 18, maxHour: 20),
      maxMembers: MockConstants.defaultMaxGroupMembers,
      memberIds: [creator.id],
      waitingList: [],
      isActive: true,
      createdAt: DateTime.now(),
      location: 'San Francisco, CA',
      latitude: coordinates['latitude'],
      longitude: coordinates['longitude'],
      groupPot: MockConstants.pointsPerMember,
      joinCost: MockConstants.minJoinCost,
      title: 'Food & Friendship',
      allowedGenders: ['Male', 'Female', 'LGBTQ+'],
      genderLimits: const {},
      allowedLanguages: ['English'],
      ageRangeMin: 18,
      ageRangeMax: 100,
      joinCostFees: (MockConstants.minJoinCost * 0.1).round(),
      hostAdditionalPoints: 0,
    );
  }

  /// Extract group index from ID
  int _extractGroupIndex(String groupId) {
    final parts = groupId.split('_');
    if (parts.length >= 2) {
      return int.tryParse(parts.last) ?? 0;
    }
    return 0;
  }

  /// Calculate max members based on group index (for variety)
  int _calculateMaxMembers(int groupIndex) {
    // Create variety in group sizes
    final sizeCategories = [
      [2, 4],    // Intimate
      [5, 8],    // Small
      [9, 12],   // Medium
      [13, 20],  // Large
    ];

    final category = groupIndex % sizeCategories.length;
    final range = sizeCategories[category];
    return randomInt(range[0], range[1]);
  }

  /// Calculate additional members to select (excluding creator)
  int _calculateAvailableMembers(int groupIndex, int maxMembers) {
    // Create different availability patterns
    // This method returns how many additional members to select (creator is handled separately)
    if (groupIndex < MockConstants.goodAvailabilityGroups) {
      // Good availability: 30-70% of spots filled by additional members
      final totalMembers = (maxMembers * randomDouble(0.3, 0.7)).round();
      return (totalMembers - 1).clamp(0, maxMembers - 1); // -1 for creator, ensure >= 0
    } else if (groupIndex < MockConstants.limitedAvailabilityGroups + MockConstants.goodAvailabilityGroups) {
      // Limited availability: 10-30% of spots filled by additional members
      final totalMembers = (maxMembers * randomDouble(0.1, 0.3)).round();
      return (totalMembers - 1).clamp(0, maxMembers - 1); // -1 for creator, ensure >= 0
    } else {
      // Full capacity: 80-100% of spots filled by additional members
      final totalMembers = (maxMembers * randomDouble(0.8, 1.0)).round();
      return (totalMembers - 1).clamp(0, maxMembers - 1); // -1 for creator, ensure >= 0
    }
  }

  /// Select a creator from available users (prefer premium/creator)
  User _selectCreator(List<User> availableUsers, {String? excludeUserId}) {
    final filteredUsers = excludeUserId == null
        ? availableUsers
        : availableUsers.where((user) => user.id != excludeUserId).toList();

    if (filteredUsers.isEmpty) {
      return _createFallbackUser();
    }

    // Filter for premium and creator users first
    final priorityUsers = filteredUsers.where((u) => u.isPremium || u.userType == 'creator').toList();

    if (priorityUsers.isNotEmpty) {
      return randomItem(priorityUsers);
    }

    // Fall back to any user
    return randomItem(filteredUsers);
  }

  /// Select members for the group
  List<User> _selectMembers(
    List<User> availableUsers,
    int count,
    User creator,
    String? currentUserIdToExclude, {
    List<User>? forcedMembers,
  }) {
    if (availableUsers.isEmpty || count <= 0) {
      return (forcedMembers ?? [])
          .where((member) => member.id != creator.id)
          .toList();
    }

    final lookup = {for (final user in availableUsers) user.id: user};
    final selected = <User>[];
    final forcedIds = <String>{};

    for (final forced in forcedMembers ?? const <User>[]) {
      if (forced.id == creator.id) {
        continue;
      }
      if (forcedIds.add(forced.id)) {
        selected.add(lookup[forced.id] ?? forced);
      }
    }

    // Remove creator and current user (if specified and not the creator) from available users
    final otherUsers = availableUsers.where((u) {
      if (u.id == creator.id) {
        return false;
      }
      if (forcedIds.contains(u.id)) {
        return false;
      }
      if (currentUserIdToExclude != null && u.id == currentUserIdToExclude) {
        return false;
      }
      return true;
    }).toList();

    final remainingSlots = count - selected.length;

    if (remainingSlots <= 0) {
      return selected.take(count).toList();
    }

    if (otherUsers.length <= remainingSlots) {
      selected.addAll(otherUsers);
      return selected;
    }

    selected.addAll(randomItems(otherUsers, remainingSlots));
    return selected;
  }

  
  /// Create a fallback user for missing users
  User _createFallbackUser() {
    return User(
      id: 'fallback_user',
      name: 'Group Organizer',
      username: 'organizer',
      age: 30,
      bio: 'Passionate about bringing people together over great food',
      imageUrl: generateImageUrl(width: 200, height: 200, seed: 'organizer'),
      interests: ['#Dining', '#Social', '#Food'],
      isAvailable: true,
      distance: 5.0,
      lastSeen: DateTime.now(),
      intents: ['dining', 'friendship'],
      languages: ['English'],
      gender: 'Female',
      userType: 'premium',
      isPremium: true,
      isVerified: true,
      points: 1000,
    );
  }

  /// Generate waiting list
  List<String> _generateWaitingList(List<User> availableUsers, int size, List<User> excludeUsers) {
    if (availableUsers.isEmpty || size <= 0) {
      return [];
    }

    final excludeIds = excludeUsers.map((u) => u.id).toSet();
    final candidates = availableUsers.where((u) => !excludeIds.contains(u.id)).toList();

    if (candidates.length <= size) {
      return candidates.map((u) => u.id).toList();
    }

    return randomItems(candidates, size).map((u) => u.id).toList();
  }

  /// Generate allowed genders
  List<String> _generateAllowedGenders() {
    final allGenders = ['Male', 'Female', 'LGBTQ+'];
    final count = randomInt(1, allGenders.length);
    return randomItems(allGenders, count);
  }

  /// Generate gender limits based on max members and allowed genders
  Map<String, int> _generateGenderLimits(int maxMembers, List<String> allowedGenders) {
    final limits = <String, int>{};

    if (shouldInclude(0.6)) { // 60% of groups have gender limits
      final availableSlots = maxMembers - 1; // Reserve 1 for flexibility

      for (final gender in allowedGenders) {
        if (shouldInclude(0.5)) { // 50% chance of limit per gender
          limits[gender] = randomInt(1, (availableSlots / allowedGenders.length).ceil());
        }
      }
    }

    return limits;
  }

  /// Generate allowed languages
  List<String> _generateAllowedLanguages() {
    final commonLanguages = ['English', 'Spanish', 'Chinese (Mandarin)', 'French', 'German'];
    final count = randomInt(1, 3);
    final languages = randomItems(commonLanguages, count);

    // Ensure English is always included
    if (!languages.contains('English')) {
      languages[0] = 'English';
    }

    return languages;
  }
}