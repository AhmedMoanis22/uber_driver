import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Toggle button for driver online/offline status
class OnlineToggleButton extends StatelessWidget {
  final bool isOnline;
  final VoidCallback onToggle;

  const OnlineToggleButton({
    super.key,
    required this.isOnline,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: GestureDetector(
        onTap: onToggle,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isOnline ? AppColors.success : AppColors.error,
            boxShadow: [
              BoxShadow(
                color: (isOnline ? AppColors.success : AppColors.error)
                    .withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.power_settings_new,
            size: 40,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
