import 'package:flutter/material.dart';

import '../../../../app/layout/app_scale.dart';
import '../../../../app/theme/models/app_theme.dart';
import '../../../../app/theme/theme_controller.dart';
import '../../../../app/widgets/glow_pressable.dart';
import '../../domain/note_item.dart';
import '../../domain/todo_list_item.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    required this.note,
    required this.theme,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
    this.dragHandle,
    super.key,
  });

  final NoteItem note;
  final AppTheme theme;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Widget? dragHandle;

  @override
  Widget build(BuildContext context) {
    final scale = ThemeController().textScale;
    final content = note.content.isEmpty ? 'No content' : note.content;
    final contentStyle = theme.entrySubtitleStyle.copyWith(
      height: 1.45,
      fontSize: 16 * scale,
    );

    return _ThemedEntryShell(
      theme: theme,
      selected: selected,
      onTap: onTap,
      onLongPress: onLongPress,
      dragHandle: dragHandle,
      enableGlow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  note.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.entryTitleStyle.copyWith(
                    fontSize: 20 * scale,
                  ),
                ),
              ),
              if (note.pinned)
                Icon(Icons.push_pin, color: theme.primaryColor, size: 20 * scale),
              if (note.archived)
                Icon(Icons.archive, color: theme.appBarIconColor.withValues(alpha: 0.5), size: 20 * scale),
              if (note.deletedAt != null)
                Icon(Icons.delete_outline, color: theme.deleteIconColor, size: 20 * scale),
            ],
          ),
          SizedBox(height: AppScale.size(10)),
          LayoutBuilder(
            builder: (context, constraints) {
              final span = TextSpan(text: content, style: contentStyle);
              final tp = TextPainter(
                text: span,
                maxLines: 7,
                textDirection: TextDirection.ltr,
              );
              tp.layout(maxWidth: constraints.maxWidth);
              final isOverflowing = tp.didExceedMaxLines;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content,
                    maxLines: 7,
                    overflow: TextOverflow.clip,
                    style: contentStyle,
                  ),
                  if (isOverflowing)
                    Padding(
                      padding: AppScale.only(top: 2),
                      child: Text('. . .', style: contentStyle),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class TodoCard extends StatelessWidget {
  const TodoCard({
    required this.todo,
    required this.theme,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
    this.dragHandle,
    super.key,
  });

  final TodoListItem todo;
  final AppTheme theme;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Widget? dragHandle;

  @override
  Widget build(BuildContext context) {
    final scale = ThemeController().textScale;
    final visibleTasks = todo.tasks.take(7).toList();
    return _ThemedEntryShell(
      theme: theme,
      selected: selected,
      onTap: onTap,
      onLongPress: onLongPress,
      dragHandle: dragHandle,
      enableGlow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  todo.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.entryTitleStyle.copyWith(fontSize: 20 * scale),
                ),
              ),
              if (todo.pinned)
                Icon(Icons.push_pin, color: theme.primaryColor, size: 20 * scale),
              if (todo.archived)
                Icon(Icons.archive, color: theme.appBarIconColor.withValues(alpha: 0.5), size: 20 * scale),
              if (todo.deletedAt != null)
                Icon(Icons.delete_outline, color: theme.deleteIconColor, size: 20 * scale),
            ],
          ),
          SizedBox(height: AppScale.size(12)),
          if (visibleTasks.isEmpty)
            Text(
              'No items yet',
              style: theme.entrySubtitleStyle.copyWith(
                height: 1.4,
                fontSize: (theme.entrySubtitleStyle.fontSize ?? 16) * scale,
              ),
            )
          else ...[
            for (var i = 0; i < visibleTasks.length; i++)
              Padding(
                padding: AppScale.symmetric(vertical: 2),
                child: _TodoTaskPreviewRow(
                  text: visibleTasks[i].text,
                  completed: visibleTasks[i].completed,
                  theme: theme,
                  scale: scale,
                ),
              ),
            if (todo.tasks.length > 7)
              Padding(
                padding: AppScale.only(top: 2, left: 28),
                child: Text(
                  '. . .', 
                  style: theme.entrySubtitleStyle.copyWith(
                    fontSize: (theme.entrySubtitleStyle.fontSize ?? 16) * scale,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _TodoTaskPreviewRow extends StatelessWidget {
  const _TodoTaskPreviewRow({
    required this.text,
    required this.completed,
    required this.theme,
    required this.scale,
  });

  final String text;
  final bool completed;
  final AppTheme theme;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          completed ? Icons.check_box : Icons.check_box_outline_blank,
          color: completed
              ? theme.primaryColor
              : theme.appBarIconColor.withValues(alpha: 0.55),
          size: 20 * scale,
        ),
        SizedBox(width: AppScale.size(8) * scale),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.entrySubtitleStyle.copyWith(
              fontSize: 16 * scale,
              decoration: completed ? TextDecoration.lineThrough : null,
              color: completed
                  ? theme.appBarIconColor.withValues(alpha: 0.45)
                  : theme.entrySubtitleStyle.color,
            ),
          ),
        ),
      ],
    );
  }
}

class _ThemedEntryShell extends StatelessWidget {
  const _ThemedEntryShell({
    required this.theme,
    required this.child,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
    this.dragHandle,
    this.enableGlow = true,
  });

  final AppTheme theme;
  final Widget child;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Widget? dragHandle;
  final bool enableGlow;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        margin: AppScale.symmetric(horizontal: selected ? 4 : 0),
        child: GlowPressable(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: theme.borderRadius,
          glowColor: selected ? theme.deleteIconColor : theme.primaryColor,
          enableGlow: enableGlow,
          builder: (context, isPressed, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: double.infinity,
              padding: AppScale.symmetric(horizontal: 16, vertical: 16),
              decoration: theme.getEntryItemDecoration(
                isPressed,
                isSelected: selected,
              ),
              child: Row(
                children: [
                  Expanded(child: this.child),
                  if (dragHandle != null) ...[
                    SizedBox(width: AppScale.size(12)),
                    dragHandle!,
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
