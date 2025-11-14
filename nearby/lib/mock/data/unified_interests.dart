/// Unified interests and cuisine system for consistent mock data across all screens
class UnifiedInterests {
  // Private constructor to prevent instantiation
  UnifiedInterests._();

  // Centralized interest categories with comprehensive coverage
  static const Map<String, List<String>> categories = {
    'Cuisines': [
      'Italian', 'Japanese', 'Mexican', 'Thai', 'Indian', 'French',
      'Chinese', 'Korean', 'Vietnamese', 'Greek', 'Spanish',
      'Mediterranean', 'American', 'Fusion', 'Ethiopian',
      'Malaysian', 'Indonesian', 'Filipino', 'Cuban', 'Peruvian',
      'Brazilian', 'Argentine', 'Turkish', 'Lebanese', 'Moroccan'
    ],
    'Dining Styles': [
      'Fine Dining', 'Casual Dining', 'Fast Food', 'Street Food',
      'Food Trucks', 'Pop-up Restaurants', 'Ghost Kitchens',
      'Family Style', 'Buffet', 'Tasting Menu', 'A La Carte'
    ],
    'Beverages': [
      'Wine', 'Craft Cocktails', 'Coffee', 'Tea', 'Beer', 'Whiskey',
      'Mocktails', 'Fresh Juice', 'Smoothies', 'Sake', 'Soju',
      'Mojitos', 'Martinis', 'Old Fashioned', 'Espresso', 'Latte'
    ],
    'Specific Dishes': [
      'Pizza', 'Burgers', 'Sushi', 'Ramen', 'Tacos', 'Pasta',
      'BBQ', 'Seafood', 'Steakhouse', 'Dim Sum', 'Curry',
      'Tapas', 'Paella', 'Pho', 'Bibimbap', 'Fajitas',
      'Ceviche', 'Gyoza', 'Kebab', 'Falafel', 'Bruschetta'
    ],
    'Meal Types': [
      'Breakfast', 'Brunch', 'Lunch', 'Dinner', 'Happy Hour',
      'Late Night', 'Dessert', 'Coffee', 'Tapas', 'Appetizers',
      'Tasting Menu', 'Buffet', 'Family Style', 'Bar Snacks'
    ],
    'Dietary Preferences': [
      'Vegetarian', 'Vegan', 'Gluten-Free', 'Keto', 'Paleo',
      'Organic', 'Farm-to-Table', 'Sustainable', 'Halal', 'Kosher',
      'Dairy-Free', 'Nut-Free', 'Low-Carb', 'Low-Sodium', 'Raw'
    ],
    'Social Dining': [
      'Brunch', 'Happy Hour', 'Dinner Parties', 'Food Festivals',
      'Cooking Classes', 'Food Tours', 'Wine Tasting', 'Brewery Tours',
      'Group Dining', 'Shared Plates', 'Family Meals', 'Community Tables'
    ],
    'Food Experiences': [
      'Food Tours', 'Cooking Classes', 'Wine Tasting', 'Brewery Tours',
      'Chef Tables', 'Kitchen Bar', 'Food Festivals', 'Pop-up Events',
      'Food Photography', 'Culinary Workshops', 'Farm Visits'
    ]
  };

  // Get all interests as a flat list (for backward compatibility)
  static List<String> getAllInterests() {
    return categories.values.expand((list) => list).toList();
  }

  // Get interests by category
  static List<String> getInterestsByCategory(String category) {
    return categories[category] ?? [];
  }

  // Get random interests from specific categories
  static List<String> getRandomInterests(int count, {List<String>? fromCategories}) {
    final sourceCategories = fromCategories ?? categories.keys.toList();
    final availableInterests = sourceCategories
        .expand((category) => categories[category] ?? [])
        .cast<String>()
        .toList();

    if (availableInterests.length <= count) {
      return availableInterests;
    }

    final shuffled = List<String>.from(availableInterests)..shuffle();
    return shuffled.take(count).toList();
  }

  // Check if an interest belongs to a specific category
  static String? getInterestCategory(String interest) {
    for (final entry in categories.entries) {
      if (entry.value.contains(interest)) {
        return entry.key;
      }
    }
    return null;
  }

  // Get related interests (same category)
  static List<String> getRelatedInterests(String interest) {
    final category = getInterestCategory(interest);
    if (category == null) return [];

    final categoryInterests = categories[category] ?? [];
    return categoryInterests.where((i) => i != interest).toList();
  }

  // Popular interest combinations for realistic user profiles
  static const List<List<String>> popularCombinations = [
    ['Italian', 'Wine', 'Fine Dining'],
    ['Japanese', 'Sushi', 'Ramen'],
    ['Mexican', 'Tacos', 'Casual Dining'],
    ['Thai', 'Street Food', 'Spicy Food'],
    ['Coffee', 'Brunch', 'Casual Dining'],
    ['Vegan', 'Farm-to-Table', 'Organic'],
    ['BBQ', 'Beer', 'Casual Dining'],
    ['French', 'Wine', 'Fine Dining'],
    ['Indian', 'Curry', 'Casual Dining'],
    ['Chinese', 'Dim Sum', 'Family Style'],
  ];

  // Get a realistic combination of interests for a user
  static List<String> getRealisticUserInterests() {
    final random = DateTime.now().millisecondsSinceEpoch;
    final combinationIndex = random % popularCombinations.length;
    final baseInterests = List<String>.from(popularCombinations[combinationIndex]);

    // Add 1-3 more random interests
    final additionalCount = (random % 3) + 1;
    final additionalInterests = getRandomInterests(additionalCount);

    return [...baseInterests, ...additionalInterests];
  }

  // Interest compatibility scoring (for group matching)
  static double getCompatibilityScore(List<String> interests1, List<String> interests2) {
    final set1 = interests1.toSet();
    final set2 = interests2.toSet();
    final intersection = set1.intersection(set2);
    final union = set1.union(set2);

    return union.isEmpty ? 0.0 : intersection.length / union.length;
  }

  // Category-based filtering
  static List<String> filterByCategory(List<String> interests, String category) {
    final categoryInterests = categories[category] ?? [];
    return interests.where((interest) => categoryInterests.contains(interest)).toList();
  }

  // Validation methods
  static bool isValidInterest(String interest) {
    return getAllInterests().contains(interest);
  }

  static bool isValidCategory(String category) {
    return categories.containsKey(category);
  }
}