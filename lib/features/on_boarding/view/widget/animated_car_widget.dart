import 'package:flutter/material.dart';

class AnimatedCarWidget extends StatelessWidget {
  final int currentPage;
  final Animation<double> animation;
  final Color backgroundColor;

  const AnimatedCarWidget({
    super.key,
    required this.currentPage,
    required this.animation,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 200,
      child: _buildCarIcon(),
    );
  }

  Widget _buildCarIcon() {
    // Get the correct car image based on current page
    String carImagePath;
    switch (currentPage) {
      case 0:
        carImagePath = 'assets/images/car_with_angel.png';
        break;
      case 1:
        carImagePath = 'assets/images/car_behind.png';
        break;
      case 2:
        carImagePath = 'assets/images/car_in_front.png';
        break;
      default:
        carImagePath = 'assets/images/car_with_angel.png';
    }

    return Image.asset(
      carImagePath,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.directions_car_rounded,
          size: 120,
          color: backgroundColor.withOpacity(0.8),
        );
      },
    );
  }
}
