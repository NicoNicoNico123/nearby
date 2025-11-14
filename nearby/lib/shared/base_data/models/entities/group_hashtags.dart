/// Group hashtag requirements for user matching
/// Defines what types of users should match with this group
class GroupHashtags {
  final List<String> requiredHashtags;      // Must match these
  final List<String> preferredHashtags;     // Nice to match
  final List<String> demographicTargets;    // Age/gender/location
  final List<String> vibeTags;              // Lifestyle/atmosphere
  final List<String> activityTags;          // Activity matching

  const GroupHashtags({
    this.requiredHashtags = const [],
    this.preferredHashtags = const [],
    this.demographicTargets = const [],
    this.vibeTags = const [],
    this.activityTags = const [],
  });

  /// Checks if a user's hashtags match this group's requirements
  bool matchesUser(List<String> userHashtags, {double minimumMatchRate = 0.3}) {
    if (requiredHashtags.isNotEmpty) {
      final requiredMatches = requiredHashtags.where((tag) =>
          userHashtags.contains(tag)).length;
      final requiredMatchRate = requiredMatches / requiredHashtags.length;

      if (requiredMatchRate < 0.5) return false; // Must match at least 50% of required
    }

    // Calculate overall compatibility
    final allGroupTags = [
      ...requiredHashtags,
      ...preferredHashtags,
      ...demographicTargets,
      ...vibeTags,
      ...activityTags,
    ];

    if (allGroupTags.isEmpty) return true;

    final matches = allGroupTags.where((tag) =>
        userHashtags.contains(tag)).length;
    final matchRate = matches / allGroupTags.length;

    return matchRate >= minimumMatchRate;
  }

  /// Calculates compatibility score with user hashtags
  double calculateCompatibilityScore(List<String> userHashtags) {
    final allGroupTags = [
      ...requiredHashtags,
      ...preferredHashtags,
      ...demographicTargets,
      ...vibeTags,
      ...activityTags,
    ];

    if (allGroupTags.isEmpty) return 0.5; // Default score

    final weightedScores = <String, double>{};

    // Required tags have highest weight (40%)
    for (final tag in requiredHashtags) {
      weightedScores[tag] = (weightedScores[tag] ?? 0) + 0.40 / requiredHashtags.length;
    }

    // Preferred tags have medium weight (25%)
    for (final tag in preferredHashtags) {
      weightedScores[tag] = (weightedScores[tag] ?? 0) + 0.25 / preferredHashtags.length;
    }

    // Demographic tags have medium weight (20%)
    for (final tag in demographicTargets) {
      weightedScores[tag] = (weightedScores[tag] ?? 0) + 0.20 / demographicTargets.length;
    }

    // Vibe tags have lower weight (10%)
    for (final tag in vibeTags) {
      weightedScores[tag] = (weightedScores[tag] ?? 0) + 0.10 / vibeTags.length;
    }

    // Activity tags have lowest weight (5%)
    for (final tag in activityTags) {
      weightedScores[tag] = (weightedScores[tag] ?? 0) + 0.05 / activityTags.length;
    }

    double totalScore = 0.0;
    for (final userTag in userHashtags) {
      totalScore += weightedScores[userTag] ?? 0.0;
    }

    return totalScore.clamp(0.0, 1.0);
  }

  /// Gets matching hashtags between user and group
  List<String> getMatchingHashtags(List<String> userHashtags) {
    final allGroupTags = {
      ...requiredHashtags,
      ...preferredHashtags,
      ...demographicTargets,
      ...vibeTags,
      ...activityTags,
    };

    return userHashtags.where((tag) => allGroupTags.contains(tag)).toList();
  }

  /// Generates recommendation reasons for why user should join
  List<String> getRecommendationReasons(List<String> userHashtags) {
    final reasons = <String>[];
    final matchingHashtags = getMatchingHashtags(userHashtags);

    // Required tag matches
    final requiredMatches = requiredHashtags.where((tag) =>
        userHashtags.contains(tag)).toList();
    if (requiredMatches.isNotEmpty) {
      reasons.add('Perfect match: You share ${requiredMatches.length} required interests');
    }

    // Professional matches
    final professionalTags = ['#Tech', '#Engineering', '#Business', '#Management', '#Startup'];
    final professionalMatches = matchingHashtags.where((tag) =>
        professionalTags.contains(tag)).toList();
    if (professionalMatches.length >= 2) {
      reasons.add('Great professional networking opportunity');
    }

    // Lifestyle matches
    final lifestyleTags = ['#FineDining', '#Wine', '#Social', '#Upscale', '#Gourmet'];
    final lifestyleMatches = matchingHashtags.where((tag) =>
        lifestyleTags.contains(tag)).toList();
    if (lifestyleMatches.isNotEmpty) {
      reasons.add('Similar lifestyle preferences');
    }

    // Demographic matches
    final demographicMatches = demographicTargets.where((tag) =>
        userHashtags.contains(tag)).toList();
    if (demographicMatches.isNotEmpty) {
      reasons.add('You\'re in the target demographic');
    }

    // Activity matches
    if (activityTags.isNotEmpty) {
      final activityMatches = activityTags.where((tag) =>
          userHashtags.contains(tag)).toList();
      if (activityMatches.isNotEmpty) {
        reasons.add('Shared activity interests');
      }
    }

    if (reasons.isEmpty && matchingHashtags.isNotEmpty) {
      reasons.add('You have ${matchingHashtags.length} overlapping interests');
    }

    return reasons;
  }

  GroupHashtags copyWith({
    List<String>? requiredHashtags,
    List<String>? preferredHashtags,
    List<String>? demographicTargets,
    List<String>? vibeTags,
    List<String>? activityTags,
  }) {
    return GroupHashtags(
      requiredHashtags: requiredHashtags ?? this.requiredHashtags,
      preferredHashtags: preferredHashtags ?? this.preferredHashtags,
      demographicTargets: demographicTargets ?? this.demographicTargets,
      vibeTags: vibeTags ?? this.vibeTags,
      activityTags: activityTags ?? this.activityTags,
    );
  }

  /// Creates hashtags for tech professional groups
  factory GroupHashtags.forTechProfessionals({
    List<String> skills = const [],
    String experienceLevel = 'any',
  }) {
    final required = ['#Tech', '#Engineering'];
    final preferred = ['#Professional', '#Networking'];

    if (skills.isNotEmpty) {
      required.addAll(skills.map((skill) => '#$skill'));
    }

    switch (experienceLevel.toLowerCase()) {
      case 'senior':
        preferred.addAll(['#Senior', '#Lead', '#Experienced']);
        break;
      case 'junior':
        preferred.addAll(['#Junior', '#EarlyCareer', '#Learning']);
        break;
    }

    return GroupHashtags(
      requiredHashtags: required,
      preferredHashtags: preferred,
      demographicTargets: ['#25-45', '#Career'],
      vibeTags: ['#Professional', '#Intellectual', '#Innovative'],
      activityTags: ['#TechMeetups', '#Networking', '#CareerGrowth'],
    );
  }

  /// Creates hashtags for dining/social groups
  factory GroupHashtags.forDining({
    String cuisineType = 'international',
    String diningStyle = 'casual',
    List<String> drinkPreferences = const [],
  }) {
    final required = <String>['#Dining', '#Food'];
    final preferred = <String>['#Social'];

    // Add cuisine-specific tags
    switch (cuisineType.toLowerCase()) {
      case 'italian':
        required.addAll(['#Italian', '#Pasta', '#Wine']);
        break;
      case 'japanese':
        required.addAll(['#Japanese', '#Sushi', '#Asian']);
        break;
      case 'mediterranean':
        required.addAll(['#Mediterranean', '#Healthy', '#Seafood']);
        break;
      default:
        required.add('#International');
    }

    // Add dining style tags
    switch (diningStyle.toLowerCase()) {
      case 'fine':
        preferred.addAll(['#FineDining', '#Upscale', '#Gourmet']);
        break;
      case 'casual':
        preferred.addAll(['#Casual', '#Relaxed', '#Informal']);
        break;
    }

    // Add drink preference tags
    if (drinkPreferences.isNotEmpty) {
      preferred.addAll(drinkPreferences.map((drink) => '#$drink'));
    }

    return GroupHashtags(
      requiredHashtags: required,
      preferredHashtags: preferred,
      demographicTargets: ['#25-55', '#Social'],
      vibeTags: ['#Social', '#Foodie', '#Culinary'],
      activityTags: ['#FoodTasting', '#Socializing', '#Exploration'],
    );
  }

  /// Creates hashtags for lifestyle/activity groups
  factory GroupHashtags.forLifestyle({
    String activity = 'general',
    String intensity = 'moderate',
    List<String> interests = const [],
  }) {
    final required = <String>['#Lifestyle'];
    final preferred = <String>['#Social'];

    // Add activity-specific tags
    switch (activity.toLowerCase()) {
      case 'fitness':
        required.addAll(['#Fitness', '#Health', '#Exercise']);
        preferred.addAll(['#Active', '#Wellness']);
        break;
      case 'outdoors':
        required.addAll(['#Outdoors', '#Nature', '#Adventure']);
        preferred.addAll(['#Hiking', '#Exploration']);
        break;
      case 'arts':
        required.addAll(['#Arts', '#Creative', '#Culture']);
        preferred.addAll(['#Artistic', '#Cultural']);
        break;
      default:
        required.add('#General');
    }

    // Add intensity tags
    switch (intensity.toLowerCase()) {
      case 'high':
        preferred.addAll(['#Intense', '#Challenging', '#Advanced']);
        break;
      case 'low':
        preferred.addAll(['#Relaxed', '#Beginner', '#Casual']);
        break;
    }

    // Add interest tags
    preferred.addAll(interests.map((interest) => '#$interest'));

    return GroupHashtags(
      requiredHashtags: required,
      preferredHashtags: preferred,
      demographicTargets: ['#18-50', '#Active'],
      vibeTags: ['#Active', '#Healthy', '#Balanced'],
      activityTags: ['#Lifestyle', '#Activities', '#Hobbies'],
    );
  }

  @override
  String toString() {
    return 'GroupHashtags(requiredHashtags: $requiredHashtags, preferredHashtags: $preferredHashtags, demographicTargets: $demographicTargets, vibeTags: $vibeTags, activityTags: $activityTags)';
  }
}