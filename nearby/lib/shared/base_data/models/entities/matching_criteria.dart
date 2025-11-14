/// Matching criteria configuration for user-group compatibility
/// Defines weights and thresholds for the matching algorithm
class MatchingCriteria {
  final double workWeight;              // Work/career compatibility (25%)
  final double educationWeight;         // Education/background (15%)
  final double lifestyleWeight;         // Meal/drink/social (30%)
  final double demographicWeight;       // Age/gender (20%)
  final double zodiacWeight;            // Star sign (10%)

  final double minimumThreshold;        // Minimum score to show group (30%)
  final double goodMatchThreshold;      // Good match score (60%)
  final double excellentMatchThreshold; // Excellent match score (80%)

  const MatchingCriteria({
    this.workWeight = 0.25,
    this.educationWeight = 0.15,
    this.lifestyleWeight = 0.30,
    this.demographicWeight = 0.20,
    this.zodiacWeight = 0.10,
    this.minimumThreshold = 0.30,
    this.goodMatchThreshold = 0.60,
    this.excellentMatchThreshold = 0.80,
  });

  /// Validates that weights sum to 1.0
  bool get isValid {
    final totalWeight = workWeight + educationWeight + lifestyleWeight +
                       demographicWeight + zodiacWeight;
    return (totalWeight - 1.0).abs() < 0.01; // Allow small floating point errors
  }

  /// Creates criteria for professional networking focus
  factory MatchingCriteria.professionalFocus() {
    return const MatchingCriteria(
      workWeight: 0.40,              // Emphasize work compatibility
      educationWeight: 0.25,         // Education more important
      lifestyleWeight: 0.15,         // Lifestyle less important
      demographicWeight: 0.15,       // Demographics moderate
      zodiacWeight: 0.05,            // Zodiac least important
      minimumThreshold: 0.35,        // Higher threshold for professional groups
      goodMatchThreshold: 0.65,
      excellentMatchThreshold: 0.85,
    );
  }

  /// Creates criteria for social dining focus
  factory MatchingCriteria.socialDiningFocus() {
    return const MatchingCriteria(
      workWeight: 0.15,              // Work less important
      educationWeight: 0.10,         // Education less important
      lifestyleWeight: 0.45,         // Lifestyle very important
      demographicWeight: 0.25,       // Demographics important for age groups
      zodiacWeight: 0.05,            // Zodiac least important
      minimumThreshold: 0.25,        // Lower threshold for social groups
      goodMatchThreshold: 0.55,
      excellentMatchThreshold: 0.75,
    );
  }

  /// Creates criteria for lifestyle/activity focus
  factory MatchingCriteria.lifestyleFocus() {
    return const MatchingCriteria(
      workWeight: 0.10,              // Work least important
      educationWeight: 0.10,         // Education less important
      lifestyleWeight: 0.40,         // Lifestyle most important
      demographicWeight: 0.30,       // Demographics important for activities
      zodiacWeight: 0.10,            // Zodiac moderate for lifestyle compatibility
      minimumThreshold: 0.30,
      goodMatchThreshold: 0.60,
      excellentMatchThreshold: 0.80,
    );
  }

  /// Creates criteria for dating/romantic focus
  factory MatchingCriteria.datingFocus() {
    return const MatchingCriteria(
      workWeight: 0.20,              // Work moderately important
      educationWeight: 0.15,         // Education moderately important
      lifestyleWeight: 0.35,         // Lifestyle very important
      demographicWeight: 0.20,       // Demographics important for dating
      zodiacWeight: 0.10,            // Zodiac more important for dating
      minimumThreshold: 0.40,        // Higher threshold for dating
      goodMatchThreshold: 0.70,
      excellentMatchThreshold: 0.90,
    );
  }

  MatchingCriteria copyWith({
    double? workWeight,
    double? educationWeight,
    double? lifestyleWeight,
    double? demographicWeight,
    double? zodiacWeight,
    double? minimumThreshold,
    double? goodMatchThreshold,
    double? excellentMatchThreshold,
  }) {
    return MatchingCriteria(
      workWeight: workWeight ?? this.workWeight,
      educationWeight: educationWeight ?? this.educationWeight,
      lifestyleWeight: lifestyleWeight ?? this.lifestyleWeight,
      demographicWeight: demographicWeight ?? this.demographicWeight,
      zodiacWeight: zodiacWeight ?? this.zodiacWeight,
      minimumThreshold: minimumThreshold ?? this.minimumThreshold,
      goodMatchThreshold: goodMatchThreshold ?? this.goodMatchThreshold,
      excellentMatchThreshold: excellentMatchThreshold ?? this.excellentMatchThreshold,
    );
  }

  @override
  String toString() {
    return 'MatchingCriteria(workWeight: $workWeight, educationWeight: $educationWeight, lifestyleWeight: $lifestyleWeight, demographicWeight: $demographicWeight, zodiacWeight: $zodiacWeight, minimumThreshold: $minimumThreshold, goodMatchThreshold: $goodMatchThreshold, excellentMatchThreshold: $excellentMatchThreshold)';
  }
}