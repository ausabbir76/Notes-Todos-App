import 'package:flutter/material.dart';

import '../features/notes_todos/presentation/notes_todos_screen.dart';
import 'layout/app_scale.dart';
import 'theme/theme_controller.dart';

class NotesTodosApp extends StatelessWidget {
  const NotesTodosApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController();
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Notes & Todos',
          debugShowCheckedModeBanner: false,
          theme: themeController.currentTheme.themeData,
          builder: (context, child) {
            AppScale.update(context);
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.1),
              ),
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: const NotesTodosScreen(),
        );
      },
    );
  }
}
