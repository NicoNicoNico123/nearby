/// Mock USER HOUSE data for testing hashtag matching functionality
/// Contains sample USER HOUSE groups with hashtag requirements
class MockUserHouseData {
  // USER HOUSE venue data
  static const List<Map<String, String>> userHouseVenues = [
    {
      'name': 'The Professional Hub',
      'address': '123 Business District, Tech City',
      'type': 'Professional',
      'vibe': 'Modern, collaborative workspace',
    },
    {
      'name': 'Creative Collective',
      'address': '456 Arts District, Creative Quarter',
      'type': 'Creative',
      'vibe': 'Artistic, inspiring atmosphere',
    },
    {
      'name': 'Social Connect Lounge',
      'address': '789 Social Street, Community Hub',
      'type': 'Social',
      'vibe': 'Welcoming, conversational space',
    },
    {
      'name': 'Wellness Garden Cafe',
      'address': '321 Health Boulevard, Wellness District',
      'type': 'Wellness',
      'vibe': 'Calming, health-focused environment',
    },
  ];

  // USER HOUSE category templates
  static const Map<String, Map<String, dynamic>> userHouseCategories = {
    'Professional': {
      'description': 'Professional networking and career development groups',
      'requiredHashtags': ['#Professional', '#Networking', '#Career'],
      'preferredHashtags': ['#Leadership', '#Innovation', '#Industry'],
      'vibeTags': ['#Ambitious', '#Driven', '#GoalOriented'],
      'activityTags': ['#Workshops', '#Seminars', '#Mentorship'],
    },
    'Social': {
      'description': 'Social gatherings and community building groups',
      'requiredHashtags': ['#Social', '#Community', '#Connection'],
      'preferredHashtags': ['#Outgoing', '#Communication', '#Friendship'],
      'vibeTags': ['#Friendly', '#Welcoming', '#Inclusive'],
      'activityTags': ['#SocialEvents', '#Meetups', '#Gatherings'],
    },
    'Hobby': {
      'description': 'Interest-based hobby and skill-sharing groups',
      'requiredHashtags': ['#Hobby', '#Interest', '#SkillShare'],
      'preferredHashtags': ['#Creative', '#Learning', '#Passion'],
      'vibeTags': ['#Enthusiastic', '#Collaborative', '#Inspiring'],
      'activityTags': ['#Workshops', '#Projects', '#Collaboration'],
    },
    'Lifestyle': {
      'description': 'Lifestyle and wellness-focused groups',
      'requiredHashtags': ['#Lifestyle', '#Wellness', '#Balance'],
      'preferredHashtags': ['#Healthy', '#Mindful', '#Sustainable'],
      'vibeTags': ['#Relaxed', '#Supportive', '#Positive'],
      'activityTags': ['#WellnessActivities', '#LifestyleEvents', '#SelfCare'],
    },
  };

  // Sample USER HOUSE groups
  static List<Map<String, dynamic>> getSampleUserHouseGroups() {
    return [
      // Professional Networking Groups
      {
        'id': 'user_house_professional_1',
        'name': 'Tech Professionals Network',
        'description': 'Connect with fellow tech professionals for networking, knowledge sharing, and career opportunities.',
        'subtitle': 'Innovation meets opportunity',
        'category': 'Professional',
        'userHouseCategory': 'Professional',
        'isUserHouse': true,
        'requiredHashtags': ['#Tech', '#Engineering', '#Professional'],
        'preferredHashtags': ['#Innovation', '#Leadership', '#Networking', '#Software'],
        'venue': userHouseVenues[0]['name'],
        'maxMembers': 15,
        'joinCost': 50,
        'groupPot': 0,
        'ageRangeMin': 25,
        'ageRangeMax': 45,
        'allowedLanguages': ['English'],
      },
      {
        'id': 'user_house_professional_2',
        'name': 'Startup Founders Meetup',
        'description': 'Exclusive group for startup founders to share experiences, challenges, and growth strategies.',
        'subtitle': 'Where founders connect and collaborate',
        'category': 'Professional',
        'userHouseCategory': 'Professional',
        'isUserHouse': true,
        'requiredHashtags': ['#Entrepreneurship', '#Startup', '#Founder'],
        'preferredHashtags': ['#Innovation', '#Business', '#Leadership', '#Tech'],
        'venue': userHouseVenues[0]['name'],
        'maxMembers': 12,
        'joinCost': 75,
        'groupPot': 0,
        'ageRangeMin': 28,
        'ageRangeMax': 50,
        'allowedLanguages': ['English'],
      },
      {
        'id': 'user_house_professional_3',
        'name': 'Creative Professionals Collective',
        'description': 'Bring together creative professionals for collaboration, inspiration, and industry networking.',
        'subtitle': 'Creativity in action',
        'category': 'Professional',
        'userHouseCategory': 'Professional',
        'isUserHouse': true,
        'requiredHashtags': ['#Creative', '#Design', '#Arts'],
        'preferredHashtags': ['#Design', '#Innovation', '#Collaboration', '#Visual'],
        'venue': userHouseVenues[1]['name'],
        'maxMembers': 18,
        'joinCost': 40,
        'groupPot': 0,
        'ageRangeMin': 22,
        'ageRangeMax': 40,
        'allowedLanguages': ['English'],
      },

      // Social Connection Groups
      {
        'id': 'user_house_social_1',
        'name': 'Social Butterflies Unite',
        'description': 'For extroverts and social butterflies who love meeting new people and building connections.',
        'subtitle': 'Making every interaction count',
        'category': 'Social',
        'userHouseCategory': 'Social',
        'isUserHouse': true,
        'requiredHashtags': ['#Social', '#Outgoing', '#Community'],
        'preferredHashtags': ['#Communication', '#Friendship', '#Networking', '#Events'],
        'venue': userHouseVenues[2]['name'],
        'maxMembers': 20,
        'joinCost': 30,
        'groupPot': 0,
        'ageRangeMin': 21,
        'ageRangeMax': 35,
        'allowedLanguages': ['English'],
      },
      {
        'id': 'user_house_social_2',
        'name': 'Urban Professionals Social Club',
        'description': 'Social group for urban professionals looking to expand their social circle beyond work.',
        'subtitle': 'Work hard, social harder',
        'category': 'Social',
        'userHouseCategory': 'Social',
        'isUserHouse': true,
        'requiredHashtags': ['#Social', '#Professional', '#Urban'],
        'preferredHashtags': ['#Networking', '#Lifestyle', '#CityLife', '#AfterHours'],
        'venue': userHouseVenues[2]['name'],
        'maxMembers': 25,
        'joinCost': 35,
        'groupPot': 0,
        'ageRangeMin': 25,
        'ageRangeMax': 40,
        'allowedLanguages': ['English'],
      },
      {
        'id': 'user_house_social_3',
        'name': 'International Friends Network',
        'description': 'Connect with people from different cultures and backgrounds in a welcoming environment.',
        'subtitle': 'Where cultures meet and friendships bloom',
        'category': 'Social',
        'userHouseCategory': 'Social',
        'isUserHouse': true,
        'requiredHashtags': ['#Social', '#International', '#Cultural'],
        'preferredHashtags': ['#Languages', '#Travel', '#Global', '#Diversity'],
        'venue': userHouseVenues[2]['name'],
        'maxMembers': 30,
        'joinCost': 25,
        'groupPot': 0,
        'ageRangeMin': 20,
        'ageRangeMax': 45,
        'allowedLanguages': ['English', 'Spanish', 'French'],
      },

      // Hobby & Interest Groups
      {
        'id': 'user_house_hobby_1',
        'name': 'Photography Enthusiasts Club',
        'description': 'Share your passion for photography with fellow enthusiasts, explore techniques, and go on photo walks.',
        'subtitle': 'Capturing moments, creating memories',
        'category': 'Hobby',
        'userHouseCategory': 'Hobby',
        'isUserHouse': true,
        'requiredHashtags': ['#Photography', '#Hobby', '#Creative'],
        'preferredHashtags': ['#Art', '#Visual', '#Technology', '#Outdoors'],
        'venue': userHouseVenues[1]['name'],
        'maxMembers': 16,
        'joinCost': 20,
        'groupPot': 0,
        'ageRangeMin': 18,
        'ageRangeMax': 50,
        'allowedLanguages': ['English'],
      },
      {
        'id': 'user_house_hobby_2',
        'name': 'Culinary Explorers Society',
        'description': 'For food lovers who enjoy exploring new cuisines, cooking techniques, and culinary adventures.',
        'subtitle': 'Food adventures await',
        'category': 'Hobby',
        'userHouseCategory': 'Hobby',
        'isUserHouse': true,
        'requiredHashtags': ['#Foodie', '#Cooking', '#Cuisine'],
        'preferredHashtags': ['#Mediterranean', '#Japanese', '#Italian', '#Adventure'],
        'venue': userHouseVenues[3]['name'],
        'maxMembers': 12,
        'joinCost': 45,
        'groupPot': 0,
        'ageRangeMin': 22,
        'ageRangeMax': 45,
        'allowedLanguages': ['English'],
      },
      {
        'id': 'user_house_hobby_3',
        'name': 'Wellness & Mindfulness Circle',
        'description': 'Practice mindfulness, meditation, and wellness activities in a supportive group environment.',
        'subtitle': 'Finding balance together',
        'category': 'Hobby',
        'userHouseCategory': 'Lifestyle',
        'isUserHouse': true,
        'requiredHashtags': ['#Wellness', '#Mindfulness', '#Health'],
        'preferredHashtags': ['#Meditation', '#Yoga', '#Balance', '#SelfCare'],
        'venue': userHouseVenues[3]['name'],
        'maxMembers': 20,
        'joinCost': 25,
        'groupPot': 0,
        'ageRangeMin': 20,
        'ageRangeMax': 50,
        'allowedLanguages': ['English'],
      },

      // Lifestyle Groups
      {
        'id': 'user_house_lifestyle_1',
        'name': 'Sustainable Living Advocates',
        'description': 'Connect with like-minded individuals passionate about sustainability and eco-friendly living.',
        'subtitle': 'Living consciously, making a difference',
        'category': 'Lifestyle',
        'userHouseCategory': 'Lifestyle',
        'isUserHouse': true,
        'requiredHashtags': ['#Sustainable', '#EcoFriendly', '#Green'],
        'preferredHashtags': ['#Environment', '#Organic', '#Conscious', '#Community'],
        'venue': userHouseVenues[3]['name'],
        'maxMembers': 15,
        'joinCost': 15,
        'groupPot': 0,
        'ageRangeMin': 20,
        'ageRangeMax': 45,
        'allowedLanguages': ['English'],
      },
      {
        'id': 'user_house_lifestyle_2',
        'name': 'Work-Life Balance Champions',
        'description': 'For professionals seeking to achieve better work-life balance and personal wellbeing.',
        'subtitle': 'Balancing ambition with wellbeing',
        'category': 'Lifestyle',
        'userHouseCategory': 'Lifestyle',
        'isUserHouse': true,
        'requiredHashtags': ['#Balance', '#Wellness', '#Lifestyle'],
        'preferredHashtags': ['#Career', '#Health', '#PersonalGrowth', '#Mindful'],
        'venue': userHouseVenues[3]['name'],
        'maxMembers': 18,
        'joinCost': 30,
        'groupPot': 0,
        'ageRangeMin': 25,
        'ageRangeMax': 45,
        'allowedLanguages': ['English'],
      },
      {
        'id': 'user_house_lifestyle_3',
        'name': 'Fitness & Active Living Group',
        'description': 'Connect with fitness enthusiasts and active individuals for workouts and healthy lifestyle activities.',
        'subtitle': 'Strong body, strong mind',
        'category': 'Lifestyle',
        'userHouseCategory': 'Lifestyle',
        'isUserHouse': true,
        'requiredHashtags': ['#Fitness', '#Active', '#Healthy'],
        'preferredHashtags': ['#Exercise', '#Outdoors', '#Energy', '#Motivation'],
        'venue': userHouseVenues[3]['name'],
        'maxMembers': 22,
        'joinCost': 20,
        'groupPot': 0,
        'ageRangeMin': 20,
        'ageRangeMax': 40,
        'allowedLanguages': ['English'],
      },
    ];
  }

  // Get USER HOUSE groups by category
  static List<Map<String, dynamic>> getUserHouseGroupsByCategory(String category) {
    return getSampleUserHouseGroups()
        .where((group) => group['userHouseCategory'] == category)
        .toList();
  }

  // Get USER HOUSE groups by required hashtags
  static List<Map<String, dynamic>> getUserHouseGroupsByHashtag(String hashtag) {
    return getSampleUserHouseGroups()
        .where((group) =>
            (group['requiredHashtags'] as List<String>).contains(hashtag) ||
            (group['preferredHashtags'] as List<String>).contains(hashtag))
        .toList();
  }

  // Get USER HOUSE category template
  static Map<String, dynamic>? getCategoryTemplate(String category) {
    return userHouseCategories[category];
  }

  // Generate hashtag requirements for a category
  static List<String> generateRequiredHashtagsForCategory(String category) {
    final template = getCategoryTemplate(category);
    if (template == null) return [];

    return List<String>.from(template['requiredHashtags'] as List<String>);
  }

  // Generate preferred hashtags for a category
  static List<String> generatePreferredHashtagsForCategory(String category) {
    final template = getCategoryTemplate(category);
    if (template == null) return [];

    return List<String>.from(template['preferredHashtags'] as List<String>);
  }
}