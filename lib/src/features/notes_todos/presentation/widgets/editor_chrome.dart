import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../app/app_constants.dart';
import '../../../../app/layout/app_scale.dart';
import '../../../../app/theme/models/app_theme.dart';
import '../../../../app/widgets/glow_pressable.dart';

class EditorTopBar extends StatelessWidget implements PreferredSizeWidget {
  const EditorTopBar({
    required this.theme,
    required this.title,
    required this.onBack,
    required this.onSave,
    this.onUndo,
    super.key,
  });

  final AppTheme theme;
  final String title;
  final VoidCallback onBack;
  final VoidCallback onSave;
  final VoidCallback? onUndo;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: theme.appBarBlur,
          sigmaY: theme.appBarBlur,
        ),
        child: AppBar(
          backgroundColor: theme.appBarColor,
          elevation: 0,
          centerTitle: true,
          title: AnimatedSwitcher(
            duration: AppConstants.entranceDuration,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutBack,
                      ),
                    ),
                    child: child,
                  ),
                ),
              );
            },
            child: Text(
              title,
              key: ValueKey(title),
              style: theme.appBarTitleStyle,
            ),
          ),
          leading: Center(
            child: GlowPressable(
              onTap: onBack,
              borderRadius: 30,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  theme.icons.back,
                  size: 28,
                  color: theme.appBarIconColor,
                ),
              ),
            ),
          ),
          actions: [
            if (onUndo != null)
              Center(
                child: GlowPressable(
                  onTap: onUndo!,
                  borderRadius: 30,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      theme.icons.history,
                      size: 28,
                      color: theme.appBarIconColor.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            Center(
              child: GlowPressable(
                onTap: onSave,
                borderRadius: 30,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    theme.icons.check,
                    size: 28,
                    color: theme.primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          shape: theme.appBarBorder,
        ),
      ),
    );
  }
}

class EditorBottomTitleBar extends StatelessWidget {
  const EditorBottomTitleBar({
    required this.theme,
    required this.titleController,
    required this.titleFocusNode,
    this.textInputAction,
    super.key,
  });

  final AppTheme theme;
  final TextEditingController titleController;
  final FocusNode titleFocusNode;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: theme.appBarBlur,
            sigmaY: theme.appBarBlur,
          ),
          child: Container(
            height: kBottomNavigationBarHeight + AppScale.size(20),
            padding: AppScale.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: theme.appBarColor,
              border: theme.navBarBorder,
            ),
            child: ListenableBuilder(
              listenable: titleFocusNode,
              builder: (context, _) {
                final isEditing = titleFocusNode.hasFocus;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IgnorePointer(
                      ignoring: !isEditing,
                      child: Opacity(
                        opacity: isEditing ? 1 : 0,
                        child: TextField(
                          controller: titleController,
                          focusNode: titleFocusNode,
                          textAlign: TextAlign.center,
                          style: theme.appBarTitleStyle.copyWith(
                            color: theme.primaryColor,
                          ),
                          textInputAction: textInputAction,
                          decoration: InputDecoration(
                            hintText: 'Untitled',
                            hintStyle: theme.appBarTitleStyle.copyWith(
                              color: theme.primaryColor.withValues(alpha: 0.5),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          maxLines: 1,
                          onTapOutside: (_) => titleFocusNode.unfocus(),
                        ),
                      ),
                    ),
                    if (!isEditing)
                      GestureDetector(
                        onTap: () => titleFocusNode.requestFocus(),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: ListenableBuilder(
                            listenable: titleController,
                            builder: (context, _) {
                              final text = titleController.text;
                              return Text(
                                text.isEmpty ? 'Untitled' : text,
                                style: theme.appBarTitleStyle.copyWith(
                                  color: theme.primaryColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class EditorTimestamp extends StatelessWidget {
  const EditorTimestamp({
    required this.theme,
    required this.timestamp,
    super.key,
  });

  final AppTheme theme;
  final DateTime timestamp;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: AppScale.size(12),
      right: AppScale.size(16),
      child: Text(
        formatEditorTimestamp(timestamp),
        style: theme.entrySubtitleStyle.copyWith(
          fontSize: 11,
          color: theme.appBarIconColor.withValues(alpha: 0.4),
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}

String formatEditorTimestamp(DateTime dt) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final month = months[dt.month - 1];
  final day = dt.day;
  final year = dt.year;
  final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
  final minute = dt.minute.toString().padLeft(2, '0');
  final period = dt.hour >= 12 ? 'PM' : 'AM';
  return '$month $day, $year, $hour:$minute $period';
}
