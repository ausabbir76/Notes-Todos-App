import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/app_theme.dart';
import 'implementations/neon_theme.dart';
import 'implementations/classic_theme.dart';
import 'implementations/retro_theme.dart';
import 'implementations/cyber_theme.dart';
import 'implementations/synthwave_theme.dart';
import 'implementations/glass_theme.dart';
import 'implementations/amber_glass_theme.dart';
import 'implementations/black_white_theme.dart';
import 'implementations/legacy_red_black_theme.dart';
import 'implementations/legacy_red_light_theme.dart';
import 'implementations/light_noir_theme.dart';
import 'implementations/orange_light_theme.dart';
import 'implementations/orange_dark_theme.dart';

class ThemeController extends ChangeNotifier with WidgetsBindingObserver {
  static final ThemeController _instance = ThemeController._internal();
  factory ThemeController() => _instance;

  ThemeController._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  AppTheme _currentTheme = BlackWhiteTheme();
  AppTheme get currentTheme => _currentTheme;

  bool _followSystem = false;
  bool get followSystem => _followSystem;

  double _textScale = 1.0;
  double get textScale => _textScale;

  final List<AppTheme> availableThemes = [
    NeonTheme(),
    RetroTheme(),
    CyberTheme(),
    SynthwaveTheme(),
    ClassicTheme(),
    GlassTheme(),
    AmberGlassTheme(),
    BlackWhiteTheme(),
    LightNoirTheme(),
    LegacyRedBlackTheme(),
    LegacyRedLightTheme(),
    OrangeDarkTheme(),
    OrangeLightTheme(),
  ];

  bool _isSettingTheme = false;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _followSystem = prefs.getBool('theme_follow_system') ?? false;
    _textScale = 1.0;

    final savedTypeIndex = prefs.getInt('theme_type_index');
    ThemeType? themeType;

    if (savedTypeIndex != null && savedTypeIndex < ThemeType.values.length) {
      themeType = ThemeType.values[savedTypeIndex];
    }

    if (_followSystem) {
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      if (themeType == null || !_isPairableTheme(themeType)) {
        themeType = brightness == Brightness.light ? ThemeType.lightNoir : ThemeType.blackWhite;
      } else {
        themeType = _getSyncedThemeType(themeType, brightness);
      }
    } else {
      themeType ??= ThemeType.blackWhite;
    }

    _currentTheme = availableThemes.firstWhere(
      (t) => t.type == themeType,
      orElse: () => BlackWhiteTheme(),
    );
  }

  @override
  void didChangePlatformBrightness() {
    if (!_followSystem) return;
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    
    if (_isPairableTheme(_currentTheme.type)) {
      final newType = _getSyncedThemeType(_currentTheme.type, brightness);
      if (newType != _currentTheme.type) {
        setTheme(newType, saveToPrefs: true);
      }
    }
  }

  bool _isPairableTheme(ThemeType type) {
    return type == ThemeType.blackWhite ||
           type == ThemeType.lightNoir ||
           type == ThemeType.legacyRedBlack ||
           type == ThemeType.legacyRedLight ||
           type == ThemeType.orangeLight ||
           type == ThemeType.orangeDark;
  }

  ThemeType _getSyncedThemeType(ThemeType current, Brightness brightness) {
    final isLight = brightness == Brightness.light;
    if (current == ThemeType.blackWhite || current == ThemeType.lightNoir) {
      return isLight ? ThemeType.lightNoir : ThemeType.blackWhite;
    }
    if (current == ThemeType.legacyRedBlack || current == ThemeType.legacyRedLight) {
      return isLight ? ThemeType.legacyRedLight : ThemeType.legacyRedBlack;
    }
    if (current == ThemeType.orangeLight || current == ThemeType.orangeDark) {
      return isLight ? ThemeType.orangeLight : ThemeType.orangeDark;
    }
    return current;
  }

  Future<void> setTheme(ThemeType type, {bool saveToPrefs = true}) async {
    if (_currentTheme.type == type || _isSettingTheme) return;

    _isSettingTheme = true;
    try {
      _currentTheme = availableThemes.firstWhere((t) => t.type == type);
      notifyListeners();

      if (saveToPrefs) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('theme_type_index', type.index);
      }
    } finally {
      _isSettingTheme = false;
    }
  }

  Future<void> setFollowSystem(bool value) async {
    if (_followSystem == value) return;
    _followSystem = value;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('theme_follow_system', value);
    
    if (_followSystem) {
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      ThemeType targetType;
      
      if (_isPairableTheme(_currentTheme.type)) {
        targetType = _getSyncedThemeType(_currentTheme.type, brightness);
      } else {
        targetType = brightness == Brightness.light ? ThemeType.lightNoir : ThemeType.blackWhite;
      }
      
      await setTheme(targetType);
    }
    
    notifyListeners();
  }

  Future<void> setTextScale(double scale) async {
    final clamped = scale.clamp(0.8, 2.5);
    if ((_textScale - clamped).abs() < 0.01) return;
    
    _textScale = clamped;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('theme_text_scale', _textScale);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
