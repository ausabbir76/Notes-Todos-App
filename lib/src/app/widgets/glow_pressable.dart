import 'package:flutter/material.dart';
import '../theme/theme_controller.dart';
import '../app_constants.dart';

class GlowPressable extends StatefulWidget {
  const GlowPressable({
    this.child,
    this.builder,
    required this.onTap,
    this.onLongPress,
    this.glowColor,
    this.borderRadius,
    this.padding,
    this.delay = const Duration(milliseconds: 150),
    this.enableGlow = true,
    super.key,
  });

  final Widget? child;
  final Widget Function(BuildContext context, bool isPressed, Widget? child)? builder;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? glowColor;
  final double? borderRadius;
  final EdgeInsets? padding;
  final Duration delay;
  final bool enableGlow;

  @override
  State<GlowPressable> createState() => _GlowPressableState();
}

class _GlowPressableState extends State<GlowPressable> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null || widget.onLongPress != null) {
      setState(() => _isPressed = true);
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isPressed) {
      setState(() => _isPressed = false);
    }
  }

  void _handleTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
    }
  }

  Future<void> _handleTap() async {
    if (widget.onTap == null) return;
    
    // Briefly keep the pressed state if it was a very fast tap
    if (!_isPressed) {
      setState(() => _isPressed = true);
      await Future.delayed(const Duration(milliseconds: 50));
      if (mounted) setState(() => _isPressed = false);
    }
    
    widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController().currentTheme;
    final glowColor = widget.glowColor ?? theme.primaryColor;
    final br = widget.borderRadius ?? 12.0;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap != null ? _handleTap : null,
      onLongPress: widget.onLongPress,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: _isPressed ? Duration.zero : AppConstants.feedbackDuration,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: Colors.transparent, // Explicitly set to help with shadow rendering
          borderRadius: BorderRadius.circular(br),
          boxShadow: [
            if (_isPressed && widget.enableGlow) ...[
              BoxShadow(
                color: glowColor.withValues(alpha: 0.6),
                blurRadius: 18,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: glowColor.withValues(alpha: 0.35),
                blurRadius: 32,
                spreadRadius: 4,
              ),
            ],
          ],
        ),
        child: Center(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: widget.builder?.call(context, _isPressed, widget.child) ?? widget.child,
        ),
      ),
    );
  }
}
