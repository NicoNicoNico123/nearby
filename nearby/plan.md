# Nearby App Development Plan - UI-First MVP

## Project Overview
This plan outlines a UI-first MVP approach for the Nearby social dining app, a HeyMandi-inspired Flutter application. The focus is on building core UI screens and user experience first, with backend complexity deferred to post-MVP.

## UI Reference Screens Structure
The app will be built around these core UI screens (based on `UI reference/` directory):
- **welcome/** - Onboarding and app introduction
- **discover_page/** - Location-based discovery feed
- **feed/** - Main content feed interface
- **group_info_view/** - Group details and management
- **messaging/** - Real-time chat interface
- **settings/** - User settings and preferences
- **user_profile/** - Profile management and editing

---

# MVP IMPLEMENTATION - STEP-BY-STEP APPROACH

## Step 1: Project Foundation & Architecture ✅ COMPLETED
1. **Setup Flutter Project Structure** ✅
   - ✅ Replace default Flutter main.dart with proper app structure
   - ✅ Set up feature-based folder structure matching UI screens:
     ```
     lib/
     ├── main.dart
     ├── main_navigation.dart
     ├── screens/
     │   ├── welcome/
     │   ├── discover_page/
     │   ├── feed/
     │   ├── group_info_view/
     │   ├── messaging/
     │   ├── settings/
     │   └── user_profile/
     ├── widgets/ (shared UI components)
     ├── models/ (data models)
     ├── services/ (mock data services)
     ├── theme/ (dark theme constants)
     └── utils/ (helpers and utilities)
     ```

2. **Implement Unified Dark Theme** ✅
   - ✅ Create theme constants file with all colors, fonts, spacing
   - ✅ Implement complete dark theme across all components
   - ✅ Ensure no hard-coded style values anywhere in the app
   - ✅ Use flex layouts for responsive design (avoid fixed sizes)

3. **Setup Navigation & Routing** ✅
   - ✅ Configure basic navigation scaffold
   - ✅ Set up bottom navigation bar for main screens
   - ✅ Implement routing between: welcome → discover → feed → profile → settings
   - ✅ Add navigation flow: discover → group_info_view → messaging

## Step 2: Core UI Components Development ✅ COMPLETED
1. **Create Reusable UI Components** ✅
   - ✅ Avatar component with placeholder images (UserAvatar)
   - ✅ Card component for user/group previews (UserCard, GroupCard)
   - ✅ Button components with theme styling (integrated in AppTheme)
   - ✅ Input field components with validation (integrated in AppTheme)
   - ✅ Loading states and empty states (LoadingSpinner, EmptyState)
   - ⏳ Basic animations and transitions

2. **Setup Logging & Utilities** ✅
   - ✅ Configure logging with `dart:developer` (not print statements)
   - ✅ Create utility functions for common operations (NavigationService)
   - ✅ Set up error handling and validation utilities (Logger)

## Step 3: Welcome & Onboarding Screens ✅ COMPLETED
1. **Build Welcome Screen** (`welcome/`) ✅
   - ✅ Create onboarding flow from UI reference
   - ⏳ Implement location permission request
   - ✅ Add app introduction and feature highlights
   - ✅ Create call-to-action for profile setup

## Step 4: User Profile Management ⏳ PENDING
1. **Build User Profile Screen** (`user_profile/`) ⏳
   - ⏳ Implement photo upload with placeholder functionality
   - ⏳ Create bio input with character limits
   - ⏳ Add interests selection (up to 5 hashtags)
   - ⏳ Build intent selection system (dining, romantic, networking, etc.)
   - ⏳ Implement profile editing interface

2. **Build Settings Screen** (`settings/`) ⏳
   - ⏳ Add availability toggle functionality
   - ⏳ Implement basic privacy controls
   - ⏳ Create profile visibility settings
   - ⏳ Add basic report/block UI buttons (actions logged locally)
   - ⏳ Implement profile photo management

## Step 5: Discovery & Feed Implementation 🔄 IN PROGRESS
1. **Build Discover Page** (`discover_page/`) ✅
   - ✅ Create location-based discovery feed
   - ✅ Implement group discovery with horizontal and grid layouts
   - ✅ Add group cards with images, descriptions, and interest tags
   - ✅ Build filtering by interests system (Music, Art, Gaming, etc.)
   - ✅ Implement search functionality for groups
   - ✅ Add like and superlike functionality for groups
   - ✅ Fix RenderFlex overflow issues and proper layout constraints

2. **Build Feed Interface** (`feed/`) ✅
   - ✅ Create scrollable user feed with mock data integration
   - ✅ Implement user cards with photos, bios, and interests
   - ✅ Add pull-to-refresh functionality
   - ⏳ Add infinite scroll loading
   - ⏳ Create user detail modal/view
   - ⏳ Implement basic sorting options

## Step 6: Group Management System ⏳ PENDING
1. **Build Group Info View** (`group_info_view/`) ⏳
   - ⏳ Implement simplified group creation (title, meal time, venue, intent)
   - ⏳ Add group size limits (2-10 attendees)
   - ⏳ Create group join interface
   - ⏳ Implement basic member management UI
   - ⏳ Add group editing capabilities

2. **Group Management Features** ⏳
   - ⏳ Implement waiting list system (FIFO)
   - ⏳ Add group approval system for creators
   - ⏳ Create group member list interface
   - ⏳ Implement group info editing
   - ⏳ Add group status indicators
   - ⏳ Create group deletion/cancellation flow

## Step 7: Messaging System ⏳ PENDING
1. **Build Messaging Interface** (`messaging/`) ⏳
   - ⏳ Implement basic message exchange UI
   - ⏳ Create message input field with send button
   - ⏳ Add message history display
   - ⏳ Implement basic message timestamps
   - ⏳ Create chat room list interface
   - ⏳ Add message read receipt UI (basic implementation)

## Step 8: Mock Data Service Layer
1. **Create Mock Data Service**
   - Build service layer for all screens
   - Generate realistic user profiles with photos, bios, interests
   - Create sample groups with various intents and sizes
   - Generate mock chat messages with realistic content
   - Implement location-based mock user generation
   - Add data persistence across app sessions

## Step 9: Integration & Polish
1. **Integrate Mock Data with UI**
   - Connect all screens to mock data service
   - Test complete user flows: onboarding → discover → join group → chat
   - Ensure data consistency across screens

2. **UI Polish & Refinement**
   - Fix UI inconsistencies and polish animations
   - Ensure dark theme consistency across all screens
   - Test responsive design on different screen sizes
   - Final testing and bug fixes

---

# CURRENT PROGRESS SUMMARY

## ✅ Completed (Step 1-3: Foundation & Welcome)
- **Project Architecture**: Complete folder structure, main.dart refactored
- **Dark Theme System**: Comprehensive AppTheme with unified styling
- **Navigation System**: MainNavigation with bottom nav and welcome flow
- **Logging System**: Professional Logger using dart:developer
- **Basic Screens**: Welcome screen complete, placeholder screens created
- **Utilities**: NavigationService for global navigation management

## ✅ Completed (Step 1-3: Foundation & Welcome)
- **Project Architecture**: Complete folder structure, main.dart refactored
- **Dark Theme System**: Comprehensive AppTheme with unified styling
- **Navigation System**: MainNavigation with bottom nav and welcome flow
- **Logging System**: Professional Logger using dart:developer
- **Basic Screens**: Welcome screen complete, placeholder screens created
- **Utilities**: NavigationService for global navigation management

## ✅ Completed (Step 2: UI Components)
- **Theme Integration**: Button and input field styling complete
- **Core Components**: Avatar, UserCard, GroupCard, LoadingSpinner, EmptyState complete
- **Missing**: Basic animations and transitions

## 🔄 In Progress (Step 5: Discovery & Feed)
- **Discover Page**: Complete group discovery with horizontal and grid layouts
- **Feed Interface**: User cards with mock data integration complete
- **Missing**: Infinite scroll, user detail modals, advanced sorting

## ⏳ Pending (Steps 4,6-9)
- User Profile Management
- Group Management System
- Messaging System
- Mock Data Service Layer
- Integration & Polish

## 📊 Completion Status: ~50%
- Foundation: 100% ✅
- UI Components: 90% ✅
- Screens Implementation: 40% 🔄
- Mock Data & Integration: 10% ⏳

---

# POST-MVP FEATURES (Deferred)

## Phase 8: Points Economy System (Post-MVP)
- [ ] Points foundation with balance tracking
- [ ] Group creation fee (100 pts) and join costs
- [ ] Group Pot escrow system
- [ ] Points settlement and refund logic
- [ ] Superlike and bypass system
- [ ] Premium tier benefits

## Phase 9: User Tiers & Limits (Post-MVP)
- [ ] Free tier limits (5 joins, 2 creations)
- [ ] Premium subscription system
- [ ] Usage tracking and upgrade prompts
- [ ] Tier-specific features and benefits

## Phase 10: QR Check-in & Attendance (Post-MVP)
- [ ] QR code generation for creators
- [ ] QR scanning for attendees
- [ ] 90-minute check-in window
- [ ] Attendance verification system
- [ ] Pot distribution based on attendance

## Phase 11: Advanced Safety Features (Post-MVP)
- [ ] Full report/block system with backend integration
- [ ] Strike system for policy violations
- [ ] Creator no-show reporting
- [ ] Automated content moderation
- [ ] Advanced privacy controls

## Phase 12: Enhanced Features (Post-MVP)
- [ ] Group polls and voting
- [ ] Photo request system with points
- [ ] Burn-after-view photos
- [ ] Push notifications
- [ ] Offline support
- [ ] Advanced filtering and recommendations

---

# DEVELOPMENT REQUIREMENTS

## Code Standards (Strict)
- **Dark Theme Only**: All screens must use unified dark theme
- **No Hard-coded Values**: All colors, fonts, spacing from theme constants
- **Responsive Design**: Use flex layouts, avoid fixed widths/heights
- **Small Widgets**: Prefer composable widgets over large monolithic ones
- **Proper Logging**: Use `dart:developer` for logging, not `print` statements

## MVP Success Criteria
- All 7 UI reference screens implemented and functional
- Complete user flow from onboarding to group chat
- Mock data integration demonstrating full app experience
- Clean, HeyMandi-inspired interface with minimal friction
- Responsive design across all device sizes
- Basic safety UI elements (report/block buttons)

## Testing Strategy (Simplified for MVP)
- [ ] Basic UI validation for all screens
- [ ] User flow testing with mock data
- [ ] Responsive design testing on multiple screen sizes
- [ ] Theme consistency validation
- [ ] Navigation flow testing

## Implementation Summary

**MVP (UI-First)**: 9 implementation steps
1. **Project Foundation & Architecture** - Setup, theme, navigation
2. **Core UI Components Development** - Reusable widgets and utilities
3. **Welcome & Onboarding Screens** - First user experience
4. **User Profile Management** - Profile creation and settings
5. **Discovery & Feed Implementation** - Location-based discovery
6. **Group Management System** - Create and manage dining groups
7. **Messaging System** - Basic chat functionality
8. **Mock Data Service Layer** - Realistic data for demonstration
9. **Integration & Polish** - Complete user experience testing

**Post-MVP Features**: Additional phases as needed based on user feedback and business priorities

## Key MVP Decisions
- **No points system** in MVP - focus on core social functionality
- **No real-time features** like typing indicators - basic chat only
- **Mock data service** - no backend integration for MVP
- **Basic safety UI** - report/block buttons that log actions
- **Location permission** handled in onboarding flow
- **Availability toggle** for user discovery control