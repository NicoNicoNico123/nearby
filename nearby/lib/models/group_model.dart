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
  final String intent;
  final int maxMembers;
  final List<String> memberIds;
  final List<String> waitingList;
  final bool isActive;
  final DateTime createdAt;
  final String? location;

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
    required this.intent,
    this.maxMembers = 10,
    this.memberIds = const [],
    this.waitingList = const [],
    this.isActive = true,
    required this.createdAt,
    this.location,
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
    String? intent,
    int? maxMembers,
    List<String>? memberIds,
    List<String>? waitingList,
    bool? isActive,
    DateTime? createdAt,
    String? location,
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
      intent: intent ?? this.intent,
      maxMembers: maxMembers ?? this.maxMembers,
      memberIds: memberIds ?? this.memberIds,
      waitingList: waitingList ?? this.waitingList,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      location: location ?? this.location,
    );
  }
}