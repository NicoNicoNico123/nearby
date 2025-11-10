# Mock User Scenarios

This document defines three primary user scenarios for testing the Nearby social dining app.

## Scenario 1: Normal User (Basic Experience)

### User Profile
- **Name:** Alex Johnson
- **Age:** 25
- **User Type:** normal
- **Points:** 150
- **Premium Status:** false
- **Verified Status:** false
- **Work:** Marketing Coordinator
- **Education:** Bachelor's Degree
- **Bio:** "Love trying new restaurants and meeting interesting people! Just started exploring the dining scene."

### Current Activity Status
- **Groups Created:** 1/2 (has created 1 group, can create 1 more)
- **Groups Joined:** 3/5 (joined 3 groups, can join 2 more)
- **Events Attended:** 2 (attending limited events as normal user)
- **Points Spent:** 130 (100 for 1 created group + 30 for 3 joined groups)
- **Points Remaining:** 20

### User Capabilities
- ✅ Join existing groups (if they have enough points)
- ✅ Browse groups and users
- ✅ Send messages in joined groups
- ✅ Create up to 2 groups total
- ✅ Join up to 5 groups total
- ❌ Access premium features
- ❌ Host premium events
- ❌ Unlimited group creation

### Points & Limitations
- **Starting Points:** 150
- **Group Creation Cost:** 100 points per group
- **Join Group Cost:** 10 points per group
- **Group Creation Limit:** 2 groups total
- **Group Joining Limit:** 5 groups total
- **Available for Joining:** 2 more groups (needs 20 more points)
- **Refill Rate:** None (must earn points through activity)

### Use Case
Perfect for testing the basic user experience with limited resources, understanding the points economy constraints, and testing group limit enforcement.

### How to Enable
```dart
mockDataService.setPreviewNormalUserWithGroup();
```

---

## Scenario 2: Premium User (Enhanced Experience)

### User Profile
- **Name:** Sarah Chen
- **Age:** 32
- **User Type:** premium
- **Points:** 850
- **Premium Status:** true
- **Verified Status:** true
- **Work:** Senior Software Engineer
- **Education:** Master's Degree
- **Subscription:** premium (1 year)
- **Bio:** "Wine connoisseur and Michelin guide follower. Love hosting exclusive dining events and culinary adventures."

### Current Activity Status
- **Groups Created:** 3/4 (has created 3 groups, can create 1 more)
- **Groups Joined:** 5/8 (joined 5 groups, can join 3 more)
- **Points Spent:** 350 (300 for 3 created groups at 50% discount + 50 for 5 joined groups)
- **Points Remaining:** 500

### User Capabilities
- ✅ Join existing groups
- ✅ Browse groups and users
- ✅ Send messages in joined groups
- ✅ Create up to 4 groups total
- ✅ Join up to 8 groups total
- ✅ Host premium events
- ✅ Priority group discovery
- ✅ Advanced filtering options
- ✅ Verified badge display

### Points & Limitations
- **Starting Points:** 850
- **Group Creation Cost:** 100 points per group (50% discount = 50 points)
- **Join Group Cost:** 10 points per group
- **Group Creation Limit:** 4 groups total
- **Group Joining Limit:** 8 groups total
- **Premium Discount:** 50% off group creation costs
- **Available for Joining:** 3 more groups (has sufficient points)
- **Refill Rate:** 50 points/month from subscription

### Use Case
Ideal for testing premium features, understanding the enhanced user experience, validating premium subscription benefits, and testing higher group limits.

### How to Enable
```dart
mockDataService.setPreviewPremiumUserWithGroups();
```

---

## Scenario 3: God Mode User (Administrator Experience)

### User Profile
- **Name:** System Administrator
- **Age:** 35
- **User Type:** admin
- **Points:** 999,999 (unlimited)
- **Premium Status:** true
- **Verified Status:** true
- **Work:** Platform Administrator & System Architect
- **Education:** PhD in Computer Science
- **Subscription:** vip (10 years)
- **Bio:** "Platform administrator with full access to all features and unlimited resources."

### Current Activity Status
- **Groups Created:** 12/unlimited (admin has created many groups for testing)
- **Groups Joined:** 25/unlimited (admin has joined many groups for moderation)
- **Points Spent:** 0 (admin override - no costs)
- **Points Remaining:** 999,999

### User Capabilities
- ✅ Join any group (no restrictions)
- ✅ Browse all groups and users
- ✅ Send messages in any group
- ✅ Unlimited group creation
- ✅ Host premium events
- ✅ Access to all premium features
- ✅ Admin panel access (if implemented)
- ✅ User moderation capabilities
- ✅ System-wide announcements
- ✅ Override group capacity limits

### Points & Limitations
- **Starting Points:** 999,999 (effectively unlimited)
- **Group Creation Cost:** Free (admin override)
- **Join Group Cost:** Free (admin override)
- **Group Creation Limit:** Unlimited
- **Group Joining Limit:** Unlimited
- **Premium Features:** All unlocked
- **Refill Rate:** Not applicable (unlimited points)
- **System Access:** Full administrative privileges

### Use Case
Perfect for testing admin functionality, stress testing with unlimited resources, ensuring the app handles extreme scenarios gracefully, and validating group limit overrides.

### How to Enable
```dart
mockDataService.setPreviewGodmodeUser();
```

---

## Testing Scenarios Matrix

| Feature | Normal User | Premium User | God Mode User |
|---------|-------------|--------------|----------------|
| **Points Available** | 150 (20 left) | 850 (500 left) | 999,999 |
| **Groups Created** | 1/2 | 3/4 | 12/unlimited |
| **Groups Joined** | 3/5 | 5/8 | 25/unlimited |
| **Group Creation Limit** | 2 total | 4 total | Unlimited |
| **Group Joining Limit** | 5 total | 8 total | Unlimited |
| **Premium Features** | ❌ | ✅ | ✅ |
| **Verified Badge** | ❌ | ✅ | ✅ |
| **Admin Access** | ❌ | ❌ | ✅ |
| **Priority Support** | ❌ | ✅ | ✅ |
| **Advanced Filters** | ❌ | ✅ | ✅ |
| **Event Hosting** | ❌ | ✅ | ✅ |

## Quick Testing Checklist

### Normal User Tests:
- [ ] Verify points balance display (150 total, 20 remaining)
- [ ] Test group creation limit (1/2 created)
- [ ] Test group joining limit (3/5 joined)
- [ ] Verify premium features are locked
- [ ] Check insufficient points handling (only 20 points left)

### Premium User Tests:
- [ ] Verify premium badge display
- [ ] Test group creation with discount (3/4 created)
- [ ] Test higher group joining limit (5/8 joined)
- [ ] Check subscription status display
- [ ] Verify points remaining (500/850)

### God Mode User Tests:
- [ ] Verify unlimited points display
- [ ] Test admin features (if implemented)
- [ ] Check system override capabilities
- [ ] Verify high activity counts (12 created, 25 joined)
- [ ] Test no cost operations

## Hot Reload Testing

Switch between scenarios by editing `lib/main.dart` and hot reloading:

```dart
// Switch to Normal User (1/2 groups created, 3/5 joined)
mockDataService.setPreviewNormalUserWithGroup();

// Switch to Premium User (3/4 groups created, 5/8 joined)
mockDataService.setPreviewPremiumUserWithGroups();

// Switch to God Mode User (12+ groups created, 25+ joined)
mockDataService.setPreviewGodmodeUser();
```

Press 'r' in the terminal to hot reload and see the changes immediately across all screens including Profile, Settings, and Group Management. The data will be consistent across all screens showing the correct group counts and points balances.