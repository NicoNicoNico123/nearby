class Group {
  final String id;
  final String name;
  final String description;
  final String subtitle;
  final String imageUrl;
  final List<String> interests;
  final int memberCount;
  final String? category;
  final String creatorId;
  final String creatorName;
  final String venue;
  final DateTime mealTime;
    final int maxMembers;
  final List<String> memberIds;
  final List<String> waitingList;
  final bool isActive;
  final DateTime createdAt;
  final String? location;
  final double? latitude;
  final double? longitude;
  final int groupPot; // Total pot amount in points
  final int joinCost; // Cost to join in points

  // New fields for Phase 1 enhancement
  final String title; // Group title field
  final List<String> allowedGenders; // Multiple gender options allowed
  final Map<String, int> genderLimits; // Gender-based seat reservations
  final List<String> allowedLanguages; // Language requirements
  final int ageRangeMin; // Minimum age requirement
  final int ageRangeMax; // Maximum age requirement
  final int joinCostFees; // Additional join cost fees
  final int hostAdditionalPoints; // Manually added points by host

  // USER HOUSE fields for hashtag matching
  final bool isUserHouse; // Whether this is a USER HOUSE group
  final List<String> requiredHashtags; // Required hashtags for matching
  final List<String> preferredHashtags; // Preferred hashtags for matching
  final String userHouseCategory; // USER HOUSE category (Professional, Social, Hobby, Lifestyle)

  Group({
    required this.id,
    required this.name,
    required this.description,
    required this.subtitle,
    required this.imageUrl,
    required this.interests,
    required this.memberCount,
    this.category,
    required this.creatorId,
    required this.creatorName,
    required this.venue,
    required this.mealTime,
        this.maxMembers = 10,
    this.memberIds = const [],
    this.waitingList = const [],
    this.isActive = true,
    required this.createdAt,
    this.location,
    this.latitude,
    this.longitude,
    this.groupPot = 0,
    this.joinCost = 0,
    // New fields with default values
    this.title = '',
    this.allowedGenders = const ['Male', 'Female', 'LGBTQ+'],
    this.genderLimits = const {},
    this.allowedLanguages = const [],
    this.ageRangeMin = 18,
    this.ageRangeMax = 100,
    this.joinCostFees = 0,
    this.hostAdditionalPoints = 0,
    // USER HOUSE fields with defaults
    this.isUserHouse = false,
    this.requiredHashtags = const [],
    this.preferredHashtags = const [],
    this.userHouseCategory = '',
  });

  // Check if group is full
  bool get isFull => memberCount >= maxMembers;

  // Check if current user is a member
  bool isMember(String userId) => memberIds.contains(userId);

  // Check if current user is creator
  bool isCreator(String userId) => creatorId == userId;

  // Check if current user is in waiting list
  bool isInWaitingList(String userId) => waitingList.contains(userId);

  // Get available spots
  int get availableSpots => maxMembers - memberCount;

  // Create a copy with updated data
  Group copyWith({
    String? id,
    String? name,
    String? description,
    String? subtitle,
    String? imageUrl,
    List<String>? interests,
    int? memberCount,
    String? category,
    String? creatorId,
    String? creatorName,
    String? venue,
    DateTime? mealTime,
        int? maxMembers,
    List<String>? memberIds,
    List<String>? waitingList,
    bool? isActive,
    DateTime? createdAt,
    String? location,
    double? latitude,
    double? longitude,
    int? groupPot,
    int? joinCost,
    // New fields
    String? title,
    List<String>? allowedGenders,
    Map<String, int>? genderLimits,
    List<String>? allowedLanguages,
    int? ageRangeMin,
    int? ageRangeMax,
    int? joinCostFees,
    int? hostAdditionalPoints,
    // USER HOUSE fields
    bool? isUserHouse,
    List<String>? requiredHashtags,
    List<String>? preferredHashtags,
    String? userHouseCategory,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      subtitle: subtitle ?? this.subtitle,
      imageUrl: imageUrl ?? this.imageUrl,
      interests: interests ?? this.interests,
      memberCount: memberCount ?? this.memberCount,
      category: category ?? this.category,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      venue: venue ?? this.venue,
      mealTime: mealTime ?? this.mealTime,
            maxMembers: maxMembers ?? this.maxMembers,
      memberIds: memberIds ?? this.memberIds,
      waitingList: waitingList ?? this.waitingList,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      groupPot: groupPot ?? this.groupPot,
      joinCost: joinCost ?? this.joinCost,
      // New fields
      title: title ?? this.title,
      allowedGenders: allowedGenders ?? this.allowedGenders,
      genderLimits: genderLimits ?? this.genderLimits,
      allowedLanguages: allowedLanguages ?? this.allowedLanguages,
      ageRangeMin: ageRangeMin ?? this.ageRangeMin,
      ageRangeMax: ageRangeMax ?? this.ageRangeMax,
      joinCostFees: joinCostFees ?? this.joinCostFees,
      hostAdditionalPoints: hostAdditionalPoints ?? this.hostAdditionalPoints,
      // USER HOUSE fields
      isUserHouse: isUserHouse ?? this.isUserHouse,
      requiredHashtags: requiredHashtags ?? this.requiredHashtags,
      preferredHashtags: preferredHashtags ?? this.preferredHashtags,
      userHouseCategory: userHouseCategory ?? this.userHouseCategory,
    );
  }

  // Serialization methods for persistence
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'interests': interests,
      'memberCount': memberCount,
      'category': category,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'venue': venue,
      'mealTime': mealTime.toIso8601String(),
            'maxMembers': maxMembers,
      'memberIds': memberIds,
      'waitingList': waitingList,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'groupPot': groupPot,
      'joinCost': joinCost,
      // New fields
      'title': title,
      'allowedGenders': allowedGenders,
      'genderLimits': genderLimits,
      'allowedLanguages': allowedLanguages,
      'ageRangeMin': ageRangeMin,
      'ageRangeMax': ageRangeMax,
      'joinCostFees': joinCostFees,
      'hostAdditionalPoints': hostAdditionalPoints,
      // USER HOUSE fields
      'isUserHouse': isUserHouse,
      'requiredHashtags': requiredHashtags,
      'preferredHashtags': preferredHashtags,
      'userHouseCategory': userHouseCategory,
    };
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      subtitle: json['subtitle'] as String,
      imageUrl: json['imageUrl'] as String,
      interests: List<String>.from(json['interests'] as List),
      memberCount: json['memberCount'] as int,
      category: json['category'] as String?,
      creatorId: json['creatorId'] as String,
      creatorName: json['creatorName'] as String,
      venue: json['venue'] as String,
      mealTime: DateTime.parse(json['mealTime'] as String),
            maxMembers: json['maxMembers'] as int? ?? 10,
      memberIds: List<String>.from(json['memberIds'] as List? ?? []),
      waitingList: List<String>.from(json['waitingList'] as List? ?? []),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      location: json['location'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      groupPot: json['groupPot'] as int? ?? 0,
      joinCost: json['joinCost'] as int? ?? 0,
      // New fields with defaults for backward compatibility
      title: json['title'] as String? ?? '',
      allowedGenders: (json['allowedGenders'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? ['Male', 'Female', 'LGBTQ+'],
      genderLimits: (json['genderLimits'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value as int),
      ) ?? {},
      allowedLanguages: (json['allowedLanguages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      ageRangeMin: json['ageRangeMin'] as int? ?? 18,
      ageRangeMax: json['ageRangeMax'] as int? ?? 100,
      joinCostFees: json['joinCostFees'] as int? ?? 0,
      hostAdditionalPoints: json['hostAdditionalPoints'] as int? ?? 0,
      // USER HOUSE fields with defaults for backward compatibility
      isUserHouse: json['isUserHouse'] as bool? ?? false,
      requiredHashtags: (json['requiredHashtags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      preferredHashtags: (json['preferredHashtags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      userHouseCategory: json['userHouseCategory'] as String? ?? '',
    );
  }
}