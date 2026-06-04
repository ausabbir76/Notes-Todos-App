import 'package:flutter/material.dart';
import '../models/app_theme.dart';

class AmberGlassTheme extends AppTheme {
  @override
  String get name => 'Amber Glass';

  @override
  ThemeType get type => ThemeType.amberGlass;

  @override
  ThemeIcons get icons => const ThemeIcons(
    logo: Icons.auto_awesome_rounded,
    history: Icons.history_rounded,
    settings: Icons.tune_outlined,
    delete: Icons.backspace_outlined,
    back: Icons.arrow_back_ios_new,
    check: Icons.verified_rounded,
    warning: Icons.warning_amber_rounded,
    arrowForward: Icons.arrow_forward_ios_rounded,
    clear: Icons.close_rounded,
  );

  // Amber Glass Palette
  static const Color amberDeep = Color(0xFFFF8F00);
  static const Color amberGlow = Color(0xFFFFD54F);
  static const Color obsidian = Color(0xFF080808);
  static const Color indigoDark = Color(0xFF1A1A2E);

  @override
  Color get primaryColor => amberDeep;
  @override
  Color get secondaryColor => amberGlow;
  @override
  Color get backgroundDark => obsidian;
  @override
  Color get panelBackground => const Color(0xFF121212);
  @override
  Color get cardBackground => Colors.white.withValues(alpha: 0.05);

  @override
  double get borderRadius => 24.0;
  @override
  bool get useGlowEffects => true;

  @override
  ThemeData get themeData {
    final baseTextTheme = ThemeData.dark().textTheme.apply(
      fontFamily: 'OnePlusSansRegular',
    );

    return ThemeData(
      fontFamily: 'OnePlusSansRegular',
      useMaterial3: false,
      brightness: Brightness.dark,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      scaffoldBackgroundColor: obsidian,
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
  CustomPainter? get backgroundPainter => const _AmberGlassBackgroundPainter();

  @override
  TextStyle get editorTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: amberGlow,
    fontSize: 48,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
    shadows: [Shadow(color: amberDeep, blurRadius: 20)],
  );

  // --- SEMANTIC GETTERS ---

  @override
  Color get appBarColor => Colors.transparent;
  @override
  double get appBarBlur => 8;
  @override
  Border? get appBarBorder => Border(
    bottom: BorderSide(color: amberDeep.withValues(alpha: 0.4), width: 1),
  );
  @override
  Border? get navBarBorder => Border(
    top: BorderSide(color: amberDeep.withValues(alpha: 0.4), width: 1),
  );
  @override
  TextStyle get appBarTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: amberGlow,
    fontSize: 20,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );
  @override
  Color get appBarIconColor => amberGlow;

  @override
  BoxDecoration getEntryItemDecoration(bool isPressed, {bool isSelected = false}) => BoxDecoration(
    color: isSelected
        ? deleteIconColor.withValues(alpha: 0.15)
        : isPressed
        ? amberDeep.withValues(alpha: 0.3)
        : Colors.transparent,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isSelected
          ? deleteIconColor
          : isPressed
          ? amberGlow
          : amberDeep.withValues(alpha: 0.5),
      width: isSelected ? 2 : 1,
    ),
    boxShadow: [
      if (isSelected)
        BoxShadow(color: deleteIconColor.withValues(alpha: 0.2), blurRadius: 12),
      if (isPressed && !isSelected)
        BoxShadow(color: amberDeep.withValues(alpha: 0.25), blurRadius: 15),
    ],
  );

  @override
  TextStyle get entrySubtitleStyle => TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Colors.grey.shade100,
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );
  @override
  TextStyle get entryTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: amberGlow,
    fontSize: 20,
    fontWeight: FontWeight.w900,
  );
  @override
  Color get deleteIconColor => Colors.redAccent;
  @override
  BoxDecoration get emptyStateIconDecoration => BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(color: amberDeep.withValues(alpha: 0.2), width: 2),
  );
  @override
  Color get emptyStateIconColor => amberGlow.withValues(alpha: 0.75);

  @override
  BoxDecoration get dialogDecoration => BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: amberDeep.withValues(alpha: 0.4), width: 2),
    boxShadow: [
      BoxShadow(color: amberDeep.withValues(alpha: 0.2), blurRadius: 60),
    ],
  );
  @override
  double get dialogBlur => 8;
  @override
  String getDialogTitle(String type) =>
      type == 'warning' ? 'ERASE SYSTEM' : 'SYSTEM ALERT';
  @override
  String getDialogMessage(String type) => type == 'warning'
      ? 'Delete the selected item from this list?'
      : 'System notification.';
  @override
  TextStyle get dialogTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: amberGlow,
    fontSize: 22,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );
  @override
  TextStyle get dialogMessageStyle => TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Colors.white.withValues(alpha: 0.7),
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.normal,
  );

  @override
  BoxDecoration getDialogIconDecoration(Color baseColor) => BoxDecoration(
    color: baseColor.withValues(alpha: 0.1),
    shape: BoxShape.circle,
  );

  @override
  String getDialogConfirmLabel(String type) => 'ERASE';
  @override
  String getDialogCancelLabel(String type) => 'BACK';

  @override
  BoxDecoration getDialogButtonDecoration(Color baseColor) => BoxDecoration(
    color: baseColor.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: baseColor.withValues(alpha: 0.5), width: 1),
  );
  @override
  TextStyle getDialogButtonTextStyle(Color baseColor) => TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: baseColor == Colors.white38 ? Colors.white54 : baseColor,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
    fontSize: 14,
  );

  @override
  BoxDecoration getThemeItemDecoration(bool isSelected) => BoxDecoration(
    color: isSelected ? amberDeep.withValues(alpha: 0.25) : Colors.transparent,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isSelected ? amberGlow : amberDeep.withValues(alpha: 0.5),
      width: isSelected ? 2 : 1,
    ),
  );
  @override
  TextStyle get themeItemTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w900,
  );
  @override
  TextStyle get themeItemStatusStyle => TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: amberGlow.withValues(alpha: 0.6),
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
  );

  @override
  Color get fabBackgroundColor => Colors.transparent;
  @override
  Color get fabForegroundColor => amberGlow;
  @override
  Color get fabDeleteBackgroundColor => Colors.transparent;
  @override
  Color get fabDeleteForegroundColor => deleteIconColor;

  @override
  ShapeBorder get fabShape => RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    side: BorderSide(color: amberDeep.withValues(alpha: 0.5), width: 1),
  );
  @override
  ShapeBorder get fabDeleteShape => RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    side: BorderSide(color: deleteIconColor.withValues(alpha: 0.5), width: 1),
  );
  @override
  double get fabElevation => 0.0;

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
      color: active ? primaryColor.withValues(alpha: 0.4) : Colors.transparent,
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

class _AmberGlassBackgroundPainter extends CustomPainter {
  const _AmberGlassBackgroundPainter();
  @override
  void paint(Canvas canvas, Size size) {
    // Beautiful abstract background for amber glass to sit on (Subdued Orange version)
    final bgPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.5, -0.5),
        radius: 1.5,
        colors: [
          Color(0xFF802B00),
          Color(0xFF0D0500),
        ], // Darker, more muted orange and deep black
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bgPaint);

    // Floating glass spheres - Subdued Amber version
    final sphere1Paint = Paint()
      ..shader =
          const RadialGradient(
            colors: [
              Color(0x22FFD54F),
              Colors.transparent,
            ], // Reduced opacity from 0x44 to 0x22
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.8, size.height * 0.2),
              radius: 180,
            ),
          );
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      180,
      sphere1Paint,
    );

    final sphere2Paint = Paint()
      ..shader =
          const RadialGradient(
            colors: [
              Color(0x18FFB74D),
              Colors.transparent,
            ], // Reduced opacity from 0x33 to 0x18
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.2, size.height * 0.8),
              radius: 220,
            ),
          );
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.8),
      220,
      sphere2Paint,
    );
  }

  @override
  bool shouldRepaint(covariant _AmberGlassBackgroundPainter oldDelegate) =>
      false;
}
