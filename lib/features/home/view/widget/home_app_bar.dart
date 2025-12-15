import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/action_icon_button.dart';

/// App bar for home screen with menu and profile buttons
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ActionIconButton(
            icon: Icons.menu,
            onPressed: () {
              // Open drawer or menu
            },
          ),
          const Spacer(),
          ActionIconButton(
            icon: Icons.person,
            onPressed: () {
              Get.toNamed(AppRoutes.profile);
            },
          ),
        ],
      ),
    );
  }
}
