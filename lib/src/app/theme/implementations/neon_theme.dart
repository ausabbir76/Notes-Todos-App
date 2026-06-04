import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../app_constants.dart';
import '../models/app_theme.dart';

class NeonTheme extends AppTheme {
  @override
  String get name => 'Neon Glow';

  @override
  ThemeType get type => ThemeType.neon;

  @override
  ThemeIcons get icons => const ThemeIcons(
    logo: Icons.bolt,
    history: Icons.auto_graph,
    settings: Icons.tune_outlined,
    delete: Icons.backspace_outlined,
    back: Icons.arrow_back_ios_new,
    check: Icons.done_all,
    warning: Icons.gpp_maybe,
    arrowForward: Icons.chevron_right,
    clear: Icons.highlight_off,
  );

  @override
  Color get primaryColor => const Color(0xFF00E5FF);
  @override
  Color get secondaryColor => const Color(0xFFFF2BD6);
  @override
  Color get backgroundDark => const Color(0xFF080A18);
  @override
  Color get panelBackground => const Color.fromARGB(255, 0, 43, 64);
  @override
  Color get cardBackground => const Color(0xFF11152D);

  @override
  double get borderRadius => AppConstants.borderRadius;
  @override
  bool get useGlowEffects => true;

  @override
  ThemeData get themeData {
    final baseTextTheme = ThemeData.dark().textTheme.apply(
      fontFamily: 'Orbitron',
    );

    return ThemeData(
      fontFamily: 'Orbitron',
      useMaterial3: false,
      brightness: Brightness.dark,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      scaffoldBackgroundColor: Colors.black,
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
          fontWeight: FontWeight.w900,
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
  CustomPainter? get backgroundPainter => const _NeonBackgroundPainter();

  @override
  String? get backgroundImage => null;

  @override
  TextStyle get editorTitleStyle => TextStyle(
    fontFamily: 'Orbitron',
    color: primaryColor,
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
  Border? get appBarBorder => Border(
    bottom: BorderSide(color: primaryColor.withValues(alpha: 0.2), width: 1),
  );

  @override
  Border? get navBarBorder => Border(
    top: BorderSide(color: primaryColor.withValues(alpha: 0.2), width: 1),
  );

  @override
  TextStyle get appBarTitleStyle => const TextStyle(
    fontFamily: 'Orbitron',
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
        ? const Color.fromARGB(255, 151, 0, 0)
        : isPressed
        ? const Color.fromARGB(255, 140, 115, 202)
        : cardBackground,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isSelected
          ? deleteIconColor
          : isPressed
          ? primaryColor
          : primaryColor.withValues(alpha: 0.1),
      width: isSelected ? 2 : 1,
    ),
    boxShadow: [
      if (isSelected && useGlowEffects)
        BoxShadow(color: deleteIconColor.withValues(alpha: 0.25), blurRadius: 12),
      if (isPressed && !isSelected && useGlowEffects)
        BoxShadow(color: primaryColor.withValues(alpha: 0.2), blurRadius: 10),
    ],
  );

  @override
  TextStyle get entrySubtitleStyle =>
      TextStyle(fontFamily: 'Orbitron', color: Colors.grey[300], fontSize: 18);
  @override
  TextStyle get entryTitleStyle => TextStyle(
    fontFamily: 'Orbitron',
    color: primaryColor,
    fontSize: 22,
    fontWeight: FontWeight.w900,
  );
  @override
  Color get deleteIconColor => Colors.redAccent;
  @override
  BoxDecoration get emptyStateIconDecoration => BoxDecoration(
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: primaryColor.withValues(alpha: 0.25),
        blurRadius: 22,
        spreadRadius: 2,
      ),
    ],
  );
  @override
  Color get emptyStateIconColor => Colors.white.withValues(alpha: 0.75);

  @override
  BoxDecoration get dialogDecoration => BoxDecoration(
    color: Colors.transparent,
    border: Border.all(color: primaryColor.withValues(alpha: 0.5), width: 1),
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: [
      BoxShadow(color: primaryColor.withValues(alpha: 0.2), blurRadius: 40),
    ],
  );
  @override
  double get dialogBlur => 8;
  @override
  String getDialogTitle(String type) =>
      type == 'warning' ? 'PURGE SYSTEM' : 'SYSTEM ALERT';
  @override
  String getDialogMessage(String type) => type == 'warning'
      ? 'This action will permanently delete the selected item.'
      : 'Operation in progress.';
  @override
  TextStyle get dialogTitleStyle => const TextStyle(
    fontFamily: 'Orbitron',
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );
  @override
  TextStyle get dialogMessageStyle => TextStyle(
    fontFamily: 'Orbitron',
    color: Colors.white.withValues(alpha: 0.7),
    fontSize: 14,
    height: 1.5,
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
    borderRadius: BorderRadius.circular(15),
    border: Border.all(color: baseColor.withValues(alpha: 0.5), width: 1),
  );
  @override
  TextStyle getDialogButtonTextStyle(Color baseColor) => TextStyle(
    fontFamily: 'Orbitron',
    color: baseColor == Colors.white38 ? Colors.white54 : baseColor,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
    fontSize: 14,
  );

  @override
  BoxDecoration getThemeItemDecoration(bool isSelected) => BoxDecoration(
    color: isSelected ? primaryColor.withValues(alpha: 0.2) : cardBackground,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isSelected ? primaryColor : primaryColor.withValues(alpha: 0.1),
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
    fontFamily: 'Orbitron',
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w900,
  );
  @override
  TextStyle get themeItemStatusStyle => TextStyle(
    fontFamily: 'Orbitron',
    color: Colors.white.withValues(alpha: 0.6),
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
  );

  @override
  Color get fabBackgroundColor => const Color.fromARGB(255, 0, 229, 255);
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

class _NeonBackgroundPainter extends CustomPainter {
  const _NeonBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Gradient Sky (Synthwave style but neon colors)
    final skyGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF080A18), // backgroundDark
        Color(0xFF120E2B), // Deep navy
        Color(0xFF2B0E2B), // Deep purple-ish
      ],
    ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, Paint()..shader = skyGradient);

    // 2. Neon Glowed Diamond Triangle
    _drawNeonTriangle(canvas, size);

    // 3. Perspective Grid (Synthwave style)
    final gridPaint = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.15)
      ..strokeWidth = 1.0;

    final horizon = size.height * 0.6;

    // Radial lines
    for (var i = 0.0; i <= size.width; i += size.width / 10) {
      canvas.drawLine(
        Offset(size.width * 0.5, horizon),
        Offset(i, size.height),
        gridPaint,
      );
    }

    // Horizontal lines with perspective compression
    for (var i = 0.0; i <= 1.0; i += 0.1) {
      final y = horizon + (size.height - horizon) * math.pow(i, 2);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 4. Subtle Vignette
    final vignettePaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.transparent, Colors.black.withValues(alpha: .5)],
        stops: const [0.5, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, vignettePaint);
  }

  void _drawNeonTriangle(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.4);
    final radius = size.width * 0.3; // Similar to synthwave sun

    final path = Path();
    // Equilateral triangle pointing up
    path.moveTo(center.dx, center.dy - radius);
    path.lineTo(
      center.dx + radius * math.cos(math.pi / 6),
      center.dy + radius * math.sin(math.pi / 6),
    );
    path.lineTo(
      center.dx - radius * math.cos(math.pi / 6),
      center.dy + radius * math.sin(math.pi / 6),
    );
    path.close();

    // Outer glow
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFFF2BD6).withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 32)
        ..style = PaintingStyle.fill,
    );

    // Triangle gradient
    final triangleGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF00E5FF), Color(0xFFFF2BD6)],
    ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawPath(
      path,
      Paint()
        ..shader = triangleGradient
        ..style = PaintingStyle.fill,
    );

    // Diamond themed lines (facets)
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Lines from center to vertices
    canvas.drawLine(center, Offset(center.dx, center.dy - radius), linePaint);
    canvas.drawLine(
      center,
      Offset(
        center.dx + radius * math.cos(math.pi / 6),
        center.dy + radius * math.sin(math.pi / 6),
      ),
      linePaint,
    );
    canvas.drawLine(
      center,
      Offset(
        center.dx - radius * math.cos(math.pi / 6),
        center.dy + radius * math.sin(math.pi / 6),
      ),
      linePaint,
    );

    // Internal triangle
    final innerPath = Path();
    final innerRadius = radius * 0.45;
    innerPath.moveTo(center.dx, center.dy - innerRadius);
    innerPath.lineTo(
      center.dx + innerRadius * math.cos(math.pi / 6),
      center.dy + innerRadius * math.sin(math.pi / 6),
    );
    innerPath.lineTo(
      center.dx - innerRadius * math.cos(math.pi / 6),
      center.dy + innerRadius * math.sin(math.pi / 6),
    );
    innerPath.close();
    canvas.drawPath(innerPath, linePaint);

    // Add a diamond-like glow on top
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _NeonBackgroundPainter oldDelegate) => false;
}
