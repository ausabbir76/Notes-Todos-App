import 'dart:ui';
import 'package:flutter/material.dart';
import '../../layout/app_scale.dart';
import '../../widgets/app_dialog_button.dart';
import '../../widgets/glow_pressable.dart';
import '../../widgets/neon_background.dart';
import '../models/app_theme.dart';
import '../theme_controller.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  late final List<AppTheme> _themes;
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _themes = ThemeController().availableThemes;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeController(),
      builder: (context, _) {
        final controller = ThemeController();
        final currentTheme = controller.currentTheme;
        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: currentTheme.appBarBlur,
                  sigmaY: currentTheme.appBarBlur,
                ),
                child: AppBar(
                  backgroundColor: currentTheme.appBarColor,
                  elevation: 0,
                  title: Text('THEMES', style: currentTheme.appBarTitleStyle),
                  centerTitle: true,
                  leading: Center(
                    child: GlowPressable(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: 30,
                      child: Padding(
                        padding: AppScale.symmetric(horizontal: 8, vertical: 8),
                        child: Icon(
                          currentTheme.icons.back,
                          color: currentTheme.appBarIconColor,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    Center(
                      child: GlowPressable(
                        onTap: _showThemeMenu,
                        borderRadius: currentTheme.borderRadius,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.more_vert,
                            color: currentTheme.appBarIconColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  shape: currentTheme.appBarBorder,
                ),
              ),
            ),
          ),
          body: NeonBackground(
            theme: currentTheme,
            child: ListView.builder(
              itemCount: _themes.length,
              padding: EdgeInsets.only(
                top:
                    MediaQuery.of(context).padding.top +
                    kToolbarHeight +
                    AppScale.size(12),
                bottom:
                    MediaQuery.of(context).padding.bottom + AppScale.size(12),
                left: AppScale.size(20),
                right: AppScale.size(20),
              ),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final theme = _themes[index];
                final isSelected = currentTheme.type == theme.type;

                return Padding(
                  padding: AppScale.only(bottom: 12),
                  child: _ThemeItemWidget(
                    theme: theme,
                    isSelected: isSelected,
                    currentActiveTheme: currentTheme,
                    onTap: () => controller.setTheme(theme.type),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showThemeMenu() {
    if (_isMenuOpen) return;
    _isMenuOpen = true;
    final controller = ThemeController();
    final theme = controller.currentTheme;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: const Cubic(0.175, 0.885, 0.32, 1.275),
          reverseCurve: Curves.easeInCubic,
        );
        final scaleAnimation = Tween<double>(
          begin: 0.9,
          end: 1.0,
        ).animate(curve);

        return ScaleTransition(
          scale: scaleAnimation,
          alignment: Alignment.topRight,
          child: FadeTransition(
            opacity: animation,
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(
                  top:
                      MediaQuery.of(context).padding.top +
                      kToolbarHeight +
                      AppScale.size(18),
                  right: AppScale.size(26.5),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(theme.borderRadius),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: theme.dialogBlur,
                          sigmaY: theme.dialogBlur,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: theme.dialogDecoration,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AppDialogButton(
                                label: controller.followSystem
                                    ? 'DISABLE FOLLOW SYSTEM'
                                    : 'ENABLE FOLLOW SYSTEM',
                                color: theme.primaryColor,
                                onTap: () {
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.pop(context);
                                  }
                                  controller.setFollowSystem(
                                    !controller.followSystem,
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              AppDialogButton(
                                label: 'CLOSE',
                                color: Colors.white38,
                                onTap: () {
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ).then((_) => _isMenuOpen = false);
  }
}

class _ThemeItemWidget extends StatelessWidget {
  const _ThemeItemWidget({
    required this.theme,
    required this.isSelected,
    required this.currentActiveTheme,
    required this.onTap,
  });

  final AppTheme theme;
  final bool isSelected;
  final AppTheme currentActiveTheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlowPressable(
      onTap: onTap,
      borderRadius: currentActiveTheme.borderRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: AppScale.symmetric(horizontal: 12, vertical: 12),
        decoration: currentActiveTheme.getThemeItemDecoration(isSelected),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: currentActiveTheme.type == ThemeType.retro
                    ? BoxShape.rectangle
                    : BoxShape.circle,
                borderRadius: currentActiveTheme.type == ThemeType.retro
                    ? BorderRadius.zero
                    : null,
                gradient: LinearGradient(
                  colors: [theme.primaryColor, theme.secondaryColor],
                ),
                border: currentActiveTheme.type == ThemeType.retro
                    ? Border.all(
                        color: currentActiveTheme.primaryColor,
                        width: 2,
                      )
                    : null,
              ),
              child: Icon(
                isSelected
                    ? currentActiveTheme.icons.check
                    : theme.icons.settings,
                color: currentActiveTheme.type == ThemeType.retro
                    ? currentActiveTheme.backgroundDark
                    : Colors.white,
              ),
            ),
            SizedBox(width: AppScale.size(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    theme.name.toUpperCase(),
                    style: currentActiveTheme.themeItemTitleStyle,
                  ),
                  SizedBox(height: AppScale.size(4)),
                  Text(
                    isSelected ? 'SYSTEM ACTIVE' : 'TAP TO INITIALIZE',
                    style: currentActiveTheme.themeItemStatusStyle,
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? currentActiveTheme.icons.check
                  : currentActiveTheme.icons.arrowForward,
              color: currentActiveTheme.type == ThemeType.retro
                  ? currentActiveTheme.primaryColor
                  : Colors.white24,
            ),
          ],
        ),
      ),
    );
  }
}
