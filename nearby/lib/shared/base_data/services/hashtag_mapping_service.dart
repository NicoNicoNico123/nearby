import '../models/entities/user_profile_attributes.dart';
import '../models/entities/group_hashtags.dart';
import '../models/entities/compatibility_result.dart';
import '../models/entities/matching_criteria.dart';

/// Service for converting user attributes to hashtags and performing matching
class HashtagMappingService {
  static final HashtagMappingService _instance = HashtagMappingService._internal();
  factory HashtagMappingService() => _instance;
  HashtagMappingService._internal();

  /// Converts user work to relevant hashtags
  static const Map<String, List<String>> workToHashtags = {
    'software engineer': ['#Tech', '#Engineering', '#Programming', '#Software', '#Developer'],
    'ux designer': ['#Design', '#Creative', '#UI', '#UX', '#ProductDesign'],
    'product manager': ['#Product', '#Management', '#Business', '#Strategy', '#Leadership'],
    'data scientist': ['#Data', '#Analytics', '#Science', '#MachineLearning', '#Statistics'],
    'marketing manager': ['#Marketing', '#Business', '#Strategy', '#Creative', '#Communication'],
    'teacher': ['#Education', '#Teaching', '#Academic', '#Mentorship', '#Learning'],
    'doctor': ['#Healthcare', '#Medical', '#Science', '#Wellness', '#Professional'],
    'artist': ['#Arts', '#Creative', '#Design', '#Visual', '#Expression'],
    'consultant': ['#Consulting', '#Professional', '#Expert', '#Strategy', '#Business'],
    'entrepreneur': ['#Entrepreneurship', '#Startup', '#Founder', '#Business', '#Innovation'],
  };

  /// Converts user education to relevant hashtags
  static const Map<String, List<String>> educationToHashtags = {
    'stanford university': ['#Stanford', '#EliteEducation', '#SiliconValley', '#Tech', '#Innovation'],
    'harvard university': ['#Harvard', '#IvyLeague', '#EliteEducation', '#Prestigious', '#Excellence'],
    'mit': ['#MIT', '#TechSchool', '#Engineering', '#Science', '#Innovation'],
    'berkeley': ['#Berkeley', '#UC', '#PublicUniversity', '#Research', '#Diverse'],
    'yale': ['#Yale', '#IvyLeague', '#LiberalArts', '#Humanities', '#Excellence'],
    'princeton': ['#Princeton', '#IvyLeague', '#Research', '#Academic', '#Prestigious'],
  };

  /// Converts meal interests to relevant hashtags
  static const Map<String, List<String>> mealToHashtags = {
    'mediterranean': ['#Mediterranean', '#Healthy', '#Seafood', '#OliveOil', '#Fresh'],
    'japanese': ['#Japanese', '#Sushi', '#Asian', '#Ramen', '#Fresh'],
    'vegetarian': ['#Vegetarian', '#Healthy', '#PlantBased', '#Sustainable', '#Conscious'],
    'italian': ['#Italian', '#Pasta', '#Wine', '#Family', '#Comfort'],
    'mexican': ['#Mexican', '#Spicy', '#Tacos', '#Vibrant', '#Flavorful'],
    'thai': ['#Thai', '#Asian', '#Spicy', '#Aromatic', '#Exotic'],
    'indian': ['#Indian', '#Curry', '#Spices', '#Aromatic', '#Diverse'],
    'french': ['#French', '#FineDining', '#Gourmet', '#Wine', '#Elegant'],
  };

  /// Converts drinking habits to relevant hashtags
  static const Map<String, List<String>> drinkToHashtags = {
    'non-drinker': ['#NonDrinker', '#Sober', '#Health', '#ClearMind', '#Wellness'],
    'occasional': ['#Occasional', '#Moderate', '#Casual', '#Balanced', '#Social'],
    'social drinker': ['#Social', '#SocialButterfly', '#Wine', '#Cocktails', '#Outgoing'],
    'regular': ['#Regular', '#Social', '#Nightlife', '#Wine', '#Connoisseur'],
    'wine enthusiast': ['#Wine', '#WineTasting', '#Vineyard', '#Sophisticated', '#Connoisseur'],
    'craft beer': ['#Beer', '#CraftBeer', '#Brewery', '#Artisan', '#Local'],
    'cocktails': ['#Cocktails', '#Mixology', '#Bar', '#Creative', '#Social'],
  };

  /// Converts star signs to relevant hashtags
  static const Map<String, List<String>> starSignToHashtags = {
    'aries': ['#Aries', '#FireSign', '#Leadership', '#Adventurous', '#Confident'],
    'taurus': ['#Taurus', '#EarthSign', '#Reliable', '#Patient', '#Practical'],
    'gemini': ['#Gemini', '#AirSign', '#Adaptable', '#Curious', '#Outgoing'],
    'cancer': ['#Cancer', '#WaterSign', '#Loyal', '#Emotional', '#Protective'],
    'leo': ['#Leo', '#FireSign', '#Leadership', '#Creative', '#Generous'],
    'virgo': ['#Virgo', '#EarthSign', '#Analytical', '#Helpful', '#Hardworking'],
    'libra': ['#Libra', '#AirSign', '#Diplomatic', '#Fair', '#Social'],
    'scorpio': ['#Scorpio', '#WaterSign', '#Passionate', '#Resourceful', '#Mysterious'],
    'sagittarius': ['#Sagittarius', '#FireSign', '#Adventurous', '#Optimistic', '#Philosophical'],
    'capricorn': ['#Capricorn', '#EarthSign', '#Responsible', '#Disciplined', '#Ambitious'],
    'aquarius': ['#Aquarius', '#AirSign', '#Independent', '#Humanitarian', '#Innovative'],
    'pisces': ['#Pisces', '#WaterSign', '#Compassionate', '#Artistic', '#Intuitive'],
  };

  /// Gets hashtags for a work title using mapping
  static List<String> getWorkHashtags(String work) {
    final workLower = work.toLowerCase();

    // Check for exact matches first
    for (final entry in workToHashtags.entries) {
      if (workLower.contains(entry.key)) {
        return entry.value;
      }
    }

    // Check for partial matches
    if (workLower.contains('engineer') || workLower.contains('developer')) {
      return workToHashtags['software engineer'] ?? [];
    }
    if (workLower.contains('design')) {
      return workToHashtags['ux designer'] ?? [];
    }
    if (workLower.contains('manager')) {
      return workToHashtags['product manager'] ?? [];
    }
    if (workLower.contains('teacher') || workLower.contains('professor')) {
      return workToHashtags['teacher'] ?? [];
    }
    if (workLower.contains('doctor') || workLower.contains('medical')) {
      return workToHashtags['doctor'] ?? [];
    }
    if (workLower.contains('artist') || workLower.contains('creative')) {
      return workToHashtags['artist'] ?? [];
    }
    if (workLower.contains('consultant')) {
      return workToHashtags['consultant'] ?? [];
    }
    if (workLower.contains('entrepreneur') || workLower.contains('founder')) {
      return workToHashtags['entrepreneur'] ?? [];
    }

    return ['#Professional', '#Career'];
  }

  /// Gets hashtags for education using mapping
  static List<String> getEducationHashtags(String education) {
    final educationLower = education.toLowerCase();

    // Check for exact matches
    for (final entry in educationToHashtags.entries) {
      if (educationLower.contains(entry.key)) {
        return entry.value;
      }
    }

    // Check for education level indicators
    if (educationLower.contains('phd') || educationLower.contains('doctorate')) {
      return ['#PhD', '#Doctorate', '#HigherEducation', '#Expert', '#Specialist'];
    }
    if (educationLower.contains('master') || educationLower.contains('m.s.') || educationLower.contains('m.a.')) {
      return ['#Masters', '#Graduate', '#Postgraduate', '#Advanced', '#Specialized'];
    }
    if (educationLower.contains('bachelor') || educationLower.contains('b.s.') || educationLower.contains('b.a.')) {
      return ['#Bachelors', '#Undergraduate', '#College', '#Educated', '#Degree'];
    }

    return ['#Education', '#Learning'];
  }

  /// Gets hashtags for meal interests using mapping
  static List<String> getMealHashtags(String mealInterest) {
    final mealLower = mealInterest.toLowerCase();

    // Check for exact matches
    for (final entry in mealToHashtags.entries) {
      if (mealLower.contains(entry.key)) {
        return entry.value;
      }
    }

    // Check for broader categories
    if (mealLower.contains('healthy') || mealLower.contains('organic')) {
      return ['#Healthy', '#Organic', '#Natural', '#Wellness', '#Conscious'];
    }
    if (mealLower.contains('vegetarian') || mealLower.contains('vegan')) {
      return mealToHashtags['vegetarian'] ?? [];
    }
    if (mealLower.contains('asian')) {
      return ['#Asian', '#Diverse', '#Exotic', '#Flavorful', '#International'];
    }

    return ['#Foodie', '#Dining', '#Cuisine'];
  }

  /// Gets hashtags for drinking habits using mapping
  static List<String> getDrinkHashtags(String drinkingHabits) {
    final drinkLower = drinkingHabits.toLowerCase();

    // Check for exact matches
    for (final entry in drinkToHashtags.entries) {
      if (drinkLower.contains(entry.key)) {
        return entry.value;
      }
    }

    return ['#Social', '#Lifestyle'];
  }

  /// Gets hashtags for star sign using mapping
  static List<String> getStarSignHashtags(String starSign) {
    final signLower = starSign.toLowerCase();

    for (final entry in starSignToHashtags.entries) {
      if (signLower.contains(entry.key)) {
        return entry.value;
      }
    }

    return starSign.isNotEmpty ? ['#$starSign'] : [];
  }

  /// Creates a compatibility result between user and group
  static CompatibilityResult calculateCompatibility({
    required UserProfileAttributes userAttributes,
    required GroupHashtags groupHashtags,
    required String userId,
    required String groupId,
    MatchingCriteria? criteria,
  }) {
    final userHashtags = userAttributes.allHashtags;
    final matchingHashtags = groupHashtags.getMatchingHashtags(userHashtags);
    final recommendationReasons = groupHashtags.getRecommendationReasons(userHashtags);

    // Calculate individual dimension scores
    final workHashtags = userAttributes.workHashtags;
    final educationHashtags = userAttributes.educationHashtags;
    final lifestyleHashtags = userAttributes.lifestyleHashtags;
    final zodiacHashtags = userAttributes.zodiacHashtags;
    final demographicHashtags = userAttributes.demographicHashtags;

    final workScore = _calculateCategoryScore(workHashtags, groupHashtags);
    final educationScore = _calculateCategoryScore(educationHashtags, groupHashtags);
    final lifestyleScore = _calculateCategoryScore(lifestyleHashtags, groupHashtags);
    final zodiacScore = _calculateCategoryScore(zodiacHashtags, groupHashtags);
    final demographicScore = _calculateCategoryScore(demographicHashtags, groupHashtags);

    return CompatibilityResult.fromScores(
      userId: userId,
      groupId: groupId,
      workScore: workScore,
      educationScore: educationScore,
      lifestyleScore: lifestyleScore,
      demographicScore: demographicScore,
      zodiacScore: zodiacScore,
      matchingHashtags: matchingHashtags,
      recommendationReasons: recommendationReasons,
      criteria: criteria,
      algorithmUsed: 'hashtag_mapping_service_v1',
    );
  }

  /// Calculates score for a category of hashtags against group requirements
  static double _calculateCategoryScore(List<String> categoryHashtags, GroupHashtags groupHashtags) {
    if (categoryHashtags.isEmpty) return 0.0;

    final allGroupTags = {
      ...groupHashtags.requiredHashtags,
      ...groupHashtags.preferredHashtags,
      ...groupHashtags.demographicTargets,
      ...groupHashtags.vibeTags,
      ...groupHashtags.activityTags,
    };

    if (allGroupTags.isEmpty) return 0.5; // Default neutral score

    final matches = categoryHashtags.where((tag) => allGroupTags.contains(tag)).length;
    return matches / categoryHashtags.length;
  }

  /// Provides sample groups for testing
  static List<GroupHashtags> getSampleGroups() {
    return [
      GroupHashtags.forTechProfessionals(
        skills: ['Software', 'React', 'Flutter'],
        experienceLevel: 'mid',
      ),
      GroupHashtags.forDining(
        cuisineType: 'japanese',
        diningStyle: 'casual',
        drinkPreferences: ['Sake', 'Social'],
      ),
      GroupHashtags.forLifestyle(
        activity: 'outdoors',
        intensity: 'moderate',
        interests: ['Hiking', 'Nature', 'Photography'],
      ),
      GroupHashtags(
        requiredHashtags: ['#Design', '#Creative'],
        preferredHashtags: ['#Arts', '#Visual'],
        demographicTargets: ['#25-40', '#Creative'],
        vibeTags: ['#Artistic', '#Inspirational'],
        activityTags: ['#DesignWorkshops', '#Creative', '#Collaboration'],
      ),
    ];
  }

  // ========== USER HOUSE SPECIFIC METHODS ==========

  /// USER HOUSE specific hashtag categories
  static const Map<String, List<String>> userHouseCategoryHashtags = {
    'Professional': [
      '#NetworkPro', '#CareerBuilder', '#IndustryExpert', '#Leadership',
      '#Innovation', '#Business', '#Strategy', '#Professional'
    ],
    'Social': [
      '#SocialButterfly', '#CommunityBuilder', '#Connector', '#Friendship',
      '#Communication', '#Outgoing', '#Social', '#Events'
    ],
    'Hobby': [
      '#HobbyEnthusiast', '#PassionProject', '#SkillShare', '#Creative',
      '#Learning', '#Expertise', '#Interest', '#Enthusiastic'
    ],
    'Lifestyle': [
      '#WorkLifeBalance', '#Wellness', '#Sustainable', '#Healthy',
      '#Mindful', '#Lifestyle', '#Balance', '#Positive'
    ],
  };

  /// Generate USER HOUSE specific hashtags for a category
  static List<String> generateUserHouseHashtags(String category) {
    return userHouseCategoryHashtags[category] ?? [];
  }

  /// Create enhanced GroupHashtags for USER HOUSE categories
  static GroupHashtags createUserHouseGroupHashtags({
    required String category,
    required List<String> requiredHashtags,
    List<String>? preferredHashtags,
    String? targetDemographic,
    String? specificVibe,
  }) {
    final categoryHashtags = generateUserHouseHashtags(category);
    final vibe = specificVibe ?? _getDefaultVibeForCategory(category);
    final demographic = targetDemographic ?? _getDefaultDemographicForCategory(category);

    return GroupHashtags(
      requiredHashtags: [...requiredHashtags, ...categoryHashtags.take(2)],
      preferredHashtags: [
        ...categoryHashtags.skip(2),
        ...(preferredHashtags ?? []),
      ],
      demographicTargets: _parseDemographicTargets(demographic),
      vibeTags: _parseVibeTags(vibe),
      activityTags: _getActivityTagsForCategory(category),
    );
  }

  /// Calculate enhanced compatibility for USER HOUSE matching
  static CompatibilityResult calculateUserHouseCompatibility({
    required UserProfileAttributes userAttributes,
    required GroupHashtags groupHashtags,
    required String userId,
    required String groupId,
    required String userHouseCategory,
    MatchingCriteria? criteria,
  }) {
    // Use USER HOUSE specific criteria if none provided
    final finalCriteria = criteria ?? _getMatchingCriteriaForCategory(userHouseCategory);

    // Get user hashtags
    final userHashtags = userAttributes.allHashtags;

    // Add USER HOUSE category hashtags to group preferences
    final categoryHashtags = generateUserHouseHashtags(userHouseCategory);
    final enhancedGroupHashtags = groupHashtags.copyWith(
      preferredHashtags: [...groupHashtags.preferredHashtags, ...categoryHashtags],
    );

    final matchingHashtags = enhancedGroupHashtags.getMatchingHashtags(userHashtags);
    final recommendationReasons = enhancedGroupHashtags.getRecommendationReasons(userHashtags);

    // Calculate individual dimension scores
    final workHashtags = userAttributes.workHashtags;
    final educationHashtags = userAttributes.educationHashtags;
    final lifestyleHashtags = userAttributes.lifestyleHashtags;
    final zodiacHashtags = userAttributes.zodiacHashtags;
    final demographicHashtags = userAttributes.demographicHashtags;

    final workScore = _calculateCategoryScore(workHashtags, enhancedGroupHashtags);
    final educationScore = _calculateCategoryScore(educationHashtags, enhancedGroupHashtags);
    final lifestyleScore = _calculateCategoryScore(lifestyleHashtags, enhancedGroupHashtags);
    final zodiacScore = _calculateCategoryScore(zodiacHashtags, enhancedGroupHashtags);
    final demographicScore = _calculateCategoryScore(demographicHashtags, enhancedGroupHashtags);

    return CompatibilityResult.fromScores(
      userId: userId,
      groupId: groupId,
      workScore: workScore,
      educationScore: educationScore,
      lifestyleScore: lifestyleScore,
      demographicScore: demographicScore,
      zodiacScore: zodiacScore,
      matchingHashtags: matchingHashtags,
      recommendationReasons: [
        ...recommendationReasons,
        'Perfect match for $userHouseCategory category',
        if (matchingHashtags.length >= 3) 'Strong hashtag compatibility'
      ],
      criteria: finalCriteria,
      algorithmUsed: 'user_house_hashtag_matching_v1',
      metadata: {
        'userHouseCategory': userHouseCategory,
        'totalMatchingHashtags': matchingHashtags.length,
        'categoryCompatibility': _calculateCategoryCompatibility(userHashtags, categoryHashtags),
      },
    );
  }

  /// Get compatibility score for a USER HOUSE category
  static double calculateUserHouseCategoryCompatibility(
    List<String> userHashtags,
    String userHouseCategory,
  ) {
    final categoryHashtags = generateUserHouseHashtags(userHouseCategory);
    final matches = userHashtags.where((tag) => categoryHashtags.contains(tag)).length;

    if (categoryHashtags.isEmpty) return 0.0;
    return matches / categoryHashtags.length;
  }

  /// Get personalized recommendations for USER HOUSE groups
  static List<String> getUserHouseRecommendations(UserProfileAttributes userAttributes) {
    final userHashtags = userAttributes.allHashtags;
    final recommendations = <String>[];

    // Analyze user's dominant hashtag categories
    final workTags = userHashtags.where((tag) =>
        workToHashtags.values.any((hashtags) => hashtags.contains(tag))).length;
    final socialTags = userHashtags.where((tag) =>
        tag.contains('#Social') || tag.contains('#Network') || tag.contains('#Community')).length;
    final creativeTags = userHashtags.where((tag) =>
        tag.contains('#Creative') || tag.contains('#Design') || tag.contains('#Art')).length;
    final lifestyleTags = userHashtags.where((tag) =>
        tag.contains('#Wellness') || tag.contains('#Health') || tag.contains('#Balance')).length;

    // Generate recommendations based on dominant themes
    if (workTags > socialTags && workTags > creativeTags) {
      recommendations.add('Professional networking groups for career advancement');
      recommendations.add('Industry-specific USER HOUSE communities');
    }

    if (socialTags > workTags && socialTags > lifestyleTags) {
      recommendations.add('Social connector groups for community building');
      recommendations.add('Event-focused USER HOUSE experiences');
    }

    if (creativeTags > workTags && creativeTags > socialTags) {
      recommendations.add('Creative collaboration USER HOUSE groups');
      recommendations.add('Artistic and design-focused communities');
    }

    if (lifestyleTags > socialTags && lifestyleTags > creativeTags) {
      recommendations.add('Wellness and balance USER HOUSE groups');
      recommendations.add('Healthy lifestyle communities');
    }

    // Add general recommendations
    recommendations.add('Groups matching your professional interests');
    recommendations.add('Communities aligned with your educational background');

    return recommendations;
  }

  /// Generate USER HOUSE specific hashtag suggestions for users
  static List<String> generateUserHouseHashtagSuggestions(UserProfileAttributes userAttributes) {
    final suggestions = <String>[];

    // Add category-specific suggestions based on user attributes
    if (userAttributes.work.toLowerCase().contains('engineer') ||
        userAttributes.work.toLowerCase().contains('developer')) {
      suggestions.addAll(['#TechInnovator', '#CodeBuilder', '#DigitalCreator']);
    }

    if (userAttributes.work.toLowerCase().contains('designer')) {
      suggestions.addAll(['#VisualThinker', '#CreativePro', '#DesignInnovator']);
    }

    if (userAttributes.education.toLowerCase().contains('stanford') ||
        userAttributes.education.toLowerCase().contains('harvard')) {
      suggestions.addAll(['#EliteEducation', '#TopGraduate', '#PremierAcademic']);
    }

    if (userAttributes.mealInterest.toLowerCase().contains('fine dining')) {
      suggestions.addAll(['#GourmetExplorer', '#CulinaryExpert', '#FoodConnoisseur']);
    }

    if (userAttributes.drinkingHabits.toLowerCase().contains('social')) {
      suggestions.addAll(['#SocialConnector', '#NetworkBuilder', '#CommunityHost']);
    }

    // Add lifestyle suggestions
    suggestions.addAll(['#ActiveParticipant', '#PositiveContributor', '#TeamPlayer']);

    return suggestions.toSet().toList(); // Remove duplicates
  }

  // Private helper methods

  static MatchingCriteria _getMatchingCriteriaForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'professional':
        return MatchingCriteria.professionalFocus();
      case 'social':
        return MatchingCriteria.socialDiningFocus();
      case 'hobby':
        return MatchingCriteria.lifestyleFocus();
      case 'lifestyle':
        return MatchingCriteria.lifestyleFocus();
      default:
        return const MatchingCriteria();
    }
  }

  static String _getDefaultVibeForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'professional':
        return 'Ambitious,Driven,GoalOriented';
      case 'social':
        return 'Friendly,Welcoming,Inclusive';
      case 'hobby':
        return 'Enthusiastic,Collaborative,Inspiring';
      case 'lifestyle':
        return 'Relaxed,Supportive,Positive';
      default:
        return 'Balanced,Open,Engaging';
    }
  }

  static String _getDefaultDemographicForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'professional':
        return '#25-45,#Career,#Professional';
      case 'social':
        return '#21-35,#Social,#Community';
      case 'hobby':
        return '#20-50,#Creative,#Learning';
      case 'lifestyle':
        return '#22-45,#Wellness,#Balance';
      default:
        return '#21-40,#Open,#Diverse';
    }
  }

  static List<String> _parseDemographicTargets(String demographic) {
    return demographic.split(',').map((tag) => '#${tag.trim()}').toList();
  }

  static List<String> _parseVibeTags(String vibe) {
    return vibe.split(',').map((tag) => '#${tag.trim()}').toList();
  }

  static List<String> _getActivityTagsForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'professional':
        return ['#Workshops', '#Seminars', '#Mentorship', '#Networking'];
      case 'social':
        return ['#SocialEvents', '#Meetups', '#Gatherings', '#Community'];
      case 'hobby':
        return ['#Workshops', '#Projects', '#Collaboration', '#SkillShare'];
      case 'lifestyle':
        return ['#WellnessActivities', '#LifestyleEvents', '#SelfCare', '#Balance'];
      default:
        return ['#Activities', '#Events', '#Gatherings', '#Community'];
    }
  }

  
  static double _calculateCategoryCompatibility(List<String> userHashtags, List<String> categoryHashtags) {
    if (categoryHashtags.isEmpty) return 0.0;

    final matches = userHashtags.where((tag) => categoryHashtags.contains(tag)).length;
    return matches / categoryHashtags.length;
  }
}