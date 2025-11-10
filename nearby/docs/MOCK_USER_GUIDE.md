# Mock User Preview Guide

This guide shows you how to set different mock users for preview when running `flutter run`.

## Quick Setup

1. **Run Flutter app:**
   ```bash
   flutter run
   ```

2. **Check available users:** When you first run the app, you'll see a list of all available preview users in your console.

## Setting Different User Types

### Method 1: Edit main.dart (Easiest)

In `lib/main.dart`, uncomment one of these lines in the `main()` function:

```dart
// Set up preview mode (comment this out for production)
// Uncomment any of these lines to test different user types:
mockDataService.setPreviewNormalUser(index: 0);        // Normal user with low points
mockDataService.setPreviewPremiumUser(index: 1);       // Premium user with more points
mockDataService.setPreviewCreatorUser(index: 0);       // Creator user (VIP)
mockDataService.setPreviewAdminUser(index: 0);         // Admin user
```

### Method 2: Custom User

Create a custom user with specific attributes:

```dart
mockDataService.setPreviewCustomUser(
  name: 'Test User',
  userType: 'premium',
  points: 2000,
  isPremium: true,
  isVerified: true,
);
```

## 4 Distinct User Scenarios

### Scenario 1: Normal User with 1 Group
- **Name:** Alex Johnson
- **Points:** 150
- **Premium:** false
- **Verified:** false
- **Work:** Marketing Coordinator
- **Education:** Bachelor's Degree
- **Groups Created:** 1
- **Usage:** `mockDataService.setPreviewNormalUserWithGroup();`

### Scenario 2: Premium User with 2 Groups
- **Name:** Sarah Chen
- **Points:** 850
- **Premium:** true
- **Verified:** true
- **Subscription:** premium (1 year)
- **Work:** Senior Software Engineer
- **Education:** Master's Degree
- **Groups Created:** 2
- **Usage:** `mockDataService.setPreviewPremiumUserWithGroups();`

### Scenario 3: Guest User (New User)
- **Name:** Guest User
- **Points:** 0
- **Premium:** false
- **Verified:** false
- **Work:** None
- **Education:** None
- **Groups Created:** 0
- **Interests:** Minimal (Coffee, Casual)
- **Languages:** English only
- **Usage:** `mockDataService.setPreviewGuestUser();`

### Scenario 4: Godmode User (Administrator)
- **Name:** System Administrator
- **Points:** 999,999 (unlimited)
- **Premium:** true
- **Verified:** true
- **Subscription:** vip (10 years)
- **Work:** Platform Administrator & System Architect
- **Education:** PhD in Computer Science
- **Groups Created:** Unlimited
- **Languages:** 5 languages
- **Features:** Full platform access
- **Usage:** `mockDataService.setPreviewGodmodeUser();`

## Individual User Types

### Normal Users (24 total)
- **Points:** 50-250
- **Premium:** false
- **Verified:** Random
- **Subscription:** None
- **Examples:** Alex Johnson, Sarah Chen, Mike Williams

### Premium Users (10 total)
- **Points:** 500-1500
- **Premium:** true
- **Verified:** true
- **Subscription:** premium
- **Examples:** Rachel Green, Tom Anderson, Julia Smith

### Creator Users (3 total)
- **Points:** 1500-3500
- **Premium:** true
- **Verified:** true
- **Subscription:** vip
- **Work:** Professional titles (Chef, Food Writer, etc.)
- **Examples:** Maya Patel, Oliver Smith, Zoe Johnson

### Admin Users (2 total)
- **Points:** 9999
- **Premium:** true
- **Verified:** true
- **Subscription:** vip
- **Examples:** System Admin, Community Manager

## User Selection Examples

```dart
// First normal user
mockDataService.setPreviewNormalUser(index: 0);

// Third premium user
mockDataService.setPreviewPremiumUser(index: 2);

// Reset to default user
mockDataService.resetPreviewUser();
```

## Hot Reload Support

After changing the user type in main.dart:
1. Save the file
2. Press 'r' in your terminal for hot reload
3. Your app will show the new user type instantly

## Using in Code

You can access the current user anywhere in your app:

```dart
import '../services/mock_data_service.dart';

// Get current user
final currentUser = mockDataService.getCurrentUser();

// Check user type
if (currentUser.userType == 'premium') {
  // Show premium features
}

// Check points balance
if (currentUser.points >= 1000) {
  // Allow premium actions
}

// Check verification status
if (currentUser.isVerified) {
  // Show verified badge
}
```

## Testing Different Scenarios

1. **Test Premium Features:**
   ```dart
   mockDataService.setPreviewPremiumUser(index: 0);
   ```

2. **Test Points System:**
   ```dart
   mockDataService.setPreviewCustomUser(
     name: 'Low Points User',
     userType: 'normal',
     points: 50,
   );
   ```

3. **Test Creator Experience:**
   ```dart
   mockDataService.setPreviewCreatorUser(index: 0);
   ```

4. **Test Admin Access:**
   ```dart
   mockDataService.setPreviewAdminUser(index: 0);
   ```

## Production Deployment

**Important:** Comment out or remove all preview user setup before deploying to production:

```dart
// Comment out these lines for production
// mockDataService.setPreviewNormalUser(index: 0);
// mockDataService.setPreviewCustomUser(...);
```

The app will automatically fall back to the default user if no preview user is set.