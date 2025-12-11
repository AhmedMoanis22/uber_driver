# Car Animation Setup

## خطوات إضافة صورة السيارة:

1. احفظ صورة السيارة في المجلد التالي:
   ```
   C:\Users\mans\AndroidStudioProjects\uber_driver\assets\images\car.png
   ```

2. الصورة ستظهر تلقائياً في الـ onboarding

## كيف تعمل الحركة:

### الصفحة الأولى (Page 0):
- السيارة تظهر بشكل مستقيم
- عند الضغط على Next: دوران خفيف (10 درجات) + تكبير 15%

### الصفحة الثانية (Page 1):
- السيارة تدور جانبياً (45 درجة) - منظر جانبي
- عند الضغط على Next: دوران أكبر + تكبير 20%

### الصفحة الثالثة (Page 2):
- السيارة تدور بالكامل (90 درجة)
- عند الضغط على Next: دوران نهائي + تكبير 25%

## التخصيص:

لتغيير زوايا الدوران، عدّل الملف:
`lib/features/on_boarding/widgets/animated_car_widget.dart`

في الـ switch case:
```dart
case 0: rotationAngle = animation.value * 0.1;  // غيّر 0.1
case 1: rotationAngle = animation.value * math.pi / 4;  // غيّر pi/4
case 2: rotationAngle = animation.value * math.pi / 2;  // غيّر pi/2
```

## الألوان:

الخلفية تتغير تلقائياً حسب لون كل صفحة من:
`lib/features/on_boarding/data/onboarding_data.dart`
