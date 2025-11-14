# Feature-First Clean Architecture Implementation Plan

This document provides a detailed, actionable implementation plan for migrating the Nearby Flutter app to Feature-First Clean Architecture. Each phase contains specific tasks with checkboxes to track progress systematically.

## Phase 0: Mock System Bridge Creation (NEW)

### Current Mock System Analysis
- [ ] Analyze existing `MockDataService` structure and API dependencies:
  - [ ] Document all 40+ public methods in `MockDataService`
  - [ ] Identify 17 files that directly import `MockDataService`
  - [ ] Map current dependency patterns and instantiation methods
  - [ ] Catalog existing mock data generation logic and storage patterns

### Mock System Bridge Architecture (Enhanced)
- [ ] Create mock system compatibility layer:
  - [ ] `lib/shared/base_data/bridges/mock_data_bridge.dart` - Main compatibility interface
    - [ ] Implements same interface as current `MockDataService`
    - [ ] Delegates calls to either legacy or new services based on feature flags
    - [ ] Provides seamless transition for existing code
  - [ ] `lib/shared/base_data/bridges/legacy_mock_adapter.dart` - Wraps existing `MockDataService`
    - [ ] Maintains existing `MockDataService` instance during migration
    - [ ] Provides adapter pattern for gradual service extraction
    - [ ] Ensures existing functionality remains intact
  - [ ] `lib/shared/base_data/bridges/service_migration_facade.dart` - Gradual migration facade
    - [ ] Orchestrates service switching based on migration progress
    - [ ] Provides unified interface during transition period
    - [ ] Handles fallback logic if new services fail
- [ ] **Enhanced Bridge Pattern Implementation:**
  - [ ] Maintain all existing `MockDataService` method signatures exactly
  - [ ] Create delegation patterns to new service architecture:
    - [ ] User-related methods delegate to `UserService` when ready
    - [ ] Group-related methods delegate to `GroupService` when ready
    - [ ] Feature methods delegate to appropriate feature services
    - [ ] Legacy methods continue using `MockDataService` until migrated
  - [ ] Ensure 100% backward compatibility during transition:
    - [ ] All existing screens continue working without changes
    - [ ] All existing method calls return same data structures
    - [ ] All existing error handling patterns preserved
    - [ ] All existing performance characteristics maintained
- [ ] **Compatibility Layer Features:**
  - [ ] Runtime service switching based on feature flags
  - [ ] Automatic fallback to legacy services if new services fail
  - [ ] Performance monitoring during migration
  - [ ] Migration logging and debugging support
  - [ ] Data consistency validation between legacy and new services

### Incremental Migration Infrastructure
- [ ] Create feature flag system for gradual service migration:
  - [ ] `lib/core/feature_flags/feature_flags.dart` - Migration feature flags
  - [ ] `lib/core/feature_flags/mock_migration_flags.dart` - Mock system migration flags
  - [ ] Implement per-feature migration toggles
- [ ] Build parallel service architecture:
  - [ ] Legacy mock system continues working unchanged
  - [ ] New services created alongside legacy system
  - [ ] Gradual migration path from legacy to new services
- [ ] Create dependency injection bridge:
  - [ ] Register both legacy and new services in DI container
  - [ ] Implement service switching based on feature flags
  - [ ] Create provider wrappers for smooth transition

### Service Migration Matrix Creation
- [ ] Map `MockDataService` methods to target services:
  - [ ] User-related methods → `UserService` + `UserProfileService`
  - [ ] Group-related methods → `GroupService` + `GroupManagementService`
  - [ ] Messaging methods → `MessagingService`
  - [ ] Feed filtering methods → `FeedService`
  - [ ] Discovery methods → `DiscoveryService`
  - [ ] Authentication methods → `AuthenticationService`
  - [ ] Settings methods → `SettingsService`
- [ ] Create migration dependency graph:
  - [ ] Identify method interdependencies
  - [ ] Plan safe migration order to minimize disruption
  - [ ] Document migration prerequisites for each service

### Mock Data Preservation Strategy
- [ ] Preserve existing mock data generation capabilities:
  - [ ] Maintain current `MockStorage` functionality
  - [ ] Preserve existing generator logic (`UserGenerator`, `GroupGenerator`)
  - [ ] Keep current mock data files and constants
  - [ ] Ensure existing test data remains available

## Phase 1: Foundation Setup

### Dependencies and Configuration
- [ ] Add required dependencies to pubspec.yaml:
  - [ ] flutter_riverpod: ^2.4.9
  - [ ] get_it: ^7.6.4
  - [ ] freezed: ^2.4.6
  - [ ] freezed_annotation: ^2.4.1
  - [ ] dio: ^5.4.0
  - [ ] json_annotation: ^4.8.1
  - [ ] equatable: ^2.0.5
- [ ] Add development dependencies:
  - [ ] build_runner: ^2.4.7
  - [ ] riverpod_generator: ^2.3.9
  - [ ] json_serializable: ^6.7.1
  - [ ] mockito: ^5.4.4
- [ ] Run `flutter pub get` to install dependencies
- [ ] Fix existing static analysis issues (25 identified issues)

### Core Layer Structure
- [ ] Create lib/core/ folder structure:
  - [ ] lib/core/constants/ - App constants and configuration
  - [ ] lib/core/theme/ - Theme configuration (move from lib/theme/)
  - [ ] lib/core/error/ - Error handling and exceptions
  - [ ] lib/core/routes/ - Route configuration
- [ ] Create core error handling:
  - [ ] lib/core/error/failures.dart - Custom failure classes
  - [ ] lib/core/error/exceptions.dart - Custom exception classes
  - [ ] lib/core/error/error_handler.dart - Centralized error handling
- [ ] Set up core constants:
  - [ ] lib/core/constants/app_constants.dart - App-wide constants
  - [ ] lib/core/constants/api_constants.dart - API configuration
  - [ ] lib/core/constants/theme_constants.dart - Theme constants

### Shared Layer Structure (Updated - Minimal Shared Data Architecture)
- [ ] Create lib/shared/ folder structure:
  - [ ] lib/shared/base_domain/ - Base domain abstractions
  - [ ] lib/shared/base_data/ - **MINIMAL SHARED DATA LAYER** (User, Group, and basic entities only)
  - [ ] lib/shared/utils/ - Dart utility classes
  - [ ] lib/shared/ui_utils/ - Flutter utility classes
  - [ ] lib/shared/ui_kit/ - Design system components

- [ ] Create base domain abstractions:
  - [ ] lib/shared/base_domain/entities.dart - Base entity class
  - [ ] lib/shared/base_domain/repositories.dart - Base repository interfaces
  - [ ] lib/shared/base_domain/usecases.dart - Base use case class
  - [ ] lib/shared/base_domain/value_objects.dart - Common value objects

- [ ] **Create minimal shared data layer structure:**
  - [ ] lib/shared/base_data/models/ - **CORE shared data models only**
    - [ ] lib/shared/base_data/models/group_model.dart - Core group model
    - [ ] lib/shared/base_data/models/user_model.dart - Core user model
    - [ ] lib/shared/base_data/models/entities/ - **Shared building blocks (like Lego pieces)**
      - [ ] lib/shared/base_data/models/entities/location.dart - Location entity (used by both User & Group)
      - [ ] lib/shared/base_data/models/entities/interest_set.dart - Interest entity (used by both User & Group)
      - [ ] lib/shared/base_data/models/entities/language.dart - Language entity (used by both User & Group)
      - [ ] lib/shared/base_data/models/entities/user_profile_attributes.dart - **NEW: User attributes for hashtag matching**
      - [ ] lib/shared/base_data/models/entities/group_hashtags.dart - **NEW: Group hashtag system**
      - [ ] lib/shared/base_data/models/entities/matching_criteria.dart - **NEW: Matching weights and thresholds**
      - [ ] lib/shared/base_data/models/entities/compatibility_result.dart - Enhanced compatibility results
  - [ ] lib/shared/base_data/data_sources/ - **SHARED data sources only**
    - [ ] lib/shared/base_data/data_sources/local/
      - [ ] lib/shared/base_data/data_sources/local/mock_group_data_source.dart
      - [ ] lib/shared/base_data/data_sources/local/mock_user_data_source.dart
    - [ ] lib/shared/base_data/data_sources/remote/ - Future API data sources
  - [ ] lib/shared/base_data/repositories/ - **SHARED repository interfaces only**
    - [ ] lib/shared/base_data/repositories/group_repository_interface.dart
    - [ ] lib/shared/base_data/repositories/user_repository_interface.dart
  - [ ] lib/shared/base_data/services/ - **SHARED services only (core business logic)**
    - [ ] lib/shared/base_data/services/group_service.dart - Core group operations
    - [ ] lib/shared/base_data/services/user_service.dart - Core user operations
  - [ ] lib/shared/base_data/mappers/ - **SHARED data mappers only**
    - [ ] lib/shared/base_data/mappers/group_mapper.dart
    - [ ] lib/shared/base_data/mappers/user_mapper.dart

### Dependency Injection Setup
- [ ] Create lib/core/di/ folder:
  - [ ] lib/core/di/injection_container.dart - Main DI container
  - [ ] lib/core/di/core_providers.dart - Core dependency providers
  - [ ] lib/core/di/shared_providers.dart - Shared dependency providers (User/Group only)
- [ ] Configure GetIt service locator
- [ ] Set up provider registration patterns
- [ ] Create DI initialization in main.dart

## Phase 2: Minimal Shared Data Layer Implementation

### Shared Data Models Creation (ELI5: Shared Building Blocks)
- [ ] **Understanding Shared vs Separate Storage:**
  - [ ] **Shared entities** are like Lego pieces that both User and Group models can use
  - [ ] **User data** lives in `user_model.dart` (personal profile info)
  - [ ] **Group data** lives in `group_model.dart` (group-specific info)
  - [ ] Both can use the same building blocks (Location, InterestSet, Language)
- [ ] Create CORE shared data models in lib/shared/base_data/models/:
  - [ ] lib/shared/base_data/models/group_model.dart - Core group model with essential fields
  - [ ] lib/shared/base_data/models/user_model.dart - Core user model with essential fields
  - [ ] lib/shared/base_data/models/entities/location.dart - **Shared Lego piece** for GPS data
    - [ ] User: "I'm at **123 Main Street**" (currentLocation)
    - [ ] Group: "We meet at **456 Oak Avenue**" (meetingLocation)
    - [ ] Same Location entity, different addresses
  - [ ] lib/shared/base_data/models/entities/interest_set.dart - **Shared Lego piece** for interests
    - [ ] User: "I like **pizza, sushi, hiking**" (personalInterests)
    - [ ] Group: "We're about **tech, startups, networking**" (groupInterests)
    - [ ] Same InterestSet system, different actual interests
  - [ ] lib/shared/base_data/models/entities/language.dart - **Shared Lego piece** for languages
    - [ ] User: "I speak **English, Spanish**" (userLanguages)
    - [ ] Group: "We accept **English, French**" (allowedLanguages)
    - [ ] Same Language system, different language lists
  - [ ] lib/shared/base_data/models/entities/user_profile_attributes.dart - **NEW: User attribute hashtags**
    - [ ] Work: "Software Engineer" → generates #Tech, #Engineering, #Programming
    - [ ] Education: "Stanford" → generates #Stanford, #EliteEducation, #SiliconValley
    - [ ] Meal Interest: "Fine Dining" → generates #FineDining, #Gourmet, #Upscale
    - [ ] Drink Habits: "Socially" → generates #Social, #SocialButterfly, #Wine
    - [ ] Star Sign: "Leo" → generates #Leo, #FireSign, #Leadership
    - [ ] Combined: User gets comprehensive hashtag profile for matching
  - [ ] lib/shared/base_data/models/entities/group_hashtags.dart - **NEW: Group hashtag requirements**
    - [ ] Group Interests: "Tech Professionals" → requires #Tech, #Engineering, #Professional
    - [ ] Demographic Targets: "25-35, Urban" → targets specific age/location hashtags
    - [ ] Activity Tags: "Networking Events" → includes #Networking, #Events, #Career
    - [ ] Vibe Tags: "Sophisticated" → targets #FineDining, #Professional, #Upscale
  - [ ] lib/shared/base_data/models/entities/matching_criteria.dart - **NEW: Matching configuration**
    - [ ] Weight system: Work (25%), Education (15%), Meal Interest (20%), Drink Habits (10%)
    - [ ] Demographic weights: Age (10%), Gender (10%), Languages (10%)
    - [ ] Matching thresholds: Minimum 30%, Good 60%, Excellent 80%
  - [ ] lib/shared/base_data/models/entities/compatibility_result.dart - **NEW: Enhanced matching results**
    - [ ] User: "Software Engineer, Stanford, Fine Dining, Socially"
    - [ ] Group: "Tech Professionals, #Upscale, #Networking"
    - [ ] Result: "85% match - Work (95%), Education (80%), Lifestyle (90%), Demographics (75%)"
  - [ ] Add JSON serialization annotations to all models

### Shared Data Sources Implementation (Updated - Mock Migration Path)
- [ ] Create SHARED data sources in lib/shared/base_data/data_sources/local/:
  - [ ] lib/shared/base_data/data_sources/local/mock_group_data_source.dart - Groups data only
  - [ ] lib/shared/base_data/data_sources/local/mock_user_data_source.dart - Users data only
- [ ] **Bridge existing mock data sources during migration:**
  - [ ] **Phase 2A: Wrap existing repositories**
    - [ ] `SharedUserDataSource` wraps existing `UserRepository` from mock system
    - [ ] `SharedGroupDataSource` wraps existing `GroupRepository` from mock system
    - [ ] Maintain existing `MockStorage` functionality through wrapper pattern
  - [ ] **Phase 2B: Gradual data extraction**
    - [ ] Move user_generator.dart logic to shared user data source (preserving existing logic)
    - [ ] Move group_generator.dart logic to shared group data source (preserving existing logic)
    - [ ] Move mock_storage.dart patterns for User/Group to shared data sources
    - [ ] Maintain backward compatibility with existing mock data structures
- [ ] **Mock data preservation during transition:**
  - [ ] Keep existing mock data files accessible through new data sources
  - [ ] Ensure existing mock data generation capabilities remain intact
  - [ ] Maintain current mock user/group relationships and data integrity

### Shared Repository Interfaces Creation
- [ ] Create SHARED repository interfaces in lib/shared/base_data/repositories/:
  - [ ] lib/shared/base_data/repositories/group_repository_interface.dart
  - [ ] lib/shared/base_data/repositories/user_repository_interface.dart

### Shared Services Implementation (Updated - Mock Migration Path)
- [ ] Create SHARED services in lib/shared/base_data/services/:
  - [ ] lib/shared/base_data/services/group_service.dart - Core group operations (CRUD only)
  - [ ] lib/shared/base_data/services/user_service.dart - Core user operations (identity, profile basics)
- [ ] **Bridge existing MockDataService functionality:**
  - [ ] **Phase 2A: Create service wrappers**
    - [ ] `UserService` wraps user-related methods from existing `MockDataService`
    - [ ] `GroupService` wraps group-related methods from existing `MockDataService`
    - [ ] Maintain exact method signatures to prevent breaking changes
  - [ ] **Phase 2B: Gradual service extraction**
    - [ ] Extract user identity/profile methods from `MockDataService` to `UserService`
    - [ ] Extract group CRUD methods from `MockDataService` to `GroupService`
    - [ ] Preserve existing business logic and data relationships
    - [ ] Maintain current error handling patterns
- [ ] **Mock service compatibility layer:**
  - [ ] Ensure new services can work with existing `MockStorage`
  - [ ] Preserve existing mock data generation capabilities
  - [ ] Maintain current mock data relationships and constraints

### Shared Data Mappers Creation
- [ ] Create SHARED mappers in lib/shared/base_data/mappers/:
  - [ ] lib/shared/base_data/mappers/group_mapper.dart
  - [ ] lib/shared/base_data/mappers/user_mapper.dart

### Dependency Integration (Updated - Mock Migration Path)
- [ ] Set up shared service bindings:
  - [ ] Create shared service implementations for User/Group repository interfaces
  - [ ] Register shared User/Group services in dependency injection container
  - [ ] Ensure features can access shared User/Group services only
  - [ ] Test shared User/Group data functionality across features

### Service Dependency Management Strategy (Enhanced with Lego Analogy)
- [ ] **Dual Service Registration Strategy:**
  - [ ] Register legacy `MockDataService` in DI container alongside new services
  - [ ] Register new shared services (`UserService`, `GroupService`) in DI container
  - [ ] Create service provider wrappers for gradual migration
  - [ ] Implement feature flags for switching between legacy and new services
- [ ] **Lego Block Architecture Pattern (Enhanced with User Attributes):**
  - [ ] **Shared Services (Lego Factory):**
    - [ ] `UserService` - manages user's house built from comprehensive Lego pieces
    - [ ] `GroupService` - manages group's house built from hashtag Lego pieces
    - [ ] `HashtagMappingService` - converts user attributes into Lego pieces
    - [ ] `MatchingService` - compares Lego pieces between user and group houses
  - [ ] **Enhanced Lego Pieces:**
    - [ ] Location, InterestSet, Language (basic Lego pieces)
    - [ ] **NEW:** UserProfileAttributes → generates comprehensive hashtag Lego pieces
    - [ ] **NEW:** GroupHashtags → defines required Lego piece patterns
  - [ ] **Feature Services (House Builders with Matching):**
    - [ ] `DiscoveryService` - builds discovery using User + Group houses + Matching scores
    - [ ] `FeedService` - builds feed with compatibility-ranked groups
    - [ ] `MessagingService` - builds messaging using User + Group houses
  - [ ] **Enhanced Data Flow Architecture:**
    ```
    User Profile     ←─ UserService ←─ Attributes → HashtagMapping → User Hashtags
         ↓                                                      (Lego pieces)
    Discovery Feed   ←─ DiscoveryService ←─ MatchingService ←─ Compatibility Scores
         ↓                                 (User hashtags + Group hashtags)
    Group Details    ←─ GroupService ←─ Requirements → Group Hashtags
    ```
- [ ] **Service Migration Orchestration:**
  - [ ] Create service migration coordinator in `lib/core/di/service_migration_coordinator.dart`
  - [ ] Implement gradual service switching based on feature flags
  - [ ] Add service health checks during migration period
  - [ ] Create rollback mechanism if new services cause issues
- [ ] **Provider Wrapper Implementation:**
  - [ ] `lib/core/di/providers/legacy_user_service_provider.dart` - Wraps MockDataService user methods
  - [ ] `lib/core/di/providers/legacy_group_service_provider.dart` - Wraps MockDataService group methods
  - [ ] `lib/core/di/providers/migration_service_provider.dart` - Handles service switching logic
  - [ ] Ensure UI layer can use either legacy or new services seamlessly
- [ ] **Gradual Migration Path:**
  - [ ] Phase 1: Both legacy and new services registered, UI uses legacy
  - [ ] Phase 2: Individual screens switch to new services via feature flags
  - [ ] Phase 3: All screens migrated to new services
  - [ ] Phase 4: Legacy services deregistered and removed
- [ ] **Migration Safety Mechanisms:**
  - [ ] Add service availability checks before switching
  - [ ] Implement fallback to legacy services if new services fail
  - [ ] Create migration logging and monitoring
  - [ ] Add migration validation tests

## Phase 3: Feature Modules Setup

### Feature Folder Creation (Updated - Complete Feature Structure)
- [ ] Create feature module structures (domain + data + presentation):
  - [ ] lib/features/feed/ with domain/data/presentation folders
  - [ ] lib/features/discovery/ with domain/data/presentation folders
  - [ ] lib/features/messaging/ with domain/data/presentation folders
  - [ ] lib/features/group_management/ with domain/data/presentation folders
  - [ ] lib/features/user_profile/ with domain/data/presentation folders
  - [ ] lib/features/authentication/ with domain/data/presentation folders
  - [ ] lib/features/settings/ with domain/data/presentation folders

### Feature Domain Layer Setup
- [ ] Set up domain layer for each feature:
  - [ ] models/ folder for feature-specific entities and state models
  - [ ] repositories/ folder for feature-specific repository interfaces
  - [ ] use_cases/ folder for feature-specific business logic
  - [ ] Features will use shared User/Group services for core operations

### Feature Data Layer Setup
- [ ] Set up data layer for each feature:
  - [ ] models/ folder for feature-specific data models
  - [ ] data_sources/ folder for feature-specific data sources
  - [ ] repositories/ folder for feature-specific repository implementations
  - [ ] mappers/ folder for feature-specific data mappers
  - [ ] Features will depend on shared User/Group repositories but own their feature data

### Feature Presentation Layer Setup
- [ ] Set up presentation layer for each feature:
  - [ ] screens/ folder for feature screens
  - [ ] widgets/ folder for feature-specific widgets
  - [ ] providers/ folder for state management (Riverpod providers)
  - [ ] Features will use shared User/Group services + feature-specific services

## Entity Relationship Architecture (NEW)

### User vs Group Data Structure Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    SHARED BUILDING BLOCKS                        │
│                    (Like Lego Pieces)                           │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │   Location   │  │  InterestSet │  │   Language   │         │
│  │   Entity     │  │   Entity     │  │   Entity     │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
└─────────────────────────────────────────────────────────────────┘
         ↕                       ↕                       ↕
┌─────────────────────┐                   ┌─────────────────────┐
│   USER HOUSE        │                   │   GROUP HOUSE       │
│   (user_model.dart) │                   │ (group_model.dart)  │
│                     │                   │                     │
│ • name, age, bio    │                   │ • name, description │
│ • currentLocation   │←─ uses ──────────→│ • meetingLocation   │
│ • personalInterests │←─ uses ──────────→│ • groupInterests    │
│ • userLanguages     │←─ uses ──────────→│ • allowedLanguages  │
│ • searchRadius      │                   │ • memberCount       │
│ • isPremium         │                   │ • joinCost          │
└─────────────────────┘                   └─────────────────────┘
         ↕                                       ↕
         └───────────────┬───────────────────────┘
                         ↕
                ┌─────────────────────┐
                │   MATCHING ENGINE   │
                │   (Compares houses) │
                │                     │
                │ • Location proximity │
                │ • Interest overlap  │
                │ • Language match    │
                │ • Overall score     │
                └─────────────────────┘
```

### Data Purpose Separation

**USER DATA (Comprehensive Profile Attributes):**
- `currentLocation`: Where user is right now (for discovery)
- `personalInterests`: What user likes (for matching)
- `userLanguages`: What user speaks (for communication)
- `searchRadius`: How far user will travel
- **NEW - Profile Attributes for Hashtag Matching:**
  - `work`: "Software Engineer" → generates #Tech, #Engineering, #Programming
  - `education`: "Stanford University" → generates #Stanford, #EliteEducation, #IvyLeague
  - `mealInterest`: "Fine Dining" → generates #FineDining, #Gourmet, #Upscale
  - `drinkingHabits`: "Socially" → generates #Social, #Wine, #Networking
  - `starSign`: "Leo" → generates #Leo, #FireSign, #Leadership
  - `age`: "28" → targets #25-35, #YoungProfessionals
  - `gender`: "Female" → targets appropriate demographic groups

**GROUP DATA (Hashtag Requirements & Targets):**
- `meetingLocation`: Where group meets (for joining decisions)
- `groupInterests`: What group focuses on (as hashtags)
- `allowedLanguages`: What group accepts (for participation)
- `memberCount`: Current group size
- **NEW - Hashtag System for User Matching:**
  - `requiredHashtags`: #Tech, #Engineering (must match)
  - `demographicTargets`: #25-35, #Urban, #Professional (demographic matching)
  - `vibeTags`: #Upscale, #Networking, #Career (lifestyle matching)
  - `activityTags`: #TechMeetups, #CareerGrowth (activity matching)

**ENHANCED MATCHING RESULTS (Multi-Dimensional Scoring):**
- `locationScore`: Distance compatibility (10% weight)
- `workScore`: Work/career compatibility (25% weight)
- `educationScore`: Education/background compatibility (15% weight)
- `lifestyleScore`: Meal/drink/social compatibility (30% weight)
- `demographicScore`: Age/gender compatibility (20% weight)
- `overallScore`: Weighted total compatibility score
- `matchingHashtags`: List of overlapping hashtags
- `recommendationReasons`: Why this group matches the user

### File Organization Pattern

```
lib/shared/base_data/models/entities/
├── location.dart                      # GPS coordinate system (shared Lego piece)
├── interest_set.dart                  # Interest category system (shared Lego piece)
├── language.dart                      # Language proficiency system (shared Lego piece)
├── user_profile_attributes.dart       # User attribute hashtag generator (NEW)
├── group_hashtags.dart                # Group hashtag requirement system (NEW)
├── matching_criteria.dart             # Matching weights and thresholds (NEW)
└── compatibility_result.dart          # Enhanced compatibility results (NEW)

lib/shared/base_data/models/
├── user_model.dart                    # User's house with comprehensive attributes
└── group_model.dart                   # Group's house with hashtag requirements

lib/shared/base_data/services/
├── user_service.dart                  # User profile management
├── group_service.dart                 # Group management
├── hashtag_mapping_service.dart       # Attribute-to-hashtag conversion (NEW)
└── matching_service.dart              # User-group matching engine (NEW)
```

This architecture provides **clear separation** of user vs group data purposes while using **shared building blocks** where it makes sense.

## Implementation Guidance: When to Use Shared vs Feature-Specific Data (NEW)

### Decision Framework for Developers

**Use SHARED ENTITIES when:**
✅ **Same data structure needed by multiple features**
- Location: Used by User profile, Group meeting, Discovery proximity, Map view
- InterestSet: Used by User matching, Group filtering, Feed recommendations
- Language: Used by User profile, Group requirements, Communication features

✅ **Complex business logic that should be centralized**
- GPS distance calculations (Location entity)
- Interest compatibility scoring (InterestSet entity)
- Language proficiency matching (Language entity)

✅ **Cross-feature consistency required**
- Same coordinate system across all location features
- Same interest categories across all matching features
- Same language codes across all communication features

**Use FEATURE-SPECIFIC MODELS when:**
❌ **Data only used within one feature**
- Feed filtering state (only used by Feed feature)
- Chat message drafts (only used by Messaging feature)
- Group creation workflow (only used by Group Management feature)

❌ **UI-specific state management**
- Screen loading states
- Form validation states
- Animation states

❌ **Feature-specific business logic**
- Feed ranking algorithms
- Message threading logic
- Pot contribution calculations

### Implementation Examples

**SHARED ENTITY PATTERN:**
```dart
// ✅ GOOD: Shared entity used by multiple features
class Location {
  final double latitude;
  final double longitude;

  double distanceTo(Location other) => _calculateDistance(this, other);
}

// User model uses shared Location
class User {
  final Location? currentLocation;  // Where user is now
  final Location? homeLocation;     // User's home area
}

// Group model uses same shared Location
class Group {
  final Location? meetingLocation;  // Where group meets
}
```

**USER PROFILE ATTRIBUTES PATTERN (NEW):**
```dart
// ✅ GOOD: User attributes that generate hashtags for matching
class UserProfileAttributes {
  final String work;
  final String education;
  final String mealInterest;
  final String drinkingHabits;
  final String starSign;
  final int age;
  final String gender;

  // Generate hashtags from user attributes
  List<String> get workHashtags => HashtagMappingService.workToHashtags[work] ?? [];
  List<String> get educationHashtags => HashtagMappingService.educationToHashtags[education] ?? [];
  List<String> get lifestyleHashtags => [
    ...HashtagMappingService.mealToHashtags[mealInterest] ?? [],
    ...HashtagMappingService.drinkToHashtags[drinkingHabits] ?? [],
    ...HashtagMappingService.starSignToHashtags[starSign] ?? [],
  ];

  List<String> get allHashtags => [...workHashtags, ...educationHashtags, ...lifestyleHashtags];
}

// User model includes comprehensive attributes
class User {
  final Location? currentLocation;
  final UserProfileAttributes attributes;  // Comprehensive profile

  late final List<String> hashtags = attributes.allHashtags;
}
```

**GROUP HASHTAG REQUIREMENTS PATTERN (NEW):**
```dart
// ✅ GOOD: Group requirements expressed as hashtags
class GroupHashtags {
  final List<String> requiredHashtags;      // Must match these
  final List<String> preferredHashtags;     // Nice to match
  final List<String> demographicTargets;    // Age/gender/location
  final List<String> vibeTags;              // Lifestyle/atmosphere

  bool matchesUser(User user) {
    final userHashtags = user.hashtags;
    final requiredMatches = requiredHashtags.any((tag) => userHashtags.contains(tag));
    final demographicMatch = _checkDemographicMatch(user);
    return requiredMatches && demographicMatch;
  }
}

// Group model includes hashtag requirements
class Group {
  final Location? meetingLocation;
  final GroupHashtags hashtagRequirements;  // What users should match

  bool isGoodMatchFor(User user) => hashtagRequirements.matchesUser(user);
}
```

**FEATURE-SPECIFIC PATTERN:**
```dart
// ✅ GOOD: Feature-specific model
class FeedFilter {
  final List<String> selectedInterests;
  final double maxDistance;
  final bool showOnlyAvailable;
}

// ❌ AVOID: Making FeedFilter shared unnecessarily
// Don't put FeedFilter in lib/shared/base_data/models/
// Keep it in lib/features/feed/domain/models/
```

### File Organization Rules

**SHARED LAYER (`lib/shared/base_data/`):**
```
models/entities/
├── location.dart                      # GPS coordinate system
├── interest_set.dart                  # Interest categories + compatibility
├── language.dart                      # Language codes + proficiency
├── user_profile_attributes.dart       # User attribute hashtag generator
├── group_hashtags.dart                # Group hashtag requirement system
├── matching_criteria.dart             # Matching weights & thresholds
└── compatibility_result.dart          # Enhanced matching results

models/
├── user_model.dart                    # Core user identity + comprehensive attributes
└── group_model.dart                   # Core group identity + hashtag requirements

services/
├── hashtag_mapping_service.dart       # Attribute-to-hashtag conversion
├── matching_service.dart              # Multi-dimensional matching engine
├── user_service.dart                  # User profile management
└── group_service.dart                 # Group management
```

**FEATURE LAYER (`lib/features/{feature}/domain/models/`):**
```
feed/models/
├── feed_filter.dart       # Feed filtering UI state
├── feed_preferences.dart  # User feed preferences
└── search_history.dart    # Feed search history

messaging/models/
├── message.dart           # Message with UI metadata
├── conversation.dart      # Chat thread management
└── message_draft.dart     # Message composition state
```

### Migration Path for Existing Code

**Step 1: Identify Shared Patterns**
- Look for duplicate data structures across features
- Find business logic that's copied between features
- Identify data that needs to stay consistent across the app

**Step 2: Extract to Shared Layer**
- Move the shared entity to `lib/shared/base_data/models/entities/`
- Update all features to use the shared entity
- Ensure all business logic stays with the entity

**Step 3: Keep Feature-Specific Data Separate**
- Leave UI state in feature layers
- Keep feature-specific business logic in features
- Maintain clean boundaries between shared and feature code

This guidance ensures developers can make informed decisions about when to share data vs keep it feature-specific.

## Data-Driven Matching Architecture (NEW)

### Hybrid Architecture: Phased Implementation

The matching system follows a **hybrid architecture approach** that starts simple and scales sophistication as data accumulates:

**Phase 1: Core Matching in Main Backend (Immediate)**
- Basic rule-based matching with data collection
- User behavior tracking infrastructure
- Simple analytics collection

**Phase 2: ML Processing Service (Medium-term)**
- Separate Python service for machine learning
- Hashtag clustering and behavior analysis
- Prediction models for matching optimization

**Phase 3: Advanced Analytics Service (Long-term)**
- Real-time analytics and A/B testing
- Statistical significance testing
- Performance monitoring and optimization

### Phase 1: Core Analytics Infrastructure (Immediate Implementation)

**1. User Behavior Tracking Service**
```dart
class UserBehaviorService {
  final AnalyticsService _analytics;

  // Track all user interactions for ML training data
  Future<void> trackHashtagSelection(String hashtag, String context) async {
    await _analytics.trackEvent('hashtag_selected', {
      'hashtag': hashtag,
      'context': context,  // 'profile_creation', 'group_discovery', etc.
      'timestamp': DateTime.now().toIso8601String(),
      'user_id': _currentUserId,
    });
  }

  Future<void> trackGroupJoin(String groupId, List<String> matchingHashtags) async {
    await _analytics.trackEvent('group_joined', {
      'group_id': groupId,
      'matching_hashtags': matchingHashtags,
      'timestamp': DateTime.now().toIso8601String(),
      'user_profile_attributes': await _getUserAttributes(),
    });
  }

  Future<void> trackSwipeAction(String userId, String action, List<String> hashtags) async {
    await _analytics.trackEvent('swipe_action', {
      'target_user_id': userId,
      'action': action,  // 'like', 'pass', 'super_like'
      'hashtags': hashtags,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<void> trackLocationPreference(Location location, String context) async {
    await _analytics.trackEvent('location_preference', {
      'latitude': location.latitude,
      'longitude': location.longitude,
      'context': context,  // 'group_meeting', 'user_discovery', etc.
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}
```

**2. Dynamic Hashtag Generation Service (Data-Driven)**
```dart
class DynamicHashtagService {
  final UserBehaviorService _behaviorService;
  final AnalyticsRepository _analyticsRepo;

  // Generate hashtags based on collected behavior data, not hardcoded rules
  Future<List<String>> generateWorkHashtags(String work) async {
    // Query analytics data for similar professionals
    final similarProfessionals = await _analyticsRepo.getSimilarProfessionals(work);
    final trendingHashtags = await _analyticsRepo.getTrendingHashtagsForProfession(work);

    // Combine popular hashtags from actual user behavior
    final behaviorBasedHashtags = await _getBehaviorBasedWorkHashtags(work);

    return [
      ...trendingHashtags,  // What's currently popular
      ...behaviorBasedHashtags,  // What similar users actually use
      ...await _getMLPredictedHashtags(work),  // ML predictions when available
    ];
  }

  Future<List<String>> generateEducationHashtags(String education) async {
    final alumniData = await _analyticsRepo.getAlumniHashtagData(education);
    final trendingEducationTags = await _analyticsRepo.getTrendingEducationHashtags();

    return [
      ...alumniData.mostCommonHashtags,
      ...trendingEducationTags,
      ...await _getEducationMLPredictions(education),
    ];
  }

  private Future<List<String>> _getBehaviorBasedWorkHashtags(String work) async {
    // Analyze what hashtags users with this work profile actually select and use
    final behaviorData = await _analyticsRepo.getHashtagSelectionByWork(work);

    // Weight by engagement (joins, likes, messages)
    return behaviorData
        .where((data) => data.engagementScore > 0.7)  // Only high-engagement hashtags
        .map((data) => data.hashtag)
        .toList();
  }
}
```

**3. Analytics Collection Infrastructure**
```dart
class AnalyticsCollectionService {
  // Collect comprehensive interaction data
  Future<void> collectInteractionData(InteractionEvent event) async {
    final enrichedEvent = await _enrichEventWithUserData(event);
    await _storeEvent(enrichedEvent);
    await _updateRealTimeMetrics(enrichedEvent);
  }

  Future<void> collectMatchingResult(MatchingResult result) async {
    await _storeMatchingData({
      'user_id': result.userId,
      'group_id': result.groupId,
      'compatibility_score': result.totalScore,
      'hashtag_matches': result.matchingHashtags,
      'user_joined': result.userJoined,
      'timestamp': DateTime.now().toIso8601String(),
      'algorithm_version': 'v1.0',  // Track algorithm performance
    });
  }

  Future<void> collectUserFeedback(UserFeedback feedback) async {
    // Track when users rate group recommendations
    await _storeFeedbackData({
      'user_id': feedback.userId,
      'group_id': feedback.groupId,
      'rating': feedback.rating,  // 1-5 stars
      'feedback_type': feedback.type,  // 'recommendation', 'hashtag_suggestion', etc.
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}
```

**4. Simple Rule-Based Matching (Phase 1 - With Data Collection)**
```dart
class BasicMatchingService {
  final DynamicHashtagService _hashtagService;
  final AnalyticsCollectionService _analytics;

  Future<CompatibilityResult> calculateCompatibility(User user, Group group) async {
    // Generate hashtags using data-driven approach (not hardcoded)
    final userHashtags = await _hashtagService.generateUserHashtags(user);
    final groupRequiredHashtags = group.hashtagRequirements.requiredHashtags;

    // Calculate basic compatibility
    final matchingHashtags = userHashtags.where((tag) =>
        groupRequiredHashtags.contains(tag)).toList();

    final hashtagScore = matchingHashtags.length / groupRequiredHashtags.length;

    // Collect data for ML training
    await _analytics.collectMatchingResult(MatchingResult(
      userId: user.id,
      groupId: group.id,
      totalScore: hashtagScore,
      matchingHashtags: matchingHashtags,
      algorithmUsed: 'basic_hashtag_matching_v1',
    ));

    return CompatibilityResult(
      totalScore: hashtagScore,
      matchingHashtags: matchingHashtags,
      dataCollectionMetadata: {
        'algorithm': 'basic_v1',
        'hashtag_generation_method': 'data_driven',
        'collection_timestamp': DateTime.now().toIso8601String(),
      },
    );
  }
}
```

### Phase 2: ML Processing Service (Medium-term Implementation)

**Separate Python ML Service Architecture:**
```python
# ml_service/app.py - Separate Python service for ML processing
from fastapi import FastAPI
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import pandas as pd
import numpy as np

app = FastAPI(title="Nearby ML Matching Service")

class HashtagClusterService:
    def __init__(self):
        self.vectorizer = TfidfVectorizer(max_features=1000)
        self.hashtag_clusters = {}
        self.user_behavior_matrix = None

    async def train_hashtag_clustering(self, user_data: List[Dict]):
        """Train clustering model on user behavior data"""
        # Process user interactions and hashtag selections
        interaction_matrix = self._build_interaction_matrix(user_data)

        # Perform clustering analysis
        from sklearn.cluster import KMeans
        kmeans = KMeans(n_clusters=50, random_state=42)
        hashtag_clusters = kmeans.fit_predict(interaction_matrix)

        self.hashtag_clusters = self._interpret_clusters(hashtag_clusters, user_data)

    async def predict_user_hashtags(self, user_profile: Dict) -> List[str]:
        """Predict optimal hashtags for user based on similar users"""
        # Find similar users based on behavior patterns
        similar_users = self._find_similar_users(user_profile)

        # Extract high-performing hashtags from similar users
        recommended_hashtags = self._extract_top_hashtags(similar_users)

        return recommended_hashtags

    def _find_similar_users(self, user_profile: Dict) -> List[Dict]:
        """Find users with similar behavior patterns"""
        # Use collaborative filtering to find similar users
        user_vector = self._vectorize_user_profile(user_profile)

        # Calculate similarity scores
        similarities = cosine_similarity(
            user_vector.reshape(1, -1),
            self.user_behavior_matrix
        )

        # Return top similar users
        similar_indices = np.argsort(similarities[0])[::-1][:20]
        return [self.user_database[i] for i in similar_indices]

class UserBehaviorAnalyzer:
    def __init__(self):
        self.behavior_patterns = {}
        self.engagement_models = {}

    async def analyze_user_patterns(self, user_interactions: List[Dict]):
        """Analyze user behavior patterns for ML insights"""
        # Extract interaction patterns
        patterns = self._extract_interaction_patterns(user_interactions)

        # Identify successful matching patterns
        successful_patterns = self._identify_successful_patterns(patterns)

        # Update behavior models
        self.behavior_patterns.update(successful_patterns)

    async def predict_engagement_probability(self, user_id: str, group_id: str) -> float:
        """Predict probability of user engaging with group"""
        user_features = self._extract_user_features(user_id)
        group_features = self._extract_group_features(group_id)

        # Use trained ML model to predict engagement
        engagement_score = self._engagement_model.predict([
            np.concatenate([user_features, group_features])
        ])[0]

        return float(engagement_score)

# API Endpoints
@app.post("/predict-hashtags")
async def predict_hashtags(user_profile: Dict):
    """Predict hashtags for user based on ML models"""
    hashtag_service = HashtagClusterService()
    predicted_hashtags = await hashtag_service.predict_user_hashtags(user_profile)
    return {"hashtags": predicted_hashtags}

@app.post("/analyze-behavior")
async def analyze_behavior(user_interactions: List[Dict]):
    """Analyze user behavior patterns"""
    analyzer = UserBehaviorAnalyzer()
    insights = await analyzer.analyze_user_patterns(user_interactions)
    return {"insights": insights}

@app.post("/predict-engagement")
async def predict_engagement(user_id: str, group_id: str):
    """Predict user engagement with group"""
    analyzer = UserBehaviorAnalyzer()
    probability = await analyzer.predict_engagement_probability(user_id, group_id)
    return {"engagement_probability": probability}
```

**Integration with Flutter Backend:**
```dart
class MLServiceClient {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8000',  // ML service endpoint
  ));

  Future<List<String>> getPredictedHashtags(UserProfileAttributes attributes) async {
    try {
      final response = await _dio.post('/predict-hashtags', data: {
        'work': attributes.work,
        'education': attributes.education,
        'meal_interest': attributes.mealInterest,
        'drinking_habits': attributes.drinkingHabits,
        'star_sign': attributes.starSign,
        'age': attributes.age,
        'gender': attributes.gender,
      });

      final hashtags = List<String>.from(response.data['hashtags']);
      return hashtags;
    } catch (e) {
      // Fallback to basic hashtag generation if ML service unavailable
      return await _getFallbackHashtags(attributes);
    }
  }

  Future<double> predictEngagementProbability(String userId, String groupId) async {
    try {
      final response = await _dio.post('/predict-engagement', data: {
        'user_id': userId,
        'group_id': groupId,
      });

      return double.parse(response.data['engagement_probability'].toString());
    } catch (e) {
      return 0.5; // Default probability if ML service unavailable
    }
  }
}
```

### Phase 3: Advanced Analytics Service (Long-term Implementation)

**Real-time Analytics & A/B Testing Framework:**
```dart
class AdvancedAnalyticsService {
  final ABTestService _abTestService;
  final RealTimeAnalytics _realTimeAnalytics;
  final StatisticalAnalysis _statsAnalysis;

  // A/B Testing for Matching Algorithms
  Future<MatchingResult> calculateCompatibilityWithTest(User user, Group group) async {
    // Determine which algorithm version to test
    final testGroup = await _abTestService.getTestGroup('matching_algorithm_v2', user.id);

    MatchingResult result;
    switch (testGroup) {
      case 'ml_enhanced':
        result = await _calculateMLCompatibility(user, group);
        break;
      case 'weighted_hashtag':
        result = await _calculateWeightedCompatibility(user, group);
        break;
      case 'collaborative_filtering':
        result = await _calculateCollaborativeCompatibility(user, group);
        break;
      default:
        result = await _calculateBasicCompatibility(user, group);
    }

    // Track test results
    await _abTestService.trackTestResult('matching_algorithm_v2', testGroup, {
      'user_id': user.id,
      'group_id': group.id,
      'compatibility_score': result.totalScore,
      'algorithm_used': result.algorithmUsed,
    });

    return result;
  }

  // Statistical Significance Testing
  Future<bool> isAlgorithmSignificantlyBetter(String algorithmA, String algorithmB) async {
    final resultsA = await _statsAnalysis.getAlgorithmResults(algorithmA);
    final resultsB = await _statsAnalysis.getAlgorithmResults(algorithmB);

    return _statsAnalysis.performSignificanceTest(resultsA, resultsB);
  }

  // Real-time Performance Monitoring
  Future<void> monitorAlgorithmPerformance() async {
    final metrics = await _realTimeAnalytics.getLiveMetrics();

    if (metrics.engagementRate < 0.3) {
      // Algorithm underperforming - trigger alert
      await _alertingService.sendAlert('Low engagement rate detected');
    }

    if (metrics.errorRate > 0.05) {
      // High error rate - rollback to previous version
      await _rollbackService.rollbackAlgorithm('matching_algorithm_v2');
    }
  }
}
```

### Technology Stack Recommendations

**Phase 1 (Main Backend - Flutter/Dart):**
```yaml
# pubspec.yaml additions
dependencies:
  # Analytics & Data Collection
  firebase_analytics: ^10.7.4
  sentry_flutter: ^7.14.0  # Error tracking

  # Data Processing
  csv: ^5.0.2              # Export analytics data
  collection: ^1.17.2      # Enhanced collections

  # Background Processing
  workmanager: ^0.5.2      # Background analytics sync
```

**Phase 2 (ML Service - Python):**
```python
# requirements.txt
fastapi==0.104.1
uvicorn==0.24.0
scikit-learn==1.3.2
pandas==2.1.4
numpy==1.25.2
joblib==1.3.2              # Model persistence
redis==5.0.1               # Caching ML predictions
celery==5.3.4              # Background ML training
```

**Phase 3 (Advanced Analytics):**
```yaml
# Advanced analytics infrastructure
services:
  - redis:                  # Real-time caching
  - postgresql:            # Analytics data storage
  - influxdb:              # Time-series metrics
  - kafka:                 # Event streaming
  - spark:                 # Big data processing
  - grafana:               # Analytics dashboards
```

### Data Flow Architecture

```
Phase 1: Data Collection
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   User Action   │───▶│ Behavior Tracking │───▶│  Data Storage   │
│   (Selects tag) │    │   Service        │    │ (PostgreSQL)    │
└─────────────────┘    └──────────────────┘    └─────────────────┘

Phase 2: ML Processing
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│  Behavior Data  │───▶│  Python ML       │───▶│ ML Predictions  │
│   (Exported)    │    │  Service         │    │   (API)         │
└─────────────────┘    └──────────────────┘    └─────────────────┘

Phase 3: Advanced Analytics
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│ ML Predictions  │───▶│  A/B Testing &   │───▶│ Optimized       │
│   + User Data   │    │  Analytics       │    │ Recommendations │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### Integration Points

**Feed Feature Integration:**
- Use ML-enhanced matching scores to rank group recommendations
- Show "Why you're seeing this" with data-driven insights
- A/B test different recommendation strategies

**User Profile Integration:**
- Display ML-generated hashtag suggestions during profile creation
- Show compatibility insights based on behavior analysis
- Allow users to provide feedback on recommendation quality

**Group Management Integration:**
- Provide creators with ML insights on optimal hashtag selection
- Show predicted user demographics for different hashtag combinations
- A/B test group discovery strategies

This data-driven architecture replaces static, hardcoded mappings with a sophisticated analytics system that learns from user behavior and continuously improves matching accuracy through machine learning and statistical analysis.

### Integration Points

**Feed Feature Integration:**
- Use matching scores to rank group recommendations
- Show "Why you're seeing this" with matching hashtag breakdown
- Allow users to filter by match quality (Good Match, Excellent Match)

**User Profile Integration:**
- Display user's generated hashtags on profile
- Show compatibility insights with different group types
- Allow users to prioritize certain attributes for matching

**Group Management Integration:**
- Help creators optimize group hashtags for better matching
- Show what types of users match well with current group setup
- Provide suggestions for hashtag improvements

This enhanced matching system creates sophisticated, multi-dimensional compatibility scoring that considers professional background, education, lifestyle preferences, and demographic factors to provide highly relevant group recommendations.

## Phase 4: Feature Domain Layer Implementation (Updated - Feature-Specific Data Models)

### Feed Feature Domain (Updated - Feature-Specific Data Models)
- [ ] Create feed-specific domain models:
  - [ ] lib/features/feed/domain/models/feed_filter.dart - Feed filtering criteria and state
  - [ ] lib/features/feed/domain/models/feed_state.dart - Feed UI state management
  - [ ] lib/features/feed/domain/models/search_history.dart - Search history and suggestions
  - [ ] lib/features/feed/domain/models/feed_preferences.dart - User feed preferences
- [ ] Create feed repository interface:
  - [ ] lib/features/feed/domain/repositories/feed_repository_interface.dart - Feed operations
- [ ] Implement feed use cases:
  - [ ] lib/features/feed/domain/use_cases/get_feed_groups_use_case.dart - Get groups for feed
  - [ ] lib/features/feed/domain/use_cases/filter_groups_use_case.dart - Apply feed filters
  - [ ] lib/features/feed/domain/use_cases/search_groups_use_case.dart - Search functionality
  - [ ] lib/features/feed/domain/use_cases/save_search_history_use_case.dart - Save searches
- [ ] Feed feature will use shared GroupService for core Group operations

### Discovery Feature Domain (Updated - Feature-Specific Data Models)
- [ ] Create discovery-specific domain models:
  - [ ] lib/features/discovery/domain/models/location_settings.dart - Location preferences and GPS settings
  - [ ] lib/features/discovery/domain/models/discovery_state.dart - Discovery UI state
  - [ ] lib/features/discovery/domain/models/map_preferences.dart - Map display preferences
- [ ] Create discovery repository interface:
  - [ ] lib/features/discovery/domain/repositories/discovery_repository_interface.dart - Discovery operations
- [ ] Implement discovery use cases:
  - [ ] lib/features/discovery/domain/use_cases/get_nearby_groups_use_case.dart - Find groups by location
  - [ ] lib/features/discovery/domain/use_cases/get_discoverable_users_use_case.dart - Find users by location
  - [ ] lib/features/discovery/domain/use_cases/update_location_settings_use_case.dart - Location preferences
  - [ ] lib/features/discovery/domain/use_cases/get_groups_by_proximity_use_case.dart - Proximity-based discovery
- [ ] Discovery feature will use shared GroupService for core Group operations

### Messaging Feature Domain (Updated - Feature-Specific Data Models)
- [ ] Create messaging-specific domain models:
  - [ ] lib/features/messaging/domain/models/message.dart - Complete message entity with metadata
  - [ ] lib/features/messaging/domain/models/conversation.dart - Conversation/thread management
  - [ ] lib/features/messaging/domain/models/chat_state.dart - Chat UI state management
  - [ ] lib/features/messaging/domain/models/message_draft.dart - Message draft composition
  - [ ] lib/features/messaging/domain/models/typing_indicator.dart - Typing status management
- [ ] Create messaging repository interface:
  - [ ] lib/features/messaging/domain/repositories/messaging_repository_interface.dart - Messaging operations
- [ ] Implement messaging use cases:
  - [ ] lib/features/messaging/domain/use_cases/get_conversation_messages_use_case.dart - Get message history
  - [ ] lib/features/messaging/domain/use_cases/send_message_use_case.dart - Send messages
  - [ ] lib/features/messaging/domain/use_cases/get_user_conversations_use_case.dart - Get conversation list
  - [ ] lib/features/messaging/domain/use_cases/mark_messages_read_use_case.dart - Mark as read
  - [ ] lib/features/messaging/domain/use_cases/save_message_draft_use_case.dart - Draft management
- [ ] Messaging feature will use shared GroupService for group operations

### Group Management Feature Domain (Updated - Feature-Specific Data Models)
- [ ] Create group management-specific domain models:
  - [ ] lib/features/group_management/domain/models/group_creation_state.dart - Group creation workflow state
  - [ ] lib/features/group_management/domain/models/pot_management.dart - Group pot economics and management
  - [ ] lib/features/group_management/domain/models/member_management.dart - Member invitation and management
  - [ ] lib/features/group_management/domain/models/group_settings.dart - Group configuration and privacy
  - [ ] lib/features/group_management/domain/models/join_request.dart - Group join requests and approvals
- [ ] Create group management repository interface:
  - [ ] lib/features/group_management/domain/repositories/group_management_repository_interface.dart - Extended group operations
- [ ] Implement group management use cases:
  - [ ] lib/features/group_management/domain/use_cases/create_group_use_case.dart - Create groups with pots
  - [ ] lib/features/group_management/domain/use_cases/manage_group_members_use_case.dart - Member operations
  - [ ] lib/features/group_management/domain/use_cases/manage_pot_use_case.dart - Pot economics
  - [ ] lib/features/group_management/domain/use_cases/join_group_with_cost_use_case.dart - Join with payment
  - [ ] lib/features/group_management/domain/use_cases/update_group_settings_use_case.dart - Settings management
- [ ] Group Management will use shared GroupService for core Group operations

### User Profile Feature Domain (Updated - Feature-Specific Data Models)
- [ ] Create user profile-specific domain models:
  - [ ] lib/features/user_profile/domain/models/profile_edit_state.dart - Profile editing workflow
  - [ ] lib/features/user_profile/domain/models/achievement.dart - User achievements and badges
  - [ ] lib/features/user_profile/domain/models/verification_status.dart - Profile verification state
  - [ ] lib/features/user_profile/domain/models/profile_preferences.dart - Profile display preferences
  - [ ] lib/features/user_profile/domain/models/points_transaction.dart - Points economics and history
  - [ ] lib/features/user_profile/domain/models/premium_subscription.dart - Premium management
- [ ] Create user profile repository interface:
  - [ ] lib/features/user_profile/domain/repositories/user_profile_repository_interface.dart - Extended user operations
- [ ] Implement user profile use cases:
  - [ ] lib/features/user_profile/domain/use_cases/get_user_profile_use_case.dart - Get profile data
  - [ ] lib/features/user_profile/domain/use_cases/update_user_profile_use_case.dart - Update profile
  - [ ] lib/features/user_profile/domain/use_cases/manage_points_use_case.dart - Points economics
  - [ ] lib/features/user_profile/domain/use_cases/upgrade_to_premium_use_case.dart - Premium subscription
  - [ ] lib/features/user_profile/domain/use_cases/get_achievements_use_case.dart - Achievement management
- [ ] User Profile will use shared UserService for core User operations

### Authentication Feature Domain (Updated - Feature-Specific Data Models)
- [ ] Create authentication-specific domain models:
  - [ ] lib/features/authentication/domain/models/auth_state.dart - Authentication state management
  - [ ] lib/features/authentication/domain/models/login_request.dart - Login credentials and validation
  - [ ] lib/features/authentication/domain/models/signup_request.dart - Signup data and validation
  - [ ] lib/features/authentication/domain/models/session.dart - User session management
  - [ ] lib/features/authentication/domain/models/social_auth_request.dart - Social login credentials
- [ ] Create authentication repository interface:
  - [ ] lib/features/authentication/domain/repositories/authentication_repository_interface.dart - Auth operations
- [ ] Implement authentication use cases:
  - [ ] lib/features/authentication/domain/use_cases/login_use_case.dart - User login
  - [ ] lib/features/authentication/domain/use_cases/signup_use_case.dart - User registration
  - [ ] lib/features/authentication/domain/use_cases/logout_use_case.dart - User logout
  - [ ] lib/features/authentication/domain/use_cases/get_current_user_use_case.dart - Current user session
  - [ ] lib/features/authentication/domain/use_cases/social_login_use_case.dart - Social authentication
  - [ ] lib/features/authentication/domain/use_cases/reset_password_use_case.dart - Password recovery
- [ ] Authentication will use shared UserService for User identity operations

### Settings Feature Domain (Updated - Feature-Specific Data Models)
- [ ] Create settings-specific domain models:
  - [ ] lib/features/settings/domain/models/app_preferences.dart - App-wide preferences
  - [ ] lib/features/settings/domain/models/notification_settings.dart - Notification preferences
  - [ ] lib/features/settings/domain/models/privacy_settings.dart - Privacy and security settings
  - [ ] lib/features/settings/domain/models/settings_state.dart - Settings UI state management
- [ ] Create settings repository interface:
  - [ ] lib/features/settings/domain/repositories/settings_repository_interface.dart - Settings operations
- [ ] Implement settings use cases:
  - [ ] lib/features/settings/domain/use_cases/get_app_settings_use_case.dart - Get all settings
  - [ ] lib/features/settings/domain/use_cases/update_app_settings_use_case.dart - Update preferences
  - [ ] lib/features/settings/domain/use_cases/manage_notification_settings_use_case.dart - Notification management
  - [ ] lib/features/settings/domain/use_cases/manage_privacy_settings_use_case.dart - Privacy management
  - [ ] lib/features/settings/domain/use_cases/export_settings_use_case.dart - Settings backup/restore
- [ ] Settings feature will use shared UserService for user-specific settings

## Phase 5: State Management Setup (Updated - Feature-Specific Services)

### Riverpod Provider Creation
- [ ] Create Riverpod providers for shared services (in core/di/):
  - [ ] lib/core/di/providers/group_service_provider.dart
  - [ ] lib/core/di/providers/user_service_provider.dart
- [ ] Create Riverpod providers for each feature:
  - [ ] lib/features/feed/presentation/providers/feed_provider.dart - Uses Feed service + shared GroupService
  - [ ] lib/features/discovery/presentation/providers/discovery_provider.dart - Uses Discovery service + shared GroupService
  - [ ] lib/features/messaging/presentation/providers/messaging_provider.dart - Uses Messaging service
  - [ ] lib/features/group_management/presentation/providers/group_management_provider.dart - Uses GroupManagement service + shared GroupService
  - [ ] lib/features/user_profile/presentation/providers/user_profile_provider.dart - Uses UserProfile service + shared UserService
  - [ ] lib/features/authentication/presentation/providers/authentication_provider.dart - Uses Authentication service + shared UserService
  - [ ] lib/features/settings/presentation/providers/settings_provider.dart - Uses Settings service

### State Management Implementation
- [ ] Implement state management for Feed feature:
  - [ ] Feed state classes (loading, loaded, error, filtered)
  - [ ] Feed notifier/providers using Feed service + shared GroupService
  - [ ] Feed state actions and reducers
- [ ] Implement state management for Discovery feature:
  - [ ] Discovery state classes
  - [ ] Location-based state updates using Discovery service + shared GroupService
  - [ ] Nearby users/groups state management
- [ ] Implement state management for Messaging feature:
  - [ ] Messaging state classes using Messaging service
  - [ ] Chat state management
  - [ ] Real-time message updates
- [ ] Implement state management for Group Management feature:
  - [ ] Group creation state using GroupManagement service + shared GroupService
  - [ ] Group management state
  - [ ] Member management state
  - [ ] Pot balance state management (within GroupManagement service)
  - [ ] Join cost state management
  - [ ] Contribution state management
- [ ] Implement state management for User Profile feature:
  - [ ] Profile state management using UserProfile service + shared UserService
  - [ ] Profile editing state
  - [ ] Profile updates state
  - [ ] Points balance state management (within UserProfile service)
  - [ ] Points transaction state management
  - [ ] Premium subscription state management (within UserProfile service)
  - [ ] Premium upgrade flow state
- [ ] Implement state management for Authentication feature:
  - [ ] Authentication state (authenticated, unauthenticated, loading) using Authentication service
  - [ ] Login state management
  - [ ] Signup state management
  - [ ] Session management state
  - [ ] Authentication error states
- [ ] Implement state management for Settings feature:
  - [ ] Settings state management using Settings service
  - [ ] Settings updates state
  - [ ] Settings persistence state
  - [ ] Authentication settings state

## Phase 5: Mock System Decommissioning (NEW)

### Legacy Service Removal Process
- [ ] **Legacy MockDataService Removal:**
  - [ ] Verify all screens have been migrated to new services
  - [ ] Confirm no direct `MockDataService` imports remain in codebase
  - [ ] Remove `lib/shared/base_data/bridges/mock_data_bridge.dart`
  - [ ] Remove `lib/shared/base_data/bridges/legacy_mock_adapter.dart`
  - [ ] Remove `lib/shared/base_data/bridges/service_migration_facade.dart`
  - [ ] Delete original `lib/services/mock_data_service.dart` file
- [ ] **Bridge Layer Cleanup:**
  - [ ] Remove `lib/core/feature_flags/feature_flags.dart`
  - [ ] Remove `lib/core/feature_flags/mock_migration_flags.dart`
  - [ ] Delete `lib/core/di/service_migration_coordinator.dart`
  - [ ] Remove legacy service provider wrappers
  - [ ] Clean up migration-related DI providers

### Feature File Cleanup
- [ ] **Remove Legacy Mock Files:**
  - [ ] Delete `lib/mock/` directory after successful migration
  - [ ] Remove `lib/mock/data/` subdirectories and files
  - [ ] Remove `lib/mock/generators/` subdirectories and files
  - [ ] Remove `lib/mock/repositories/` subdirectories and files
  - [ ] Remove `lib/mock/storage/` subdirectories and files
- [ ] **Clean Up Legacy Imports:**
  - [ ] Remove all import statements referencing `lib/mock/` directory
  - [ ] Update any remaining indirect references
  - [ ] Verify no broken imports remain

### Service Registration Cleanup
- [ ] **DI Container Cleanup:**
  - [ ] Remove legacy `MockDataService` registration from DI container
  - [ ] Remove feature flag-based service switching logic
  - [ ] Remove migration service provider registrations
  - [ ] Clean up migration-related DI configuration
- [ ] **Provider Cleanup:**
  - [ ] Remove `lib/core/di/providers/legacy_user_service_provider.dart`
  - [ ] Remove `lib/core/di/providers/legacy_group_service_provider.dart`
  - [ ] Remove `lib/core/di/providers/migration_service_provider.dart`
  - [ ] Clean up any other migration-related providers

### Final Validation
- [ ] **System Integration Validation:**
  - [ ] Verify all features work with new services only
  - [ ] Test complete app functionality without legacy services
  - [ ] Confirm no performance degradation after cleanup
  - [ ] Validate memory usage is optimized
- [ ] **Code Quality Validation:**
  - [ ] Run static analysis to ensure no unused imports
  - [ ] Verify zero references to legacy mock system
  - [ ] Confirm all tests pass with new service architecture
  - [ ] Validate code coverage maintained after cleanup

### Documentation Updates
- [ ] **Update Development Documentation:**
  - [ ] Update CLAUDE.md with new service architecture
  - [ ] Document new service patterns and usage
  - [ ] Update onboarding guides for new architecture
  - [ ] Remove references to legacy mock system
- [ ] **Update API Documentation:**
  - [ ] Document new service interfaces
  - [ ] Update service usage examples
  - [ ] Document data flow patterns with new services
  - [ ] Create migration completion summary

### Post-Migration Monitoring
- [ ] **Performance Monitoring:**
  - [ ] Monitor app performance after legacy system removal
  - [ ] Track memory usage patterns
  - [ ] Monitor service response times
  - [ ] Set up alerts for any performance regressions
- [ ] **Error Monitoring:**
  - [ ] Monitor error rates after migration
  - [ ] Track any service-related issues
  - [ ] Set up logging for service interactions
  - [ ] Create dashboards for service health monitoring

### File Movements and Transformations (NEW)
- [ ] **Phase 0-1 File Movements (Immediate):**
  - [ ] `lib/mock/storage/mock_storage.dart` → `lib/shared/base_data/data_sources/local/mock_storage.dart`
  - [ ] `lib/mock/data/consolidated_constants.dart` → `lib/core/constants/mock_constants.dart`
  - [ ] `lib/mock/data/unified_interests.dart` → `lib/shared/base_data/models/entities/interest.dart`
  - [ ] `lib/mock/data/mock_user_data.dart` → `lib/shared/base_data/data_sources/local/mock_user_data.dart`
  - [ ] `lib/mock/data/mock_group_data.dart` → `lib/shared/base_data/data_sources/local/mock_group_data.dart`
- [ ] **Generator File Movements:**
  - [ ] `lib/mock/generators/base_generator.dart` → `lib/shared/base_data/generators/base_generator.dart`
  - [ ] `lib/mock/generators/user_generator.dart` → `lib/shared/base_data/generators/user_generator.dart`
  - [ ] `lib/mock/generators/group_generator.dart` → `lib/shared/base_data/generators/group_generator.dart`
- [ ] **Service Extraction Phases:**
  - [ ] **Phase 1:** Create shared service wrappers
    - [ ] Create `lib/shared/base_data/services/user_service.dart` wrapping user methods from `MockDataService`
    - [ ] Create `lib/shared/base_data/services/group_service.dart` wrapping group methods from `MockDataService`
  - [ ] **Phase 2:** Extract feature-specific services
    - [ ] Create `lib/features/feed/domain/services/feed_service.dart` extracting feed methods from `MockDataService`
    - [ ] Create `lib/features/discovery/domain/services/discovery_service.dart` extracting discovery methods from `MockDataService`
    - [ ] Create `lib/features/messaging/domain/services/messaging_service.dart` extracting messaging methods from `MockDataService`
    - [ ] Create `lib/features/group_management/domain/services/group_management_service.dart` extracting group management methods from `MockDataService`
    - [ ] Create `lib/features/user_profile/domain/services/user_profile_service.dart` extracting user profile methods from `MockDataService`
    - [ ] Create `lib/features/authentication/domain/services/authentication_service.dart` extracting authentication methods from `MockDataService`
    - [ ] Create `lib/features/settings/domain/services/settings_service.dart` extracting settings methods from `MockDataService`
  - [ ] **Phase 3:** Remove original service
    - [ ] Delete `lib/services/mock_data_service.dart` after all methods extracted
    - [ ] Update all imports to use new service locations
- [ ] **File Transformation Guidelines:**
  - [ ] Maintain existing method signatures and return types
  - [ ] Preserve existing error handling patterns
  - [ ] Keep existing mock data generation logic intact
  - [ ] Ensure all data relationships and constraints preserved
  - [ ] Update import statements throughout codebase
  - [ ] Validate all references updated correctly

## Phase 6: Presentation Layer Migration (Updated - Feature-Specific Services)

### Screen Migration Strategy
- [ ] Migrate simple screens first:
  - [ ] lib/features/settings/presentation/screens/settings_screen.dart - Uses Settings service
  - [ ] lib/features/authentication/presentation/screens/ - Uses Authentication service
- [ ] Migrate medium complexity screens:
  - [ ] lib/features/user_profile/presentation/screens/profile_screen.dart - Uses UserProfile service + shared UserService
  - [ ] lib/features/messaging/presentation/screens/chat_room_list_screen.dart - Uses Messaging service
  - [ ] lib/features/discovery/presentation/screens/discover_screen.dart - Uses Discovery service + shared GroupService
- [ ] Migrate complex screens last:
  - [ ] lib/features/feed/presentation/screens/feed_screen.dart - Uses Feed service + shared GroupService
  - [ ] lib/features/messaging/presentation/screens/chat_screen.dart - Uses Messaging service + shared GroupService
  - [ ] lib/features/group_management/presentation/screens/ - Uses GroupManagement service + shared GroupService

### Screen Migration Tasks
- [ ] **Authentication screens:**
  - [ ] Create login screen using Authentication service + shared UserService
  - [ ] Create signup screen using Authentication service + shared UserService
  - [ ] Create forgot password screen using Authentication service
- [ ] Migrate settings screen to use Settings service
- [ ] Migrate user profile screen to use UserProfile service + shared UserService
- [ ] Migrate chat room list screen to use Messaging service
- [ ] Migrate chat screen to use Messaging service + shared GroupService
- [ ] Migrate discover screen to use Discovery service + shared GroupService
- [ ] Migrate feed screen to use Feed service + shared GroupService
- [ ] Migrate filter screen to use Feed service + shared GroupService
- [ ] Migrate interest search screen to use Feed service + shared GroupService
- [ ] Migrate group info screen (enhance with pot UI) to use GroupManagement service + shared GroupService
- [ ] Migrate create group screen (enhance with pot creation UI) to use GroupManagement service + shared GroupService

### Widget Creation
- [ ] Create feature-specific widgets that use feature-specific + shared services:
  - [ ] Feed feature widgets in lib/features/feed/presentation/widgets/ - Uses Feed service + shared GroupService
  - [ ] Messaging feature widgets in lib/features/messaging/presentation/widgets/ - Uses Messaging service + shared GroupService
  - [ ] Discovery feature widgets in lib/features/discovery/presentation/widgets/ - Uses Discovery service + shared GroupService
  - [ ] Group management widgets in lib/features/group_management/presentation/widgets/ - Uses GroupManagement service + shared GroupService
  - [ ] Group management pots widgets in lib/features/group_management/presentation/widgets/ - Uses GroupManagement service
  - [ ] User profile widgets in lib/features/user_profile/presentation/widgets/ - Uses UserProfile service + shared UserService
  - [ ] User profile points widgets in lib/features/user_profile/presentation/widgets/ - Uses UserProfile service
  - [ ] User profile premium widgets in lib/features/user_profile/presentation/widgets/ - Uses UserProfile service
  - [ ] Authentication feature widgets in lib/features/authentication/presentation/widgets/ - Uses Authentication service + shared UserService
  - [ ] Settings widgets in lib/features/settings/presentation/widgets/ - Uses Settings service

### UI State Implementation
- [ ] Implement proper loading states using feature-specific services
- [ ] Implement error states with user-friendly messages from feature-specific services
- [ ] Ensure reactive updates across components using proper service integration

## Phase 7: Navigation & Routing (Updated - Feature-Specific Services)

### Routing System Setup
- [ ] Create new routing system in lib/core/routes/:
  - [ ] lib/core/routes/app_router.dart - Type-safe navigation
  - [ ] lib/core/routes/route_names.dart - Route constants
  - [ ] lib/core/routes/unknown_route.dart - 404 handling
- [ ] Implement type-safe navigation:
  - [ ] Define route parameters with proper typing
  - [ ] Create route guards for authentication using Authentication service + shared UserService
  - [ ] Add deep linking support
- [ ] Update main.dart with new routing system:
  - [ ] Configure routing with Riverpod providers
  - [ ] Set up route guards for authenticated routes
  - [ ] Add navigation error handling

### Route Migration
- [ ] Migrate routes incrementally:
  - [ ] Welcome route
  - [ ] Feed routes (uses Feed service + shared GroupService)
  - [ ] Discovery routes (uses Discovery service + shared GroupService)
  - [ ] Messaging routes (uses Messaging service + shared GroupService)
  - [ ] Group management routes (uses GroupManagement service + shared GroupService)
  - [ ] User profile routes (uses UserProfile service + shared UserService)
  - [ ] Settings routes (uses Settings service)
  - [ ] Authentication routes (uses Authentication service + shared UserService)

### Navigation Integration
- [ ] Configure navigation with Riverpod providers
- [ ] Implement navigation state management using feature-specific services
- [ ] Add navigation error handling from appropriate services
- [ ] Test navigation flow across all features

## Phase 8: Widget & UI Organization (Updated - Feature-Specific Services)

### Shared Widget Migration
- [ ] Migrate shared widgets to shared/ui_kit/:
  - [ ] lib/shared/ui_kit/widgets/custom_bottom_nav.dart
  - [ ] lib/shared/ui_kit/widgets/user_avatar.dart
  - [ ] lib/shared/ui_kit/widgets/loading_states.dart
  - [ ] lib/shared/ui_kit/widgets/user_card.dart
  - [ ] lib/shared/ui_kit/widgets/member_profile_popup.dart
  - [ ] lib/shared/ui_kit/widgets/map_popup_dialog.dart

### Widget Composition
- [ ] Break down large screen files into smaller components using appropriate services
- [ ] Create reusable UI components that work with service layers:
  - [ ] Form components compatible with feature-specific services
  - [ ] List components compatible with feature-specific services
  - [ ] Card components compatible with feature-specific services
  - [ ] Button components (service-agnostic)
  - [ ] Input components (service-agnostic)
- [ ] Implement proper widget composition patterns

### UI Utilities
- [ ] Create UI utility functions:
  - [ ] lib/shared/ui_utils/responsive_utils.dart
  - [ ] lib/shared/ui_utils/validation_utils.dart
  - [ ] lib/shared/ui_utils/formatting_utils.dart
  - [ ] lib/shared/ui_utils/dialog_utils.dart

### Theme Integration
- [ ] Move theme configuration to lib/core/theme/
- [ ] Ensure consistent theming across all features
- [ ] Maintain dark theme compliance
- [ ] Add responsive design improvements

## Phase 9: Integration & Cleanup (Updated - Feature-Specific Services)

### Import Statement Updates
- [ ] Update all import statements throughout the app:
  - [ ] Remove old import paths to feature data layers
  - [ ] Add new import paths to feature-specific services + shared services
  - [ ] Update imports to use appropriate service layers
  - [ ] Verify all imports resolve correctly

### Service Dependency Updates
- [ ] Remove direct service dependencies from UI layer:
  - [ ] Update screens to use feature-specific services via dependency injection
  - [ ] Remove deprecated services from individual features
  - [ ] Clean up unused service files
  - [ ] Remove old mock system references

### Legacy Code Cleanup
- [ ] Remove old mock system references:
  - [ ] Clean up unused files and imports
  - [ ] Remove duplicate data sources from features
  - [ ] Remove redundant repository implementations
  - [ ] Delete unused utility functions

### Validation Testing
- [ ] Validate complete app functionality using feature-specific + shared services:
  - [ ] Test all existing features work identically
  - [ ] Verify feature-specific services work correctly
  - [ ] Test navigation flow works correctly
  - [ ] Confirm all user interactions preserved
  - [ ] Verify real-time messaging functionality intact
  - [ ] Test authentication system works correctly
  - [ ] Validate group management includes pots functionality
  - [ ] Verify user profile includes points and premium subscription management
  - [ ] Test authentication guards protect appropriate features
  - [ ] Validate session management works correctly

## Phase 10: Testing Infrastructure (Updated - Feature-Specific Services)

### Unit Tests
- [ ] Create unit tests for domain use cases using feature-specific + shared services:
  - [ ] Feed feature use case tests using Feed service + shared GroupService
  - [ ] Messaging feature use case tests using Messaging service
  - [ ] Discovery feature use case tests using Discovery service + shared GroupService
  - [ ] Group management use case tests using GroupManagement service + shared GroupService
  - [ ] User profile use case tests using UserProfile service + shared UserService
  - [ ] Authentication use case tests using Authentication service + shared UserService
  - [ ] Settings use case tests using Settings service
- [ ] Create unit tests for services:
  - [ ] Shared GroupService tests
  - [ ] Shared UserService tests
  - [ ] Feature-specific service tests (Feed, Messaging, Discovery, etc.)

### Widget Tests
- [ ] Create widget tests for UI components using appropriate services:
  - [ ] Shared widget tests using mocked services
  - [ ] Feature-specific widget tests using mocked feature-specific services
  - [ ] Screen widget tests using mocked service combinations
  - [ ] State management widget tests using mocked services

### Integration Tests
- [ ] Create integration tests for user flows using appropriate services:
  - [ ] Feed browsing flow using Feed service + shared GroupService
  - [ ] Discovery flow using Discovery service + shared GroupService
  - [ ] Messaging flow using Messaging service + shared GroupService
  - [ ] Group management flow using GroupManagement service + shared GroupService
  - [ ] User profile flow using UserProfile service + shared UserService
  - [ ] Authentication flow using Authentication service + shared UserService

### Test Utilities
- [ ] Create test data utilities for service testing:
  - [ ] Mock service generators for testing
  - [ ] Test fixture classes for all models
  - [ ] Test helper functions for service combinations
  - [ ] Test setup utilities for feature-specific architecture

### Migration Testing and Rollback Strategies (NEW)
- [ ] **Migration Period Testing Strategy:**
  - [ ] **Parallel Testing:**
    - [ ] Test legacy services and new services simultaneously
    - [ ] Compare outputs between legacy and new services for identical inputs
    - [ ] Validate data consistency between service implementations
    - [ ] Performance testing between legacy and new services
  - [ ] **Feature Flag Testing:**
    - [ ] Test service switching functionality
    - [ ] Validate fallback mechanisms work correctly
    - [ ] Test rollback procedures during migration
    - [ ] Verify feature flag changes don't break functionality
- [ ] **Service Compatibility Testing:**
  - [ ] **Interface Compatibility Tests:**
    - [ ] Verify new services implement identical interfaces to legacy services
    - [ ] Test method signatures match exactly
    - [ ] Validate return types and error handling patterns
    - [ ] Ensure performance characteristics maintained
  - [ ] **Data Consistency Tests:**
    - [ ] Compare mock data generation between legacy and new services
    - [ ] Validate data relationships preserved during migration
    - [ ] Test data integrity across service boundaries
    - [ ] Verify caching mechanisms work correctly
- [ ] **Rollback Strategy Implementation:**
  - [ ] **Automatic Rollback Triggers:**
    - [ ] Set up performance threshold monitoring
    - [ ] Configure error rate monitoring with automatic rollback
    - [ ] Implement memory usage monitoring
    - [ ] Create service response time monitoring
  - [ ] **Manual Rollback Procedures:**
    - [ ] Document rollback steps for each migration phase
    - [ ] Create rollback scripts for feature flag changes
    - [ ] Establish rollback communication procedures
    - [ ] Define rollback validation criteria
  - [ ] **Rollback Validation:**
    - [ ] Test rollback procedures before migration starts
    - [ ] Validate rollback restores full functionality
    - [ ] Ensure no data corruption during rollback
    - [ ] Confirm performance returns to baseline after rollback
- [ ] **Migration Monitoring and Alerting:**
  - [ ] **Real-time Monitoring:**
    - [ ] Set up dashboards for service health monitoring
    - [ ] Create alerts for service failures or performance degradation
    - [ ] Monitor user experience metrics during migration
    - [ ] Track error rates and response times
  - [ ] **Migration Logging:**
    - [ ] Log all service switching events
    - [ ] Record performance metrics during migration
    - [ ] Document any issues encountered during migration
    - [ ] Create audit trail for migration process
- [ ] **Contingency Planning:**
  - [ ] **Migration Pause Procedures:**
    - [ ] Define criteria for pausing migration
    - [ ] Create procedures for freezing migration at any phase
    - [ ] Document how to maintain system stability during pause
    - [ ] Plan communication strategies for migration pauses
  - [ ] **Emergency Procedures:**
    - [ ] Document emergency rollback procedures
    - [ ] Create emergency contact protocols
    - [ ] Establish system stabilization procedures
    - [ ] Plan post-emergency validation steps

## Phase 11: Performance Optimization (Updated - Feature-Specific Services)

### Performance Optimization
- [ ] Implement lazy loading for large datasets using appropriate services:
  - [ ] Lazy loading for group data using shared GroupService
  - [ ] Lazy loading for message data using Messaging service
  - [ ] Lazy loading for user data using shared UserService
  - [ ] Lazy loading for feature-specific data using feature services
- [ ] Add proper widget disposal patterns using appropriate services
- [ ] Optimize state management subscriptions using service layers
- [ ] Reduce bundle size and memory usage using feature-specific architecture
- [ ] Add performance monitoring for all service layers

### Cache Optimization
- [ ] Implement caching strategies for service layers:
  - [ ] Group data caching in shared GroupService
  - [ ] Message caching in Messaging service
  - [ ] User profile caching in shared UserService + UserProfile service
  - [ ] Feature-specific data caching in appropriate feature services
  - [ ] Settings caching in Settings service

## Success Metrics Validation (Updated - Feature-Specific Services)

### Code Quality Validation
- [ ] Verify cyclomatic complexity reduced by 60%
- [ ] Confirm 80%+ test coverage achieved
- [ ] Ensure zero static analysis issues
- [ ] Validate average file size under 300 lines

### Architecture Validation
- [ ] Confirm 100% dependency injection coverage
- [ ] Verify complete separation of concerns across feature and shared layers
- [ ] Check for zero circular dependencies
- [ ] Validate proper error handling throughout all service layers
- [ ] Verify feature data isolation and proper data sharing boundaries
- [ ] Confirm minimal shared layer implementation (User, Group, entities only)

### Functional Validation
- [ ] Test all existing features work identically with feature-specific + shared services
- [ ] Verify authentication system works correctly (login, signup, logout)
- [ ] Verify group management includes pots functionality using GroupManagement service
- [ ] Verify user profile includes points and premium subscription management using UserProfile service
- [ ] Verify no regression in user experience with proper feature isolation
- [ ] Confirm feature-specific services provide proper data encapsulation
- [ ] Validate clean architecture patterns applied consistently across all features
- [ ] Test authentication guards protect appropriate features
- [ ] Validate session management works correctly across Authentication + shared UserService
- [ ] Verify minimal shared data layer provides appropriate cross-feature coordination

This implementation plan provides a systematic, step-by-step approach to migrating the Nearby Flutter app to Feature-First Clean Architecture with **minimal shared data** and **feature-specific data layers** that properly isolates feature concerns while maintaining appropriate cross-feature coordination through shared User/Group entities.