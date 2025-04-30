import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:product_catelog_app/data/theme_mode_cache.dart';
import 'package:product_catelog_app/widgets/riipple_overlay.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;

  ThemeMode get themeMode => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;


  Future<void> loadTheme() async {
    final mode = await ThemeModeCache.loadThemeMode();
    isDarkMode.value = mode == ThemeMode.dark;
  }

  Future toggleTheme()async {
    await Future.microtask((){
      HapticFeedback.mediumImpact();
      isDarkMode.value = !isDarkMode.value;
      Get.changeThemeMode(themeMode);
      ThemeModeCache.saveThemeMode(themeMode);
    });
  }

  Future<void> toggleThemeWithRipple(BuildContext context, Offset tapPosition) async {
     toggleTheme();
    late OverlayEntry entry; // declare first

    entry = OverlayEntry( // now assign it
      builder: (_) => RippleThemeTransition(
        position: tapPosition,
        onCompleted: () async {
          entry.remove(); // ✅ safe to reference now
        },
      ),
    );

    Overlay.of(context).insert(entry);
  }


}
