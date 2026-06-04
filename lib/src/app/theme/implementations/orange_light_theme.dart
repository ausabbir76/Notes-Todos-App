import 'package:flutter/material.dart';
import '../../app_constants.dart';
import '../models/app_theme.dart';

class OrangeLightTheme extends AppTheme {
  @override
  String get name => 'Orange Light';

  @override
  ThemeType get type => ThemeType.orangeLight;

  @override
  ThemeIcons get icons => const ThemeIcons(
    logo: Icons.sticky_note_2,
    history: Icons.history,
    settings: Icons.tune_outlined,
    delete: Icons.backspace_outlined,
    back: Icons.arrow_back_ios_new,
    check: Icons.check,
    warning: Icons.warning,
    arrowForward: Icons.arrow_forward_ios,
    clear: Icons.clear,
  );

  @override
  Color get primaryColor => const Color.fromARGB(255, 255, 115, 0);
  @override
  Color get secondaryColor => const Color(0xFFFFD7B8);
  @override
  Color get backgroundDark => const Color(0xFFFFF7F0);
  @override
  Color get panelBackground => const Color(0xFFFFFFFF);
  @override
  Color get cardBackground => const Color(0xFFFFFFFF);

  @override
  double get borderRadius => AppConstants.borderRadius;
  @override
  bool get useGlowEffects => true;

  @override
  ThemeData get themeData {
    final baseTextTheme = ThemeData.light().textTheme.apply(fontFamily: 'Inter');

    return ThemeData(
      fontFamily: 'Inter',
      useMaterial3: false,
      brightness: Brightness.light,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: panelBackground,
      ),
      textTheme: baseTextTheme.copyWith(
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          color: const Color(0xFF26170E),
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          color: const Color(0xFF26170E),
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
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
  TextStyle get editorTitleStyle => TextStyle(
    fontFamily: 'Inter',
    color: primaryColor,
    fontSize: 48,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );

  @override
  Color get appBarColor => Colors.white.withValues(alpha: 0.72);
  @override
  double get appBarBlur => 8;
  @override
  Border? get appBarBorder => const Border(
    bottom: BorderSide(color: Color(0x33FF7300), width: 0.5),
  );
  @override
  Border? get navBarBorder => const Border(
    top: BorderSide(color: Color(0x33FF7300), width: 0.5),
  );

  @override
  TextStyle get appBarTitleStyle => const TextStyle(
    fontFamily: 'Inter',
    color: Color(0xFF26170E),
    fontSize: 20,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );
  @override
  Color get appBarIconColor => const Color(0xFF26170E);

  @override
  BoxDecoration getEntryItemDecoration(bool isPressed, {bool isSelected = false}) => BoxDecoration(
    color: isSelected
        ? deleteIconColor.withValues(alpha: 0.08)
        : isPressed
        ? secondaryColor
        : cardBackground,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isSelected ? deleteIconColor : const Color(0xFFFFE1CA),
      width: isSelected ? 2 : 1,
    ),
    boxShadow: [
      BoxShadow(
        color: primaryColor.withValues(alpha: 0.08),
        blurRadius: 22,
        offset: const Offset(0, 10),
      ),
    ],
  );

  @override
  TextStyle get entrySubtitleStyle => const TextStyle(
    fontFamily: 'Inter',
    color: Color.fromARGB(255, 58, 43, 32),
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );
  @override
  TextStyle get entryTitleStyle => const TextStyle(
    fontFamily: 'Inter',
    color: Color(0xFF26170E),
    fontSize: 22,
    fontWeight: FontWeight.w900,
  );
  @override
  Color get deleteIconColor => const Color(0xFFE53935);
  @override
  BoxDecoration get emptyStateIconDecoration => BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(color: primaryColor.withValues(alpha: 0.18), width: 2),
  );
  @override
  Color get emptyStateIconColor => primaryColor.withValues(alpha: 0.45);

  @override
  BoxDecoration get dialogDecoration => BoxDecoration(
    color: Colors.white.withValues(alpha: 0.9),
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: const Color(0xFFFFE1CA), width: 2),
    boxShadow: [
      BoxShadow(
        color: primaryColor.withValues(alpha: 0.12),
        blurRadius: 30,
        offset: const Offset(0, 14),
      ),
    ],
  );
  @override
  double get dialogBlur => 8;
  @override
  String getDialogTitle(String type) => 'CONFIRMATION';
  @override
  String getDialogMessage(String type) => 'Are you sure to delete all items?';
  @override
  TextStyle get dialogTitleStyle => const TextStyle(
    fontFamily: 'Inter',
    color: Color(0xFF26170E),
    fontSize: 22,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );
  @override
  TextStyle get dialogMessageStyle => const TextStyle(
    fontFamily: 'Inter',
    color: Color(0xFF6B5544),
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.normal,
  );

  @override
  BoxDecoration getDialogIconDecoration(Color baseColor) =>
      const BoxDecoration(shape: BoxShape.circle);

  @override
  String getDialogConfirmLabel(String type) => 'YES';
  @override
  String getDialogCancelLabel(String type) => 'NO';

  @override
  BoxDecoration getDialogButtonDecoration(Color baseColor) => BoxDecoration(
    color: primaryColor.withValues(alpha: 0.08),
    borderRadius: BorderRadius.circular(8),
  );
  @override
  TextStyle getDialogButtonTextStyle(Color baseColor) => const TextStyle(
    fontFamily: 'Inter',
    color: Color(0xFF26170E),
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
    fontSize: 14,
  );

  @override
  BoxDecoration getThemeItemDecoration(bool isSelected) => BoxDecoration(
    color: isSelected ? secondaryColor : cardBackground,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isSelected ? primaryColor : const Color(0xFFFFE1CA),
    ),
  );
  @override
  TextStyle get themeItemTitleStyle => const TextStyle(
    fontFamily: 'Inter',
    color: Color(0xFF26170E),
    fontSize: 18,
    fontWeight: FontWeight.w900,
  );
  @override
  TextStyle get themeItemStatusStyle => const TextStyle(
    fontFamily: 'Inter',
    color: Color(0xFF8A6D58),
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
  );

  @override
  Color get fabBackgroundColor => primaryColor;
  @override
  Color get fabForegroundColor => Colors.white;
  @override
  Color get fabDeleteBackgroundColor => deleteIconColor;
  @override
  Color get fabDeleteForegroundColor => Colors.white;

  @override
  ShapeBorder get fabShape => RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(borderRadius),
  );
  @override
  ShapeBorder get fabDeleteShape => RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(borderRadius),
  );
  @override
  double get fabElevation => 6.0;

  @override
  BoxDecoration get appBarLogoDecoration => BoxDecoration(
    color: primaryColor.withValues(alpha: 0.1),
    shape: BoxShape.circle,
  );

  @override
  BoxDecoration getTabDecoration(bool active) => BoxDecoration(
    color: active ? primaryColor.withValues(alpha: 0.15) : Colors.transparent,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: active ? primaryColor : Colors.transparent,
      width: 1,
    ),
  );

  @override
  Color get navBarSelectedItemColor => primaryColor;
  @override
  Color get navBarUnselectedItemColor => appBarIconColor.withValues(alpha: 0.55);

  @override
  EdgeInsets get listPadding => const EdgeInsets.only(
    top: kToolbarHeight + 64,
    bottom: kBottomNavigationBarHeight + 26,
    left: 12,
    right: 12,
  );
  @override
  double get listItemSpacing => 12.0;

  @override
  String get notesTabLabel => 'NOTES';
  @override
  String get todosTabLabel => 'TODOS';
  @override
  IconData get notesTabIcon => Icons.notes_rounded;
  @override
  IconData get todosTabIcon => Icons.checklist_rounded;

  @override
  Color get dialogBarrierColor => Colors.black.withValues(alpha: 0.10);
}
