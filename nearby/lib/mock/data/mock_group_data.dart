import 'unified_interests.dart';

/// Static group data for mock generation
class MockGroupData {
  // Private constructor to prevent instantiation
  MockGroupData._();

  // Group names
  static const List<String> groupNames = [
    'Weekend Brunch Crew',
    'Sushi Lovers Unite',
    'Taco Tuesday Regulars',
    'Wine & Dine Wednesdays',
    'Foodie Adventures',
    'Coffee Connoisseurs',
    'Spicy Food Challenge',
    'Vegan Vibes',
    'Pasta Paradise',
    'BBQ Masters',
    'Dim Sum Sundays',
    'Pizza Perfect',
    'Seafood Celebration',
    'Thai Time',
    'Indian Indulgence',
    'Mediterranean Magic',
    'French Cuisine',
    'Korean BBQ',
    'Tapas Tuesday',
    'Ramen Revolution'
  ];

  // Group descriptions
  static const List<String> groupDescriptions = [
    'Join us for amazing food and great conversations',
    'Exploring the best restaurants in town together',
    'Food adventures with fellow food enthusiasts',
    'Making new friends over delicious meals',
    'Culinary exploration and social dining',
    'Good food, better company',
    'Discovering hidden culinary gems',
    'Shared meals and shared stories',
    'From street food to fine dining',
    'Every meal is an adventure',
    'Connecting through cuisine',
    'Taste buds and friendships',
    'Eating our way through the city',
    'Food, friends, and fun',
    'Culinary journeys together',
    'Dining discoveries daily',
    'Flavor exploration society',
    'Gourmet gatherings',
    'Taste testing tribe',
    'Mealtime memories'
  ];

  // Group titles/phrases
  static const List<String> groupTitles = [
    'Food & Friendship',
    'Culinary Explorers',
    'Dining Adventures',
    'Taste Buds United',
    'Flavor Finders',
    'Gourmet Gatherings',
    'Eating Experiences',
    'Meal Meetups',
    'Foodie Friends',
    'Dine & Discover',
    'Cuisine Connections',
    'Taste Journeys',
    'Flavor Adventures',
    'Food Fellowship',
    'Culinary Companions',
    'Dine Together',
    'Taste Together',
    'Eat & Meet',
    'Food & Fun',
    'Dine Daily'
  ];

  // Venues and restaurants
  static const List<String> venues = [
    'The French Laundry',
    'Chez Panisse',
    'Gary Danko',
    'Bouchon',
    'La Folie',
    'Acquerello',
    'Saison',
    'Atelier Crenn',
    'Manresa',
    'Commis',
    'Coi',
    'Quince',
    'Michael Mina',
    'Aqua',
    'Farallon',
    'Slanted Door',
    'Foreign Cinema',
    'Mission Chinese Food',
    'Tartine Bakery',
    'Bi-Rite Creamery',
    'Swan Oyster Depot',
    'Zuni Café',
    'Burma Superstar',
    'Dottie\'s True Blue Café',
    'Tartine Manufactory',
    'State Bird Provisions',
    'La Taqueria',
    'Mission Beach Café',
    'The Grove',
    'Philz Coffee',
    'Blue Bottle Coffee',
    'Four Barrel Coffee',
    'Ritual Coffee Roasters',
    'Sight Glass Coffee'
  ];

  // DEPRECATED: Use UnifiedInterests.getAllInterests() instead
  // Group categories/interests - now using unified interests system
  @Deprecated('Use UnifiedInterests.getAllInterests() instead')
  static List<String> get groupInterests => UnifiedInterests.getAllInterests();

  // Meal types
  static const List<String> mealTypes = [
    'Breakfast',
    'Brunch',
    'Lunch',
    'Dinner',
    'Happy Hour',
    'Late Night',
    'Coffee',
    'Dessert',
    'Tasting Menu',
    'Buffet',
    'Family Style',
    'Tapas'
  ];

  // Location descriptions
  static const List<String> locationDescriptions = [
    'San Francisco, CA',
    'Mission District, San Francisco',
    'SOMA, San Francisco',
    'North Beach, San Francisco',
    'Chinatown, San Francisco',
    'Marina District, San Francisco',
    'Hayes Valley, San Francisco',
    'Castro, San Francisco',
    'Haight-Ashbury, San Francisco',
    'Pacific Heights, San Francisco',
    'Financial District, San Francisco',
    'Union Square, San Francisco',
    'Nob Hill, San Francisco',
    'Russian Hill, San Francisco',
    'Telegraph Hill, San Francisco',
    'Sunset District, San Francisco',
    'Richmond District, San Francisco',
    'Bernal Heights, San Francisco',
    'Potrero Hill, San Francisco',
    'Noe Valley, San Francisco',
    'West Portal, San Francisco',
    'Excelsior, San Francisco',
    'Visitacion Valley, San Francisco',
    'Bayview, San Francisco',
    'Ocean View, San Francisco',
    'Golden Gate Park, San Francisco',
    'Fisherman\'s Wharf, San Francisco',
    'Embarcadero, San Francisco',
    'Pier 39, San Francisco',
    'Ferry Building, San Francisco'
  ];

  // Group size descriptions
  static const Map<String, String> groupSizeDescriptions = {
    '2-4': 'Intimate gathering',
    '5-7': 'Small group',
    '8-12': 'Medium group',
    '13-20': 'Large group',
  };

  // Group atmosphere types
  static const List<String> atmosphereTypes = [
    'Casual and relaxed',
    'Energetic and lively',
    'Quiet and intimate',
    'Social and conversational',
    'Adventure seeking',
    'Romantic',
    'Professional networking',
    'Family friendly',
    'Trendy and modern',
    'Traditional and classic'
  ];

  // Dietary accommodation options
  static const List<String> dietaryAccommodations = [
    'Vegetarian friendly',
    'Vegan options',
    'Gluten-free options',
    'Halal certified',
    'Kosher options',
    'Nut-free environment',
    'Dairy-free alternatives',
    'Low-carb options',
    'Keto-friendly',
    'Paleo options'
  ];

  // Special features
  static const List<String> specialFeatures = [
    'Live music',
    'Outdoor seating',
    'Parking available',
    'Pet-friendly patio',
    'Private dining room',
    'Full bar service',
    'Valet parking',
    'WiFi available',
    'Reservations recommended',
    'Walk-ins welcome',
    'Late night menu',
    'Happy hour specials',
    'Group discounts',
    'Chef\'s table available',
    'Wine pairing available',
    'Cooking classes',
    'Private events',
    'Catering available',
    'Takeout available',
    'Delivery available'
  ];

  // Price ranges (for descriptive purposes)
  static const Map<String, String> priceRanges = {
    '\$': 'Budget friendly',
    '\$\$': 'Moderate pricing',
    '\$\$\$': 'Upscale dining',
    '\$\$\$\$': 'Fine dining',
  };

  // Group popularity levels (for additional metadata)
  static const List<String> popularityLevels = [
    'Hidden gem',
    'Local favorite',
    'Popular spot',
    'Trending now',
    'Always busy',
    'Viral sensation'
  ];

  // Seasonal themes
  static const Map<String, List<String>> seasonalThemes = {
    'Spring': [
      'Spring blossom brunch',
      'Easter dinner',
      'Mother\'s Day celebration',
      'Graduation dining'
    ],
    'Summer': [
      'Summer BBQ series',
      'Patio dining',
      'Ice cream social',
      'Fourth of July feast'
    ],
    'Fall': [
      'Harvest dinner',
      'Oktoberfest celebration',
      'Thanksgiving planning',
      'Halloween themed dining'
    ],
    'Winter': [
      'Holiday feast',
      'New Year\'s Eve dinner',
      'Valentine\'s romance',
      'Comfort food series'
    ]
  };

  // Group meeting frequencies (for recurring groups)
  static const List<String> meetingFrequencies = [
    'One-time event',
    'Weekly gathering',
    'Bi-weekly meetup',
    'Monthly dinner',
    'Quarterly food tour',
    'Seasonal celebration'
  ];

  // Group communication styles
  static const List<String> communicationStyles = [
    'Formal and organized',
    'Casual and friendly',
    'Spontaneous and flexible',
    'Structured and planned',
    'Interactive and engaging',
    'Quiet and respectful'
  ];
}