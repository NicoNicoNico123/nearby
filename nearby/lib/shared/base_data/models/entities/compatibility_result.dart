import 'matching_criteria.dart';

/// Enhanced compatibility results for user-group matching
/// Provides detailed scoring and reasoning for matches
class CompatibilityResult {
  final String userId;
  final String groupId;
  final double totalScore;              // Overall compatibility (0.0 to 1.0)

  // Individual dimension scores
  final double workScore;               // Work/career compatibility
  final double educationScore;          // Education/background compatibility
  final double lifestyleScore;          // Meal/drink/social compatibility
  final double demographicScore;        // Age/gender compatibility
  final double zodiacScore;             // Star sign compatibility

  final List<String> matchingHashtags;  // Overlapping hashtags
  final List<String> recommendationReasons; // Why user should join
  final MatchQuality matchQuality;      // Quality classification
  final DateTime calculatedAt;          // When this result was calculated
  final String? algorithmUsed;          // Which matching algorithm was used
  final Map<String, dynamic>? metadata; // Additional data

  const CompatibilityResult({
    required this.userId,
    required this.groupId,
    required this.totalScore,
    required this.workScore,
    required this.educationScore,
    required this.lifestyleScore,
    required this.demographicScore,
    required this.zodiacScore,
    required this.matchingHashtags,
    required this.recommendationReasons,
    required this.matchQuality,
    required this.calculatedAt,
    this.algorithmUsed,
    this.metadata,
  });

  /// Creates a compatibility result from scores
  factory CompatibilityResult.fromScores({
    required String userId,
    required String groupId,
    required double workScore,
    required double educationScore,
    required double lifestyleScore,
    required double demographicScore,
    required double zodiacScore,
    required List<String> matchingHashtags,
    required List<String> recommendationReasons,
    MatchingCriteria? criteria,
    String? algorithmUsed,
    Map<String, dynamic>? metadata,
  }) {
    // Use default criteria if none provided
    final finalCriteria = criteria ?? const MatchingCriteria();

    // Calculate weighted total score
    final totalScore = (workScore * finalCriteria.workWeight) +
                      (educationScore * finalCriteria.educationWeight) +
                      (lifestyleScore * finalCriteria.lifestyleWeight) +
                      (demographicScore * finalCriteria.demographicWeight) +
                      (zodiacScore * finalCriteria.zodiacWeight);

    // Determine match quality
    final matchQuality = totalScore >= finalCriteria.excellentMatchThreshold
        ? MatchQuality.excellent
        : totalScore >= finalCriteria.goodMatchThreshold
            ? MatchQuality.good
            : totalScore >= finalCriteria.minimumThreshold
                ? MatchQuality.fair
                : MatchQuality.poor;

    return CompatibilityResult(
      userId: userId,
      groupId: groupId,
      totalScore: totalScore,
      workScore: workScore,
      educationScore: educationScore,
      lifestyleScore: lifestyleScore,
      demographicScore: demographicScore,
      zodiacScore: zodiacScore,
      matchingHashtags: matchingHashtags,
      recommendationReasons: recommendationReasons,
      matchQuality: matchQuality,
      calculatedAt: DateTime.now(),
      algorithmUsed: algorithmUsed ?? 'weighted_hashtag_matching_v1',
      metadata: metadata,
    );
  }

  /// Creates a simple compatibility result from overall score
  factory CompatibilityResult.simple({
    required String userId,
    required String groupId,
    required double totalScore,
    required List<String> matchingHashtags,
    required List<String> recommendationReasons,
    String? algorithmUsed,
    Map<String, dynamic>? metadata,
  }) {
    // Determine match quality
    final matchQuality = totalScore >= 0.80
        ? MatchQuality.excellent
        : totalScore >= 0.60
            ? MatchQuality.good
            : totalScore >= 0.30
                ? MatchQuality.fair
                : MatchQuality.poor;

    return CompatibilityResult(
      userId: userId,
      groupId: groupId,
      totalScore: totalScore,
      workScore: 0.0,
      educationScore: 0.0,
      lifestyleScore: 0.0,
      demographicScore: 0.0,
      zodiacScore: 0.0,
      matchingHashtags: matchingHashtags,
      recommendationReasons: recommendationReasons,
      matchQuality: matchQuality,
      calculatedAt: DateTime.now(),
      algorithmUsed: algorithmUsed ?? 'simple_hashtag_matching_v1',
      metadata: metadata,
    );
  }

  /// Gets score as percentage (0-100)
  int get totalPercentage => (totalScore * 100).round();
  int get workPercentage => (workScore * 100).round();
  int get educationPercentage => (educationScore * 100).round();
  int get lifestylePercentage => (lifestyleScore * 100).round();
  int get demographicPercentage => (demographicScore * 100).round();
  int get zodiacPercentage => (zodiacScore * 100).round();

  /// Gets primary matching dimension
  String get primaryMatchingDimension {
    final scores = {
      'Work': workScore,
      'Education': educationScore,
      'Lifestyle': lifestyleScore,
      'Demographics': demographicScore,
      'Star Sign': zodiacScore,
    };

    return scores.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// Gets the top 3 matching dimensions
  List<Map<String, dynamic>> get topMatchingDimensions {
    final dimensions = [
      {'name': 'Work', 'score': workScore, 'percentage': workPercentage},
      {'name': 'Education', 'score': educationScore, 'percentage': educationPercentage},
      {'name': 'Lifestyle', 'score': lifestyleScore, 'percentage': lifestylePercentage},
      {'name': 'Demographics', 'score': demographicScore, 'percentage': demographicPercentage},
      {'name': 'Star Sign', 'score': zodiacScore, 'percentage': zodiacPercentage},
    ];

    dimensions.sort((a, b) => (b['score'] as double).compareTo(a['score'] as double));
    return dimensions.take(3).toList();
  }

  /// Checks if this is a good match worth showing
  bool get isGoodMatch => matchQuality.index >= MatchQuality.good.index;

  /// Checks if this is an excellent match worth highlighting
  bool get isExcellentMatch => matchQuality == MatchQuality.excellent;

  /// Gets a user-friendly description of the match
  String get matchDescription {
    switch (matchQuality) {
      case MatchQuality.excellent:
        return 'Excellent match! You share many interests and demographics.';
      case MatchQuality.good:
        return 'Good match! You have several overlapping interests.';
      case MatchQuality.fair:
        return 'Fair match. You have some interests in common.';
      case MatchQuality.poor:
        return 'Limited compatibility. Consider other groups.';
    }
  }

  /// Converts to JSON for storage/serialization
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'groupId': groupId,
      'totalScore': totalScore,
      'workScore': workScore,
      'educationScore': educationScore,
      'lifestyleScore': lifestyleScore,
      'demographicScore': demographicScore,
      'zodiacScore': zodiacScore,
      'matchingHashtags': matchingHashtags,
      'recommendationReasons': recommendationReasons,
      'matchQuality': matchQuality.name,
      'calculatedAt': calculatedAt.toIso8601String(),
      'algorithmUsed': algorithmUsed,
      'metadata': metadata,
    };
  }

  /// Creates from JSON
  factory CompatibilityResult.fromJson(Map<String, dynamic> json) {
    return CompatibilityResult(
      userId: json['userId'] as String,
      groupId: json['groupId'] as String,
      totalScore: (json['totalScore'] as num).toDouble(),
      workScore: (json['workScore'] as num?)?.toDouble() ?? 0.0,
      educationScore: (json['educationScore'] as num?)?.toDouble() ?? 0.0,
      lifestyleScore: (json['lifestyleScore'] as num?)?.toDouble() ?? 0.0,
      demographicScore: (json['demographicScore'] as num?)?.toDouble() ?? 0.0,
      zodiacScore: (json['zodiacScore'] as num?)?.toDouble() ?? 0.0,
      matchingHashtags: List<String>.from(json['matchingHashtags'] as List? ?? []),
      recommendationReasons: List<String>.from(json['recommendationReasons'] as List? ?? []),
      matchQuality: MatchQuality.values.firstWhere(
        (quality) => quality.name == json['matchQuality'],
        orElse: () => MatchQuality.fair,
      ),
      calculatedAt: DateTime.parse(json['calculatedAt'] as String),
      algorithmUsed: json['algorithmUsed'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  String toString() {
    return 'CompatibilityResult(userId: $userId, groupId: $groupId, totalScore: $totalPercentage%, matchQuality: $matchQuality)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompatibilityResult &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          groupId == other.groupId &&
          calculatedAt == other.calculatedAt;

  @override
  int get hashCode => userId.hashCode ^ groupId.hashCode ^ calculatedAt.hashCode;
}

/// Quality levels for compatibility matches
enum MatchQuality {
  poor,      // < 30% match
  fair,      // 30-59% match
  good,      // 60-79% match
  excellent, // 80%+ match
}

/// Extension methods for MatchQuality enum
extension MatchQualityExtension on MatchQuality {
  /// Gets display color for the match quality
  String get colorHex {
    switch (this) {
      case MatchQuality.excellent:
        return '#4CAF50'; // Green
      case MatchQuality.good:
        return '#2196F3'; // Blue
      case MatchQuality.fair:
        return '#FF9800'; // Orange
      case MatchQuality.poor:
        return '#F44336'; // Red
    }
  }

  /// Gets emoji for the match quality
  String get emoji {
    switch (this) {
      case MatchQuality.excellent:
        return '🔥';
      case MatchQuality.good:
        return '✨';
      case MatchQuality.fair:
        return '👍';
      case MatchQuality.poor:
        return '❓';
    }
  }

  /// Gets priority for sorting (higher = better)
  int get priority {
    switch (this) {
      case MatchQuality.excellent:
        return 4;
      case MatchQuality.good:
        return 3;
      case MatchQuality.fair:
        return 2;
      case MatchQuality.poor:
        return 1;
    }
  }
}