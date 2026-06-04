import 'package:flutter/material.dart';
import 'src/app/notes_todos_app.dart';
import 'src/app/theme/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeController().initialize();

  runApp(const NotesTodosApp());
}
