# Clean Navigation Architecture

## Structure

```
lib/
├── core/
│   ├── navigation/
│   │   └── app_navigator.dart    # Navigation helper
│   └── routes/
│       ├── app_routes.dart        # Route constants
│       └── app_pages.dart         # Route definitions
└── features/
    ├── splash/
    ├── on_boarding/
    ├── auth/
    └── home/
```

## Usage Examples

### 1. Basic Navigation

```dart
// Navigate to new screen
AppNavigator.to(AppRoutes.login);

// Navigate and replace current
AppNavigator.off(AppRoutes.onboarding);

// Navigate and clear all previous
AppNavigator.offAll(AppRoutes.home);

// Go back
AppNavigator.back();
```

### 2. Quick Navigation

```dart
// Pre-defined shortcuts
AppNavigator.toLogin();
AppNavigator.toRegister();
AppNavigator.toHome();
AppNavigator.toOnboarding();
```

### 3. With Arguments

```dart
// Pass data
AppNavigator.to(AppRoutes.profile, arguments: userId);

// Receive data
final userId = Get.arguments;
```

### 4. Back with Result

```dart
// Return data when going back
AppNavigator.backWithResult({'success': true});

// Receive result
final result = await Get.toNamed(AppRoutes.someScreen);
```

## Benefits

✅ **Clean Code**: One-line navigation calls
✅ **Type Safe**: Centralized route constants
✅ **Easy Maintenance**: Single source of truth
✅ **Less Boilerplate**: No PageRouteBuilder needed
✅ **Built-in Animations**: Transition effects included
✅ **Navigation Stack Control**: Easy back/offAll methods

## Navigation Methods Comparison

### Standard Navigator
```dart
Navigator.of(context).pushReplacement(
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    transitionDuration: Duration(milliseconds: 500),
  ),
);
```

### Clean with AppNavigator
```dart
AppNavigator.toHome();
```

## Adding New Routes

### 1. Add route constant (app_routes.dart)
```dart
static const String newScreen = '/new-screen';
```

### 2. Add page definition (app_pages.dart)
```dart
GetPage(
  name: AppRoutes.newScreen,
  page: () => const NewScreen(),
  transition: Transition.fadeIn,
),
```

### 3. Add helper method (app_navigator.dart) - Optional
```dart
static void toNewScreen() => to(AppRoutes.newScreen);
```

## Transitions Available

- `Transition.fade`
- `Transition.fadeIn`
- `Transition.rightToLeft`
- `Transition.leftToRight`
- `Transition.upToDown`
- `Transition.downToUp`
- `Transition.zoom`
- `Transition.cupertino`

## Current Flow

```
Splash (3s delay)
  ↓
Onboarding (swipe through 3 pages)
  ↓
Login
  ↓
Home
```
