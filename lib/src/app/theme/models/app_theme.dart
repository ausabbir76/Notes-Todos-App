import 'package:flutter/material.dart';

enum ThemeType {
  neon,
  classic,
  retro,
  cyber,
  synthwave,
  glass,
  amberGlass,
  blackWhite,
  lightNoir,
  orangeLight,
  orangeDark,
  legacyRedBlack,
  legacyRedLight,
}

class ThemeIcons {
  const ThemeIcons({
    required this.logo,
    required this.history,
    required this.settings,
    required this.delete,
    required this.back,
    required this.check,
    required this.warning,
    required this.arrowForward,
    required this.clear,
  });

  final IconData logo;
  final IconData history;
  final IconData settings;
  final IconData delete;
  final IconData back;
  final IconData check;
  final IconData warning;
  final IconData arrowForward;
  final IconData clear;
}

abstract class AppTheme {
  String get name;
  ThemeType get type;
  ThemeData get themeData;

  // Icons
  ThemeIcons get icons;

  // Colors
  Color get primaryColor;
  Color get secondaryColor;
  Color get backgroundDark;
  Color get panelBackground;
  Color get cardBackground;

  // Design Tokens
  double get borderRadius;
  bool get useGlowEffects;

  // Custom Painters/Decorations
  CustomPainter? get backgroundPainter;
  String? get backgroundImage => null; // Path to asset image

  // Widget-specific styles
  TextStyle get editorTitleStyle;

  // --- NEW SEMANTIC GETTERS ---

  // App Bar & General UI
  Color get appBarColor;
  double get appBarBlur;
  Border? get appBarBorder;
  Border? get navBarBorder;
  TextStyle get appBarTitleStyle;
  Color get appBarIconColor;

  // List entries
  BoxDecoration getEntryItemDecoration(bool isPressed, {bool isSelected = false});
  TextStyle get entrySubtitleStyle;
  TextStyle get entryTitleStyle;
  Color get deleteIconColor;
  BoxDecoration get emptyStateIconDecoration;
  Color get emptyStateIconColor;

  // Dialogs
  BoxDecoration get dialogDecoration;
  double get dialogBlur;
  String getDialogTitle(String type); // 'warning' or 'purge'
  String getDialogMessage(String type);
  TextStyle get dialogTitleStyle;
  TextStyle get dialogMessageStyle;
  BoxDecoration getDialogIconDecoration(Color baseColor);
  String getDialogConfirmLabel(String type);
  String getDialogCancelLabel(String type);
  BoxDecoration getDialogButtonDecoration(Color baseColor);
  TextStyle getDialogButtonTextStyle(Color baseColor);

  BoxDecoration getThemeItemDecoration(bool isSelected);
  TextStyle get themeItemTitleStyle;
  TextStyle get themeItemStatusStyle;

  // Floating Action Button
  Color get fabBackgroundColor;
  Color get fabForegroundColor;
  Color get fabDeleteBackgroundColor;
  Color get fabDeleteForegroundColor;
  ShapeBorder get fabShape;
  ShapeBorder get fabDeleteShape;
  double get fabElevation;

  // Home Screen & Navigation
  BoxDecoration get appBarLogoDecoration;
  BoxDecoration getTabDecoration(bool active);
  Color get navBarSelectedItemColor;
  Color get navBarUnselectedItemColor;

  // List UI
  EdgeInsets get listPadding;
  double get listItemSpacing;

  // Tabs
  String get notesTabLabel;
  String get todosTabLabel;
  IconData get notesTabIcon;
  IconData get todosTabIcon;

  // Dialogs
  Color get dialogBarrierColor;
}
