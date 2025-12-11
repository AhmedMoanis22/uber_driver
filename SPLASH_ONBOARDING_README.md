# Driver Pro - Splash & Onboarding

## Features Implemented

### 🚀 Splash Screen
- **Animated Logo**: Elastic bounce animation with fade-in effect
- **Brand Identity**: Professional gradient background with app branding
- **Smooth Transitions**: Fade transition to onboarding screen
- **Auto Navigation**: 3-second delay before navigating to onboarding

### 📱 Onboarding Experience
- **4 Informative Pages**:
  1. Start Earning Today - Money-making opportunities
  2. Real-Time Navigation - Smart routing features
  3. Track Your Performance - Analytics & insights
  4. Safe & Secure - Safety features

- **Advanced Animations**:
  - **Parallax Effect**: Icons scale and move during page transitions
  - **Fade Animations**: Smooth opacity changes for content
  - **Elastic Icon Animations**: Bouncy entrance animations
  - **Smooth Page Indicators**: Expanding dots effect
  - **Transform Animations**: Scale, translate, and opacity combined

### 🎨 Design System
- **Professional Color Palette**: Primary, accent, and semantic colors
- **Material 3 Theme**: Modern UI components
- **Consistent Styling**: Reusable theme components
- **Gradient Backgrounds**: Eye-catching visual hierarchy

### 🎯 User Experience
- **Skip Option**: Users can skip onboarding anytime
- **Page Indicators**: Visual feedback of progress
- **Responsive Buttons**: Clear CTAs (Next/Get Started)
- **Portrait Lock**: Optimized for mobile experience

## Project Structure

```
lib/
├── core/
│   └── theme/
│       ├── app_colors.dart      # Color palette
│       └── app_theme.dart       # App theme configuration
├── features/
│   ├── splash/
│   │   └── splash_screen.dart   # Animated splash screen
│   └── on_boarding/
│       ├── data/
│       │   └── onboarding_data.dart    # Onboarding content
│       ├── model/
│       │   └── onboarding_model.dart   # Data model
│       └── view/
│           └── on_boarding_screen.dart # Onboarding UI with animations
└── main.dart                    # App entry point
```

## Dependencies Added
- `smooth_page_indicator: ^1.1.0` - Beautiful page indicators
- `animate_do: ^3.3.4` - Pre-built animations

## How to Run
1. Ensure Flutter is installed and configured
2. Run: `flutter pub get`
3. Run: `flutter run`

## Animation Details

### PageView Scroll Animation
- **Scale Effect**: Icons scale from 0.7x to 1.0x based on scroll position
- **Opacity**: Content fades in/out during page transitions
- **Translation**: Vertical movement creates depth effect
- **Timing**: Smooth 400ms transitions with easeInOut curve

### Icon Animation
- **Elastic Bounce**: 600ms elastic-out curve for entrance
- **Layered Circles**: Three-layer design for depth
- **Color Coordination**: Each page has unique icon color
- **Shadow Effects**: Elevated appearance with soft shadows

## Customization

### To Change Colors
Edit `lib/core/theme/app_colors.dart`

### To Modify Onboarding Content
Edit `lib/features/on_boarding/data/onboarding_data.dart`

### To Adjust Animation Speed
Modify duration values in:
- `splash_screen.dart` (lines 28-29)
- `on_boarding_screen.dart` (lines 32-39)

## Next Steps
- Implement authentication screens
- Add home/dashboard screen
- Connect to backend services
- Add user preferences storage
