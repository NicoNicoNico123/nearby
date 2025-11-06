# UI Enhancement Execute Plan
**Based on adjustment.md feedback**

## Overview
This plan outlines the UI enhancements needed across multiple screens to improve user experience, add functionality, and align visual design throughout the app.

---

## Priority 1: Core Functionality (High Impact)

### 1. Feed Screen - Maps Integration & Filter Enhancement ✅ **COMPLETED**
**File:** `lib/screens/feed/feed_screen.dart`

#### Task 1.1: Venue Location Maps Integration ✅ **COMPLETED**
**Subtasks:**
- [x] Create venue location tap detection in group cards
- [x] Implement platform detection (iOS/Android) for map selection
- [x] Create map popup dialog with venue location (`widgets/map_popup_dialog.dart`)
- [x] Add Google Maps integration for Android
- [x] Add Apple Maps integration for iOS
- [x] Handle map app launching with venue coordinates
- [x] Add fallback for web platform (web maps)
- [x] Add simulator/emulator detection for robust functionality

**Completed Files:**
- `lib/services/map_service.dart` - Complete map service with platform detection
- `lib/widgets/map_popup_dialog.dart` - Platform-aware map dialog
- `lib/models/group_model.dart` - Added coordinate support
- `pubspec.yaml` - Added map_launcher dependency

**Estimated Complexity:** Medium → **COMPLETED**
**Dependencies:** Map service packages (google_maps_flutter, map_launcher) → **RESOLVED**

#### Task 1.2: Enhanced Filter System ✅ **COMPLETED**
**Subtasks:**
- [x] Remove refresh button from top-right corner
- [x] Replace with enhanced filter icon (more visible)
- [x] Create comprehensive filter screen (`screens/feed/filter_screen.dart`)
- [x] Implement filter options:
  - [x] Interest multi-select with chips
  - [x] ~~Intent selection dropdown~~ **REMOVED** - Intent field removed from data model
  - [x] Distance slider/radius selector
  - [x] Age range selector (15-20, 20-30, 30-40, 40+)
  - [x] Language multi-select
  - [x] Gender selection filter
- [x] Add filter state management
- [x] Implement filter persistence
- [x] Add clear filters functionality
- [x] Update MockDataService to support filtering
- [x] **Remove intent field entirely** from data model and all related components

**Completed Features:**
- Full filter screen with all requested options
- Filter state persistence across app sessions
- Real-time filter application with proper data service integration
- Clean UI with proper dark theme support

**Estimated Complexity:** High → **COMPLETED**
**Dependencies:** New filter screen, data service updates → **RESOLVED**

---

### 2. Group Details Screen - Member Management & Host Controls
**File:** `lib/screens/group_info_view/group_info_screen.dart`

#### Task 2.1: Maps Integration for Venue
**Subtasks:**
- [ ] Reuse maps integration from feed screen
- [ ] Add tap gesture to venue location text
- [ ] Launch maps with group venue coordinates

**Estimated Complexity:** Low
**Dependencies:** Task 1.1 completion

#### Task 2.2: Dynamic Action Button Management
**Subtasks:**
- [ ] Check user's group membership status
- [ ] Hide like/superlike/waiting list buttons when user is member
- [ ] Show alternative actions for members (Leave Group, View Chat)
- [ ] Update UI state based on membership changes

**Estimated Complexity:** Medium
**Dependencies:** Group model updates for membership tracking

#### Task 2.3: Host Editing Functionality with Cost System
**Subtasks:**
- [ ] Detect if current user is group creator
- [ ] Create edit mode toggle for hosts
- [ ] Implement inline editing for:
  - [ ] Title (free to edit)
  - [ ] Description (free to edit)
  - [ ] ~~Intent (free to edit)~~ **REMOVED** - Intent field removed from data model
  - [ ] Interests (free to edit)
  - [ ] Meal Time (50 pts cost)
  - [ ] Venue (50 pts cost)
- [ ] **Create comprehensive cost confirmation popup** (`widgets/edit_cost_popup.dart`)
  - [ ] Design popup with cost breakdown
  - [ ] Show current user points balance
  - [ ] Display specific edit cost (50 pts per change)
  - [ ] Add confirmation checkbox for understanding costs
  - [ ] Show what will be edited and new values
  - [ ] Add "Confirm Edit" and "Cancel" buttons
  - [ ] Include "Why this costs points?" explanation
- [ ] Integrate with points system (deduct 50 pts)
- [ ] Add insufficient points handling with upgrade prompt
- [ ] Add edit history/log for transparency
- [ ] Update group data after edits
- [ ] Show success confirmation after edit

**Estimated Complexity:** High
**Dependencies:** Points system integration, group model updates, user balance tracking

#### Task 2.4: Member Profile Popup System
**Subtasks:**
- [ ] Create member profile popup widget (`widgets/member_profile_popup.dart`)
- [ ] Add tap gesture to member list items
- [ ] Design profile card with:
  - [ ] Age range display
  - [ ] Gender with icons
  - [ ] Bio text
  - [ ] Profile image(s) with swipe navigation
  - [ ] Interests tags
  - [ ] Language preferences
  - [ ] Other profile fields (Work, Education, etc.)
- [ ] Implement image swiping (0-5 images)
- [ ] Add image zoom functionality
- [ ] Create smooth popup animations
- [ ] Add close/dismiss gestures

**Estimated Complexity:** High
**Dependencies:** User model expansion, image handling

---

## Priority 2: Navigation & Group Creation (High Impact)

### 3. Dedicated Create Group Screen
**File:** `lib/screens/create_group/create_group_screen.dart`
**UI Reference:** `/UI reference/feed/home_3/code.html`

#### Task 3.1: Complete Group Creation Interface (Based on UI Reference)
**Subtasks:**
- [ ] **Create new dedicated screen** for group creation (separate from group_info_view)
- [ ] **Implement header with close button and Post button** matching UI reference
- [ ] **Use single-page layout** (not multi-step) as shown in UI design
- [ ] **Required Settings Section** (white card container):
  - [ ] Group description textarea with placeholder "Write an engaging description to attract participants..."
  - [ ] Restaurant location input with chevron_right icon and restaurant icon
  - [ ] Date input with calendar_today icon and chevron_right
  - [ ] Time input with schedule icon and chevron_right
  - [ ] People limit with +/- buttons (showing number 4, styled with primary color for +,minium is 2 up to 8)
- [ ] **Optional Settings Section**:
  - [ ] Optional details textarea with placeholder "Add further details about the group (optional)..."
  - [ ] **Image Upload Section**:
    - [ ] Drag & drop area with "Upload an image" text
    - [ ] add_photo_alternate icon (3xl size)
    - [ ] File format validation (PNG, JPG MAX. 5MB)
    - [ ] Image preview after upload
  - [ ] **Toggle Settings** (in same container):
    - [ ] "Approved by Creator" toggle switch
    - [ ] "Allow Waiting List" toggle switch
  - [ ] **Gender Setting**:
    - [ ] Show current selection ("Any")
    - [ ] Three buttons: Male, Female, Any (with "Any" selected as primary)
    - [ ] Button styling: gray-200 for unselected, primary for selected
  - [ ] **Age Range**:
    - [ ] Show current range ("18 - 35")
    - [ ] Dual-handle slider (styled as in UI with primary color)
    - [ ] Range labels and visual indicators
  - [ ] ~~**Intent section**~~:
    - [ ] ~~Interest field that show text with up to 1 - 3 words~~ **REMOVED** - Intent field removed from data model
  - [ ] **Interests Section**:
    - [ ] "Add Interests" button
    - [ ] Interest tags with close buttons (Travel, Movie, Food shown)
    - [ ] Tag styling: primary/10 background with primary text
- [ ] **Form Validation**:
  - [ ] Description required (minimum characters)
  - [ ] Location, date, time required
  - [ ] People limit minimum 2, maximum 20
- [ ] **Post Button**:
  - [ ] Enable only when required fields filled
  - [ ] Show creation cost (100 pts)
  - [ ] Confirmation dialog before posting
- [ ] **Styling Consistency**:
  - [ ] Use Material Symbols icons throughout
  - [ ] Implement dark theme support (white/5 background for cards)
  - [ ] Use primary color (#5b13ec) consistently
  - [ ] Rounded corners (rounded-lg) matching UI reference

**Estimated Complexity:** High
**Dependencies:** MockDataService integration, image picker, form validation

#### Task 3.2: Flutter Widget Implementation Based on HTML Structure
**Subtasks:**
- [ ] **Create header widget** with close button (material-symbols-outlined: close) and Post button
- [ ] **Implement description textarea widget** with description icon and proper placeholder
- [ ] **Create input field widgets** for location, date, time with:
  - [ ] Material Symbols icons (restaurant, calendar_today, schedule)
  - [ ] chevron_right navigation icons
  - [ ] Proper dark theme styling
- [ ] **Build people limit widget** with:
  - [ ] group icon
  - [ ] Minus button (gray-200 styling)
  - [ ] Number display (centered, w-8)
  - [ ] Plus button (primary color styling)
- [ ] **Create toggle switch widgets** for approval and waiting list settings
- [ ] **Implement gender selection widget** with:
  - [ ] Three option buttons (Male, Female, Any)
  - [ ] Primary color for selected state
  - [ ] Gray background for unselected
- [ ] **Build age range slider widget** with:
  - [ ] Dual-handle implementation
  - [ ] Primary color track
  - [ ] White circle handles with primary border
  - [ ] Range display (18 - 35 format)
- [ ] **Create interests widget** with:
  - [ ] "Add Interests" button
  - [ ] Tag display with close buttons
  - [ ] primary/10 background styling
- [ ] **Implement image upload widget** with:
  - [ ] Drag & drop area
  - [ ] add_photo_alternate icon (3xl)
  - [ ] File validation and preview
- [ ] **Add responsive layout** with proper spacing and containers
- [ ] **Implement dark theme support** matching HTML dark mode styles

**Estimated Complexity:** High
**Dependencies:** Flutter Material Symbols, image picker package

#### Task 3.3: Group Creation UX Enhancements
**Subtasks:**
- [ ] Add helpful tooltips and guidance for each field
- [ ] Implement smart suggestions based on user profile
- [ ] Add group templates (Quick Setup options)
- [ ] Create photo upload for group cover image
- [ ] Add co-host selection from friends list
- [ ] Implement group creation success screen
- [ ] Add share group functionality after creation
- [ ] Create group management quick access

**Estimated Complexity:** Medium
**Dependencies:** Task 3.1 completion

### 4. Navigation Bar Enhancement
**File:** `lib/main_navigation.dart`

#### Task 4.1: Add Group Creation Button
**Subtasks:**
- [ ] Design eye-catching circular '+' button
- [ ] Position floating action button appropriately (bottom-right)
- [ ] Add navigation to new dedicated create group screen
- [ ] Implement proper animations and shadows
- [ ] Handle button visibility on different screens (hide on create group screen)
- [ ] Add ripple effect and haptic feedback
- [ ] Create long-press menu with quick options (Quick Create, Templates)
- [ ] Add badge notifications for group creation invites

**Estimated Complexity:** Medium
**Dependencies:** Task 3.1 (Create Group Screen)

---

### 5. Discover Screen Visual Alignment
**File:** `lib/screens/discover_page/discover_screen.dart`

#### Task 5.1: Visual Style Consistency
**Subtasks:**
- [ ] Audit current discover screen components
- [ ] Align button styles with feed screen (circular icons)
- [ ] Update card containers to match feed screen design
- [ ] Standardize spacing and typography
- [ ] Ensure consistent color usage
- [ ] Update icons to match feed screen variants
- [ ] Test responsive design alignment

**Estimated Complexity:** Low
**Dependencies:** Feed screen final design

---

## Priority 3: Profile & Settings Enhancement (Medium Impact)

### 6. Settings Screen Enhancements
**File:** `lib/screens/settings/settings_screen.dart`

#### Task 6.1: User Statistics Display
**Subtasks:**
- [ ] Add "Joined Groups" count display
- [ ] Add user "Points Balance" display
- [ ] Create visually appealing stats cards
- [ ] Update stats in real-time
- [ ] Add refresh functionality for stats

**Estimated Complexity:** Low
**Dependencies:** User data model updates

#### Task 6.2: Premium Subscription Section
**Subtasks:**
- [ ] Design premium upgrade section
- [ ] Create subscription tiers display
- [ ] Add points-based pricing information
- [ ] Implement upgrade button (placeholder for now)
- [ ] Add premium benefits list
- [ ] Create upgrade confirmation dialog

**Estimated Complexity:** Medium
**Dependencies:** Mock subscription data

---

### 7. Profile Screen Field Expansion
**File:** `lib/screens/user_profile/user_profile_screen.dart`

#### Task 7.1: Optional Profile Fields
**Subtasks:**
- [ ] Add new optional fields:
  - [ ] Work (text input)
  - [ ] Education (dropdown/text)
  - [ ] Drinking habits (selector)
  - [ ] Meal interest preferences (multi-select)
  - [ ] Star Sign (dropdown)
- [ ] Update user model with new fields
- [ ] Create edit interfaces for each field
- [ ] Add validation for new fields
- [ ] Update MockDataService with sample data

**Estimated Complexity:** Medium
**Dependencies:** User model expansion

#### Task 7.2: Language Field Enhancement
**Subtasks:**
- [ ] Add language selection as required field
- [ ] Create comprehensive language list
- [ ] Implement multi-language selection
- [ ] Add validation (at least one language required)
- [ ] Update user profile display

**Estimated Complexity:** Medium
**Dependencies:** New language data

#### Task 7.3: Gender Field Iconic Design
**Subtasks:**
- [ ] Redesign gender selection with icons
- [ ] Add Male, Female, LGBT options with appropriate icons
- [ ] Create inclusive and respectful design
- [ ] Update user model gender field
- [ ] Add gender icons to profile display

**Estimated Complexity:** Low
**Dependencies:** Icon assets/design

---

## Implementation Priority Order

### ✅ Phase 1 (Week 1): Core Discovery & Group Management **COMPLETED**
1. ✅ **Feed Screen Filter System** - Essential for user experience **COMPLETED**
2. ⏳ **Dedicated Create Group Screen** - Major feature improvement **NEXT PRIORITY**
3. ✅ **Maps Integration** - Cross-cutting feature used in multiple places **COMPLETED**

### 🔄 Phase 2 (Week 2): Host Controls & Navigation **CURRENT PHASE**
1. **Group Details Maps Integration** (Task 2.1) - Reuse existing map functionality **READY**
2. **Dynamic Action Button Management** (Task 2.2) - Better UX flow **READY**
3. **Host Editing Functionality with Cost System** (Task 2.3) - Power user features
4. **Group Details Member Profiles** (Task 2.4) - High-value social feature
5. **Navigation Bar Enhancement** - Improved accessibility

### ⏭️ Phase 3 (Week 3): Profile, Settings & Polish
1. **Profile Field Expansion** - User personalization
2. **Settings Screen Enhancements** - User metrics
3. **Discover Screen Visual Alignment** - Consistency improvements
4. **Final Polish & Animations** - Complete user experience

---

## Technical Dependencies

### Required Packages
```yaml
dependencies:
  google_maps_flutter: ^2.5.0  # Maps integration
  map_launcher: ^2.5.0        # Launch external maps
  image_picker: ^1.0.4        # For profile images
  cached_network_image: ^3.3.0 # Image caching
  flutter_staggered_animations: ^1.1.1 # Popup animations
```

### Model Updates Required
- **User Model**: Add new profile fields, language, gender icons
- **Group Model**: Add editing history, cost tracking
- **Member Model**: Expand for detailed profile display

### Service Updates Required
- **MockDataService**: Add filtering, new profile data
- **MessagingService**: Member profile data integration
- **Points System**: Integration for edit costs (mock implementation)

---

## Success Metrics

### User Experience Goals
- [x] 50% reduction in taps to find relevant groups (filter system) ✅ **COMPLETED**
- [x] **Removed intent field** - Simplified data model and UI for cleaner user experience ✅ **COMPLETED**
- [ ] 30% increase in group creation (navigation button)
- [ ] Improved member discovery (profile popups)
- [ ] Better host control retention (editing features)

### Technical Goals
- [ ] Consistent visual design across all screens
- [ ] Smooth animations and transitions
- [ ] Responsive design on all device sizes
- [ ] Zero crashes in new features

---

## Testing Strategy

### Unit Tests
- [ ] Filter logic validation
- [ ] Model serialization for new fields
- [ ] Cost calculation for host edits

### Integration Tests
- [ ] Complete filter application flow
- [ ] Member profile popup functionality
- [ ] Maps integration on different platforms

### UI Tests
- [ ] Button interactions and animations
- [ ] Form validation for new fields
- [ ] Responsive design validation

---

## Next Steps

1. **Review and approve this plan** with stakeholders
2. **Set up development environment** with new dependencies
3. **Begin Phase 1 implementation** starting with filter system
4. **Regular progress reviews** after each phase completion
5. **User testing** after Phase 2 for feedback incorporation

**Total Estimated Timeline:** 3 weeks
**Total Complexity:** High (due to multiple new features and integrations)

---

## 🔥 Key Feature Highlights

### Host Edit Cost Popup (`widgets/edit_cost_popup.dart`)
**Purpose:** Transparent cost confirmation for group edits
**Features:**
- Current user points balance display
- Breakdown of edit costs (50 pts per meal time/venue change)
- Before/after comparison of edited values
- Confirmation checkbox for cost understanding
- Insufficient points handling with upgrade prompts
- "Why this costs points?" educational section

### Dedicated Create Group Screen (`screens/create_group/create_group_screen.dart`)
**Purpose:** Single-page group creation matching UI reference design
**UI Reference:** `/UI reference/feed/home_3/code.html`

**Layout Structure:**
- **Header:** Close button + "Create Group" title + Post button
- **Required Settings Section** (white card):
  - Group description textarea
  - Restaurant location input
  - Date & time inputs
  - People limit with +/- buttons
- **Optional Settings Section**:
  - Additional details textarea
  - Image upload area
  - Toggle switches (approval, waiting list)
  - Gender selection buttons
  - Age range dual-slider
  - Interest tags with add/remove

**Key Features:**
- Single-page layout (no multi-step flow)
- Material Symbols icons throughout
- Dark theme support with white/5 backgrounds
- Primary color (#5b13ec) accent styling
- Responsive design matching reference
- Form validation and cost display (100 pts)
- Image upload with validation (PNG/JPG max 5MB)

### Navigation Enhancement
**Purpose:** Prominent group creation access
**Features:**
- Eye-catching circular '+' FAB (Floating Action Button)
- Bottom-right positioning with ripple effects
- Long-press menu with quick options
- Haptic feedback integration
- Context-aware visibility (hidden on create screen)

---

## 📱 Updated Dependencies

### New Required Packages
```yaml
dependencies:
  google_maps_flutter: ^2.5.0      # Maps integration
  map_launcher: ^2.5.0            # Launch external maps
  image_picker: ^1.0.4            # Profile/group images
  cached_network_image: ^3.3.0    # Image caching
  flutter_staggered_animations: ^1.1.1 # Popup animations
  flutter_haptic_feedback: ^0.1.0  # Haptic feedback for FAB
  permission_handler: ^11.0.1     # Location permissions
  geolocator: ^10.1.0             # Location services
```

### Updated Model Requirements
```dart
// Enhanced User Model
class User {
  // Existing fields...
  final int pointsBalance;
  final List<String> languages;
  final String gender; // Updated with iconic options
  final String? work;
  final String? education;
  final String? drinkingHabits;
  final String? mealInterest;
  final String? starSign;
  final List<String> profileImages; // 0-5 images
}

// Enhanced Group Model
class Group {
  // Existing fields...
  final int creatorId;
  final DateTime createdAt;
  final List<EditHistory> editHistory;
  final int groupCreationCost; // 100 pts
  final bool isDraft;
}

// New Edit History Model
class EditHistory {
  final DateTime timestamp;
  final String fieldEdited;
  final String oldValue;
  final String newValue;
  final int cost;
  final int editedByUserId;
}
```