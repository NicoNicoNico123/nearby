import 'dart:developer' as developer;
import '../../models/user_model.dart';
import '../../models/group_model.dart';
import '../data/mock_user.dart';
import '../generators/user_generator.dart';
import '../generators/group_generator.dart';
import '../repositories/user_repository.dart';
import '../repositories/group_repository.dart';
import '../storage/mock_storage.dart';

/// Refactored MockDataService using modular architecture
/// Maintains backward compatibility while using new modular components
class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal() {
    _initializeServices();
  }

  late final UserRepository _userRepository;
  late final GroupRepository _groupRepository;
  late final UserGenerator _userGenerator;
  late final GroupGenerator _groupGenerator;
  late final MockStorageInterface _storage;

  // Preview user functionality
  User? _previewCurrentUser;
  MockUser? _currentMockUser;
  bool _isInitialized = false;

  /// Initialize the modular services
  void _initializeServices() {
    // Use the concrete MockStorage implementation directly
    _storage = MockStorage();
    _userGenerator = UserGenerator();
    _groupGenerator = GroupGenerator();

    // Create repositories with interface type
    _userRepository = UserRepository(
      generator: _userGenerator,
      storage: _storage,
    );
    _groupRepository = GroupRepository(
      generator: _groupGenerator,
      storage: _storage,
    );
  }

  /// Initialize mock data if needed
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final isFirstLaunch = await _storage.isFirstLaunch();

      if (isFirstLaunch) {
        await _generateInitialData();
        await _storage.setFirstLaunch(false);
      } else {
        // Validate existing data
        final users = _userRepository.getAllUsers();
        final groups = _groupRepository.getAllGroups();

        if (users.isEmpty || groups.isEmpty) {
          await _generateInitialData();
        }
      }

      _isInitialized = true;
      developer.log('MockDataService initialized successfully', name: 'MockDataService');
    } catch (e) {
      developer.log('Failed to initialize MockDataService: $e', name: 'MockDataService', level: 1000);
      // Generate fallback data if initialization fails
      await _generateInitialData();
      _isInitialized = true;
    }
  }

  /// Generate initial mock data
  Future<void> _generateInitialData() async {
    // Generate users first
    await _userRepository.generateUsers(
      normalCount: 12,
      premiumCount: 5,
      creatorCount: 2,
      adminCount: 1,
    );

    // Then generate groups using the created users
    final users = _userRepository.getAllUsers();
    final currentUser = getCurrentUser();
    await _groupRepository.generateGroups(
      count: 15,
      availableUsers: users,
      currentUserIdToExclude: currentUser.id,
      currentMockUser: _currentMockUser,
    );

    developer.log('Generated initial mock data', name: 'MockDataService');
  }

  // ==========================================
  // USER METHODS (Maintaining backward compatibility)
  // ==========================================

  /// Get all users
  List<User> getUsers() {
    if (!_isInitialized) {
      // Synchronous initialization for backward compatibility
      _initializeServices();
      _generateInitialData().then((_) => _isInitialized = true);
    }
    return _userRepository.getAllUsers();
  }

  /// Get available users with optional distance filter
  List<User> getAvailableUsers({double? maxDistance}) {
    return _userRepository.filterUsers(
      isAvailable: true,
      maxDistance: maxDistance,
    );
  }

  /// Get users by intent
  List<User> getUsersByIntent(String intent) {
    return _userRepository.filterUsers(
      intents: [intent],
      isAvailable: true,
    );
  }

  /// Get user by ID with fallback
  User? getUserById(String id) {
    final user = _userRepository.getUserById(id);
    if (user != null) {
      return user;
    }

    // Create fallback user if not found
    developer.log('User not found: $id, creating fallback', name: 'MockDataService', level: 900);
    return _userRepository.createFallbackUser(id);
  }

  /// Get current user (supports preview functionality)
  User getCurrentUser() {
    // Check if a specific user type is set for preview
    if (_previewCurrentUser != null) {
      return _previewCurrentUser!;
    }

    // Return the current mock user or default
    if (_currentMockUser != null) {
      return _currentMockUser!.user;
    }

    // Return the default current user from generator
    return _userGenerator.generateCurrentUser();
  }

  /// Get current mock user with activity data
  MockUser? getCurrentMockUser() {
    return _currentMockUser;
  }

  /// Search users by query
  List<User> searchUsers(String query) {
    return _userRepository.searchUsers(query);
  }

  // ==========================================
  // PREVIEW USER METHODS
  // ==========================================

  /// Set preview user type
  void setPreviewUserType(String userType, {int? userIndex}) {
    final users = _userRepository.getUsersByType(userType);

    if (users.isNotEmpty) {
      final index = userIndex ?? 0;
      if (index < users.length) {
        _previewCurrentUser = users[index];
        _currentMockUser = MockUser(
          user: users[index],
          scenario: MockUserScenario.normal,
          activity: MockUserActivity(
            groupsCreated: 0,
            groupsCreatedLimit: 5,
            groupsJoined: 0,
            groupsJoinedLimit: 20,
            pointsSpent: 0,
            pointsRemaining: users[index].points,
          ),
        );
        developer.log('Set preview user: $userType ($index)', name: 'MockDataService');
        _regenerateGroups();
      }
    }
  }

  /// Set preview normal user
  void setPreviewNormalUser({int index = 0}) {
    setPreviewUserType('normal', userIndex: index);
  }

  /// Set preview premium user
  void setPreviewPremiumUser({int index = 0}) {
    setPreviewUserType('premium', userIndex: index);
  }

  /// Set preview creator user
  void setPreviewCreatorUser({int index = 0}) {
    setPreviewUserType('creator', userIndex: index);
  }

  /// Set preview admin user
  void setPreviewAdminUser({int index = 0}) {
    setPreviewUserType('admin', userIndex: index);
  }

  /// Set preview normal user with group
  void setPreviewNormalUserWithGroup() {
    final users = _userRepository.getUsersByType('normal');
    if (users.isNotEmpty) {
      final user = users.first;
      _currentMockUser = MockUser(
        user: user,
        scenario: MockUserScenario.normal,
        activity: MockUserActivity(
          groupsCreated: 0,
          groupsCreatedLimit: 1,
          groupsJoined: 0,
          groupsJoinedLimit: 3,
          pointsSpent: 0,
          pointsRemaining: user.points,
        ),
      );
      developer.log('Set Normal User scenario: ${_currentMockUser!.user.name}', name: 'MockDataService');
      _regenerateGroups();
    }
  }

  /// Set preview premium user with groups
  void setPreviewPremiumUserWithGroups() {
    final users = _userRepository.getPremiumUsers();
    if (users.isNotEmpty) {
      final user = users.first;
      _currentMockUser = MockUser(
        user: user,
        scenario: MockUserScenario.premium,
        activity: MockUserActivity(
          groupsCreated: 2,
          groupsCreatedLimit: 10,
          groupsJoined: 3,
          groupsJoinedLimit: 50,
          pointsSpent: 200,
          pointsRemaining: user.points - 200,
        ),
      );
      developer.log('Set Premium User scenario: ${_currentMockUser!.user.name}', name: 'MockDataService');
      _regenerateGroups();
    }
  }

  /// Set preview guest user
  void setPreviewGuestUser() {
    final user = _userGenerator.generateFallbackUser('guest_user');
    _currentMockUser = MockUser(
      user: user,
      scenario: MockUserScenario.normal,
      activity: MockUserActivity(
        groupsCreated: 0,
        groupsCreatedLimit: 0,
        groupsJoined: 0,
        groupsJoinedLimit: 1,
        pointsSpent: 0,
        pointsRemaining: user.points,
      ),
    );
    developer.log('Set Guest User scenario', name: 'MockDataService');
    _regenerateGroups();
  }

  /// Set preview godmode user
  void setPreviewGodmodeUser() {
    final user = User(
      id: 'godmode_user',
      name: 'Admin User',
      username: 'admin',
      age: 30,
      bio: 'System administrator with unlimited access',
      imageUrl: 'https://picsum.photos/200/200?random=admin',
      interests: ['#Admin', '#System', '#Management'],
      isAvailable: true,
      userType: 'admin',
      isPremium: true,
      isVerified: true,
      points: 999999,
    );

    _currentMockUser = MockUser(
      user: user,
      scenario: MockUserScenario.godMode,
      activity: MockUserActivity(
        groupsCreated: 999,
        groupsCreatedLimit: 999,
        groupsJoined: 999,
        groupsJoinedLimit: 999,
        pointsSpent: 0,
        pointsRemaining: 999999,
      ),
    );
    developer.log('Set Godmode User scenario: ${_currentMockUser!.user.name}', name: 'MockDataService');
    _regenerateGroups();
  }

  /// Set preview custom user
  void setPreviewCustomUser({
    required String name,
    required String username,
    required int age,
    required String bio,
    required List<String> interests,
    String userType = 'normal',
    bool isPremium = false,
    bool isVerified = false,
    int points = 100,
    MockUserActivity? activity,
  }) {
    final user = User(
      id: 'custom_user',
      name: name,
      username: username,
      age: age,
      bio: bio,
      imageUrl: 'https://picsum.photos/200/200?random=custom',
      interests: interests,
      isAvailable: true,
      userType: userType,
      isPremium: isPremium,
      isVerified: isVerified,
      points: points,
    );

    _currentMockUser = MockUser(
      user: user,
      scenario: MockUserScenario.normal,
      activity: activity ?? MockUserActivity(
        groupsCreated: 0,
        groupsCreatedLimit: 5,
        groupsJoined: 0,
        groupsJoinedLimit: 20,
        pointsSpent: 0,
        pointsRemaining: points,
      ),
    );
    developer.log('Set Custom User scenario: ${_currentMockUser!.user.name}', name: 'MockDataService');
    _regenerateGroups();
  }

  /// Reset preview user
  void resetPreviewUser() {
    _previewCurrentUser = null;
    _currentMockUser = null;
    developer.log('Reset preview user', name: 'MockDataService');
    _regenerateGroups();
  }

  /// Get available user types for preview
  List<String> getAvailableUserTypes() {
    return ['normal', 'premium', 'creator', 'admin'];
  }

  /// Get users by type
  List<User> getUsersByType(String userType) {
    return _userRepository.getUsersByType(userType);
  }

  // ==========================================
  // GROUP METHODS (Maintaining backward compatibility)
  // ==========================================

  /// Get all groups
  List<Group> getGroups({bool forceRefresh = false, bool forceRegenerate = false}) {
    if (!_isInitialized) {
      _initializeServices();
      _generateInitialData().then((_) => _isInitialized = true);
    }

    if (forceRegenerate) {
      _regenerateGroups();
    }

    return _groupRepository.getAllGroups();
  }

  /// Get group by ID with fallback
  Group? getGroupById(String id) {
    final group = _groupRepository.getGroupById(id);
    if (group != null) {
      return group;
    }

    // Create fallback group if not found
    developer.log('Group not found: $id, creating fallback', name: 'MockDataService', level: 900);
    final users = _userRepository.getAllUsers();
    return _groupRepository.createFallbackGroup(id, users);
  }

  /// Search groups by query
  List<Group> searchGroups(String query) {
    return _groupRepository.searchGroups(query);
  }

  /// Get groups by interest
  List<Group> getGroupsByInterest(String interest) {
    return _groupRepository.filterGroups(interests: [interest]);
  }

  /// Get groups by interests
  List<Group> getGroupsByInterests(List<String> interests) {
    return _groupRepository.filterGroups(interests: interests);
  }

  /// Get groups by creator
  List<Group> getGroupsByCreator(String creatorId) {
    return _groupRepository.getGroupsByCreator(creatorId);
  }

  /// Get active groups
  List<Group> getActiveGroups() {
    return _groupRepository.getActiveGroups();
  }

  /// Get groups with available spots
  List<Group> getGroupsWithAvailableSpots() {
    return _groupRepository.getGroupsWithAvailableSpots();
  }

  /// Get groups by age range
  List<Group> getGroupsByAgeRange(int minAge, int maxAge) {
    return _groupRepository.filterGroups(
      minAge: minAge,
      maxAge: maxAge,
    );
  }

  /// Get groups by gender
  List<Group> getGroupsByGender(String gender) {
    return _groupRepository.filterGroups(
      allowedGenders: [gender],
    );
  }

  /// Get groups by location
  List<Group> getGroupsByLocation(String location) {
    return _groupRepository.getGroupsByLocation(location);
  }

  /// Get upcoming groups
  List<Group> getUpcomingGroups() {
    return _groupRepository.getUpcomingGroups();
  }

  /// Get random groups
  List<Group> getRandomGroups(int count) {
    return _groupRepository.getRandomGroups(count);
  }

  // ==========================================
  // UTILITY METHODS
  // ==========================================

  /// Regenerate all groups
  void _regenerateGroups() {
    final users = _userRepository.getAllUsers();
    final currentUser = getCurrentUser();
    final groupCount = _groupRepository.getAllGroups().length;
    final targetCount = groupCount == 0 ? 15 : groupCount;
    _groupRepository.generateGroups(
      count: targetCount,
      availableUsers: users,
      currentUserIdToExclude: currentUser.id,
      currentMockUser: _currentMockUser,
    );
    developer.log('Regenerated groups', name: 'MockDataService');
  }

  /// Force regeneration of all data
  Future<void> forceRegenerateAllData() async {
    await _storage.clearAllData();
    await _generateInitialData();
    developer.log('Force regenerated all data', name: 'MockDataService');
  }

  /// Get user statistics
  Map<String, dynamic> getUserStatistics() {
    return _userRepository.getUserStatistics();
  }

  /// Get group statistics
  Map<String, dynamic> getGroupStatistics() {
    return _groupRepository.getGroupStatistics();
  }

  /// Validate data integrity
  bool validateDataIntegrity() {
    final userStats = _userRepository.getUserStatistics();
    final groupStats = _groupRepository.getGroupStatistics();

    return userStats['total'] > 0 && groupStats['total'] > 0;
  }

  /// Get popular groups
  List<Group> getPopularGroups({int limit = 10}) {
    return _groupRepository.getPopularGroups(limit: limit);
  }

  /// Get recent groups
  List<Group> getRecentGroups({int limit = 10}) {
    return _groupRepository.getRecentGroups(limit: limit);
  }

  /// Get groups starting soon
  List<Group> getGroupsStartingSoon({Duration within = const Duration(hours: 24)}) {
    return _groupRepository.getGroupsStartingSoon(within: within);
  }

  /// Get filtered groups (for compatibility with existing code)
  List<Group> getFilteredGroups({
    List<String>? interests,
    double? maxDistance,
    double? minAge,
    double? maxAge,
    List<String>? genders,
    List<String>? languages,
    bool? hasAvailableSpots,
    int? minJoinCost,
    int? maxJoinCost,
    String? location,
  }) {
    return filterGroups(
      interests: interests,
      minAge: minAge?.toInt(),
      maxAge: maxAge?.toInt(),
      allowedGenders: genders,
      allowedLanguages: languages,
      hasAvailableSpots: hasAvailableSpots,
      minJoinCost: minJoinCost,
      maxJoinCost: maxJoinCost,
      location: location,
    );
  }

  /// Filter groups with multiple criteria
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
    return _groupRepository.filterGroups(
      category: category,
      creatorId: creatorId,
      interests: interests,
      allowedGenders: allowedGenders,
      minAge: minAge,
      maxAge: maxAge,
      allowedLanguages: allowedLanguages,
      minJoinCost: minJoinCost,
      maxJoinCost: maxJoinCost,
      minMaxMembers: minMaxMembers,
      maxMaxMembers: maxMaxMembers,
      isActive: isActive,
      isFull: isFull,
      hasAvailableSpots: hasAvailableSpots,
      location: location,
      mealTimeAfter: mealTimeAfter,
      mealTimeBefore: mealTimeBefore,
    );
  }

  /// Filter users with multiple criteria
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
    return _userRepository.filterUsers(
      minAge: minAge,
      maxAge: maxAge,
      gender: gender,
      userType: userType,
      isPremium: isPremium,
      isVerified: isVerified,
      interests: interests,
      intents: intents,
      maxDistance: maxDistance,
      isAvailable: isAvailable,
    );
  }

  // ========== USER HOUSE SPECIFIC METHODS ==========

  /// Get all USER HOUSE groups
  List<Group> getUserHouseGroups() {
    return _groupRepository.getAllGroups()
        .where((group) => group.isUserHouse)
        .toList();
  }

  /// Get USER HOUSE groups by category
  List<Group> getUserHouseGroupsByCategory(String category) {
    return _groupRepository.getAllGroups()
        .where((group) => group.isUserHouse && group.userHouseCategory == category)
        .toList();
  }

  /// Get USER HOUSE groups that match user's hashtags
  List<Group> getUserHouseGroupsByHashtags(List<String> userHashtags) {
    return _groupRepository.getAllGroups()
        .where((group) {
          if (!group.isUserHouse) return false;

          // Check if user has any required hashtags
          final hasRequiredHashtag = group.requiredHashtags
              .any((requiredTag) => userHashtags.contains(requiredTag));

          // Check if user has any preferred hashtags
          final hasPreferredHashtag = group.preferredHashtags
              .any((preferredTag) => userHashtags.contains(preferredTag));

          return hasRequiredHashtag || hasPreferredHashtag;
        })
        .toList();
  }

  /// Get USER HOUSE groups compatible with a specific user
  List<Group> getUserHouseCompatibleGroups(String userId) {
    final user = getUserById(userId);
    if (user == null) return [];

    return getUserHouseGroupsByHashtags(user.hashtags);
  }

  /// Generate USER HOUSE groups and add them to the system
  Future<void> generateUserHouseGroups({
    int count = 8,
    Map<String, int>? categoryDistribution,
  }) async {
    final users = _userRepository.getAllUsers();
    final currentUser = getCurrentUser();

    // Default category distribution if not provided
    final distribution = categoryDistribution ?? {
      'Professional': 2,
      'Social': 2,
      'Hobby': 2,
      'Lifestyle': 2,
    };

    final generatedGroups = <Group>[];
    int groupIdCounter = 1;

    for (final entry in distribution.entries) {
      final category = entry.key;
      final categoryCount = entry.value;

      for (int i = 0; i < categoryCount; i++) {
        final groupId = 'user_house_${groupIdCounter++}';

        final group = _groupGenerator.generateUserHouseGroup(
          groupId,
          users,
          userHouseCategory: category,
          currentUserIdToExclude: currentUser.id,
        );

        generatedGroups.add(group);
      }
    }

    // Add all generated groups to storage
    for (final group in generatedGroups) {
      await _groupRepository.addGroup(group);
    }

    developer.log('Generated ${generatedGroups.length} USER HOUSE groups', name: 'MockDataService');
  }

  /// Enhanced getFilteredGroups with USER HOUSE support
  List<Group> getFilteredGroupsWithUserHouse({
    List<String>? interests,
    double? maxDistance,
    double? minAge,
    double? maxAge,
    List<String>? genders,
    List<String>? languages,
    bool? hasAvailableSpots,
    int? minJoinCost,
    int? maxJoinCost,
    String? location,
    // USER HOUSE specific filters
    bool? isUserHouse,
    String? userHouseCategory,
    List<String>? requiredHashtags,
    List<String>? preferredHashtags,
    String? userId, // For compatibility matching
  }) {
    var groups = _groupRepository.getAllGroups();

    // Apply USER HOUSE filters
    if (isUserHouse != null) {
      groups = groups.where((group) => group.isUserHouse == isUserHouse).toList();
    }

    if (userHouseCategory != null) {
      groups = groups.where((group) => group.userHouseCategory == userHouseCategory).toList();
    }

    if (requiredHashtags != null && requiredHashtags.isNotEmpty) {
      groups = groups.where((group) {
        return requiredHashtags.any((requiredTag) =>
            group.requiredHashtags.contains(requiredTag));
      }).toList();
    }

    if (preferredHashtags != null && preferredHashtags.isNotEmpty) {
      groups = groups.where((group) {
        return preferredHashtags.any((preferredTag) =>
            group.preferredHashtags.contains(preferredTag));
      }).toList();
    }

    // Apply user compatibility filter
    if (userId != null) {
      final user = getUserById(userId);
      if (user != null) {
        groups = groups.where((group) {
          if (!group.isUserHouse) return true; // Non-USER HOUSE groups don't need compatibility

          final userHashtags = user.hashtags;
          final hasRequiredMatch = group.requiredHashtags
              .any((requiredTag) => userHashtags.contains(requiredTag));
          final hasPreferredMatch = group.preferredHashtags
              .any((preferredTag) => userHashtags.contains(preferredTag));

          return hasRequiredMatch || hasPreferredMatch;
        }).toList();
      }
    }

    // Apply existing filters by creating a custom filter for groups
    if (interests != null && interests.isNotEmpty) {
      groups = groups.where((group) =>
          interests.any((interest) => group.interests.contains(interest))).toList();
    }

    if (minAge != null) {
      groups = groups.where((group) => group.ageRangeMin >= minAge!.toInt()).toList();
    }

    if (maxAge != null) {
      groups = groups.where((group) => group.ageRangeMax <= maxAge!.toInt()).toList();
    }

    if (genders != null && genders.isNotEmpty) {
      groups = groups.where((group) =>
          genders.any((gender) => group.allowedGenders.contains(gender))).toList();
    }

    if (languages != null && languages.isNotEmpty) {
      groups = groups.where((group) =>
          languages.any((language) => group.allowedLanguages.contains(language))).toList();
    }

    if (hasAvailableSpots == true) {
      groups = groups.where((group) => !group.isFull).toList();
    }

    if (minJoinCost != null) {
      groups = groups.where((group) => group.joinCost >= minJoinCost!).toList();
    }

    if (maxJoinCost != null) {
      groups = groups.where((group) => group.joinCost <= maxJoinCost!).toList();
    }

    if (location != null) {
      groups = groups.where((group) => group.location?.toLowerCase().contains(location.toLowerCase()) == true).toList();
    }

    return groups;
  }

  /// Get USER HOUSE statistics
  Map<String, dynamic> getUserHouseStatistics() {
    final userHouseGroups = getUserHouseGroups();
    final totalGroups = _groupRepository.getAllGroups().length;

    final categoryStats = <String, int>{};
    for (final group in userHouseGroups) {
      categoryStats[group.userHouseCategory] = (categoryStats[group.userHouseCategory] ?? 0) + 1;
    }

    return {
      'totalUserHouseGroups': userHouseGroups.length,
      'totalGroups': totalGroups,
      'userHousePercentage': totalGroups > 0 ? (userHouseGroups.length / totalGroups * 100).round() : 0,
      'categoryBreakdown': categoryStats,
      'averageMemberCount': userHouseGroups.isNotEmpty
          ? (userHouseGroups.map((g) => g.memberCount).reduce((a, b) => a + b) / userHouseGroups.length).round()
          : 0,
      'averageJoinCost': userHouseGroups.isNotEmpty
          ? (userHouseGroups.map((g) => g.joinCost).reduce((a, b) => a + b) / userHouseGroups.length).round()
          : 0,
    };
  }

  /// Update existing groups to include USER HOUSE data (for migration)
  Future<void> migrateGroupsToUserHouse() async {
    final allGroups = _groupRepository.getAllGroups();
    bool needsUpdate = false;

    for (final group in allGroups) {
      if (!group.isUserHouse && shouldConvertToUserHouse(group)) {
        // Convert existing group to USER HOUSE
        final updatedGroup = group.copyWith(
          isUserHouse: true,
          requiredHashtags: generateRequiredHashtagsForGroup(group),
          preferredHashtags: generatePreferredHashtagsForGroup(group),
          userHouseCategory: determineUserHouseCategory(group),
        );

        await _groupRepository.updateGroup(updatedGroup);
        needsUpdate = true;
      }
    }

    if (needsUpdate) {
      developer.log('Migrated existing groups to USER HOUSE format', name: 'MockDataService');
    }
  }

  /// Helper method to determine if a group should be converted to USER HOUSE
  bool shouldConvertToUserHouse(Group group) {
    // Convert groups that seem to have clear professional/social focus
    final professionalKeywords = ['networking', 'professional', 'business', 'career', 'tech'];
    final socialKeywords = ['social', 'friends', 'community', 'meet', 'connection'];

    final lowerName = group.name.toLowerCase();
    final lowerDescription = group.description.toLowerCase();

    return professionalKeywords.any((keyword) =>
            lowerName.contains(keyword) || lowerDescription.contains(keyword)) ||
           socialKeywords.any((keyword) =>
            lowerName.contains(keyword) || lowerDescription.contains(keyword));
  }

  /// Generate required hashtags for an existing group
  List<String> generateRequiredHashtagsForGroup(Group group) {
    final hashtags = <String>[];
    final lowerName = group.name.toLowerCase();

    if (lowerName.contains('tech') || lowerName.contains('developer') || lowerName.contains('engineer')) {
      hashtags.addAll(['#Tech', '#Engineering']);
    }
    if (lowerName.contains('design') || lowerName.contains('creative')) {
      hashtags.addAll(['#Design', '#Creative']);
    }
    if (lowerName.contains('social') || lowerName.contains('network')) {
      hashtags.addAll(['#Social', '#Networking']);
    }

    // Add category as hashtag
    if (group.category != null) {
      hashtags.add('#${group.category}');
    }

    return hashtags;
  }

  /// Generate preferred hashtags for an existing group
  List<String> generatePreferredHashtagsForGroup(Group group) {
    final hashtags = <String>[];

    // Add interests as preferred hashtags
    for (final interest in group.interests) {
      hashtags.add('#$interest');
    }

    return hashtags;
  }

  /// Determine USER HOUSE category for an existing group
  String determineUserHouseCategory(Group group) {
    final lowerName = group.name.toLowerCase();

    if (lowerName.contains('tech') || lowerName.contains('business') || lowerName.contains('career')) {
      return 'Professional';
    }
    if (lowerName.contains('hobby') || lowerName.contains('art') || lowerName.contains('creative')) {
      return 'Hobby';
    }
    if (lowerName.contains('wellness') || lowerName.contains('health') || lowerName.contains('lifestyle')) {
      return 'Lifestyle';
    }

    return 'Social'; // Default to Social
  }
}