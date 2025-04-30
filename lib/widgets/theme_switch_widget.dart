import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_catelog_app/controller/theme_controller.dart';
import 'package:product_catelog_app/core/theme/app_color.dart';

class ThemeSwitch extends StatelessWidget {
  final ThemeController themeController = Get.find();

  ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;

      return GestureDetector(
        // onTap: themeController.toggleTheme,
        onTapDown: (details) {
          final position = details.globalPosition;
          themeController.toggleThemeWithRipple(context, position);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 1500),
          width: 52,
          height: 30,
          curve: Curves.linearToEaseOut,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: isDark ? Colors.blueGrey[800] : AppColors.primary[200],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Icon(
                      isDark ? CupertinoIcons.moon_fill : CupertinoIcons.sun_max_fill,
                      size: 14,
                      color: isDark ? Colors.blue[700] : Colors.orange,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
