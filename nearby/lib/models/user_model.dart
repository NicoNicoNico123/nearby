class User {
  final String id;
  final String name;
  final String? username; // Handle like @alexandra_d
  final int? age;
  final String bio;
  final String imageUrl;
  final List<String> interests;
  final bool isAvailable;
  final double? distance; // in miles
  final DateTime? lastSeen;
  final List<String> intents; // dining, romantic, networking, etc.

  // New optional fields for profile enhancement
  final String? work; // Work/occupation
  final String? education; // Education background
  final String? drinkingHabits; // Drinking habits preferences
  final String? mealInterest; // Meal interest preferences
  final String? starSign; // Star sign/zodiac
  final List<String> languages; // Languages spoken (required field)
  final String gender; // Gender field - standardized options: Male, Female, LGBTQ+

  // User type and subscription fields
  final String userType; // 'normal', 'premium', 'creator', 'admin'
  final bool isPremium; // Quick check for premium features
  final String? subscriptionLevel; // 'basic', 'premium', 'vip', etc.
  final DateTime? subscriptionExpiry; // When premium expires
  final int points; // User's points balance
  final bool isVerified; // Verified account badge

  const User({
    required this.id,
    required this.name,
    this.username,
    this.age,
    this.bio = '',
    this.imageUrl = '',
    this.interests = const [],
    this.isAvailable = true,
    this.distance,
    this.lastSeen,
    this.intents = const [],
    // New optional fields
    this.work,
    this.education,
    this.drinkingHabits,
    this.mealInterest,
    this.starSign,
    this.languages = const [],
    this.gender = 'Female', // Default to one of the three standardized options
    // User type and subscription defaults
    this.userType = 'normal',
    this.isPremium = false,
    this.subscriptionLevel,
    this.subscriptionExpiry,
    this.points = 100, // Default starting points
    this.isVerified = false,
  });

  User copyWith({
    String? id,
    String? name,
    String? username,
    int? age,
    String? bio,
    String? imageUrl,
    List<String>? interests,
    bool? isAvailable,
    double? distance,
    DateTime? lastSeen,
    List<String>? intents,
    // New optional fields
    String? work,
    String? education,
    String? drinkingHabits,
    String? mealInterest,
    String? starSign,
    List<String>? languages,
    String? gender,
    // User type and subscription fields
    String? userType,
    bool? isPremium,
    String? subscriptionLevel,
    DateTime? subscriptionExpiry,
    int? points,
    bool? isVerified,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      age: age ?? this.age,
      bio: bio ?? this.bio,
      imageUrl: imageUrl ?? this.imageUrl,
      interests: interests ?? this.interests,
      isAvailable: isAvailable ?? this.isAvailable,
      distance: distance ?? this.distance,
      lastSeen: lastSeen ?? this.lastSeen,
      intents: intents ?? this.intents,
      // New optional fields
      work: work ?? this.work,
      education: education ?? this.education,
      drinkingHabits: drinkingHabits ?? this.drinkingHabits,
      mealInterest: mealInterest ?? this.mealInterest,
      starSign: starSign ?? this.starSign,
      languages: languages ?? this.languages,
      gender: gender ?? this.gender,
      // User type and subscription fields
      userType: userType ?? this.userType,
      isPremium: isPremium ?? this.isPremium,
      subscriptionLevel: subscriptionLevel ?? this.subscriptionLevel,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
      points: points ?? this.points,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'age': age,
      'bio': bio,
      'imageUrl': imageUrl,
      'interests': interests,
      'isAvailable': isAvailable,
      'distance': distance,
      'lastSeen': lastSeen?.toIso8601String(),
      'intents': intents,
      // New optional fields
      'work': work,
      'education': education,
      'drinkingHabits': drinkingHabits,
      'mealInterest': mealInterest,
      'starSign': starSign,
      'languages': languages,
      'gender': gender,
      // User type and subscription fields
      'userType': userType,
      'isPremium': isPremium,
      'subscriptionLevel': subscriptionLevel,
      'subscriptionExpiry': subscriptionExpiry?.toIso8601String(),
      'points': points,
      'isVerified': isVerified,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      username: json['username'] as String?,
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
      // New optional fields
      work: json['work'] as String?,
      education: json['education'] as String?,
      drinkingHabits: json['drinkingHabits'] as String?,
      mealInterest: json['mealInterest'] as String?,
      starSign: json['starSign'] as String?,
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
      gender: _validateGender(json['gender'] as String?),
      // User type and subscription fields
      userType: json['userType'] as String? ?? 'normal',
      isPremium: json['isPremium'] as bool? ?? false,
      subscriptionLevel: json['subscriptionLevel'] as String?,
      subscriptionExpiry: json['subscriptionExpiry'] != null
          ? DateTime.parse(json['subscriptionExpiry'] as String)
          : null,
      points: json['points'] as int? ?? 100,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  // Validate gender field to only accept standardized options
  static String _validateGender(String? gender) {
    const validGenders = ['Male', 'Female', 'LGBTQ+'];

    if (gender == null || !validGenders.contains(gender)) {
      return 'Female'; // Default fallback to one of the valid options
    }

    return gender;
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