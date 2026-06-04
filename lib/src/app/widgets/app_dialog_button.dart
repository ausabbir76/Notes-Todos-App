import 'package:flutter/material.dart';

import '../layout/app_scale.dart';
import '../theme/models/app_theme.dart';
import '../theme/theme_controller.dart';
import 'glow_pressable.dart';

class AppDialogButton extends StatelessWidget {
  const AppDialogButton({
    required this.label,
    required this.color,
    required this.onTap,
    this.compact = false,
    super.key,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController().currentTheme;
    final effectiveColor = _effectiveColor(theme);
    return GlowPressable(
      onTap: onTap,
      glowColor: effectiveColor,
      borderRadius: theme.borderRadius > 0 ? 15 : 4,
      child: Container(
        padding: compact
            ? const EdgeInsets.symmetric(vertical: 14, horizontal: 20)
            : AppScale.symmetric(vertical: 16, horizontal: 24),
        decoration: theme.getDialogButtonDecoration(effectiveColor),
        child: Center(
          child: Text(
            label,
            style: theme.getDialogButtonTextStyle(effectiveColor).copyWith(
              fontSize: compact ? 14 : null,
              letterSpacing: compact ? 1 : null,
            ),
          ),
        ),
      ),
    );
  }

  Color _effectiveColor(AppTheme theme) {
    if (color != Colors.white38) return color;
    if (theme.type == ThemeType.lightNoir ||
        theme.type == ThemeType.orangeLight) {
      return theme.primaryColor;
    }
    return color;
  }
}
