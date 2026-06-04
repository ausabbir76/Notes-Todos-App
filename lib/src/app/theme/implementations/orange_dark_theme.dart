import 'package:flutter/material.dart';
import '../../app_constants.dart';
import '../models/app_theme.dart';

class OrangeDarkTheme extends AppTheme {
  @override
  String get name => 'Orange Dark';

  @override
  ThemeType get type => ThemeType.orangeDark;

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
  Color get primaryColor => const Color(0xFFFF7300);
  @override
  Color get secondaryColor => const Color(0xFF4A2C1D);
  @override
  Color get backgroundDark => const Color(0xFF0F0906);
  @override
  Color get panelBackground => const Color(0xFF1A110D);
  @override
  Color get cardBackground => const Color(0xFF26170E);

  @override
  double get borderRadius => AppConstants.borderRadius;
  @override
  bool get useGlowEffects => true;

  @override
  ThemeData get themeData {
    final baseTextTheme = ThemeData.dark().textTheme.apply(fontFamily: 'Inter');

    return ThemeData(
      fontFamily: 'Inter',
      useMaterial3: false,
      brightness: Brightness.dark,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: panelBackground,
      ),
      textTheme: baseTextTheme.copyWith(
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          color: Colors.white,
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
  Color get appBarColor => backgroundDark.withValues(alpha: 0.8);
  @override
  double get appBarBlur => 12;
  @override
  Border? get appBarBorder => Border(
    bottom: BorderSide(color: primaryColor.withValues(alpha: 0.2), width: 0.5),
  );
  @override
  Border? get navBarBorder => Border(
    top: BorderSide(color: primaryColor.withValues(alpha: 0.2), width: 0.5),
  );

  @override
  TextStyle get appBarTitleStyle => const TextStyle(
    fontFamily: 'Inter',
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );
  @override
  Color get appBarIconColor => Colors.white;

  @override
  BoxDecoration getEntryItemDecoration(bool isPressed, {bool isSelected = false}) => BoxDecoration(
    color: isSelected
        ? deleteIconColor.withValues(alpha: 0.15)
        : isPressed
        ? primaryColor.withValues(alpha: 0.2)
        : cardBackground,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isSelected ? deleteIconColor : primaryColor.withValues(alpha: 0.15),
      width: isSelected ? 2 : 1,
    ),
    boxShadow: [
      if (isPressed || isSelected)
        BoxShadow(
          color: primaryColor.withValues(alpha: 0.15),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
    ],
  );

  @override
  TextStyle get entrySubtitleStyle => TextStyle(
    fontFamily: 'Inter',
    color: Colors.white.withValues(alpha: 0.6),
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );
  @override
  TextStyle get entryTitleStyle => const TextStyle(
    fontFamily: 'Inter',
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.w900,
  );
  @override
  Color get deleteIconColor => const Color(0xFFFF5252);
  @override
  BoxDecoration get emptyStateIconDecoration => BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(color: primaryColor.withValues(alpha: 0.25), width: 2),
  );
  @override
  Color get emptyStateIconColor => primaryColor.withValues(alpha: 0.5);

  @override
  BoxDecoration get dialogDecoration => BoxDecoration(
    color: panelBackground.withValues(alpha: 0.95),
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: primaryColor.withValues(alpha: 0.3), width: 1.5),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.4),
        blurRadius: 30,
        offset: const Offset(0, 15),
      ),
    ],
  );
  @override
  double get dialogBlur => 15;
  @override
  String getDialogTitle(String type) => 'CONFIRMATION';
  @override
  String getDialogMessage(String type) => 'Are you sure to delete all items?';
  @override
  TextStyle get dialogTitleStyle => const TextStyle(
    fontFamily: 'Inter',
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );
  @override
  TextStyle get dialogMessageStyle => TextStyle(
    fontFamily: 'Inter',
    color: Colors.white.withValues(alpha: 0.7),
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
    color: primaryColor.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
  );
  @override
  TextStyle getDialogButtonTextStyle(Color baseColor) => const TextStyle(
    fontFamily: 'Inter',
    color: Colors.white,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
    fontSize: 14,
  );

  @override
  BoxDecoration getThemeItemDecoration(bool isSelected) => BoxDecoration(
    color: isSelected ? primaryColor.withValues(alpha: 0.15) : cardBackground,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isSelected ? primaryColor : primaryColor.withValues(alpha: 0.1),
    ),
  );
  @override
  TextStyle get themeItemTitleStyle => const TextStyle(
    fontFamily: 'Inter',
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w900,
  );
  @override
  TextStyle get themeItemStatusStyle => TextStyle(
    fontFamily: 'Inter',
    color: primaryColor.withValues(alpha: 0.5),
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
  );

  @override
  Color get fabBackgroundColor => primaryColor;
  @override
  Color get fabForegroundColor => Colors.black;
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
  double get fabElevation => 8.0;

  @override
  BoxDecoration get appBarLogoDecoration => BoxDecoration(
    color: primaryColor.withValues(alpha: 0.15),
    shape: BoxShape.circle,
  );

  @override
  BoxDecoration getTabDecoration(bool active) => BoxDecoration(
    color: active ? primaryColor.withValues(alpha: 0.2) : Colors.transparent,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: active ? primaryColor : Colors.transparent,
      width: 1,
    ),
  );

  @override
  Color get navBarSelectedItemColor => primaryColor;
  @override
  Color get navBarUnselectedItemColor => Colors.white.withValues(alpha: 0.4);

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
  Color get dialogBarrierColor => Colors.black.withValues(alpha: 0.5);
}
