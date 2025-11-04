class User {
  final String id;
  final String name;
  final int? age;
  final String bio;
  final String imageUrl;
  final List<String> interests;
  final bool isAvailable;
  final double? distance; // in miles
  final DateTime? lastSeen;
  final List<String> intents; // dining, romantic, networking, etc.

  const User({
    required this.id,
    required this.name,
    this.age,
    this.bio = '',
    this.imageUrl = '',
    this.interests = const [],
    this.isAvailable = true,
    this.distance,
    this.lastSeen,
    this.intents = const [],
  });

  User copyWith({
    String? id,
    String? name,
    int? age,
    String? bio,
    String? imageUrl,
    List<String>? interests,
    bool? isAvailable,
    double? distance,
    DateTime? lastSeen,
    List<String>? intents,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      bio: bio ?? this.bio,
      imageUrl: imageUrl ?? this.imageUrl,
      interests: interests ?? this.interests,
      isAvailable: isAvailable ?? this.isAvailable,
      distance: distance ?? this.distance,
      lastSeen: lastSeen ?? this.lastSeen,
      intents: intents ?? this.intents,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'bio': bio,
      'imageUrl': imageUrl,
      'interests': interests,
      'isAvailable': isAvailable,
      'distance': distance,
      'lastSeen': lastSeen?.toIso8601String(),
      'intents': intents,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as int?,
      bio: json['bio'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
      isAvailable: json['isAvailable'] as bool? ?? true,
      distance: (json['distance'] as num?)?.toDouble(),
      lastSeen: json['lastSeen'] != null
          ? DateTime.parse(json['lastSeen'] as String)
          : null,
      intents: (json['intents'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User{id: $id, name: $name, age: $age}';
  }
}