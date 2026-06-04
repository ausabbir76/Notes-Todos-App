import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:notes_todos/src/app/theme/presentation/theme_screen.dart';

import '../../../app/layout/app_scale.dart';
import '../../../app/theme/models/app_theme.dart';
import '../../../app/theme/theme_controller.dart';
import '../../../app/widgets/app_dialog_button.dart';
import '../../../app/widgets/glow_pressable.dart';
import '../../../app/widgets/neon_background.dart';
import '../domain/note_item.dart';
import '../domain/todo_list_item.dart';
import '../domain/todo_task.dart';
import 'note_editor_screen.dart';
import 'notes_todos_controller.dart';
import 'stats_screen.dart';
import 'todo_editor_screen.dart';
import 'widgets/entry_list_view.dart';
import 'widgets/entry_cards.dart';

enum _HomeTab { notes, todos }

enum _SelectionKind { note, todo }

class NotesTodosScreen extends StatefulWidget {
  const NotesTodosScreen({super.key, NotesTodosController? controller})
    : _providedController = controller;

  final NotesTodosController? _providedController;

  @override
  State<NotesTodosScreen> createState() => _NotesTodosScreenState();
}

class _NotesTodosScreenState extends State<NotesTodosScreen> {
  late final NotesTodosController _controller;
  late final PageController _pageController;
  late final TextEditingController _searchController;
  late final Listenable _rebuildListenable;
  _HomeTab _tab = _HomeTab.notes;
  _SelectionKind? _selectedKind;
  final Set<int> _selectedIds = {};
  bool _isNavigating = false;
  bool _isReorderMode = false;
  bool _isSearchVisible = false;
  bool _isMenuOpen = false;
  double _baseScale = 1.0;

  bool get _hasSelection => _selectedIds.isNotEmpty;
  bool get _hasSelectableItems => _currentTabIds().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller = widget._providedController ?? NotesTodosController();
    _pageController = PageController(initialPage: _tab.index);
    _searchController = TextEditingController();
    _rebuildListenable = Listenable.merge([_controller, ThemeController()]);
  }

  @override
  void dispose() {
    if (widget._providedController == null) {
      _controller.dispose();
    }
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _rebuildListenable,
      builder: (context, _) {
        final theme = ThemeController().currentTheme;
        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: _buildAppBar(theme),
          floatingActionButton: _buildFab(theme),
          bottomNavigationBar: _buildBottomNav(theme),
          body: GestureDetector(
            onScaleStart: (_) => _baseScale = ThemeController().textScale,
            onScaleUpdate: (details) {
              if (details.pointerCount >= 2) {
                ThemeController().setTextScale(_baseScale * details.scale);
              }
            },
            child: NeonBackground(
              theme: theme,
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _tab = _HomeTab.values[index];
                          _selectedKind = null;
                          _selectedIds.clear();
                        });
                      },
                      children: [
                        EntryListView<NoteItem>(
                          items: _controller.notes,
                          loading: _controller.loading,
                          reorderMode: _isReorderMode,
                          onReorder: _controller.reorderNotes,
                          selectedIds: _selectedKind == _SelectionKind.note
                              ? _selectedIds
                              : const {},
                          emptyIcon: theme.notesTabIcon,
                          emptyTitle: _controller.viewState == ViewState.active
                              ? 'No Notes Yet'
                              : _controller.viewState == ViewState.archived
                              ? 'No Archived Notes'
                              : 'Trash is Empty',
                          emptySubtitle:
                              _controller.viewState == ViewState.active
                              ? "Tap the '+' icon to create one"
                              : "Items here are archived or deleted",
                          idOf: (item) => item.id,
                          theme: theme,
                          cardBuilder:
                              (context, item, theme, selected, dragHandle) {
                                return NoteCard(
                                  note: item,
                                  theme: theme,
                                  selected: selected,
                                  onTap: () => _handleNoteTap(item),
                                  onLongPress: () => _handleLongPress(
                                    _SelectionKind.note,
                                    item.id!,
                                  ),
                                  dragHandle: dragHandle,
                                );
                              },
                        ),
                        EntryListView<TodoListItem>(
                          items: _controller.todos,
                          loading: _controller.loading,
                          reorderMode: _isReorderMode,
                          onReorder: _controller.reorderTodos,
                          selectedIds: _selectedKind == _SelectionKind.todo
                              ? _selectedIds
                              : const {},
                          emptyIcon: theme.todosTabIcon,
                          emptyTitle: _controller.viewState == ViewState.active
                              ? 'No Todos Yet'
                              : _controller.viewState == ViewState.archived
                              ? 'No Archived Todos'
                              : 'Trash is Empty',
                          emptySubtitle:
                              _controller.viewState == ViewState.active
                              ? "Tap the '+' icon to create one"
                              : "Items here are archived or deleted",
                          idOf: (item) => item.id,
                          theme: theme,
                          cardBuilder:
                              (context, item, theme, selected, dragHandle) {
                                return TodoCard(
                                  todo: item,
                                  theme: theme,
                                  selected: selected,
                                  onTap: () => _handleTodoTap(item),
                                  onLongPress: () => _handleLongPress(
                                    _SelectionKind.todo,
                                    item.id!,
                                  ),
                                  dragHandle: dragHandle,
                                );
                              },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(AppTheme theme) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: theme.appBarBlur,
            sigmaY: theme.appBarBlur,
          ),
          child: AppBar(
            backgroundColor: theme.appBarColor,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Center(
                child: GlowPressable(
                  onTap: _openThemes,
                  borderRadius: 30,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      theme.icons.settings,
                      color: theme.appBarIconColor,
                    ),
                  ),
                ),
              ),
            ),
            title: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                final sequenceAnimation = CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.5, 1.0),
                );

                return FadeTransition(
                  opacity: sequenceAnimation,
                  child: SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0, 0.4),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: sequenceAnimation,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.2, end: 1.0).animate(
                        CurvedAnimation(
                          parent: sequenceAnimation,
                          curve: Curves.easeOutBack,
                        ),
                      ),
                      child: child,
                    ),
                  ),
                );
              },
              child: _hasSelection
                  ? Text(
                      '${_selectedIds.length} SELECTED',
                      key: const ValueKey('selection_count'),
                      style: theme.appBarTitleStyle.copyWith(
                        color: theme.primaryColor,
                        fontSize:
                            (theme.appBarTitleStyle.fontSize ?? 18) *
                            ThemeController().textScale,
                      ),
                    )
                  : Text(
                      _controller.viewState == ViewState.active
                          ? (_tab == _HomeTab.notes
                                ? theme.notesTabLabel
                                : theme.todosTabLabel)
                          : _controller.viewState == ViewState.archived
                          ? 'ARCHIVE'
                          : 'TRASH',
                      key: ValueKey('${_tab}_${_controller.viewState}'),
                      style: theme.appBarTitleStyle,
                    ),
            ),
            actions: [
              if (!_hasSelection)
                Center(
                  child: ListenableBuilder(
                    listenable: _controller,
                    builder: (context, _) {
                      if (!_controller.canUndo) return const SizedBox.shrink();
                      return GlowPressable(
                        onTap: () => _showUndoConfirmation(_controller.lastAction!),
                        borderRadius: theme.borderRadius,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            theme.icons.history,
                            color: theme.appBarIconColor.withValues(alpha: 0.7),
                            size: 26,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if (_hasSelection)
                Center(
                  child: GlowPressable(
                    onTap: _showSelectionMenu,
                    borderRadius: theme.borderRadius,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.more_vert, color: theme.primaryColor),
                    ),
                  ),
                )
              else ...[
                Center(
                  child: GlowPressable(
                    onTap: _showSearchDialog,
                    borderRadius: theme.borderRadius,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.search, color: theme.appBarIconColor),
                    ),
                  ),
                ),
                Center(
                  child: GlowPressable(
                    onTap: _showMoreMenu,
                    borderRadius: theme.borderRadius,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.more_vert,
                        color: theme.appBarIconColor,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 8),
            ],
            shape: theme.appBarBorder,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(AppTheme theme) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: theme.appBarBlur,
          sigmaY: theme.appBarBlur,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: theme.appBarColor,
            border: theme.navBarBorder,
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: kBottomNavigationBarHeight,
              child: Row(
                children: [
                  _BottomNavItem(
                    icon: theme.notesTabIcon,
                    label: theme.notesTabLabel,
                    isSelected: _tab == _HomeTab.notes,
                    onTap: () {
                      if (_tab == _HomeTab.notes) return;
                      _pageController.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 320),
                        curve: Curves.easeOutCubic,
                      );
                    },
                    theme: theme,
                  ),
                  _BottomNavItem(
                    icon: theme.todosTabIcon,
                    label: theme.todosTabLabel,
                    isSelected: _tab == _HomeTab.todos,
                    onTap: () {
                      if (_tab == _HomeTab.todos) return;
                      _pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 320),
                        curve: Curves.easeOutCubic,
                      );
                    },
                    theme: theme,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFab(AppTheme theme) {
    final isVisible =
        (_controller.viewState == ViewState.active || _hasSelection) &&
        !_isSearchVisible;
    final deleteMode = _hasSelection;
    final color = deleteMode
        ? theme.fabDeleteBackgroundColor
        : theme.fabBackgroundColor;
    final fgColor = deleteMode
        ? theme.fabDeleteForegroundColor
        : theme.fabForegroundColor;
    final shape = deleteMode ? theme.fabDeleteShape : theme.fabShape;

    // Determine the border radius for the glow shadow
    double br = theme.borderRadius;
    if (br <= 0 && shape is CircleBorder) {
      br = 28; // Default FAB radius
    } else if (br <= 0 && shape is! RoundedRectangleBorder) {
      br = 12; // Fallback
    }

    return AnimatedScale(
      scale: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      child: AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: GlowPressable(
          onTap: isVisible
              ? (deleteMode ? _confirmDeleteSelected : _createCurrentItem)
              : null,
          glowColor: deleteMode ? theme.deleteIconColor : theme.primaryColor,
          borderRadius: br,
          child: IgnorePointer(
            ignoring: true,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: FloatingActionButton(
                key: ValueKey(deleteMode),
                backgroundColor: color,
                foregroundColor: fgColor,
                shape: shape,
                elevation: theme.fabElevation,
                onPressed: () {}, // Handled by GlowPressable
                child: Icon(
                  deleteMode ? Icons.delete : Icons.add,
                  shadows: [
                    if (theme.useGlowEffects)
                      Shadow(
                        color: fgColor.withValues(alpha: 0.45),
                        blurRadius: 10,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openThemes() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ThemeScreen()));
    if (mounted) setState(() {});
  }

  Future<void> _createCurrentItem() async {
    if (_isMenuOpen) return;
    _isMenuOpen = true;
    final theme = ThemeController().currentTheme;
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
          alignment: Alignment.center,
          child: FadeTransition(
            opacity: animation,
            child: Center(
              child: Padding(
                padding: AppScale.symmetric(horizontal: 40),
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
                        padding: AppScale.symmetric(
                          horizontal: 24,
                          vertical: 24,
                        ),
                        decoration: theme.dialogDecoration,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _tab == _HomeTab.notes ? 'NEW NOTE' : 'NEW TODO',
                              textAlign: TextAlign.center,
                              style: theme.dialogTitleStyle,
                            ),
                            SizedBox(height: AppScale.size(24)),
                            AppDialogButton(
                              label: 'BLANK',
                              color: theme.primaryColor,
                              onTap: () {
                                if (Navigator.of(context).canPop()) {
                                  Navigator.pop(context);
                                }
                                if (_tab == _HomeTab.notes) {
                                  _openNoteEditor(null);
                                } else {
                                  _openTodoEditor(null);
                                }
                              },
                            ),
                            const SizedBox(height: 8),
                            if (_tab == _HomeTab.notes) ...[
                              AppDialogButton(
                                label: 'MEETING NOTES',
                                color: theme.primaryColor,
                                onTap: () {
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.pop(context);
                                  }
                                  final dateStr = DateTime.now()
                                      .toString()
                                      .split(' ')
                                      .first;
                                  _openNoteEditor(
                                    NoteItem(
                                      title: 'Meeting Notes',
                                      content:
                                          '''
DATE: $dateStr
PARTICIPANTS:
- 

AGENDA:
1. 

NOTES:
- 

ACTION ITEMS:
[ ] 
''',
                                      createdAt:
                                          DateTime.fromMillisecondsSinceEpoch(
                                            0,
                                          ),
                                      updatedAt:
                                          DateTime.fromMillisecondsSinceEpoch(
                                            0,
                                          ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                              AppDialogButton(
                                label: 'DAILY JOURNAL',
                                color: theme.primaryColor,
                                onTap: () {
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.pop(context);
                                  }
                                  final dateStr = DateTime.now()
                                      .toString()
                                      .split(' ')
                                      .first;
                                  _openNoteEditor(
                                    NoteItem(
                                      title: 'Daily Journal',
                                      content:
                                          '''
DATE: $dateStr

MORNING REFLECTIONS:
- 

KEY EVENTS:
- 

WHAT I LEARNED:
- 

GRATITUDE:
1. 
2. 
''',
                                      createdAt:
                                          DateTime.fromMillisecondsSinceEpoch(
                                            0,
                                          ),
                                      updatedAt:
                                          DateTime.fromMillisecondsSinceEpoch(
                                            0,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ] else ...[
                              AppDialogButton(
                                label: 'DAILY ROUTINE',
                                color: theme.primaryColor,
                                onTap: () {
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.pop(context);
                                  }
                                  _openTodoEditor(
                                    TodoListItem(
                                      title: 'Daily Routine',
                                      tasks: const [
                                        TodoTask(
                                          text: 'Morning Workout & Hydration',
                                        ),
                                        TodoTask(text: 'Meditation (10 mins)'),
                                        TodoTask(text: 'Deep Work: Phase 1'),
                                        TodoTask(
                                          text: 'Email & Communications',
                                        ),
                                        TodoTask(text: 'Deep Work: Phase 2'),
                                        TodoTask(text: 'Evening Reflection'),
                                        TodoTask(text: 'Planning for Tomorrow'),
                                      ],
                                      createdAt: DateTime.now(),
                                      updatedAt: DateTime.now(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                              AppDialogButton(
                                label: 'PROJECT PLAN',
                                color: theme.primaryColor,
                                onTap: () {
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.pop(context);
                                  }
                                  _openTodoEditor(
                                    TodoListItem(
                                      title: 'New Project',
                                      tasks: const [
                                        TodoTask(text: 'Define Project Scope'),
                                        TodoTask(text: 'List Key Deliverables'),
                                        TodoTask(
                                          text: 'Identify Resources Needed',
                                        ),
                                        TodoTask(
                                          text: 'Initial Implementation',
                                        ),
                                        TodoTask(
                                          text: 'Quality Assurance & Testing',
                                        ),
                                        TodoTask(
                                          text: 'Documentation & Cleanup',
                                        ),
                                        TodoTask(text: 'Final Deployment'),
                                      ],
                                      createdAt: DateTime.now(),
                                      updatedAt: DateTime.now(),
                                    ),
                                  );
                                },
                              ),
                            ],
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
        );
      },
    ).then((_) => _isMenuOpen = false);
  }

  Future<void> _showSearchDialog() async {
    if (_isMenuOpen) return;
    _isMenuOpen = true;
    setState(() => _isSearchVisible = true);
    final theme = ThemeController().currentTheme;
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        final bottomOffset = keyboardHeight > 0
            ? keyboardHeight
            : (kBottomNavigationBarHeight + AppScale.size(24));

        final curve = CurvedAnimation(
          parent: animation,
          curve: const Cubic(0.175, 0.885, 0.32, 1.275),
          reverseCurve: Curves.easeInCubic,
        );
        final scaleAnimation = Tween<double>(
          begin: 0.9,
          end: 1.0,
        ).animate(curve);

        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: scaleAnimation,
            alignment: Alignment.bottomCenter,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: bottomOffset + AppScale.size(12),
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
                      child: StatefulBuilder(
                        builder: (context, setDialogState) {
                          return Container(
                            padding: AppScale.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            decoration: theme.dialogDecoration,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'SEARCH',
                                  style: theme.dialogTitleStyle.copyWith(
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: AppScale.size(16)),
                                TextField(
                                  controller: _searchController,
                                  autofocus: true,
                                  onChanged: (value) {
                                    _controller.search(value);
                                    setDialogState(() {});
                                  },
                                  style: theme.entrySubtitleStyle.copyWith(
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: 'Type to find...',
                                    hintStyle: theme.entrySubtitleStyle.copyWith(
                                      fontSize: 16,
                                      color: theme.appBarIconColor.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: theme.primaryColor,
                                      size: 24,
                                    ),
                                    suffixIcon: _searchController.text.isNotEmpty
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.close,
                                              size: 22,
                                              color: theme.appBarIconColor,
                                            ),
                                            onPressed: () {
                                              _searchController.clear();
                                              _controller.search('');
                                              setDialogState(() {});
                                            },
                                          )
                                        : null,
                                    filled: true,
                                    fillColor: theme.cardBackground.withValues(
                                      alpha: 0.05,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        theme.borderRadius / 2,
                                      ),
                                      borderSide: BorderSide(
                                        color: theme.primaryColor.withValues(
                                          alpha: 0.2,
                                        ),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        theme.borderRadius / 2,
                                      ),
                                      borderSide: BorderSide(
                                        color: theme.primaryColor.withValues(
                                          alpha: 0.1,
                                        ),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        theme.borderRadius / 2,
                                      ),
                                      borderSide: BorderSide(
                                        color: theme.primaryColor.withValues(
                                          alpha: 0.4,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppScale.size(20)),
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
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    if (mounted) {
      setState(() {
        _isSearchVisible = false;
        _isMenuOpen = false;
      });
    }
  }

  void _showSelectionMenu() {
    if (_isMenuOpen) return;
    _isMenuOpen = true;
    final theme = ThemeController().currentTheme;
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
          curve: const Cubic(0.175, 0.885, 0.32, 1.6),
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
                  top: MediaQuery.of(context).padding.top +
                      kToolbarHeight +
                      AppScale.size(18),
                  right: AppScale.size(26.5),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                  ),
                  child: IntrinsicWidth(
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
                            padding: AppScale.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: theme.dialogDecoration,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                AppDialogButton(
                                  label: 'SELECT ALL',
                                  color: theme.primaryColor,
                                  onTap: () {
                                    if (Navigator.of(context).canPop()) {
                                      Navigator.pop(context);
                                    }
                                    _selectAllCurrentTab();
                                  },
                                ),
                                const SizedBox(height: 8),
                                AppDialogButton(
                                  label: 'CLEAR SELECTION',
                                  color: Colors.white38,
                                  onTap: () {
                                    if (Navigator.of(context).canPop()) {
                                      Navigator.pop(context);
                                    }
                                    _clearSelection();
                                  },
                                ),
                                const SizedBox(height: 8),
                                Divider(
                                  color: theme.primaryColor.withValues(alpha: 0.1),
                                ),
                                const SizedBox(height: 8),
                                if (_controller.viewState == ViewState.active) ...[
                                  AppDialogButton(
                                    label: 'PIN / UNPIN',
                                    color: theme.primaryColor,
                                    onTap: () {
                                      if (Navigator.of(context).canPop()) {
                                        Navigator.pop(context);
                                      }
                                      if (_selectedKind == _SelectionKind.note) {
                                        _controller.togglePinNotes(_selectedIds);
                                      } else {
                                        _controller.togglePinTodoLists(_selectedIds);
                                      }
                                      _clearSelection();
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  AppDialogButton(
                                    label: 'ARCHIVE',
                                    color: theme.primaryColor,
                                    onTap: () {
                                      if (Navigator.of(context).canPop()) {
                                        Navigator.pop(context);
                                      }
                                      if (_selectedKind == _SelectionKind.note) {
                                        _controller.archiveNotes(_selectedIds);
                                      } else {
                                        _controller.archiveTodoLists(_selectedIds);
                                      }
                                      _clearSelection();
                                    },
                                  ),
                                ] else if (_controller.viewState == ViewState.archived) ...[
                                  AppDialogButton(
                                    label: 'UNARCHIVE',
                                    color: theme.primaryColor,
                                    onTap: () {
                                      if (Navigator.of(context).canPop()) {
                                        Navigator.pop(context);
                                      }
                                      if (_selectedKind == _SelectionKind.note) {
                                        _controller.unarchiveNotes(_selectedIds);
                                      } else {
                                        _controller.unarchiveTodoLists(_selectedIds);
                                      }
                                      _clearSelection();
                                    },
                                  ),
                                ] else if (_controller.viewState == ViewState.trash) ...[
                                  AppDialogButton(
                                    label: 'RESTORE',
                                    color: theme.primaryColor,
                                    onTap: () {
                                      if (Navigator.of(context).canPop()) {
                                        Navigator.pop(context);
                                      }
                                      if (_selectedKind == _SelectionKind.note) {
                                        _controller.restoreNotes(_selectedIds);
                                      } else {
                                        _controller.restoreTodoLists(_selectedIds);
                                      }
                                      _clearSelection();
                                    },
                                  ),
                                ],
                                const SizedBox(height: 8),
                                AppDialogButton(
                                  label: _controller.viewState == ViewState.trash
                                      ? 'DELETE FOREVER'
                                      : 'TRASH',
                                  color: theme.deleteIconColor,
                                  onTap: () {
                                    if (Navigator.of(context).canPop()) {
                                      Navigator.pop(context);
                                    }
                                    _confirmDeleteSelected();
                                  },
                                ),
                                const SizedBox(height: 12),
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
          ),
        );
      },
    ).then((_) => _isMenuOpen = false);
  }

  Future<void> _showMoreMenu() async {
    if (_isMenuOpen) return;
    _isMenuOpen = true;
    final theme = ThemeController().currentTheme;
    await showGeneralDialog(
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
          curve: const Cubic(0.175, 0.885, 0.32, 1.6),
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
                  top: MediaQuery.of(context).padding.top +
                      kToolbarHeight +
                      AppScale.size(18),
                  right: AppScale.size(26),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                  ),
                  child: IntrinsicWidth(
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
                            padding: AppScale.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: theme.dialogDecoration,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                AppDialogButton(
                                  label: 'STATS',
                                  color: theme.primaryColor,
                                  onTap: () {
                                    if (Navigator.of(context).canPop()) {
                                      Navigator.of(context).pop();
                                    }
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => StatsScreen(
                                          controller: _controller,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 8),
                                AppDialogButton(
                                  label: _controller.viewState == ViewState.active
                                      ? 'GO TO ARCHIVE'
                                      : 'GO TO ACTIVE',
                                  color: theme.primaryColor,
                                  onTap: () {
                                    if (Navigator.of(context).canPop()) {
                                      Navigator.of(context).pop();
                                    }
                                    _controller.setViewState(
                                      _controller.viewState == ViewState.active
                                          ? ViewState.archived
                                          : ViewState.active,
                                    );
                                  },
                                ),
                                const SizedBox(height: 8),
                                if (_controller.viewState != ViewState.trash) ...[
                                  AppDialogButton(
                                    label: 'GO TO TRASH',
                                    color: theme.deleteIconColor,
                                    onTap: () {
                                      if (Navigator.of(context).canPop()) {
                                        Navigator.of(context).pop();
                                      }
                                      _controller.setViewState(ViewState.trash);
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                ],
                                AppDialogButton(
                                  label: _controller.sortOrder == SortOrder.newestFirst
                                      ? 'SORT: OLDEST FIRST'
                                      : 'SORT: NEWEST FIRST',
                                  color: theme.primaryColor,
                                  onTap: () {
                                    if (Navigator.of(context).canPop()) {
                                      Navigator.of(context).pop();
                                    }
                                    _controller.setSortOrder(
                                      _controller.sortOrder == SortOrder.newestFirst
                                          ? SortOrder.oldestFirst
                                          : SortOrder.newestFirst,
                                    );
                                  },
                                ),
                                const SizedBox(height: 8),
                                AppDialogButton(
                                  label: _isReorderMode
                                      ? 'DISABLE DRAG'
                                      : 'ENABLE DRAG',
                                  color: theme.primaryColor,
                                  onTap: () {
                                    if (Navigator.of(context).canPop()) {
                                      Navigator.of(context).pop();
                                    }
                                    setState(() {
                                      _isReorderMode = !_isReorderMode;
                                    });
                                  },
                                ),
                                if (_hasSelectableItems) ...[
                                  const SizedBox(height: 8),
                                  AppDialogButton(
                                    label: 'SELECT ALL',
                                    color: theme.primaryColor,
                                    onTap: () {
                                      if (Navigator.of(context).canPop()) {
                                        Navigator.of(context).pop();
                                      }
                                      _selectAllCurrentTab();
                                    },
                                  ),
                                ],
                                if (_hasSelection) ...[
                                  const SizedBox(height: 8),
                                  AppDialogButton(
                                    label: 'CLEAR SELECTION',
                                    color: Colors.white38,
                                    onTap: () {
                                      if (Navigator.of(context).canPop()) {
                                        Navigator.of(context).pop();
                                      }
                                      _clearSelection();
                                    },
                                  ),
                                ],
                                const SizedBox(height: 8),
                                AppDialogButton(
                                  label: 'CLOSE',
                                  color: Colors.white38,
                                  onTap: () {
                                    if (Navigator.of(context).canPop()) {
                                      Navigator.of(context).pop();
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
          ),
        );
      },
    );
    if (mounted) {
      setState(() => _isMenuOpen = false);
    }
  }

  void _handleLongPress(_SelectionKind kind, int id) {
    if (!_hasSelection) {
      setState(() {
        _selectedKind = kind;
        _selectedIds.add(id);
      });
    } else if (_selectedKind == kind) {
      // If already in selection mode for the same kind, treat long press like a tap to toggle
      _toggleSelection(kind, id);
    }
  }

  Future<void> _openNoteEditor(NoteItem? note) async {
    _clearSelection();
    final result = await Navigator.of(context).push<NoteEditorResult>(
      MaterialPageRoute(builder: (context) => NoteEditorScreen(note: note)),
    );
    if (result == null) return;
    await _controller.saveNote(
      existing: note,
      title: result.title,
      content: result.content,
    );
  }

  Future<void> _openTodoEditor(
    TodoListItem? todo, {
    bool focusNewItem = false,
  }) async {
    _clearSelection();
    final result = await Navigator.of(context).push<TodoEditorResult>(
      MaterialPageRoute(
        builder: (context) =>
            TodoEditorScreen(todo: todo, focusNewItem: focusNewItem),
      ),
    );
    if (result == null) return;
    await _controller.saveTodoList(
      existing: todo,
      title: result.title,
      tasks: result.tasks,
    );
  }

  void _handleNoteTap(NoteItem note) async {
    if (_hasSelection) {
      if (note.id != null) _toggleSelection(_SelectionKind.note, note.id!);
    } else if (_controller.viewState == ViewState.active) {
      if (_isNavigating) return;
      _isNavigating = true;
      if (!mounted) {
        _isNavigating = false;
        return;
      }
      await _openNoteEditor(note);
      _isNavigating = false;
    } else {
      _showItemActions(note);
    }
  }

  void _handleTodoTap(TodoListItem todo) async {
    if (_hasSelection) {
      if (todo.id != null) _toggleSelection(_SelectionKind.todo, todo.id!);
    } else if (_controller.viewState == ViewState.active) {
      if (_isNavigating) return;
      _isNavigating = true;
      if (!mounted) {
        _isNavigating = false;
        return;
      }
      await _openTodoEditor(todo);
      _isNavigating = false;
    } else {
      _showItemActions(todo);
    }
  }

  void _showItemActions(Object item) {
    if (_isMenuOpen) return;
    _isMenuOpen = true;
    final theme = ThemeController().currentTheme;
    final title = switch (item) {
      NoteItem note => note.title,
      TodoListItem todo => todo.title,
      _ => '',
    };
    final pinned = switch (item) {
      NoteItem note => note.pinned,
      TodoListItem todo => todo.pinned,
      _ => false,
    };
    final id = switch (item) {
      NoteItem note => note.id,
      TodoListItem todo => todo.id,
      _ => null,
    };
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
          alignment: Alignment.center,
          child: FadeTransition(
            opacity: animation,
            child: Center(
              child: Padding(
                padding: AppScale.symmetric(horizontal: 40),
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
                        padding: AppScale.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        decoration: theme.dialogDecoration,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              title.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: theme.dialogTitleStyle.copyWith(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: AppScale.size(20)),
                            if (_controller.viewState != ViewState.trash) ...[
                              AppDialogButton(
                                label: 'OPEN',
                                color: theme.primaryColor,
                                onTap: () {
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.pop(context);
                                  }
                                  if (item is NoteItem) {
                                    _openNoteEditor(item);
                                  } else {
                                    _openTodoEditor(item as TodoListItem);
                                  }
                                },
                              ),
                              const SizedBox(height: 8),
                            ],
                            if (_controller.viewState == ViewState.active) ...[
                              AppDialogButton(
                                label: pinned ? 'UNPIN' : 'PIN',
                                color: theme.primaryColor,
                                onTap: () {
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.pop(context);
                                  }
                                  if (item is NoteItem) {
                                    _controller.togglePinNote(item);
                                  } else {
                                    _controller.togglePinTodoList(
                                      item as TodoListItem,
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 8),
                              AppDialogButton(
                                label: 'ARCHIVE',
                                color: theme.primaryColor,
                                onTap: () {
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.pop(context);
                                  }
                                  if (item is NoteItem) {
                                    _controller.archiveNote(item);
                                  } else {
                                    _controller.archiveTodoList(
                                      item as TodoListItem,
                                    );
                                  }
                                },
                              ),
                            ] else if (_controller.viewState ==
                                ViewState.archived) ...[
                              AppDialogButton(
                                label: 'UNARCHIVE',
                                color: theme.primaryColor,
                                onTap: () {
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.pop(context);
                                  }
                                  if (item is NoteItem) {
                                    _controller.unarchiveNote(item);
                                  } else {
                                    _controller.unarchiveTodoList(
                                      item as TodoListItem,
                                    );
                                  }
                                },
                              ),
                            ] else if (_controller.viewState ==
                                ViewState.trash) ...[
                              AppDialogButton(
                                label: 'RESTORE',
                                color: theme.primaryColor,
                                onTap: () {
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.pop(context);
                                  }
                                  if (item is NoteItem) {
                                    _controller.restoreNote(item);
                                  } else {
                                    _controller.restoreTodoList(
                                      item as TodoListItem,
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 8),
                              AppDialogButton(
                                label: 'DELETE FOREVER',
                                color: theme.deleteIconColor,
                                onTap: () {
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.pop(context);
                                  }
                                  if (id == null) return;
                                  if (item is NoteItem) {
                                    _controller.purgeNote(id);
                                  } else {
                                    _controller.purgeTodoList(id);
                                  }
                                },
                              ),
                            ],
                            if (_controller.viewState != ViewState.trash) ...[
                              const SizedBox(height: 8),
                              AppDialogButton(
                                label: 'TRASH',
                                color: theme.deleteIconColor,
                                onTap: () {
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.pop(context);
                                  }
                                  if (item is NoteItem) {
                                    _controller.trashNote(item);
                                  } else {
                                    _controller.trashTodoList(
                                      item as TodoListItem,
                                    );
                                  }
                                },
                              ),
                            ],
                            const SizedBox(height: 12),
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
        );
      },
    ).then((_) => _isMenuOpen = false);
  }

  void _toggleSelection(_SelectionKind kind, int id) {
    setState(() {
      _selectedKind = kind;
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
        if (_selectedIds.isEmpty) {
          _selectedKind = null;
        }
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _clearSelection() {
    if (!_hasSelection) return;
    setState(() {
      _selectedKind = null;
      _selectedIds.clear();
    });
  }

  List<int> _currentTabIds() {
    if (_tab == _HomeTab.notes) {
      return _controller.notes
          .map((note) => note.id)
          .whereType<int>()
          .toList(growable: false);
    }

    return _controller.todos
        .map((todo) => todo.id)
        .whereType<int>()
        .toList(growable: false);
  }

  void _selectAllCurrentTab() {
    final ids = _currentTabIds();
    if (ids.isEmpty) return;

    setState(() {
      _selectedKind = _tab == _HomeTab.notes
          ? _SelectionKind.note
          : _SelectionKind.todo;
      _selectedIds
        ..clear()
        ..addAll(ids);
    });
  }

  Future<void> _showUndoConfirmation(UndoAction action) async {
    final theme = ThemeController().currentTheme;
    final result = await showGeneralDialog<bool>(
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
          alignment: Alignment.center,
          child: FadeTransition(
            opacity: animation,
            child: Center(
              child: Padding(
                padding: AppScale.symmetric(horizontal: 40),
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
                        padding: AppScale.symmetric(
                          horizontal: 24,
                          vertical: 24,
                        ),
                        decoration: theme.dialogDecoration,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: AppScale.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              decoration: theme.getDialogIconDecoration(
                                theme.primaryColor,
                              ),
                              child: Icon(
                                theme.icons.history,
                                color: theme.primaryColor,
                                size: 40,
                              ),
                            ),
                            SizedBox(height: AppScale.size(24)),
                            Text(
                              'UNDO ACTION?',
                              textAlign: TextAlign.center,
                              style: theme.dialogTitleStyle.copyWith(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: AppScale.size(16)),
                            Text(
                              'Would you like to reverse this operation?\n"${action.message.toUpperCase()}"',
                              textAlign: TextAlign.center,
                              style: theme.dialogMessageStyle,
                            ),
                            SizedBox(height: AppScale.size(32)),
                            Row(
                              children: [
                                Expanded(
                                  child: AppDialogButton(
                                    label: 'CANCEL',
                                    color: Colors.white38,
                                    onTap: () {
                                      if (Navigator.of(context).canPop()) {
                                        Navigator.of(context).pop(false);
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(width: AppScale.size(12)),
                                Expanded(
                                  child: AppDialogButton(
                                    label: 'UNDO',
                                    color: theme.primaryColor,
                                    onTap: () {
                                      if (Navigator.of(context).canPop()) {
                                        Navigator.of(context).pop(true);
                                      }
                                    },
                                  ),
                                ),
                              ],
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
        );
      },
    );

    if (result == true) {
      await _controller.undo();
    }
  }

  Future<void> _confirmDeleteSelected() async {
    final confirmed = await _showDeleteDialog();
    if (!confirmed || _selectedIds.isEmpty || _selectedKind == null) return;

    final ids = Set<int>.from(_selectedIds);
    final kind = _selectedKind!;
    setState(() {
      _selectedKind = null;
      _selectedIds.clear();
    });

    if (kind == _SelectionKind.note) {
      await _controller.deleteNotes(ids);
    } else {
      await _controller.deleteTodoLists(ids);
    }
  }

  Future<bool> _showDeleteDialog() async {
    final theme = ThemeController().currentTheme;
    final result = await showGeneralDialog<bool>(
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
          alignment: Alignment.center,
          child: FadeTransition(
            opacity: animation,
            child: Center(
              child: Padding(
                padding: AppScale.symmetric(horizontal: 40),
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
                        padding: AppScale.symmetric(
                          horizontal: 24,
                          vertical: 24,
                        ),
                        decoration: theme.dialogDecoration,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: AppScale.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              decoration: theme.getDialogIconDecoration(
                                theme.deleteIconColor,
                              ),
                              child: Icon(
                                theme.icons.warning,
                                color: theme.deleteIconColor,
                                size: 40,
                              ),
                            ),
                            SizedBox(height: AppScale.size(24)),
                            Text(
                              'CONFIRM DELETE',
                              textAlign: TextAlign.center,
                              style: theme.dialogTitleStyle,
                            ),
                            SizedBox(height: AppScale.size(16)),
                            Text(
                              _controller.viewState == ViewState.trash
                                  ? 'This item will be permanently removed.'
                                  : 'This item will be moved to Trash.',
                              textAlign: TextAlign.center,
                              style: theme.dialogMessageStyle,
                            ),
                            SizedBox(height: AppScale.size(32)),
                            Row(
                              children: [
                                Expanded(
                                  child: AppDialogButton(
                                    label: 'CANCEL',
                                    color: Colors.white38,
                                    onTap: () {
                                      if (Navigator.of(context).canPop()) {
                                        Navigator.of(context).pop(false);
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(width: AppScale.size(12)),
                                Expanded(
                                  child: AppDialogButton(
                                    label: 'DELETE',
                                    color: theme.deleteIconColor,
                                    onTap: () {
                                      if (Navigator.of(context).canPop()) {
                                        Navigator.of(context).pop(true);
                                      }
                                    },
                                  ),
                                ),
                              ],
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
        );
      },
    );
    return result ?? false;
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? theme.navBarSelectedItemColor
        : theme.navBarUnselectedItemColor;

    return Expanded(
      child: GlowPressable(
        onTap: onTap,
        borderRadius: 60,
        builder: (context, isPressed, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color),
              // Reduced from 2
              Text(
                label,
                style: theme.themeItemStatusStyle.copyWith(
                  color: color,
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
