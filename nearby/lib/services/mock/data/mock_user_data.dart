/// Static user data for mock generation
class MockUserData {
  // Private constructor to prevent instantiation
  MockUserData._();

  // User names
  static const List<String> normalUserNames = [
    'Alex Johnson', 'Sarah Chen', 'Mike Williams', 'Emma Davis',
    'James Wilson', 'Olivia Brown', 'Daniel Garcia', 'Sophia Martinez',
    'Chris Anderson', 'Isabella Taylor', 'Ryan Thomas', 'Mia Jackson',
    'David White', 'Charlotte Harris', 'Kevin Martin', 'Amelia Thompson',
    'Jason Garcia', 'Harper Robinson', 'Brian Clark', 'Evelyn Rodriguez',
    'Marcus Kim', 'Lisa Wang', 'Tyler Brown', 'Nina Patel'
  ];

  static const List<String> premiumUserNames = [
    'Sophia Laurent', 'Alexander Chen', 'Isabella Rodriguez', 'Marcus Williams',
    'Victoria Chen', 'Alexander Wang', 'Olivia Martinez', 'William Chen',
    'Sophia Zhang', 'Alexander Rodriguez', 'Emily Chen', 'Michael Wang',
    'Isabella Liu', 'Alexander Zhang', 'Sophia Wang', 'Alexander Kim',
    'Olivia Chen', 'Alexander Liu', 'Victoria Wang', 'Sophia Kim'
  ];

  static const List<String> creatorUserNames = [
    'David Martinez', 'Sarah Thompson', 'Michael Rodriguez', 'Emily Chen',
    'James Williams', 'Jessica Garcia', 'Robert Johnson', 'Jennifer Smith',
    'William Brown', 'Maria Davis', 'Richard Miller', 'Patricia Wilson',
    'Charles Moore', 'Linda Taylor', 'Joseph Anderson', 'Barbara Thomas',
    'Thomas Jackson', 'Jennifer White', 'Daniel Harris', 'Margaret Martin'
  ];

  static const List<String> adminUserNames = [
    'System Admin', 'Test User', 'Demo Account', 'Support Agent',
    'Moderator One', 'Quality Checker', 'Data Validator', 'Content Admin'
  ];

  // User bios
  static const List<String> normalBios = [
    'Love trying new restaurants and meeting interesting people!',
    'Food enthusiast looking for dining companions',
    'Exploring the city one meal at a time',
    'Coffee addict and brunch lover',
    'Just here for good food and great conversation',
    'Weekend foodie looking for dining buddies'
  ];

  static const List<String> premiumBios = [
    'Travel food blogger • Always hunting for the next great meal • Let\'s explore together',
    'Michelin guide enthusiast • Wine lover • Private dining events host',
    'Culinary explorer • Pop-up restaurant hunter • Exclusive food experiences',
    'Fine dining connoisseur • Chef table reservations • Food photography',
    'Gastronomy adventurer • Underground dining • Culinary tours worldwide',
    'Restaurant investor • Menu consultant • Food startup advisor'
  ];

  static const List<String> creatorBios = [
    'Professional event planner • Specializing in culinary experiences • Creating memorable dining moments',
    'Chef and restaurant owner • Hosting exclusive dining events • Culinary storytelling',
    'Food writer and critic • Curating unique dining experiences • Connecting food lovers',
    'Culinary event producer • Pop-up dinner organizer • Food community builder',
    'Restaurant consultant • Dining experience designer • Food culture advocate'
  ];

  static const List<String> adminBios = [
    'System administrator • Keeping the platform running smoothly',
    'Quality assurance specialist • Ensuring the best user experience',
    'Community moderator • Maintaining a safe and respectful environment',
    'Content curator • Highlighting the best dining experiences'
  ];

  // Work/Occupation
  static const List<String> workOptions = [
    'Software Engineer',
    'Product Designer',
    'Marketing Manager',
    'Data Scientist',
    'UX Designer',
    'Product Manager',
    'Consultant',
    'Investment Banker',
    'Lawyer',
    'Doctor',
    'Architect',
    'Teacher',
    'Chef',
    'Photographer',
    'Writer',
    'Artist',
    'Entrepreneur',
    'Student',
    'Researcher',
    'Therapist',
    'Financial Advisor',
    'Real Estate Agent',
    'Journalist',
    'Engineer'
  ];

  // Education
  static const List<String> educationOptions = [
    'Stanford University',
    'UC Berkeley',
    'MIT',
    'Harvard University',
    'Yale University',
    'Princeton University',
    'Columbia University',
    'UCLA',
    'NYU',
    'Northwestern University',
    'University of Pennsylvania',
    'Duke University',
    'University of Chicago',
    'Caltech',
    'Cornell University',
    'Brown University',
    'Rice University',
    'Vanderbilt University',
    'University of Michigan',
    'University of Virginia'
  ];

  // Drinking habits
  static const List<String> drinkingHabitsOptions = [
    'Socially',
    'Rarely',
    'Never',
    'Regularly',
    'Occasionally',
    'On weekends',
    'At special events'
  ];

  // Meal interests
  static const List<String> mealInterestOptions = [
    'Fine Dining',
    'Casual Dining',
    'Street Food',
    'Home Cooking',
    'Food Tours',
    'Cooking Classes',
    'Wine Tasting',
    'Craft Cocktails',
    'Coffee Culture',
    'Brunch',
    'Desserts',
    'BBQ',
    'Vegetarian',
    'Vegan',
    'Gluten-Free',
    'Kosher',
    'Halal',
    'Farm-to-Table',
    'Seafood',
    'International Cuisine'
  ];

  // Star signs
  static const List<String> starSignOptions = [
    'Aries',
    'Taurus',
    'Gemini',
    'Cancer',
    'Leo',
    'Virgo',
    'Libra',
    'Scorpio',
    'Sagittarius',
    'Capricorn',
    'Aquarius',
    'Pisces'
  ];

  // Languages
  static const List<String> languageOptions = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
    'Russian',
    'Japanese',
    'Korean',
    'Chinese (Mandarin)',
    'Cantonese',
    'Arabic',
    'Hindi',
    'Dutch',
    'Swedish',
    'Norwegian',
    'Danish',
    'Finnish',
    'Polish',
    'Turkish',
    'Greek',
    'Hebrew',
    'Thai',
    'Vietnamese',
    'Indonesian'
  ];

  // Gender options (standardized)
  static const List<String> genderOptions = [
    'Male',
    'Female',
    'LGBTQ+'
  ];

  // User types
  static const List<String> userTypeOptions = [
    'normal',
    'premium',
    'creator',
    'admin'
  ];

  // Subscription levels
  static const List<String> subscriptionLevels = [
    'basic',
    'premium',
    'vip',
    'platinum'
  ];

  // Intents
  static const List<String> intentOptions = [
    'dining',
    'friendship',
    'networking',
    'romantic',
    'casual',
    'professional'
  ];

  // Profile completion data for realistic user generation
  static const Map<String, dynamic> profileCompletionWeights = {
    'work': 0.7,        // 70% of users have work filled
    'education': 0.6,   // 60% have education filled
    'drinkingHabits': 0.8, // 80% have drinking habits filled
    'mealInterest': 0.9,   // 90% have meal interest filled
    'starSign': 0.4,     // 40% have star sign filled
    'languages': 0.85,   // 85% have languages filled
  };

  // Interest categories for grouping
  static const Map<String, List<String>> interestCategories = {
    'Food Types': [
      'Italian', 'Japanese', 'Mexican', 'Thai', 'Indian', 'French',
      'Chinese', 'Korean', 'Vietnamese', 'Greek', 'Spanish', 'Mediterranean'
    ],
    'Dining Styles': [
      'Fine Dining', 'Casual Dining', 'Fast Food', 'Street Food',
      'Food Trucks', 'Pop-up Restaurants', 'Ghost Kitchens'
    ],
    'Beverages': [
      'Wine', 'Craft Cocktails', 'Coffee', 'Tea', 'Beer', 'Whiskey',
      'Mocktails', 'Fresh Juice', 'Smoothies'
    ],
    'Social': [
      'Brunch', 'Happy Hour', 'Dinner Parties', 'Food Festivals',
      'Cooking Classes', 'Food Tours', 'Wine Tasting'
    ],
    'Dietary': [
      'Vegetarian', 'Vegan', 'Gluten-Free', 'Keto', 'Paleo',
      'Organic', 'Farm-to-Table', 'Sustainable'
    ]
  };
}