## Nearby Dining – Product Spec

### 1) Overview
- Simple, HeyMandi-like app to connect nearby people for dining.
- Clean, modern feed and minimal interactions to reduce friction.

### 2) Objectives
- Use dinner/meals as a natural way to connect nearby people for various purposes.
- Support multiple goals: dining partners, romantic connections, shared interests, networking.
- Make discovery fast: scan feeds, tap to view/join, chat, and meet.

### 3) Users & Context
- People looking to meet nearby specifically for dining (meals, coffee, casual bites).
- Real‑world, short meetups centered around sharing a meal; location-enabled and time-bound.

### 4) Core Use Cases
- Discover nearby people and groups by intent (interest/netflix and chill/study/new friends).
- Join or create dining groups; coordinate and meet.
- Chat to coordinate logistics.
- Manage profile, availability, privacy, and simple preferences.

### 5) Primary Flows
1) Onboard → allow location → set profile → browse nearby feeds → join group → group chat → meet.
2) Return → toggle availability → browse nearby/matches → continue chats → meet.
3) Edit profile → update photos/bio/intent → save.
4) Create group → set title/meal time/venue/intent → publish → wait for users to join → group chat → meet.
5) Manage group (creator) → edit info (title/description/time/venue/intent) → approve/remove members (optional) → close group.

### 6) Core Features (MVP)
- Location-based feed: distance range, availability, brief bio, photo.
- Real-time group chat: typing indicator + basic delivered/read.
- Profile basics: photos, short bio, lightweight intent, interests with hashtag (up to 5).
- Safety: report/block; conservative defaults for sensitive info.

#### 6.1 Groups – Points & Rules
- Creator sets join cost in points for each group, those cost in point would send to Group Pot (escrow).
- Example: join = 50 pts (configurable by creator).
- Create group: costs 100 pts (premium creators get 10 pts discount); 50 pts are sent to the Group Pot (escrow) as the initial stake.
- Group size limit: creator sets maximum number of attendees from 2-10.
- Join approval: creator can require manual approval for join requests (on/off).
- Waiting list: when full, users can join a FIFO waiting list; creator can auto-fill from the list when spots open.
- Edit group info fee: changing title/description/time/venue/intent costs 20 pts per change.
- Early leave policy: if a user leaves more than 24 hours before start, they retrieve 80% of their join fee from the pot (20% stays in pot).
- Late leave / within 24 hours: 0% returned; full amount remains in the pot.
- No‑show (user): 0% returned; full amount remains in the pot.
- Joiners may gain points based on creator’s rules (e.g., attendance/punctuality bonus).
- Zero‑pot groups: if the creator sets join cost = 0 pts (pot = 0), there is no points penalty for users who no‑show or leave at any time; pot sharing yields 0 unless platform bonuses apply.
- Creator-only cancellation: if only the creator remains in the group, the dining event can be cancelled and the creator’s create fee is refunded (50pts); this refund is processed outside the Group Pot would be send to platform.
- Report (creator no-show): if ≥ 50% of confirmed attendees report within 24 hours, creator is penalized (points deduction + strike); repeated offenses can trigger suspension.

#### 6.2 Free/Premium & Superlike
- Free users:
  - Join up to 5 groups total (join count tracked).
  - Create up to 2 groups.
- Premium users:
  - 5 group creation.
  - 10 pts discount on create group fee.
- Superlike:
  - Users can manually give points directly to the group creator to request joining(user can manually enter pts).
  - creator may accept to bypass normal queue/approval.

### 7) Look & Feel
- Clean, airy, modern; inspired by HeyMandi simplicity.
- Light/Dark themes; subtle motion on transitions and match moments.
- Large touch targets; clear hierarchy; responsive layouts including web.

### 8) Interaction Principles
- One clear primary action per screen; secondary actions are secondary.
- Minimize typing with chips/toggles/prefills.
- Fast path: scan → join → chat → meet.
- Respectful defaults: opt-in discovery; easy availability control.

### 9) Safety & Privacy
- Report/block accessible from profile and chat.
- Hide exact distance; show ranges.
- Clear privacy controls; data export/delete entry points.

### 10) Attendance & Points Settlement (Concise Model)
- Group Pot (escrow): holds all join fees; distributed after event completion.
- QR check-in (proof of attendance):
  - At start time, creator displays one-time QR; attendees scan within a limited window (e.g., 90 minutes).
  - Server marks users as Attended upon successful scan.
- Pot adjustments before sharing:
  - Early leaves (>24h): refund 80% back to the user from the pot; remaining 20% stays in the pot.
  - Late leaves (≤24h) and no-shows: 0% returned; full amount stays in the pot.
- Payout scenarios (share after adjustments):
  - Everyone who remains attends: the entire remaining pot is shared between creator and all checked-in attendees.
  - User no-show: the no-show’s join fee stays in the pot; remaining pot is shared among creator and checked-in attendees.
  - Creator no-show: if ≥ 50% attendees report within 24h, creator is penalized (strike + loses create fee); attendees share the remaining pot among themselves.
- Zero‑pot note: when join cost = 0 pts (pot = 0), there are no point penalties for user no‑shows or leaves, and there is nothing to share unless the platform funds a bonus.
- Cancellation with no joiners: if the group has only the creator, cancellation refunds the creator’s create fee directly (outside the Group Pot).

### 11) Defaults (suggested; configurable later)
- Default join fee options: 20 pts (creator chooses per group).
- Default sharing split when event completes: split equally among attendees (adjustable by platform later).
- No-show thresholds: 3 creator strikes → temporary suspension.

### 12) Notes
- Keep UI minimal, friendly, and fast—take inspiration from the reference image.
- Start with static reference JPGs for layout; wire real data after.

### 13) Upcoming functions
- polls in group, layout style, photos request with pts, spoils photos in group, photos burn after view, each functions cost pts, watch ads for pts

## UI/UX

### Mobile Layout Guidelines

- The mobile layout should closely reference the "nearby/UI reference folder" design as the primary source of truth for visual structure, spacing, and interaction patterns.
- Use the reference screens to inform:
  - Navigation placement and hierarchy.
  - Safe area padding and margins.
  - Sizing and arrangement of key elements, such as cards, buttons, lists, and avatars.
  - Font sizes, spacing, and visual cues for status or availability.
- Match the airy, modern style seen in the UI reference, ensuring touch targets are large and easily accessible with one hand.
- Prioritize clear and consistent use of themed colors, typography, and iconography as specified in the UI reference.
- Make sure interactive elements are placed consistently according to the design guideline; refer to the reference images for examples.
- For any ambiguity, refer back to the provided nearby/UI reference rather than improvising new layout or visual solutions.
- Ensure responsiveness for all display sizes by adapting the structure shown in the UI reference with flexible layouts and constrained components for smaller and larger devices.



## Other Requirement

### Theming 

The app must use a unified dark theme across all screens and components.

All color values, font families, font sizes, border radii, and spacing must be declared once at the top level (e.g., in the MaterialApp theme property or a central constants file). Hard-coding style values inside widgets is strictly prohibited.

Colors and styles should be referenced using named constants or from the theme, not with literal values.

Any new UI component must inherit its color, font, and spacing from the global theme/context.

Responsive design must be supported: Avoid fixed widths/heights; use flex or constraints that support multiple device sizes and orientations.

Changes to the theme should update all components consistently, without requiring manual edits to individual widgets or screens.

Theming-related code should be easy to review, refactor, and document; use descriptive variable names for color, typography, and dimension constants.

### Code Style
Ensure proper separation of concerns by creating a suitable folder structure.

Prefer small composable widgets over large ones.

Prefer using flex values over hardcoded sizes when creating widgets inside rows/columns, ensuring the UI adapts to various screen sizes.

Use log from dart:developer rather than print or debugPrint for logging.

