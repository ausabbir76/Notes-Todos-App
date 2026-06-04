import 'package:flutter/material.dart';
import '../models/app_theme.dart';

class LightNoirTheme extends AppTheme {
  @override
  String get name => 'Light Noir';

  @override
  ThemeType get type => ThemeType.lightNoir;

  @override
  ThemeIcons get icons => const ThemeIcons(
    logo: Icons.lens_outlined,
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
  Color get primaryColor => Colors.black;
  @override
  Color get secondaryColor => const Color(0xFFBDBDBD);
  @override
  Color get backgroundDark => const Color(0xFFF8F8F8);
  @override
  Color get panelBackground => const Color(0xFFFFFFFF);
  @override
  Color get cardBackground => const Color(0xFFFFFFFF);

  @override
  double get borderRadius => 22;
  @override
  bool get useGlowEffects => false;

  @override
  ThemeData get themeData {
    final baseTextTheme = ThemeData.light().textTheme.apply(
      fontFamily: 'OnePlusSansRegular',
    );

    return ThemeData(
      fontFamily: 'OnePlusSansRegular',
      useMaterial3: false,
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: panelBackground,
      ),
      textTheme: baseTextTheme.copyWith(
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          color: Colors.black,
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
    color: Colors.black,
    fontSize: 48,
    fontWeight: FontWeight.bold,
  );

  @override
  Color get appBarColor => Colors.white.withValues(alpha: 0.5);
  @override
  double get appBarBlur => 8;
  @override
  Border? get appBarBorder =>
      const Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1));
  @override
  Border? get navBarBorder =>
      const Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 1));

  @override
  TextStyle get appBarTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
  );
  @override
  Color get appBarIconColor => Colors.black;

  @override
  BoxDecoration getEntryItemDecoration(
    bool isPressed, {
    bool isSelected = false,
  }) => BoxDecoration(
    color: isPressed ? Colors.black.withValues(alpha: 0.001) : cardBackground,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isSelected ? Colors.black : const Color(0xFFE0E0E0),
      width: isSelected ? 2 : 1,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.06),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ],
  );

  @override
  TextStyle get entrySubtitleStyle =>
      TextStyle(fontFamily: 'OnePlusSansRegular', color: Colors.grey.shade900, fontSize: 18);
  @override
  TextStyle get entryTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Colors.black,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );
  @override
  Color get deleteIconColor => Colors.black;
  @override
  BoxDecoration get emptyStateIconDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: Colors.black26, width: 1),
  );
  @override
  Color get emptyStateIconColor => Colors.black38;

  @override
  BoxDecoration get dialogDecoration => BoxDecoration(
    color: Colors.white.withValues(alpha: 0.5),
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.08),
        blurRadius: 28,
        offset: const Offset(0, 14),
      ),
    ],
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
    color: Colors.black,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
  );
  @override
  TextStyle get dialogMessageStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Color(0xFF555555),
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
    border: Border.all(color: const Color(0xFFCCCCCC), width: 1),
  );
  @override
  TextStyle getDialogButtonTextStyle(Color baseColor) => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  @override
  BoxDecoration getThemeItemDecoration(bool isSelected) => BoxDecoration(
    color: isSelected ? const Color(0xFFF1F1F1) : cardBackground,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isSelected ? Colors.black : const Color(0xFFE0E0E0),
      width: 1,
    ),
  );
  @override
  TextStyle get themeItemTitleStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  @override
  TextStyle get themeItemStatusStyle => const TextStyle(
    fontFamily: 'OnePlusSansRegular',
    color: Color(0xFF777777),
    fontSize: 11,
    fontWeight: FontWeight.bold,
  );

  @override
  Color get fabBackgroundColor => Colors.black;
  @override
  Color get fabForegroundColor => Colors.white;
  @override
  Color get fabDeleteBackgroundColor => Colors.black;
  @override
  Color get fabDeleteForegroundColor => Colors.white;

  @override
  ShapeBorder get fabShape =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius));
  @override
  ShapeBorder get fabDeleteShape =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius));
  @override
  double get fabElevation => 0.0;

  @override
  BoxDecoration get appBarLogoDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(borderRadius / 2),
    color: Colors.black12,
  );

  @override
  BoxDecoration getTabDecoration(bool active) => BoxDecoration(
    color: active ? Colors.black : Colors.transparent,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: Colors.black, width: 1),
  );

  @override
  Color get navBarSelectedItemColor => Colors.black;
  @override
  Color get navBarUnselectedItemColor => Colors.black38;

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
