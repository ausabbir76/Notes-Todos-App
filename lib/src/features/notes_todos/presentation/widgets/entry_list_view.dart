import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../app/layout/app_scale.dart';
import '../../../../app/theme/models/app_theme.dart';
import '../../../../app/theme/theme_controller.dart';

typedef EntryCardBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  AppTheme theme,
  bool selected,
  Widget? dragHandle,
);

class EntryListView<T> extends StatefulWidget {
  const EntryListView({
    required this.items,
    required this.loading,
    required this.selectedIds,
    required this.reorderMode,
    required this.onReorder,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.idOf,
    required this.cardBuilder,
    required this.theme,
    super.key,
  });

  final List<T> items;
  final bool loading;
  final Set<int> selectedIds;
  final bool reorderMode;
  final void Function(int, int) onReorder;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptySubtitle;
  final int? Function(T item) idOf;
  final EntryCardBuilder<T> cardBuilder;
  final AppTheme theme;

  @override
  State<EntryListView<T>> createState() => _EntryListViewState<T>();
}

class _EntryListViewState<T> extends State<EntryListView<T>> {
  final _listKey = GlobalKey<AnimatedListState>();
  late List<T> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  @override
  void didUpdateWidget(covariant EntryListView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.reorderMode) {
      _syncItems(widget.items);
    } else {
      _items = List.of(widget.items);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final listPadding = EdgeInsets.only(
      top: MediaQuery.of(context).padding.top + AppScale.size(12),
      bottom: MediaQuery.of(context).padding.bottom ,
      left: AppScale.size(20),
      right: AppScale.size(20),
    );
    if (widget.loading && _items.isEmpty) return const SizedBox.shrink();

    if (widget.reorderMode) {
      return Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Stack(
          children: [
            ReorderableListView.builder(
              padding: listPadding,
              itemCount: _items.length,
              onReorder: widget.onReorder,
              buildDefaultDragHandles: false,
              clipBehavior: Clip.none,
              proxyDecorator: (child, index, animation) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, _) =>
                      Material(color: Colors.transparent, child: child),
                );
              },
              itemBuilder: (context, index) {
                final item = _items[index];
                final itemId = widget.idOf(item);
                return Padding(
                  key: ValueKey(itemId),
                  padding: AppScale.only(bottom: theme.listItemSpacing),
                  child: widget.cardBuilder(
                    context,
                    item,
                    theme,
                    widget.selectedIds.contains(itemId),
                    ReorderableDragStartListener(
                      index: index,
                      child: Icon(
                        Icons.drag_indicator,
                        color: theme.appBarIconColor.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                );
              },
            ),
            if (_items.isEmpty)
              _EmptyState(
                icon: widget.emptyIcon,
                title: widget.emptyTitle,
                subtitle: widget.emptySubtitle,
              ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        AnimatedList(
          padding: listPadding,
          key: _listKey,
          initialItemCount: _items.length,
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.none,
          itemBuilder: (context, index, animation) {
            final item = _items[index];
            final itemId = widget.idOf(item);
            return _animatedItem(
              animation,
              widget.cardBuilder(
                context,
                item,
                theme,
                widget.selectedIds.contains(itemId),
                null,
              ),
              theme: theme,
            );
          },
        ),
        if (_items.isEmpty)
          _EmptyState(
            icon: widget.emptyIcon,
            title: widget.emptyTitle,
            subtitle: widget.emptySubtitle,
          ),
      ],
    );
  }

  void _syncItems(List<T> next) {
    final nextIds = next.map(widget.idOf).toList();

    // 1. Handle Removals
    for (int i = _items.length - 1; i >= 0; i--) {
      final id = widget.idOf(_items[i]);
      if (!nextIds.contains(id)) {
        final removedItem = _items.removeAt(i);
        _listKey.currentState?.removeItem(
          i,
          (context, animation) => _animatedItem(
            animation,
            widget.cardBuilder(context, removedItem, widget.theme, false, null),
            theme: widget.theme,
          ),
          duration: const Duration(milliseconds: 600),
        );
      }
    }

    // 2. Handle Insertions, Moves, and Content Updates
    int i = 0;
    while (i < next.length) {
      final nextId = nextIds[i];
      
      if (i >= _items.length) {
        // Simple append
        _items.add(next[i]);
        _listKey.currentState?.insertItem(i, duration: const Duration(milliseconds: 800));
        i++;
      } else if (widget.idOf(_items[i]) != nextId) {
        // It's either a move or a new insertion
        final oldIndex = _items.indexWhere((item) => widget.idOf(item) == nextId);
        
        if (oldIndex != -1) {
          // It's a move: remove from old, will insert at current i in next iteration
          final movedItem = _items.removeAt(oldIndex);
          _listKey.currentState?.removeItem(
            oldIndex,
            (context, animation) => _animatedItem(
              animation,
              widget.cardBuilder(context, movedItem, widget.theme, false, null),
              theme: widget.theme,
            ),
            duration: const Duration(milliseconds: 400),
          );
          // Re-check this index i against nextId in next iteration
          continue;
        } else {
          // It's a new insertion
          _items.insert(i, next[i]);
          _listKey.currentState?.insertItem(i, duration: const Duration(milliseconds: 800));
          i++;
        }
      } else {
        // IDs match, update content (important for edits!)
        _items[i] = next[i];
        i++;
      }
    }

    // Crucial: trigger rebuild so builders see the new _items data
    if (mounted) setState(() {});
  }
}

Widget _animatedItem(
  Animation<double> animation,
  Widget child, {
  required AppTheme theme,
}) {
  return RepaintBoundary(
    child: Padding(
      padding: AppScale.only(bottom: theme.listItemSpacing),
      child: SizeTransition(
        axisAlignment: -1.0,
        sizeFactor: CurvedAnimation(
          parent: animation,
          // Space opens/closes in the first part of insertion/last part of removal
          curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
          reverseCurve: const Interval(0.0, 0.5, curve: Curves.easeInCubic),
        ),
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            // Card fades in the second part of insertion/first part of removal
            curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
            reverseCurve: const Interval(0.5, 1.0, curve: Curves.easeIn),
          ),
          child: ScaleTransition(
            scale: animation.drive(
              Tween<double>(begin: 0.85, end: 1.0).chain(
                CurveTween(
                  curve: const Interval(0.5, 1.0, curve: Curves.easeOutBack),
                ),
              ),
            ),
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    ),
  );
}

class _EmptyState extends StatefulWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  State<_EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<_EmptyState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeController(),
      builder: (context, _) {
        final controller = ThemeController();
        final theme = controller.currentTheme;
        final scale = controller.textScale;
        return Center(
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(theme.borderRadius),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: theme.dialogBlur,
                    sigmaY: theme.dialogBlur,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    padding: AppScale.symmetric(horizontal: 24, vertical: 24),
                    decoration: theme.dialogDecoration,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          width: 82 * scale,
                          height: 82 * scale,
                          decoration: theme.emptyStateIconDecoration,
                          child: Icon(
                            widget.icon,
                            size: 52 * scale,
                            color: theme.emptyStateIconColor,
                          ),
                        ),
                        SizedBox(height: AppScale.size(20)),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 400),
                          style: theme.appBarTitleStyle.copyWith(
                            fontSize: 22 * scale,
                            height: 1,
                            letterSpacing: 0,
                            decoration: TextDecoration.none,
                          ),
                          child: Text(widget.title),
                        ),
                        SizedBox(height: AppScale.size(16)),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 400),
                          style: theme.entrySubtitleStyle.copyWith(
                            fontSize: 16 * scale,
                            height: 1,
                            letterSpacing: 0,
                            decoration: TextDecoration.none,
                            color: theme.entrySubtitleStyle.color
                                ?.withValues(alpha: 0.72),
                          ),
                          child: Text(widget.subtitle),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
