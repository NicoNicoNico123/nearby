import '../../models/user_model.dart';

class MockUser {
  final User user;
  final MockUserScenario scenario;
  final MockUserActivity activity;

  MockUser({
    required this.user,
    required this.scenario,
    required this.activity,
  });

  // Factory constructors for each scenario
  factory MockUser.normalUser() {
    return MockUser(
      user: User(
        id: 'current_user',
        name: 'Alex Johnson',
        age: 25,
        bio: 'Love trying new restaurants and meeting interesting people! Just started exploring the dining scene.',
        imageUrl: 'https://picsum.photos/200/200?random=normal_user',
        interests: ['Italian', 'Coffee', 'Casual Dining', 'Brunch'],
        isAvailable: true,
        userType: 'normal',
        isPremium: false,
        points: 150,
        isVerified: false,
        work: 'Marketing Coordinator',
        education: 'Bachelor\'s Degree',
        drinkingHabits: 'Social',
        mealInterest: 'Casual',
        starSign: 'Aries',
        languages: ['English'],
        gender: 'Male',
      ),
      scenario: MockUserScenario.normal,
      activity: MockUserActivity(
        groupsCreated: 1,
        groupsCreatedLimit: 2,
        groupsJoined: 3,
        groupsJoinedLimit: 5,
        pointsSpent: 130,
        pointsRemaining: 20,
        eventsAttended: 2, // Normal users attend fewer events
      ),
    );
  }

  factory MockUser.premiumUser() {
    return MockUser(
      user: User(
        id: 'current_user',
        name: 'Sarah Chen',
        age: 32,
        bio: 'Wine connoisseur and Michelin guide follower. Love hosting exclusive dining events and culinary adventures.',
        imageUrl: 'https://picsum.photos/200/200?random=premium_user',
        interests: ['Fine Dining', 'Wine', 'French Cuisine', 'Sushi', 'Premium Events'],
        isAvailable: true,
        userType: 'premium',
        isPremium: true,
        subscriptionLevel: 'premium',
        subscriptionExpiry: DateTime.now().add(Duration(days: 365)),
        points: 850,
        isVerified: true,
        work: 'Senior Software Engineer',
        education: 'Master\'s Degree',
        drinkingHabits: 'Social',
        mealInterest: 'Fine Dining',
        starSign: 'Leo',
        languages: ['English', 'Mandarin', 'French'],
        gender: 'Female',
      ),
      scenario: MockUserScenario.premium,
      activity: MockUserActivity(
        groupsCreated: 3,
        groupsCreatedLimit: 4,
        groupsJoined: 5,
        groupsJoinedLimit: 8,
        pointsSpent: 350,
        pointsRemaining: 500,
        eventsAttended: 12, // Premium users attend more events
      ),
    );
  }

  factory MockUser.godModeUser() {
    return MockUser(
      user: User(
        id: 'current_user',
        name: 'System Administrator',
        age: 35,
        bio: 'Platform administrator with full access to all features and unlimited resources.',
        imageUrl: 'https://picsum.photos/200/200?random=admin_user',
        interests: ['Fine Dining', 'Wine', 'Craft Beer', 'Premium Features', 'System Administration'],
        isAvailable: true,
        userType: 'admin',
        isPremium: true,
        subscriptionLevel: 'vip',
        subscriptionExpiry: DateTime.now().add(Duration(days: 3650)),
        points: 999999,
        isVerified: true,
        work: 'Platform Administrator & System Architect',
        education: 'PhD in Computer Science',
        drinkingHabits: 'Social',
        mealInterest: 'Fine Dining',
        starSign: 'Leo',
        languages: ['English', 'Spanish', 'French', 'German', 'Chinese'],
        gender: 'Male',
      ),
      scenario: MockUserScenario.godMode,
      activity: MockUserActivity(
        groupsCreated: 12,
        groupsCreatedLimit: -1, // Unlimited
        groupsJoined: 25,
        groupsJoinedLimit: -1, // Unlimited
        pointsSpent: 0,
        pointsRemaining: 999999,
        eventsAttended: 50, // Admin users attend many events for moderation
      ),
    );
  }

  // Helper getters
  bool get isNormal => scenario == MockUserScenario.normal;
  bool get isPremium => scenario == MockUserScenario.premium;
  bool get isGodMode => scenario == MockUserScenario.godMode;

  bool get canCreateMoreGroups => activity.groupsCreated < activity.groupsCreatedLimit || activity.groupsCreatedLimit == -1;
  bool get canJoinMoreGroups => activity.groupsJoined < activity.groupsJoinedLimit || activity.groupsJoinedLimit == -1;

  int get groupsCreatedRemaining => activity.groupsCreatedLimit == -1 ? -1 : activity.groupsCreatedLimit - activity.groupsCreated;
  int get groupsJoinedRemaining => activity.groupsJoinedLimit == -1 ? -1 : activity.groupsJoinedLimit - activity.groupsJoined;
}

enum MockUserScenario {
  normal,
  premium,
  godMode,
}

class MockUserActivity {
  final int groupsCreated;
  final int groupsCreatedLimit;
  final int groupsJoined;
  final int groupsJoinedLimit;
  final int pointsSpent;
  final int pointsRemaining;
  final int eventsAttended;

  MockUserActivity({
    required this.groupsCreated,
    required this.groupsCreatedLimit,
    required this.groupsJoined,
    required this.groupsJoinedLimit,
    required this.pointsSpent,
    required this.pointsRemaining,
    this.eventsAttended = 0, // Default value
  });

  Map<String, dynamic> toJson() {
    return {
      'groupsCreated': groupsCreated,
      'groupsCreatedLimit': groupsCreatedLimit,
      'groupsJoined': groupsJoined,
      'groupsJoinedLimit': groupsJoinedLimit,
      'pointsSpent': pointsSpent,
      'pointsRemaining': pointsRemaining,
      'eventsAttended': eventsAttended,
    };
  }

  factory MockUserActivity.fromJson(Map<String, dynamic> json) {
    return MockUserActivity(
      groupsCreated: json['groupsCreated'] as int,
      groupsCreatedLimit: json['groupsCreatedLimit'] as int,
      groupsJoined: json['groupsJoined'] as int,
      groupsJoinedLimit: json['groupsJoinedLimit'] as int,
      pointsSpent: json['pointsSpent'] as int,
      pointsRemaining: json['pointsRemaining'] as int,
      eventsAttended: json['eventsAttended'] as int? ?? 0,
    );
  }
}