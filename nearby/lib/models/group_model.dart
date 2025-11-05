import 'dart:developer' as developer;

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
  final double? latitude;
  final double? longitude;
  final int groupPot; // Total pot amount in points
  final int joinCost; // Cost to join in points

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
    this.latitude,
    this.longitude,
    this.groupPot = 0,
    this.joinCost = 0,
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
    double? latitude,
    double? longitude,
    int? groupPot,
    int? joinCost,
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
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      groupPot: groupPot ?? this.groupPot,
      joinCost: joinCost ?? this.joinCost,
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
      'intent': intent,
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
      intent: json['intent'] as String,
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
    );
  }
}