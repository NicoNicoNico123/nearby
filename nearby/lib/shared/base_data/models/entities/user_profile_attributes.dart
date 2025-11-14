
/// User profile attributes that generate hashtags for group matching
/// This class converts user information into searchable hashtags
class UserProfileAttributes {
  final String work;
  final String education;
  final String mealInterest;
  final String drinkingHabits;
  final String starSign;
  final int age;
  final String gender;

  const UserProfileAttributes({
    required this.work,
    required this.education,
    required this.mealInterest,
    required this.drinkingHabits,
    required this.starSign,
    required this.age,
    required this.gender,
  });

  /// Generates work-related hashtags based on occupation
  List<String> get workHashtags {
    final workLower = work.toLowerCase();
    final hashtags = <String>[];

    // Direct work match
    if (workLower.isNotEmpty) hashtags.add('#${workLower.replaceAll(' ', '')}');

    // Industry-based hashtags
    if (workLower.contains('software') || workLower.contains('developer') || workLower.contains('engineer')) {
      hashtags.addAll(['#Tech', '#Engineering', '#Programming', '#Software']);
    }
    if (workLower.contains('design') || workLower.contains('designer')) {
      hashtags.addAll(['#Design', '#Creative', '#UI', '#UX']);
    }
    if (workLower.contains('manager') || workLower.contains('management')) {
      hashtags.addAll(['#Management', '#Leadership', '#Business']);
    }
    if (workLower.contains('teacher') || workLower.contains('professor')) {
      hashtags.addAll(['#Education', '#Teaching', '#Academic']);
    }
    if (workLower.contains('doctor') || workLower.contains('nurse') || workLower.contains('medical')) {
      hashtags.addAll(['#Healthcare', '#Medical', '#Science']);
    }
    if (workLower.contains('artist') || workLower.contains('creative')) {
      hashtags.addAll(['#Arts', '#Creative', '#Artist']);
    }
    if (workLower.contains('marketing') || workLower.contains('sales')) {
      hashtags.addAll(['#Marketing', '#Sales', '#Business']);
    }
    if (workLower.contains('writer') || workLower.contains('journalist')) {
      hashtags.addAll(['#Writing', '#Media', '#Content']);
    }
    if (workLower.contains('consultant')) {
      hashtags.addAll(['#Consulting', '#Professional', '#Expert']);
    }
    if (workLower.contains('entrepreneur') || workLower.contains('founder')) {
      hashtags.addAll(['#Entrepreneurship', '#Startup', '#Founder']);
    }

    // Seniority level hashtags
    if (workLower.contains('senior') || workLower.contains('lead') || workLower.contains('principal')) {
      hashtags.addAll(['#Senior', '#Lead', '#Experienced']);
    }
    if (workLower.contains('junior') || workLower.contains('entry')) {
      hashtags.addAll(['#Junior', '#EntryLevel', '#EarlyCareer']);
    }

    return hashtags;
  }

  /// Generates education-related hashtags
  List<String> get educationHashtags {
    final educationLower = education.toLowerCase();
    final hashtags = <String>[];

    // School/University specific hashtags
    if (educationLower.contains('stanford')) {
      hashtags.addAll(['#Stanford', '#EliteEducation', '#SiliconValley']);
    }
    if (educationLower.contains('harvard')) {
      hashtags.addAll(['#Harvard', '#IvyLeague', '#EliteEducation']);
    }
    if (educationLower.contains('mit')) {
      hashtags.addAll(['#MIT', '#TechSchool', '#Engineering']);
    }
    if (educationLower.contains('berkeley')) {
      hashtags.addAll(['#Berkeley', '#UC', '#PublicUniversity']);
    }
    if (educationLower.contains('yale')) {
      hashtags.addAll(['#Yale', '#IvyLeague', '#LiberalArts']);
    }
    if (educationLower.contains('princeton')) {
      hashtags.addAll(['#Princeton', '#IvyLeague', '#Research']);
    }

    // Education level hashtags
    if (educationLower.contains('phd') || educationLower.contains('doctorate')) {
      hashtags.addAll(['#PhD', '#Doctorate', '#HigherEducation']);
    }
    if (educationLower.contains('master') || educationLower.contains('m.s.') || educationLower.contains('m.a.')) {
      hashtags.addAll(['#Masters', '#Graduate', '#Postgraduate']);
    }
    if (educationLower.contains('bachelor') || educationLower.contains('b.s.') || educationLower.contains('b.a.')) {
      hashtags.addAll(['#Bachelors', '#Undergraduate', '#College']);
    }
    if (educationLower.contains('associate') || educationLower.contains('a.a.')) {
      hashtags.addAll(['#Associate', '#CommunityCollege']);
    }

    // Field of study hashtags
    if (educationLower.contains('computer science') || educationLower.contains('cs')) {
      hashtags.addAll(['#ComputerScience', '#Tech', '#STEM']);
    }
    if (educationLower.contains('business') || educationLower.contains('mba')) {
      hashtags.addAll(['#Business', '#MBA', '#Management']);
    }
    if (educationLower.contains('art') || educationLower.contains('design')) {
      hashtags.addAll(['#Arts', '#Design', '#Creative']);
    }
    if (educationLower.contains('science') || educationLower.contains('biology') || educationLower.contains('chemistry')) {
      hashtags.addAll(['#Science', '#STEM', '#Research']);
    }
    if (educationLower.contains('literature') || educationLower.contains('english')) {
      hashtags.addAll(['#Literature', '#Humanities', '#Writing']);
    }

    return hashtags;
  }

  /// Generates lifestyle hashtags based on meal and drinking preferences
  List<String> get lifestyleHashtags {
    final mealLower = mealInterest.toLowerCase();
    final drinkLower = drinkingHabits.toLowerCase();
    final hashtags = <String>[];

    // Meal interest hashtags
    if (mealLower.contains('mediterranean')) {
      hashtags.addAll(['#Mediterranean', '#Healthy', '#Seafood']);
    }
    if (mealLower.contains('japanese')) {
      hashtags.addAll(['#Japanese', '#Sushi', '#Asian']);
    }
    if (mealLower.contains('vegetarian') || mealLower.contains('vegan')) {
      hashtags.addAll(['#Vegetarian', '#Healthy', '#PlantBased']);
    }
    if (mealLower.contains('italian')) {
      hashtags.addAll(['#Italian', '#Pasta', '#Wine']);
    }
    if (mealLower.contains('mexican')) {
      hashtags.addAll(['#Mexican', '#Spicy', '#Tacos']);
    }
    if (mealLower.contains('thai')) {
      hashtags.addAll(['#Thai', '#Asian', '#Spicy']);
    }
    if (mealLower.contains('indian')) {
      hashtags.addAll(['#Indian', '#Curry', '#Spices']);
    }
    if (mealLower.contains('french')) {
      hashtags.addAll(['#French', '#FineDining', '#Gourmet']);
    }
    if (mealLower.contains('chinese')) {
      hashtags.addAll(['#Chinese', '#Asian', '#DimSum']);
    }

    // Dining style hashtags
    if (mealLower.contains('fine dining') || mealLower.contains('gourmet')) {
      hashtags.addAll(['#FineDining', '#Gourmet', '#Upscale']);
    }
    if (mealLower.contains('casual')) {
      hashtags.addAll(['#Casual', '#Relaxed', '#Informal']);
    }
    if (mealLower.contains('organic')) {
      hashtags.addAll(['#Organic', '#Healthy', '#Natural']);
    }
    if (mealLower.contains('farm-to-table')) {
      hashtags.addAll(['#FarmToTable', '#Local', '#Fresh']);
    }

    // Drinking habit hashtags
    if (drinkLower.contains('non') || drinkLower.contains('sober')) {
      hashtags.addAll(['#NonDrinker', '#Sober', '#Health']);
    }
    if (drinkLower.contains('occasional') || drinkLower.contains('rarely')) {
      hashtags.addAll(['#Occasional', '#Moderate', '#Casual']);
    }
    if (drinkLower.contains('social')) {
      hashtags.addAll(['#Social', '#SocialButterfly', '#Wine', '#Cocktails']);
    }
    if (drinkLower.contains('regular') || drinkLower.contains('often')) {
      hashtags.addAll(['#Regular', '#Social', '#Nightlife']);
    }

    // Specific drink preferences
    if (drinkLower.contains('wine')) {
      hashtags.addAll(['#Wine', '#WineTasting', '#Vineyard']);
    }
    if (drinkLower.contains('cocktails') || drinkLower.contains('drinks')) {
      hashtags.addAll(['#Cocktails', '#Mixology', '#Bar']);
    }
    if (drinkLower.contains('beer') || drinkLower.contains('craft')) {
      hashtags.addAll(['#Beer', '#CraftBeer', '#Brewery']);
    }
    if (drinkLower.contains('coffee')) {
      hashtags.addAll(['#Coffee', '#Cafe', '#Espresso']);
    }

    return hashtags;
  }

  /// Generates zodiac/astrology-related hashtags
  List<String> get zodiacHashtags {
    final starLower = starSign.toLowerCase();
    final hashtags = <String>[];

    // Add the specific star sign
    hashtags.add('#$starSign');

    // Element-based hashtags
    if (['aries', 'leo', 'sagittarius'].contains(starLower)) {
      hashtags.addAll(['#FireSign', '#Passionate', '#Energetic']);
    }
    if (['taurus', 'virgo', 'capricorn'].contains(starLower)) {
      hashtags.addAll(['#EarthSign', '#Grounded', '#Practical']);
    }
    if (['gemini', 'libra', 'aquarius'].contains(starLower)) {
      hashtags.addAll(['#AirSign', '#Intellectual', '#Social']);
    }
    if (['cancer', 'scorpio', 'pisces'].contains(starLower)) {
      hashtags.addAll(['#WaterSign', '#Emotional', '#Intuitive']);
    }

    // Personality traits based on star sign
    if (starLower == 'aries') hashtags.addAll(['#Leadership', '#Adventurous', '#Confident']);
    if (starLower == 'taurus') hashtags.addAll(['#Reliable', '#Patient', '#Practical']);
    if (starLower == 'gemini') hashtags.addAll(['#Adaptable', '#Curious', '#Outgoing']);
    if (starLower == 'cancer') hashtags.addAll(['#Loyal', '#Emotional', '#Protective']);
    if (starLower == 'leo') hashtags.addAll(['#Leadership', '#Creative', '#Generous']);
    if (starLower == 'virgo') hashtags.addAll(['#Analytical', '#Helpful', '#Hardworking']);
    if (starLower == 'libra') hashtags.addAll(['#Diplomatic', '#Fair', '#Social']);
    if (starLower == 'scorpio') hashtags.addAll(['#Passionate', '#Resourceful', '#Mysterious']);
    if (starLower == 'sagittarius') hashtags.addAll(['#Adventurous', 'Optimistic', '#Philosophical']);
    if (starLower == 'capricorn') hashtags.addAll(['#Responsible', '#Disciplined', '#Ambitious']);
    if (starLower == 'aquarius') hashtags.addAll(['#Independent', '#Humanitarian', '#Innovative']);
    if (starLower == 'pisces') hashtags.addAll(['#Compassionate', '#Artistic', '#Intuitive']);

    return hashtags;
  }

  /// Generates demographic-based hashtags
  List<String> get demographicHashtags {
    final hashtags = <String>[];

    // Age-based hashtags
    if (age >= 18 && age <= 25) {
      hashtags.addAll(['#18-25', '#College', '#YoungAdult']);
    }
    if (age >= 26 && age <= 35) {
      hashtags.addAll(['#26-35', '#YoungProfessionals', '#Career']);
    }
    if (age >= 36 && age <= 45) {
      hashtags.addAll(['#36-45', '#MidCareer', '#Established']);
    }
    if (age >= 46 && age <= 55) {
      hashtags.addAll(['#46-55', '#Experienced', '#Senior']);
    }
    if (age > 55) {
      hashtags.addAll(['#55plus', '#Mature', '#Experienced']);
    }

    // Gender-based hashtags
    hashtags.add('#$gender');

    // Life stage hashtags
    if (age < 25) hashtags.add('#StudentLife');
    if (age >= 25 && age <= 35) hashtags.add('#CareerBuilding');
    if (age >= 35 && age <= 50) hashtags.add('#PeakCareer');
    if (age > 50) hashtags.add('#SeniorProfessional');

    return hashtags;
  }

  /// Gets all hashtags combined
  List<String> get allHashtags {
    return [
      ...workHashtags,
      ...educationHashtags,
      ...lifestyleHashtags,
      ...zodiacHashtags,
      ...demographicHashtags,
    ];
  }

  /// Gets weighted hashtags for matching (work and education have higher weights)
  Map<String, double> get weightedHashtags {
    final weightedMap = <String, double>{};

    // Work hashtags (25% weight)
    for (final tag in workHashtags) {
      weightedMap[tag] = (weightedMap[tag] ?? 0) + 0.25;
    }

    // Education hashtags (15% weight)
    for (final tag in educationHashtags) {
      weightedMap[tag] = (weightedMap[tag] ?? 0) + 0.15;
    }

    // Lifestyle hashtags (30% weight combined)
    for (final tag in lifestyleHashtags) {
      weightedMap[tag] = (weightedMap[tag] ?? 0) + 0.30 / lifestyleHashtags.length;
    }

    // Zodiac hashtags (10% weight)
    for (final tag in zodiacHashtags) {
      weightedMap[tag] = (weightedMap[tag] ?? 0) + 0.10;
    }

    // Demographic hashtags (20% weight)
    for (final tag in demographicHashtags) {
      weightedMap[tag] = (weightedMap[tag] ?? 0) + 0.20 / demographicHashtags.length;
    }

    return weightedMap;
  }

  UserProfileAttributes copyWith({
    String? work,
    String? education,
    String? mealInterest,
    String? drinkingHabits,
    String? starSign,
    int? age,
    String? gender,
  }) {
    return UserProfileAttributes(
      work: work ?? this.work,
      education: education ?? this.education,
      mealInterest: mealInterest ?? this.mealInterest,
      drinkingHabits: drinkingHabits ?? this.drinkingHabits,
      starSign: starSign ?? this.starSign,
      age: age ?? this.age,
      gender: gender ?? this.gender,
    );
  }

  @override
  String toString() {
    return 'UserProfileAttributes(work: $work, education: $education, mealInterest: $mealInterest, drinkingHabits: $drinkingHabits, starSign: $starSign, age: $age, gender: $gender)';
  }
}