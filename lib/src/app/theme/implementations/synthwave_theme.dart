import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/app_theme.dart';

class SynthwaveTheme extends AppTheme {
  @override
  String get name => 'Synthwave Sunset';

  @override
  ThemeType get type => ThemeType.synthwave;

  @override
  ThemeIcons get icons => const ThemeIcons(
    logo: Icons.wb_sunny,
    history: Icons.speed,
    settings: Icons.tune_outlined,
    delete: Icons.backspace_outlined,
    back: Icons.arrow_back_ios_new,
    check: Icons.check_circle_outline,
    warning: Icons.new_releases,
    arrowForward: Icons.arrow_forward,
    clear: Icons.cancel,
  );

  // Synthwave Palette
  static const Color synthPink = Color(0xFFFF2BD6);
  static const Color synthBlue = Color(0xFF00E5FF);
  static const Color synthPurple = Color(0xFF2E1A47);
  static const Color synthNavy = Color(0xFF080B1A);
  static const Color synthOrange = Color(0xFFFFD166);

  @override
  Color get primaryColor => synthPink;
  @override
  Color get secondaryColor => synthBlue;
  @override
  Color get backgroundDark => synthNavy;
  @override
  Color get panelBackground => synthPurple;
  @override
  Color get cardBackground => const Color.fromARGB(255, 17, 12, 32);

  @override
  double get borderRadius => 12.0;
  @override
  bool get useGlowEffects => true;

  @override
  ThemeData get themeData {
    final baseTextTheme = ThemeData.dark().textTheme.apply(
      fontFamily: 'OnePlusSansBold',
    );

    return ThemeData(
      fontFamily: 'OnePlusSansBold',
      useMaterial3: false,
      brightness: Brightness.dark,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      scaffoldBackgroundColor: synthNavy,
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
  CustomPainter? get backgroundPainter => const _SynthwaveBackgroundPainter();

  @override
  TextStyle get editorTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansBold',
    color: synthBlue,
    fontSize: 48,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
    shadows: [Shadow(color: synthBlue, blurRadius: 10)],
  );

  // --- SEMANTIC GETTERS ---

  @override
  Color get appBarColor => panelBackground.withValues(alpha: 0.0);
  @override
  double get appBarBlur => 8;
  @override
  Border? get appBarBorder =>
      const Border(bottom: BorderSide(color: synthPink, width: 2));

  @override
  Border? get navBarBorder =>
      const Border(top: BorderSide(color: synthPink, width: 2));

  @override
  TextStyle get appBarTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansBold',
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );
  @override
  Color get appBarIconColor => Colors.white;

  @override
  BoxDecoration getEntryItemDecoration(
    bool isPressed, {
    bool isSelected = false,
  }) => BoxDecoration(
    color: isSelected || isPressed
        ? const Color.fromARGB(255, 154, 25, 128)
        : cardBackground,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isSelected
          ? deleteIconColor
          : isPressed
          ? synthPink
          : synthPink.withValues(alpha: 0.5),
      width: 2,
    ),
    boxShadow: [
      if (isSelected && useGlowEffects)
        BoxShadow(
          color: deleteIconColor.withValues(alpha: 0.25),
          blurRadius: 12,
        ),
    ],
  );
  @override
  TextStyle get entrySubtitleStyle => TextStyle(
    fontFamily: 'OnePlusSansBold',
    color: Colors.grey[300],
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );
  @override
  TextStyle get entryTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansBold',
    color: synthPink,
    fontSize: 22,
    fontWeight: FontWeight.w900,
  );
  @override
  Color get deleteIconColor => Colors.redAccent;
  @override
  BoxDecoration get emptyStateIconDecoration => BoxDecoration(
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(color: synthPink.withValues(alpha: 0.3), blurRadius: 20),
    ],
  );
  @override
  Color get emptyStateIconColor => Colors.white.withValues(alpha: 0.75);

  @override
  BoxDecoration get dialogDecoration => BoxDecoration(
    color: synthPurple.withValues(alpha: 0.8),
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: synthPink, width: 2),
  );
  @override
  double get dialogBlur => 8;
  @override
  String getDialogTitle(String type) =>
      type == 'warning' ? 'SYSTEM PURGE' : 'ALERT';
  @override
  String getDialogMessage(String type) => type == 'warning'
      ? 'INITIATE TOTAL MEMORY WIPE? DATA CANNOT BE RECOVERED.'
      : 'Operation in progress.';
  @override
  TextStyle get dialogTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansBold',
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );
  @override
  TextStyle get dialogMessageStyle => TextStyle(
    fontFamily: 'OnePlusSansBold',
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
  String getDialogConfirmLabel(String type) => 'CONFIRM';
  @override
  String getDialogCancelLabel(String type) => 'CANCEL';

  @override
  BoxDecoration getDialogButtonDecoration(Color baseColor) => BoxDecoration(
    color: baseColor.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: baseColor.withValues(alpha: 0.5), width: 1),
  );
  @override
  TextStyle getDialogButtonTextStyle(Color baseColor) => TextStyle(
    fontFamily: 'OnePlusSansBold',
    color: baseColor,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
    fontSize: 14,
  );

  @override
  BoxDecoration getThemeItemDecoration(bool isSelected) => BoxDecoration(
    color: isSelected
        ? synthPurple.withValues(alpha: 0.6)
        : cardBackground.withValues(alpha: 1.0),
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isSelected ? synthPink : synthPink.withValues(alpha: 0.2),
      width: isSelected ? 3 : 1,
    ),
  );
  @override
  TextStyle get themeItemTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansBold',
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w900,
  );
  @override
  TextStyle get themeItemStatusStyle => TextStyle(
    fontFamily: 'OnePlusSansBold',
    color: Colors.white.withValues(alpha: 0.6),
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

class _SynthwaveBackgroundPainter extends CustomPainter {
  const _SynthwaveBackgroundPainter();
  @override
  void paint(Canvas canvas, Size size) {
    // Gradient Sky
    final skyGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        SynthwaveTheme.synthNavy,
        SynthwaveTheme.synthPurple,
        Color(0xFF5E2365),
      ],
    ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, Paint()..shader = skyGradient);

    // Sun
    final sunRadius = size.width * 0.3;
    final sunCenter = Offset(size.width * 0.5, size.height * 0.4);
    final sunGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [SynthwaveTheme.synthOrange, SynthwaveTheme.synthPink],
    ).createShader(Rect.fromCircle(center: sunCenter, radius: sunRadius));

    canvas.drawCircle(sunCenter, sunRadius, Paint()..shader = sunGradient);

    // Perspective Grid
    final gridPaint = Paint()
      ..color = SynthwaveTheme.synthBlue.withValues(alpha: 0.2)
      ..strokeWidth = 1.0;

    final horizon = size.height * 0.6;
    for (var i = 0.0; i <= size.width; i += size.width / 10) {
      canvas.drawLine(
        Offset(size.width * 0.5, horizon),
        Offset(i, size.height),
        gridPaint,
      );
    }

    for (var i = 0.0; i <= 1.0; i += 0.1) {
      final y = horizon + (size.height - horizon) * math.pow(i, 2);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SynthwaveBackgroundPainter oldDelegate) =>
      false;
}
