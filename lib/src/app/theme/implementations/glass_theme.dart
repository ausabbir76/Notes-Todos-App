import 'package:flutter/material.dart';
import '../models/app_theme.dart';

class GlassTheme extends AppTheme {
  @override
  String get name => 'Glassmorphism';

  @override
  ThemeType get type => ThemeType.glass;

  @override
  ThemeIcons get icons => const ThemeIcons(
    logo: Icons.sticky_note_2_rounded,
    history: Icons.history_toggle_off,
    settings: Icons.tune_outlined,
    delete: Icons.remove,
    back: Icons.arrow_back_ios_new,
    check: Icons.check,
    warning: Icons.info_outline,
    arrowForward: Icons.chevron_right,
    clear: Icons.close,
  );

  @override
  Color get primaryColor => const Color.fromARGB(255, 197, 236, 255);
  @override
  Color get secondaryColor => const Color.fromARGB(255, 62, 168, 255);
  @override
  Color get backgroundDark => const Color(0xFF1A237E); // Deep indigo
  @override
  Color get panelBackground => const Color.fromARGB(255, 34, 42, 130);
  @override
  Color get cardBackground =>
      const Color.fromARGB(46, 24, 44, 74).withValues(alpha: 0.05);

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
  CustomPainter? get backgroundPainter => const _GlassBackgroundPainter();

  @override
  TextStyle get editorTitleStyle => TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: primaryColor,
    fontSize: 48,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );

  // --- SEMANTIC GETTERS ---

  @override
  Color get appBarColor => panelBackground.withValues(alpha: 0.0);
  @override
  double get appBarBlur => 8;
  @override
  Border? get appBarBorder => Border(
    bottom: BorderSide(color: Colors.white.withValues(alpha: 0.4), width: 1),
  );
  @override
  Border? get navBarBorder => Border(
    top: BorderSide(color: Colors.white.withValues(alpha: 0.4), width: 1),
  );
  @override
  TextStyle get appBarTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
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
        ? primaryColor.withValues(alpha: 0.3)
        : Colors.transparent,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isSelected
          ? deleteIconColor
          : isPressed
          ? primaryColor
          : primaryColor.withValues(alpha: 0.5),
      width: isSelected ? 2 : 1,
    ),
    boxShadow: [
      if (isSelected && useGlowEffects)
        BoxShadow(color: deleteIconColor.withValues(alpha: 0.2), blurRadius: 12),
      if (isPressed && !isSelected && useGlowEffects)
        BoxShadow(color: primaryColor.withValues(alpha: 0.2), blurRadius: 10),
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
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.w900,
  );
  @override
  Color get deleteIconColor => Colors.redAccent;
  @override
  BoxDecoration get emptyStateIconDecoration =>
      const BoxDecoration(shape: BoxShape.circle);
  @override
  Color get emptyStateIconColor => Colors.white.withValues(alpha: 0.75);

  @override
  BoxDecoration get dialogDecoration => BoxDecoration(
    color: Colors.white.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
  );
  @override
  double get dialogBlur => 8;
  @override
  String getDialogTitle(String type) =>
      type == 'warning' ? 'ERASE SYSTEM' : 'SYSTEM ALERT';
  @override
  String getDialogMessage(String type) => type == 'warning'
      ? 'This action will permanently delete the selected item.'
      : 'Operation in progress.';
  @override
  TextStyle get dialogTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );
  @override
  TextStyle get dialogMessageStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Colors.white,
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
    borderRadius: BorderRadius.circular(15),
    border: Border.all(color: baseColor.withValues(alpha: 0.5), width: 1),
  );
  @override
  TextStyle getDialogButtonTextStyle(Color baseColor) => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Colors.white,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
    fontSize: 14,
  );

  @override
  BoxDecoration getThemeItemDecoration(bool isSelected) => BoxDecoration(
    color: isSelected
        ? primaryColor.withValues(alpha: 0.2)
        : Colors.transparent,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isSelected ? primaryColor : primaryColor.withValues(alpha: 0.5),
      width: isSelected ? 2 : 1,
    ),
    boxShadow: [
      if (isSelected && useGlowEffects)
        BoxShadow(
          color: primaryColor.withValues(alpha: 0.3),
          blurRadius: 15,
          spreadRadius: 2,
        ),
    ],
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
    color: Colors.white.withValues(alpha: 0.6),
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
  );

  @override
  Color get fabBackgroundColor => Colors.transparent;
  @override
  Color get fabForegroundColor => Colors.white;
  @override
  Color get fabDeleteBackgroundColor => Colors.transparent;
  @override
  Color get fabDeleteForegroundColor => deleteIconColor;

  @override
  ShapeBorder get fabShape => RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    side: BorderSide(color: primaryColor.withValues(alpha: 0.5), width: 1),
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
    color: Colors.white.withValues(alpha: 0.1),
    shape: BoxShape.circle,
  );

  @override
  BoxDecoration getTabDecoration(bool active) => BoxDecoration(
    color: active ? Colors.white.withValues(alpha: 0.15) : Colors.transparent,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: active ? Colors.white.withValues(alpha: 0.4) : Colors.transparent,
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

class _GlassBackgroundPainter extends CustomPainter {
  const _GlassBackgroundPainter();
  @override
  void paint(Canvas canvas, Size size) {
    // Beautiful abstract background for glass to sit on
    final bgPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.5, -0.5),
        radius: 1.5,
        colors: [Color(0xFF3949AB), Color(0xFF1A237E)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bgPaint);

    // Floating glass spheres
    final sphere1Paint = Paint()
      ..shader =
          const RadialGradient(
            colors: [Color(0x4481D4FA), Colors.transparent],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.8, size.height * 0.2),
              radius: 200,
            ),
          );
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      200,
      sphere1Paint,
    );

    final sphere2Paint = Paint()
      ..shader =
          const RadialGradient(
            colors: [Color(0x33CE93D8), Colors.transparent],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.2, size.height * 0.8),
              radius: 250,
            ),
          );
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.8),
      250,
      sphere2Paint,
    );
  }

  @override
  bool shouldRepaint(covariant _GlassBackgroundPainter oldDelegate) => false;
}
