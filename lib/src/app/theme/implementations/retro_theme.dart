import 'package:flutter/material.dart';
import '../models/app_theme.dart';

class RetroTheme extends AppTheme {
  @override
  String get name => 'Retro GameBoy';

  @override
  ThemeType get type => ThemeType.retro;

  @override
  ThemeIcons get icons => const ThemeIcons(
    logo: Icons.videogame_asset_outlined,
    history: Icons.save_outlined,
    settings: Icons.tune_outlined,
    delete: Icons.backspace_outlined,
    back: Icons.arrow_back_ios_new,
    check: Icons.check_box_outlined,
    warning: Icons.priority_high,
    arrowForward: Icons.arrow_forward,
    clear: Icons.cancel_outlined,
  );

  // GameBoy Palette
  static const Color gbDarkest = Color(0xFF0F380F);
  static const Color gbDark = Color(0xFF306230);
  static const Color gbLight = Color(0xFF8BAC0F);
  static const Color gbLightest = Color(0xFF9BBC0F);

  @override
  Color get primaryColor => gbDarkest;
  @override
  Color get secondaryColor => gbDark;
  @override
  Color get backgroundDark => gbLightest;
  @override
  Color get panelBackground => gbLight;
  @override
  Color get cardBackground => gbLightest;

  @override
  double get borderRadius => 2.0; // Almost square
  @override
  bool get useGlowEffects => false;

  @override
  ThemeData get themeData {
    final baseTextTheme = ThemeData.light().textTheme.apply(
      fontFamily: 'PressStart2P',
    );

    return ThemeData(
      fontFamily: 'PressStart2P',
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
          color: gbDarkest,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          color: gbDarkest,
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
  CustomPainter? get backgroundPainter => const _RetroBackgroundPainter();

  @override
  TextStyle get editorTitleStyle => const TextStyle(
    fontFamily: 'PressStart2P',
    color: gbDarkest,
    fontSize: 48,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );

  // --- SEMANTIC GETTERS ---

  @override
  Color get appBarColor => panelBackground.withValues(alpha: 0.1);
  @override
  double get appBarBlur => 8;
  @override
  Border? get appBarBorder =>
      const Border(bottom: BorderSide(color: gbDarkest, width: 4));

  @override
  Border? get navBarBorder =>
      const Border(top: BorderSide(color: gbDarkest, width: 4));

  @override
  TextStyle get appBarTitleStyle => const TextStyle(
    fontFamily: 'PressStart2P',
    color: gbDarkest,
    fontSize: 20,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );
  @override
  Color get appBarIconColor => gbDarkest;

  @override
  BoxDecoration getEntryItemDecoration(bool isPressed, {bool isSelected = false}) => BoxDecoration(
    color: isSelected
        ? deleteIconColor.withValues(alpha: 0.08)
        : isPressed
        ? primaryColor.withValues(alpha: 0.1)
        : cardBackground,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isSelected ? deleteIconColor : gbDarkest,
      width: isSelected ? 3 : 2,
    ),
  );

  @override
  TextStyle get entrySubtitleStyle => TextStyle(
    fontFamily: 'PressStart2P',
    color: gbDarkest.withValues(alpha: 0.5),
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );
  @override
  TextStyle get entryTitleStyle => const TextStyle(
    fontFamily: 'PressStart2P',
    color: gbDarkest,
    fontSize: 22,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );
  @override
  Color get deleteIconColor => gbDarkest;
  @override
  BoxDecoration get emptyStateIconDecoration => BoxDecoration(
    shape: BoxShape.rectangle,
    border: Border.all(color: gbDarkest, width: 4),
  );
  @override
  Color get emptyStateIconColor => gbDarkest.withValues(alpha: 0.75);

  @override
  BoxDecoration get dialogDecoration => BoxDecoration(
    color: Colors.white12,
    border: Border.all(color: gbDarkest, width: 4),
  );
  @override
  double get dialogBlur => 8;
  @override
  String getDialogTitle(String type) =>
      type == 'warning' ? '!!! WARNING !!!' : '!!! ALERT !!!';
  @override
  String getDialogMessage(String type) => type == 'warning'
      ? 'ALL DATA WILL BE LOST FOREVER. CONTINUE?'
      : 'SYSTEM ERROR DETECTED.';
  @override
  TextStyle get dialogTitleStyle => const TextStyle(
    fontFamily: 'PressStart2P',
    color: gbDarkest,
    fontSize: 22,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );
  @override
  TextStyle get dialogMessageStyle => TextStyle(
    fontFamily: 'PressStart2P',
    color: gbDarkest.withValues(alpha: 0.7),
    fontSize: 14,
    height: 1.1,
    letterSpacing: 0,
    fontWeight: FontWeight.normal,
  );

  @override
  BoxDecoration getDialogIconDecoration(Color baseColor) => BoxDecoration(
    shape: BoxShape.rectangle,
    border: Border.all(color: baseColor, width: 2),
  );

  @override
  String getDialogConfirmLabel(String type) => '[YES]';
  @override
  String getDialogCancelLabel(String type) => '[NO]';

  @override
  BoxDecoration getDialogButtonDecoration(Color baseColor) => BoxDecoration(
    color: Colors.transparent,
    border: Border.all(color: gbDarkest, width: 2),
  );
  @override
  TextStyle getDialogButtonTextStyle(Color baseColor) => const TextStyle(
    fontFamily: 'PressStart2P',
    color: gbDarkest,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
    fontSize: 14,
  );

  @override
  BoxDecoration getThemeItemDecoration(bool isSelected) => BoxDecoration(
    color: isSelected ? primaryColor.withValues(alpha: 0.3) : cardBackground,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: gbDarkest, width: isSelected ? 4 : 1),
  );
  @override
  TextStyle get themeItemTitleStyle => const TextStyle(
    fontFamily: 'PressStart2P',
    color: gbDarkest,
    fontSize: 18,
    fontWeight: FontWeight.w900,
  );
  @override
  TextStyle get themeItemStatusStyle => TextStyle(
    fontFamily: 'PressStart2P',
    color: gbDarkest.withValues(alpha: 0.6),
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
  );

  @override
  Color get fabBackgroundColor => primaryColor;
  @override
  Color get fabForegroundColor => backgroundDark;
  @override
  Color get fabDeleteBackgroundColor => deleteIconColor;
  @override
  Color get fabDeleteForegroundColor => backgroundDark;

  @override
  ShapeBorder get fabShape => RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(borderRadius),
  );
  @override
  ShapeBorder get fabDeleteShape => RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(borderRadius),
  );
  @override
  double get fabElevation => 0.0; // Retro UI often uses borders instead of elevation

  @override
  BoxDecoration get appBarLogoDecoration => BoxDecoration(
    color: primaryColor.withValues(alpha: 0.1),
    shape: BoxShape.rectangle,
    border: Border.all(color: primaryColor, width: 2),
  );

  @override
  BoxDecoration getTabDecoration(bool active) => BoxDecoration(
    color: active ? primaryColor.withValues(alpha: 0.15) : Colors.transparent,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: active ? primaryColor : Colors.transparent,
      width: 2,
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
  String get notesTabLabel => 'Notes';
  @override
  String get todosTabLabel => 'Todos';
  @override
  IconData get notesTabIcon => Icons.notes_rounded;
  @override
  IconData get todosTabIcon => Icons.checklist_rounded;

  @override
  Color get dialogBarrierColor => gbDark.withValues(alpha: 0.5);
}

class _RetroBackgroundPainter extends CustomPainter {
  const _RetroBackgroundPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = RetroTheme.gbLightest;
    canvas.drawRect(Offset.zero & size, paint);

    // Subtle pixel grid
    final gridPaint = Paint()
      ..color = RetroTheme.gbLight.withValues(alpha: 0.3)
      ..strokeWidth = 1.0;

    const spacing = 10.0;
    for (var i = 0.0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (var i = 0.0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RetroBackgroundPainter oldDelegate) => false;
}
