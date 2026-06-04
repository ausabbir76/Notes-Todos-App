import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/app_theme.dart';

class CyberTheme extends AppTheme {
  @override
  String get name => 'Cyberpunk 2077';

  @override
  ThemeType get type => ThemeType.cyber;

  @override
  ThemeIcons get icons => const ThemeIcons(
    logo: Icons.terminal,
    history: Icons.storage,
    settings: Icons.tune_outlined,
    delete: Icons.backspace_outlined,
    back: Icons.arrow_back_ios_new,
    check: Icons.verified_user,
    warning: Icons.report_problem,
    arrowForward: Icons.chevron_right,
    clear: Icons.power_settings_new,
  );

  // Cyberpunk Palette
  static const Color cyberYellow = Color(0xFFFCEE0A);
  static const Color cyberBlack = Color(0xFF000000);
  static const Color cyberBlue = Color(0xFF00F0FF);
  static const Color cyberRed = Color(0xFFFF003C);

  @override
  Color get primaryColor => cyberYellow;
  @override
  Color get secondaryColor => cyberBlue;
  @override
  Color get backgroundDark => const Color.fromARGB(255, 10, 8, 0);
  @override
  Color get panelBackground => const Color.fromARGB(255, 59, 53, 0);
  @override
  Color get cardBackground => const Color.fromARGB(255, 30, 28, 0);

  @override
  double get borderRadius => 0.0; // Sharp edges
  @override
  bool get useGlowEffects => true;

  @override
  ThemeData get themeData {
    final baseTextTheme = ThemeData.dark().textTheme.apply(
      fontFamily: 'Cyberpunk',
    );

    return ThemeData(
      fontFamily: 'Cyberpunk',
      useMaterial3: false,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: cyberBlack,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
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
  CustomPainter? get backgroundPainter => const _CyberBackgroundPainter();

  @override
  String? get backgroundImage => 'assets/images/cyber_bg.jpg'; // Path to your JPG image

  @override
  TextStyle get editorTitleStyle => const TextStyle(
    fontFamily: 'Cyberpunk',
    color: cyberBlue,
    fontSize: 48,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
    shadows: [Shadow(color: cyberBlue, blurRadius: 12)],
  );

  // --- SEMANTIC GETTERS ---

  @override
  Color get appBarColor => Colors.transparent;
  @override
  double get appBarBlur => 8;
  @override
  Border? get appBarBorder =>
      const Border(bottom: BorderSide(color: cyberYellow, width: 2));

  @override
  Border? get navBarBorder =>
      const Border(top: BorderSide(color: cyberYellow, width: 2));

  @override
  TextStyle get appBarTitleStyle => const TextStyle(
    fontFamily: 'Cyberpunk',
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
        ? deleteIconColor.withValues(alpha: 0.12)
        : isPressed
        ? const Color.fromARGB(255, 162, 154, 0)
        : cardBackground,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isSelected
          ? deleteIconColor
          : isPressed
          ? primaryColor
          : primaryColor.withValues(alpha: 0.1),
      width: isSelected ? 2 : 2,
    ),
    boxShadow: [
      if (isSelected && useGlowEffects)
        BoxShadow(color: deleteIconColor.withValues(alpha: 0.25), blurRadius: 12),
      if (isPressed && !isSelected && useGlowEffects)
        BoxShadow(color: primaryColor.withValues(alpha: 0.2), blurRadius: 10),
    ],
  );

  @override
  TextStyle get entrySubtitleStyle => const TextStyle(
    fontFamily: 'Cyberpunk',
    color: Color(0xFFE0E0E0), // Colors.grey[300]
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );
  @override
  TextStyle get entryTitleStyle => const TextStyle(
    fontFamily: 'Cyberpunk',
    color: cyberYellow,
    fontSize: 22,
    fontWeight: FontWeight.w900,
  );
  @override
  Color get deleteIconColor => cyberRed;
  @override
  BoxDecoration get emptyStateIconDecoration =>
      const BoxDecoration(shape: BoxShape.rectangle);
  @override
  Color get emptyStateIconColor => Colors.white.withValues(alpha: 0.75);

  @override
  BoxDecoration get dialogDecoration => BoxDecoration(
    color: primaryColor.withValues(alpha: 0.1),
    border: Border.all(color: primaryColor, width: 2),
    boxShadow: [
      BoxShadow(color: primaryColor.withValues(alpha: 0.2), blurRadius: 20),
    ],
  );
  @override
  double get dialogBlur => 8;
  @override
  String getDialogTitle(String type) =>
      type == 'warning' ? 'CRITICAL_OVERRIDE' : 'SYSTEM_ALERT';
  @override
  String getDialogMessage(String type) => type == 'warning'
      ? 'Delete the selected item from this list?'
      : 'Operation in progress...';
  @override
  TextStyle get dialogTitleStyle => const TextStyle(
    fontFamily: 'Cyberpunk',
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );
  @override
  TextStyle get dialogMessageStyle => TextStyle(
    fontFamily: 'Cyberpunk',
    color: Colors.white.withValues(alpha: 0.7),
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.normal,
  );

  @override
  BoxDecoration getDialogIconDecoration(Color baseColor) =>
      const BoxDecoration(shape: BoxShape.rectangle);

  @override
  String getDialogConfirmLabel(String type) => 'INITIATE';
  @override
  String getDialogCancelLabel(String type) => 'ABORT';

  @override
  BoxDecoration getDialogButtonDecoration(Color baseColor) => BoxDecoration(
    color: baseColor.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(4),
    border: Border.all(color: baseColor.withValues(alpha: 0.5), width: 1),
  );
  @override
  TextStyle getDialogButtonTextStyle(Color baseColor) => TextStyle(
    fontFamily: 'Cyberpunk',
    color: baseColor == Colors.white38 ? Colors.white54 : baseColor,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
    fontSize: 14,
  );

  @override
  BoxDecoration getThemeItemDecoration(bool isSelected) => BoxDecoration(
    color: isSelected ? const Color.fromARGB(255, 0, 99, 112) : cardBackground,
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
  TextStyle get themeItemTitleStyle => TextStyle(
    fontFamily: 'Cyberpunk',
    color: primaryColor,
    fontSize: 18,
    fontWeight: FontWeight.w900,
  );
  @override
  TextStyle get themeItemStatusStyle => TextStyle(
    fontFamily: 'Cyberpunk',
    color: Colors.white.withValues(alpha: 0.6),
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
  double get fabElevation => 0.0; // Flat UI look for Cyberpunk

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
  String get notesTabLabel => 'NOTES';
  @override
  String get todosTabLabel => 'TODOS';
  @override
  IconData get notesTabIcon => Icons.notes_rounded;
  @override
  IconData get todosTabIcon => Icons.checklist_rounded;

  @override
  Color get dialogBarrierColor => secondaryColor.withValues(alpha: 0.2);
}

class _CyberBackgroundPainter extends CustomPainter {
  const _CyberBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // 2. Subtle Tech Hex Grid / Circuitry Base
    _drawCircuitry(canvas, size);

    // 3. Perspective Grid at Bottom
    _drawPerspectiveGrid(canvas, size);

    // 4. Tech "HUD" Elements (Corner accents)
    _drawHUDelements(canvas, size);

    // 5. Scanlines (Very subtle)
    final scanPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.015)
      ..strokeWidth = 1.0;
    for (var i = 0.0; i < size.height; i += 3) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), scanPaint);
    }
  }

  void _drawCircuitry(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CyberTheme.cyberBlue.withValues(alpha: 0.03)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = CyberTheme.cyberBlue.withValues(alpha: 0.05)
      ..strokeWidth = 2.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final random = math.Random(42); // Seeded for consistency

    for (var i = 0; i < 15; i++) {
      final startX = random.nextDouble() * size.width;
      final startY = random.nextDouble() * size.height;
      final length = 50.0 + random.nextDouble() * 150.0;
      final isVertical = random.nextBool();

      final path = Path()..moveTo(startX, startY);
      if (isVertical) {
        path.lineTo(startX, startY + length);
        path.lineTo(
          startX + (random.nextBool() ? 20 : -20),
          startY + length + 20,
        );
      } else {
        path.lineTo(startX + length, startY);
        path.lineTo(
          startX + length + 20,
          startY + (random.nextBool() ? 20 : -20),
        );
      }

      canvas.drawPath(path, paint);
      if (random.nextDouble() > 0.7) {
        canvas.drawPath(path, glowPaint);
      }
    }
  }

  void _drawPerspectiveGrid(Canvas canvas, Size size) {
    final horizonY = size.height * 0.65;
    final gridPaint = Paint()
      ..color = CyberTheme.cyberRed.withValues(alpha: 0.08)
      ..strokeWidth = 1.5;

    final glowPaint = Paint()
      ..color = CyberTheme.cyberRed.withValues(alpha: 0.15)
      ..strokeWidth = 2.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    // Vanishing point lines
    for (var i = -size.width * 0.5; i <= size.width * 1.5; i += 60) {
      canvas.drawLine(
        Offset(size.width / 2, horizonY),
        Offset(i, size.height),
        gridPaint,
      );
    }

    // Horizontal lines with perspective scaling
    for (var i = 0.0; i <= 10; i++) {
      final y = horizonY + (size.height - horizonY) * math.pow(i / 10, 2);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      if (i == 0 || i == 10) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), glowPaint);
      }
    }
  }

  void _drawHUDelements(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CyberTheme.cyberYellow.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Top-left corner bracket
    canvas.drawPath(
      Path()
        ..moveTo(20, 60)
        ..lineTo(20, 20)
        ..lineTo(60, 20),
      paint,
    );

    // Bottom-right corner bracket
    canvas.drawPath(
      Path()
        ..moveTo(size.width - 20, size.height - 60)
        ..lineTo(size.width - 20, size.height - 20)
        ..lineTo(size.width - 60, size.height - 20),
      paint,
    );

    // Some decorative "bits"
    final bitPaint = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < 3; i++) {
      bitPaint.color = CyberTheme.cyberYellow.withValues(
        alpha: 0.05 + (i * 0.05),
      );
      canvas.drawRect(
        Rect.fromLTWH(size.width - 40, 40.0 + (i * 15), 10, 8),
        bitPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CyberBackgroundPainter oldDelegate) => false;
}
