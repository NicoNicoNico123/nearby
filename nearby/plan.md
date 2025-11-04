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

# MVP IMPLEMENTATION (12-Day Timeline)

## Phase 1: Foundation & Theme (Days 1-2)

### Day 1: Project Setup & Architecture
- [ ] Replace default Flutter main.dart with proper app structure
- [ ] Set up feature-based folder structure matching UI screens
- [ ] Create unified dark theme constants (no hard-coded values)
- [ ] Set up logging with `dart:developer` (not print)
- [ ] Configure basic navigation scaffold

### Day 2: Theme & Navigation Foundation
- [ ] Implement complete dark theme across all components
- [ ] Create responsive flex layout utilities (avoid fixed sizes)
- [ ] Set up bottom navigation bar for main screens
- [ ] Implement basic routing between welcome → discover → feed → profile → settings
- [ ] Add navigation flow: discover → group_info_view → messaging

## Phase 2: Core UI Components (Day 3)

### UI Building Blocks
- [ ] Create reusable UI components based on `UI reference/` designs
- [ ] Implement avatar component with placeholder images
- [ ] Create card component for user/group previews
- [ ] Build button components with theme styling
- [ ] Create input field components with validation
- [ ] Implement loading states and empty states
- [ ] Add basic animations and transitions

## Phase 3: Profile Management (Days 4-5)

### Day 4: Profile Creation & Display
- [ ] Build **User Profile** screen (`user_profile/`) from UI reference
- [ ] Implement photo upload with placeholder functionality
- [ ] Create bio input with character limits
- [ ] Add interests selection (up to 5 hashtags)
- [ ] Build intent selection system (dining, romantic, networking, etc.)
- [ ] Implement profile editing interface

### Day 5: Profile Settings & Privacy
- [ ] Build **Settings** screen (`settings/`) from UI reference
- [ ] Add availability toggle functionality
- [ ] Implement basic privacy controls
- [ ] Create profile visibility settings
- [ ] Add basic report/block UI buttons (actions logged locally)
- [ ] Implement profile photo management

## Phase 4: Discovery Feed (Days 6-7)

### Day 6: Discovery Interface
- [ ] Build **Discover Page** (`discover_page/`) from UI reference
- [ ] Implement location permission in onboarding flow
- [ ] Create user cards with distance ranges (not exact location)
- [ ] Add availability status indicators
- [ ] Build filtering by intent system
- [ ] Implement basic search functionality

### Day 7: Feed Implementation
- [ ] Build **Feed Interface** (`feed/`) from UI reference
- [ ] Create scrollable user feed with mock data
- [ ] Implement pull-to-refresh functionality
- [ ] Add infinite scroll loading
- [ ] Create user detail modal/view
- [ ] Implement basic sorting options

## Phase 5: Simplified Groups (Days 8-9) - No Points System

### Day 8: Group Creation
- [ ] Build **Group Info View** (`group_info_view/`) from UI reference
- [ ] Implement simplified group creation (title, meal time, venue, intent)
- [ ] Add group size limits (2-10 attendees)
- [ ] Create group join interface
- [ ] Implement basic member management UI
- [ ] Add group editing capabilities

### Day 9: Group Management
- [ ] Implement waiting list system (FIFO)
- [ ] Add group approval system for creators
- [ ] Create group member list interface
- [ ] Implement group info editing
- [ ] Add group status indicators
- [ ] Create group deletion/cancellation flow

## Phase 6: Basic Chat (Day 10) - No Typing Indicators Initially

### Chat Interface
- [ ] Build **Messaging Interface** (`messaging/`) from UI reference
- [ ] Implement basic message exchange UI
- [ ] Create message input field with send button
- [ ] Add message history display
- [ ] Implement basic message timestamps
- [ ] Create chat room list interface
- [ ] Add message read receipt UI (basic implementation)

## Phase 7: Mock Data Integration (Days 11-12)

### Day 11: Mock Data Service Layer
- [ ] Create mock data service for all screens
- [ ] Generate realistic user profiles with photos, bios, interests
- [ ] Create sample groups with various intents and sizes
- [ ] Generate mock chat messages with realistic content
- [ ] Implement location-based mock user generation
- [ ] Add data persistence across app sessions

### Day 12: Integration & Polish
- [ ] Integrate mock data with all UI screens
- [ ] Test complete user flows: onboarding → discover → join group → chat
- [ ] Fix UI inconsistencies and polish animations
- [ ] Ensure dark theme consistency across all screens
- [ ] Test responsive design on different screen sizes
- [ ] Final testing and bug fixes

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

## Timeline Summary

**MVP (UI-First)**: 12 working days
- Phase 1: Foundation & Theme (Days 1-2)
- Phase 2: Core UI Components (Day 3)
- Phase 3: Profile Management (Days 4-5)
- Phase 4: Discovery Feed (Days 6-7)
- Phase 5: Simplified Groups (Days 8-9)
- Phase 6: Basic Chat (Day 10)
- Phase 7: Mock Data Integration (Days 11-12)

**Post-MVP Features**: Additional phases as needed based on user feedback and business priorities

## Key MVP Decisions
- **No points system** in MVP - focus on core social functionality
- **No real-time features** like typing indicators - basic chat only
- **Mock data service** - no backend integration for MVP
- **Basic safety UI** - report/block buttons that log actions
- **Location permission** handled in onboarding flow
- **Availability toggle** for user discovery control