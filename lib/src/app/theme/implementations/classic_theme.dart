import 'package:flutter/material.dart';
import '../../app_constants.dart';
import '../models/app_theme.dart';

class ClassicTheme extends AppTheme {
  @override
  String get name => 'Classic Dark';

  @override
  ThemeType get type => ThemeType.classic;

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
  Color get secondaryColor => const Color.fromARGB(255, 126, 126, 126);
  @override
  Color get backgroundDark => const Color(0xFF121212);
  @override
  Color get panelBackground => const Color.fromARGB(255, 53, 53, 53);
  @override
  Color get cardBackground => const Color(0xFF2C2C2C);

  @override
  double get borderRadius => AppConstants.borderRadius;
  @override
  bool get useGlowEffects => true;

  @override
  ThemeData get themeData {
    final baseTextTheme = ThemeData.dark().textTheme;

    return ThemeData(
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
  TextStyle get editorTitleStyle => const TextStyle(
    color: Colors.orange,
    fontSize: 48,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );

  // --- SEMANTIC GETTERS ---

  @override
  Color get appBarColor => Colors.transparent;
  @override
  double get appBarBlur => 8;
  @override
  Border? get appBarBorder =>
      const Border(bottom: BorderSide(color: Colors.white38, width: 0.5));
  @override
  Border? get navBarBorder =>
      const Border(top: BorderSide(color: Colors.white38, width: 0.5));

  @override
  TextStyle get appBarTitleStyle => const TextStyle(
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
        ? deleteIconColor.withValues(alpha: 0.10)
        : isPressed
        ? secondaryColor
        : cardBackground,
    borderRadius: BorderRadius.circular(borderRadius),
    border: isSelected
        ? Border.all(color: deleteIconColor, width: 2)
        : null,
  );

  @override
  TextStyle get entrySubtitleStyle => TextStyle(
    color: Colors.grey.shade100,
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );
  @override
  TextStyle get entryTitleStyle => const TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.w900,
  );
  @override
  Color get deleteIconColor => Colors.redAccent;
  @override
  BoxDecoration get emptyStateIconDecoration => BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(color: Colors.white10, width: 2),
  );
  @override
  Color get emptyStateIconColor => Colors.white24;

  @override
  BoxDecoration get dialogDecoration => BoxDecoration(
    color: Colors.white12,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: Colors.white10, width: 2),
  );
  @override
  double get dialogBlur => 8;
  @override
  String getDialogTitle(String type) => 'CONFIRMATION';
  @override
  String getDialogMessage(String type) => 'Are you sure to delete all items?';
  @override
  TextStyle get dialogTitleStyle => const TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );
  @override
  TextStyle get dialogMessageStyle => const TextStyle(
    color: Colors.white70,
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
    color: Colors.white10,
    borderRadius: BorderRadius.circular(8),
  );
  @override
  TextStyle getDialogButtonTextStyle(Color baseColor) => const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
    fontSize: 14,
  );

  @override
  BoxDecoration getThemeItemDecoration(bool isSelected) => BoxDecoration(
    color: isSelected ? secondaryColor : cardBackground,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: isSelected ? Colors.white : Colors.white10),
  );
  @override
  TextStyle get themeItemTitleStyle => const TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w900,
  );
  @override
  TextStyle get themeItemStatusStyle => const TextStyle(
    color: Colors.white54,
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
  Color get dialogBarrierColor => Colors.black.withValues(alpha: 0.18);
}
