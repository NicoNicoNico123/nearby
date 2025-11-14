# Feature-First Clean Architecture Migration Requirements

## Project Overview

This document outlines the requirements for migrating the Nearby Flutter social dining app from its current feature-based organization to Feature-First Clean Architecture (FFCA) while preserving all existing functionality and ensuring zero breaking changes.

## Current State Analysis

### Existing Architecture
- **Framework**: Flutter 3.35.5 with 19,730 lines of code
- **Organization**: Feature-based screens with service layer
- **State Management**: Raw Flutter `setState()` patterns (18 occurrences)
- **Data Layer**: Mock data service with repository-like pattern
- **UI Components**: 7 core screens with complex state management

### Current Features
1. **Feed System**: Browse and filter groups by interests, languages, location
2. **Discovery Page**: Location-based user discovery with map integration
3. **Messaging System**: Real-time chat with group conversations
4. **Group Management**: Create groups, view group info, member management
5. **User Profiles**: Comprehensive profile management with premium features, points system
6. **Settings**: User preferences and app configuration
7. **Welcome/Onboarding**: First-time user experience

### Missing Critical Features
1. **Authentication System**: User login/signup, session management (completely missing)
2. **Pots System**: Group pot management, join costs, group economics (needs separation)

## Migration Requirements

### 1. Functional Requirements

#### 1.1 Architecture Transformation
- **MUST**: Implement Feature-First Clean Architecture structure
- **MUST**: Create core/, shared/, and features/ layers with proper separation
- **MUST**: Use Chinese comments for core/shared sections (following provided template)
- **MUST**: Implement domain/data/presentation layers for each feature
- **MUST**: Preserve all existing functionality without breaking changes

#### 1.2 Feature Modules Structure
```
lib/
├── core/                    # 核心共用功能
│   ├── constants/           # 常量定義
│   ├── theme/              # 主題配置
│   ├── error/              # 錯誤處理
│   └── routes/             # 路由配置
│
├── shared/                 # 跨功能共用
│   ├── base_domain/        # 基礎領域抽象
│   ├── base_data/          # 基礎數據抽象
│   │   ├── models/         # Core shared models (User, Group, entities)
│   │   │   ├── user_model.dart
│   │   │   ├── group_model.dart
│   │   │   └── entities/
│   │   │       ├── location.dart
│   │   │       ├── interest.dart
│   │   │       └── language.dart
│   │   ├── data_sources/   # Shared data sources (mock + future API)
│   │   ├── repositories/   # Shared repository interfaces
│   │   ├── services/       # Shared business logic services
│   │   └── mappers/       # Shared data mappers
│   ├── utils/              # Dart 工具類
│   ├── ui_utils/           # Flutter 工具類
│   └── ui_kit/             # 設計系統/共用組件
│
└── features/               # 功能模塊
    ├── feed/               # Feed browsing and filtering
    │   ├── domain/         # 業務邏輯層
    │   │   ├── models/     # Feed-specific models (FeedFilter, FeedState, SearchHistory)
    │   │   ├── repositories/ # Feed-specific repository interfaces
    │   │   └── use_cases/  # 用例 (using shared services)
    │   ├── data/           # 數據層
    │   │   ├── models/     # Feed-specific data models
    │   │   ├── data_sources/ # Feed-specific data sources
    │   │   ├── repositories/ # Feed-specific repository implementations
    │   │   └── mappers/   # Feed-specific data mappers
    │   └── presentation/   # 展示層
    │       ├── screens/    # 頁面
    │       ├── widgets/    # 功能專屬組件
    │       └── controllers/ # 狀態管理
    │
    ├── discovery/          # Location-based user discovery
    │   ├── domain/         # 業務邏輯層
    │   │   ├── models/     # Discovery-specific models (LocationSettings, MapPreferences, DiscoveryFilters)
    │   │   ├── repositories/ # Discovery-specific repository interfaces
    │   │   └── use_cases/  # 用例 (using shared services)
    │   ├── data/           # 數據層
    │   │   ├── models/     # Discovery-specific data models
    │   │   ├── data_sources/ # Discovery-specific data sources
    │   │   ├── repositories/ # Discovery-specific repository implementations
    │   │   └── mappers/   # Discovery-specific data mappers
    │   └── presentation/   # 展示層
    │       ├── screens/
    │       ├── widgets/
    │       └── controllers/
    │
    ├── messaging/          # Chat and conversations
    │   ├── domain/         # 業務邏輯層
    │   │   ├── models/     # Messaging-specific models (Conversation, ChatState, MessageDraft, TypingIndicator)
    │   │   ├── repositories/ # Messaging-specific repository interfaces
    │   │   └── use_cases/  # 用例 (using shared services)
    │   ├── data/           # 數據層
    │   │   ├── models/     # Messaging-specific data models
    │   │   ├── data_sources/ # Messaging-specific data sources
    │   │   ├── repositories/ # Messaging-specific repository implementations
    │   │   └── mappers/   # Messaging-specific data mappers
    │   └── presentation/   # 展示層
    │       ├── screens/
    │       ├── widgets/
    │       └── controllers/
    │
    ├── group_management/   # Group creation and details + pots system
    │   ├── domain/         # 業務邏輯層
    │   │   ├── models/     # GroupManagement-specific models (GroupCreationState, PotManagement, MemberManagement)
    │   │   ├── repositories/ # GroupManagement-specific repository interfaces
    │   │   └── use_cases/  # 用例 (CreateGroup, CreatePot, ContributeToPot, etc.)
    │   ├── data/           # 數據層
    │   │   ├── models/     # GroupManagement-specific data models (pot, transaction data)
    │   │   ├── data_sources/ # GroupManagement-specific data sources
    │   │   ├── repositories/ # GroupManagement-specific repository implementations
    │   │   └── mappers/   # GroupManagement-specific data mappers
    │   └── presentation/   # 展示層
    │       ├── screens/    # Group creation, group info (with pot UI)
    │       ├── widgets/    # Pot balance, contribution widgets
    │       └── controllers/ # Group and Pot state management
    │
    ├── user_profile/       # Profile management + points + premium
    │   ├── domain/         # 業務邏輯層
    │   │   ├── models/     # UserProfile-specific models (ProfileEditState, Achievement, VerificationStatus)
    │   │   ├── repositories/ # UserProfile-specific repository interfaces
    │   │   └── use_cases/  # 用例 (GetProfile, UpdateProfile, ManagePoints, etc.)
    │   ├── data/           # 數據層
    │   │   ├── models/     # UserProfile-specific data models (points, premium data)
    │   │   ├── data_sources/ # UserProfile-specific data sources
    │   │   ├── repositories/ # UserProfile-specific repository implementations
    │   │   └── mappers/   # UserProfile-specific data mappers
    │   └── presentation/   # 展示層
    │       ├── screens/    # Profile screen (with points and premium UI)
    │       ├── widgets/    # Points balance, premium status widgets
    │       └── controllers/ # User profile state management
    │
    ├── authentication/      # User authentication - NEW FEATURE
    │   ├── domain/         # 業務邏輯層
    │   │   ├── models/     # Authentication-specific models (AuthState, LoginRequest, SignUpRequest)
    │   │   ├── repositories/ # Authentication-specific repository interfaces
    │   │   └── use_cases/  # 用例 (Login, Signup, Logout, Session Management)
    │   ├── data/           # 數據層
    │   │   ├── models/     # Authentication-specific data models (session, token data)
    │   │   ├── data_sources/ # Authentication-specific data sources
    │   │   ├── repositories/ # Authentication-specific repository implementations
    │   │   └── mappers/   # Authentication-specific data mappers
    │   └── presentation/   # 展示層
    │       ├── screens/    # Login, Signup, Forgot Password
    │       ├── widgets/    # Auth forms, social login buttons
    │       └── controllers/ # Auth state management
    │
    └── settings/           # App configuration
        ├── domain/         # 業務邏輯層
        │   ├── models/     # Settings-specific models (AppPreferences, NotificationSettings, PrivacySettings)
        │   ├── repositories/ # Settings-specific repository interfaces
        │   └── use_cases/  # 用例
        ├── data/           # 數據層
        │   ├── models/     # Settings-specific data models
        │   ├── data_sources/ # Settings-specific data sources
        │   ├── repositories/ # Settings-specific repository implementations
        │   └── mappers/   # Settings-specific data mappers
        └── presentation/   # 展示層
            ├── screens/
            ├── widgets/
            └── controllers/
```

#### 1.3 Shared Data Layer Architecture
- **MUST**: Implement minimal shared data layer in `shared/base_data/` containing only truly shared data models
- **MUST**: Place only core shared models in `shared/base_data/models/`:
  - `user_model.dart` - Core user identity and profile (used by 6+ features)
  - `group_model.dart` - Group metadata and membership (used by 4+ features)
  - `entities/` - Basic domain entities (Location, Interest, Language)
- **MUST**: Locate shared data sources (mock + future API) in `shared/base_data/data_sources/`
- **MUST**: Define shared repository interfaces in `shared/base_data/repositories/`
- **MUST**: Implement shared business logic services in `shared/base_data/services/`
- **MUST**: Create shared data mappers in `shared/base_data/mappers/`
- **MUST NOT**: Include feature-specific data in shared layer (FeedFilter, ChatState, etc.)
- **MUST**: Each feature's domain layer contains its own data models
- **MUST**: Features use shared services through dependency injection for User/Group operations

#### 1.4 State Management Implementation
- **MUST**: Implement proper state management (Riverpod recommended)
- **MUST**: Replace all 18 existing `setState()` patterns
- **MUST**: Create providers for each feature's state management
- **MUST**: Implement proper loading, error, and success states
- **MUST**: Ensure reactive updates across components

#### 1.5 Feature-Specific Data Layer Requirements
- **MUST**: Each feature contains its own data models in `domain/models/`
- **MUST**: Feature data models contain UI state, filters, and feature-specific business logic
- **MUST**: Features use shared User/Group models through dependency injection
- **MUST NOT**: Create duplicate shared models (User, Group) in feature layers
- **MUST**: Feature data models remain isolated to their respective features

**Examples of Feature-Specific Data:**
- **Feed**: `FeedFilter`, `FeedState`, `SearchHistory`, `FeedPreferences`
- **Discovery**: `LocationSettings`, `MapPreferences`, `DiscoveryFilters`, `DiscoveryState`
- **Messaging**: `Conversation`, `ChatState`, `MessageDraft`, `TypingIndicator`
- **Group Management**: `GroupCreationState`, `PotManagement`, `MemberManagementState`
- **User Profile**: `ProfileEditState`, `Achievement`, `VerificationStatus`, `ProfilePreferences`
- **Authentication**: `AuthState`, `LoginRequest`, `SignUpRequest`, `Session`
- **Settings**: `AppPreferences`, `NotificationSettings`, `PrivacySettings`

#### 1.7 Authentication Feature Requirements
- **MUST**: Implement complete authentication system from scratch
- **MUST**: Support user login with email/password
- **MUST**: Support user signup with validation
- **MUST**: Implement session management and token handling
- **MUST**: Add password recovery functionality
- **MUST**: Support social login options (Google, Apple, Facebook)
- **MUST**: Include authentication state management (using AuthState model in feature domain)
- **MUST**: Implement user logout and session cleanup
- **MUST**: Add authentication guards for protected features
- **MUST**: Handle authentication errors gracefully
- **MUST**: Use shared User model for identity (no separate authentication data layer)
- **MUST**: Authentication feature contains domain + data + presentation layers

#### 1.8 User Profile Feature Requirements (Updated)
- **MUST**: Include points system integration within user profile
- **MUST**: Include premium subscription management within user profile
- **MUST**: Support user economics and transaction history
- **MUST**: Handle profile editing and validation
- **MUST**: Support photo management and avatar updates
- **MUST**: Include user preferences and privacy settings
- **MUST**: Display user achievements and badges
- **MUST**: Support user verification and reputation display

#### 1.9 Group Management Feature Requirements (Updated)
- **MUST**: Preserve group creation workflow
- **MUST**: Maintain member management functionality
- **MUST**: Support group settings and privacy controls
- **MUST**: Preserve group info display
- **MUST**: Include group pot management and tracking
- **MUST**: Support group join costs and payment processing
- **MUST**: Handle multi-user pot contributions within group context
- **MUST**: Track pot transaction history and balances for groups
- **MUST**: Implement pot withdrawal and distribution logic
- **MUST**: Support different currencies (points, real money) for groups
- **MUST**: Handle pot-related error states and validation

#### 1.10 Dependency Injection
- **MUST**: Implement dependency injection container (GetIt recommended)
- **MUST**: Register all repositories, use cases, and services
- **MUST**: Enable easy switching between mock and real implementations
- **MUST**: Eliminate manual instantiation throughout the app

### 2. Non-Functional Requirements

#### 2.1 Code Quality & Safety
- **MUST**: Zero breaking changes during migration
- **MUST**: Maintain existing UI/UX and dark theme
- **MUST**: Preserve app performance characteristics
- **MUST**: Ensure backward compatibility during transition
- **MUST**: Follow existing code quality standards

#### 2.2 Architecture Compliance
- **MUST**: Complete separation of concerns across all layers
- **MUST**: Proper dependency direction (outer to inner layers only)
- **MUST**: Zero circular dependencies
- **MUST**: Domain layer must not depend on any other layer
- **MUST**: Data layer must not depend on presentation layer

#### 2.3 Maintainability
- **MUST**: Reduce file complexity to <300 lines per file
- **MUST**: Create reusable components in shared/ui_kit/
- **MUST**: Implement proper error handling throughout
- **MUST**: Use consistent naming conventions and patterns

#### 2.4 Performance
- **MUST**: Maintain current app startup time
- **MUST**: Preserve smooth scrolling and animations
- **MUST**: No memory leaks or improper disposal
- **MUST**: Efficient state management subscriptions

### 3. Technical Requirements

#### 3.1 Dependencies
- **MUST**: Add flutter_riverpod for state management
- **MUST**: Add get_it for dependency injection
- **MUST**: Add freezed for immutable models
- **MUST**: Add json_annotation for serialization
- **MUST**: Add dio for future API integration

#### 3.2 Model Transformation
- **MUST**: Convert existing models to use freezed for immutability
- **MUST**: Implement JSON serialization for all data models
- **MUST**: Create proper DTO ↔ Model mapping
- **MUST**: Handle all model relationships correctly

#### 3.3 Error Handling
- **MUST**: Create custom exception classes
- **MUST**: Implement failure classes for domain layer
- **MUST**: Handle network, local storage, and validation errors
- **MUST**: Provide user-friendly error messages

#### 3.4 Navigation
- **MUST**: Implement type-safe navigation
- **MUST**: Create route definitions in core/routes/
- **MUST**: Handle deep linking appropriately
- **MUST**: Maintain existing navigation flow

### 4. Feature-Specific Requirements

#### 4.1 Feed Feature
- **MUST**: Preserve group filtering by interests, languages, location
- **MUST**: Maintain search functionality
- **MUST**: Support pagination and lazy loading
- **MUST**: Preserve existing UI components and interactions

#### 4.2 Discovery Feature
- **MUST**: Maintain location-based user discovery
- **MUST**: Preserve map integration functionality
- **MUST**: Support GPS location services
- **MUST**: Maintain distance calculations and display

#### 4.3 Messaging Feature
- **MUST**: Preserve real-time chat functionality
- **MUST**: Maintain conversation management
- **MUST**: Support different message types (text, system, images)
- **MUST**: Preserve unread message tracking

#### 4.4 Group Management Feature
- **MUST**: Preserve group creation workflow
- **MUST**: Maintain member management functionality
- **MUST**: Support group settings and privacy controls
- **MUST**: Preserve group info display

#### 4.5 User Profile Feature (Updated)
- **MUST**: Maintain comprehensive profile management
- **MUST**: Preserve premium features and subscription system within profile
- **MUST**: Support points system integration and transaction history
- **MUST**: Support profile editing and validation
- **MUST**: Maintain privacy settings
- **MUST**: Display user achievements and reputation badges
- **MUST**: Support user verification status display

#### 4.6 Authentication Feature (New)
- **MUST**: Implement complete user authentication flow
- **MUST**: Support email/password login and signup
- **MUST**: Implement social login integration (Google, Apple, Facebook)
- **MUST**: Maintain secure session management
- **MUST**: Support password recovery and account verification
- **MUST**: Handle authentication errors gracefully
- **MUST**: Implement authentication guards for protected features
- **MUST**: Support user logout and session cleanup

#### 4.7 Settings Feature
- **MUST**: Preserve all existing settings options
- **MUST**: Maintain settings persistence
- **MUST**: Support app configuration management
- **MUST**: Preserve user preferences
- **MUST**: Include authentication settings (login/logout, password change)

### 5. Acceptance Criteria

#### 5.1 Functional Acceptance
- [ ] All existing core screens work identically after migration
- [ ] Authentication system works correctly (login, signup, logout)
- [ ] Minimal shared data layer properly implemented (User, Group, and entities only)
- [ ] Feature-specific data models properly isolated to respective features
- [ ] No message data inappropriately shared outside messaging feature
- [ ] Authentication uses User model without separate auth data layer
- [ ] State management works correctly across all features
- [ ] Navigation flow remains unchanged
- [ ] All existing user interactions preserved
- [ ] Real-time messaging functionality intact
- [ ] Location services work correctly
- [ ] Group creation and management functions properly (including pots)
- [ ] User profile includes points and premium subscription management
- [ ] Authentication guards protect appropriate features
- [ ] Session management works correctly

#### 5.2 Architecture Acceptance
- [ ] Clean separation of concerns across all layers
- [ ] Proper dependency direction compliance
- [ ] Zero circular dependencies in codebase
- [ ] Dependency injection fully implemented
- [ ] Domain layer completely isolated
- [ ] Data layer properly abstracted
- [ ] Presentation layer depends only on domain layer

#### 5.3 Code Quality Acceptance
- [ ] No static analysis issues or warnings
- [ ] All files under 300 lines of code
- [ ] Consistent naming and structure patterns
- [ ] Proper error handling throughout
- [ ] Comprehensive documentation for complex logic
- [ ] Reusable components properly shared

#### 5.4 Performance Acceptance
- [ ] App startup time maintained or improved
- [ ] Smooth scrolling and animations preserved
- [ ] No memory leaks detected
- [ ] Efficient state management subscriptions
- [ ] Proper widget disposal patterns
- [ ] Responsive design maintained

### 6. Migration Constraints

#### 6.1 Technical Constraints
- **MUST NOT**: Break existing functionality
- **MUST NOT**: Change public APIs during migration
- **MUST NOT**: Remove existing mock data capabilities
- **MUST NOT**: Alter user interface appearance
- **MUST NOT**: Impact current app performance negatively

#### 6.2 Process Constraints
- **MUST**: Migrate incrementally to minimize risk
- **MUST**: Maintain rollback capability during migration
- **MUST**: Test each feature migration before proceeding
- **MUST**: Document all architectural decisions

### 7. Success Metrics

#### 7.1 Code Quality Metrics
- Reduce cyclomatic complexity by 60%
- Achieve 80%+ test coverage
- Eliminate all static analysis issues
- Reduce average file size to <300 lines

#### 7.2 Architecture Metrics
- 100% dependency injection coverage
- Complete separation of concerns
- Zero circular dependencies
- Proper error handling throughout

#### 7.3 Functional Metrics
- All existing features work identically
- No regression in user experience
- Minimal shared data layer properly implemented (User, Group, entities)
- Feature-specific data properly isolated within respective features
- Appropriate data sharing boundaries established
- Clean architecture patterns consistently applied

This migration must preserve the excellent existing functionality while establishing a robust, scalable architecture for future development.