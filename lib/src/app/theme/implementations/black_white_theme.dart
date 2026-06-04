import 'package:flutter/material.dart';
import '../models/app_theme.dart';

class BlackWhiteTheme extends AppTheme {
  @override
  String get name => 'Noir';

  @override
  ThemeType get type => ThemeType.blackWhite;

  @override
  ThemeIcons get icons => const ThemeIcons(
    logo: Icons.lens,
    history: Icons.history,
    settings: Icons.tune_outlined,
    delete: Icons.delete_outline,
    back: Icons.arrow_back_ios_new,
    check: Icons.check,
    warning: Icons.priority_high,
    arrowForward: Icons.arrow_forward_ios,
    clear: Icons.close,
  );

  @override
  Color get primaryColor => Colors.white;
  @override
  Color get secondaryColor => const Color(0xFF333333);
  @override
  Color get backgroundDark => const Color(0xFF000000);
  @override
  Color get panelBackground => const Color(0xFF1A1A1A);
  @override
  Color get cardBackground => const Color(0xFF121212);

  @override
  double get borderRadius => 22; // Single control point for the theme's roundness
  @override
  bool get useGlowEffects => false;

  @override
  ThemeData get themeData {
    final baseTextTheme = ThemeData.dark().textTheme.apply(fontFamily: 'OnePlusSansRegular');

    return ThemeData(
      fontFamily: 'OnePlusSansRegular',
      useMaterial3: false,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: panelBackground,
      ),
      textTheme: baseTextTheme.copyWith(
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
          TargetPlatform.windows: ZoomPageTransitionsBuilder(),
        },
      ),
    );
  }

  @override
  CustomPainter? get backgroundPainter => null;

  @override
  TextStyle get editorTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Colors.white,
    fontSize: 48,
    fontWeight: FontWeight.bold,
  );

  @override
  Color get appBarColor => Colors.grey.shade900.withAlpha(160);
  @override
  double get appBarBlur => 8;
  @override
  Border? get appBarBorder => const Border(
    bottom: BorderSide(color: Color(0xFF333333), width: 1),
  );
  @override
  Border? get navBarBorder => const Border(
    top: BorderSide(color: Color(0xFF333333), width: 1),
  );

  @override
  TextStyle get appBarTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular ',
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
  );
  @override
  Color get appBarIconColor => Colors.white;

  @override
  BoxDecoration getEntryItemDecoration(bool isPressed, {bool isSelected = false}) => BoxDecoration(
    color: isSelected
        ? Colors.white.withValues(alpha: 0.15)
        : isPressed
        ? Colors.white.withValues(alpha: 0.3)
        : cardBackground,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isSelected ? Colors.white : const Color(0xFF333333),
      width: 1,
    ),
  );

  @override
  TextStyle get entrySubtitleStyle => TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Colors.grey.shade100,
    fontSize: 18,
  );
  @override
  TextStyle get entryTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  @override
  Color get deleteIconColor => Colors.white;
  @override
  BoxDecoration get emptyStateIconDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: Colors.white24, width: 1),
  );
  @override
  Color get emptyStateIconColor => Colors.white38;

  @override
  BoxDecoration get dialogDecoration => BoxDecoration(
    color: Colors.white12,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: const Color(0xFF333333), width: 1),
  );
  @override
  double get dialogBlur => 8;
  @override
  String getDialogTitle(String type) => type.toUpperCase();
  @override
  String getDialogMessage(String type) => 'CONFIRM ACTION';
  @override
  TextStyle get dialogTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
  );
  @override
  TextStyle get dialogMessageStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Color(0xFF888888),
    fontSize: 14,
  );

  @override
  BoxDecoration getDialogIconDecoration(Color baseColor) =>
      BoxDecoration(borderRadius: BorderRadius.circular(borderRadius / 2));

  @override
  String getDialogConfirmLabel(String type) => 'OK';
  @override
  String getDialogCancelLabel(String type) => 'CANCEL';

  @override
  BoxDecoration getDialogButtonDecoration(Color baseColor) => BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(borderRadius / 2),
    border: Border.all(color: const Color.fromARGB(255, 86, 86, 86), width: 1),
  );
  @override
  TextStyle getDialogButtonTextStyle(Color baseColor) => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  @override
  BoxDecoration getThemeItemDecoration(bool isSelected) => BoxDecoration(
    color: isSelected ? const Color(0xFF222222) : cardBackground,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isSelected ? Colors.white : const Color(0xFF333333),
      width: 1,
    ),
  );
  @override
  TextStyle get themeItemTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  @override
  TextStyle get themeItemStatusStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Color(0xFF888888),
    fontSize: 11,
    fontWeight: FontWeight.bold,
  );

  @override
  Color get fabBackgroundColor => Colors.white;
  @override
  Color get fabForegroundColor => Colors.black;
  @override
  Color get fabDeleteBackgroundColor => Colors.white;
  @override
  Color get fabDeleteForegroundColor => Colors.black;

  @override
  ShapeBorder get fabShape => RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(borderRadius),
  );
  @override
  ShapeBorder get fabDeleteShape => RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(borderRadius),
  );
  @override
  double get fabElevation => 0.0;

  @override
  BoxDecoration get appBarLogoDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(borderRadius / 2),
    color: Colors.white10,
  );

  @override
  BoxDecoration getTabDecoration(bool active) => BoxDecoration(
    color: active ? Colors.white : Colors.transparent,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: Colors.white, width: 1),
  );

  @override
  Color get navBarSelectedItemColor => Colors.white;
  @override
  Color get navBarUnselectedItemColor => Colors.white38;

  @override
  EdgeInsets get listPadding => const EdgeInsets.only(
    top: kToolbarHeight + 64,
    bottom: kBottomNavigationBarHeight + 26,
    left: 12,
    right: 12,
  );
  @override
  double get listItemSpacing => 12;

  @override
  String get notesTabLabel => 'NOTES';
  @override
  String get todosTabLabel => 'TODOS';
  @override
  IconData get notesTabIcon => Icons.sticky_note_2_sharp;
  @override
  IconData get todosTabIcon => Icons.check_box_sharp;

  @override
  Color get dialogBarrierColor => Colors.transparent;
}
