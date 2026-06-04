import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:notes_todos/src/app/layout/app_scale.dart';
import '../../../app/theme/models/app_theme.dart';
import '../../../app/theme/theme_controller.dart';
import '../../../app/widgets/app_dialog_button.dart';
import '../../../app/widgets/glow_pressable.dart';
import '../../../app/widgets/neon_background.dart';
import 'notes_todos_controller.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({required this.controller, super.key});

  final NotesTodosController controller;

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController().currentTheme;
    final controller = widget.controller;

    // Filtered Todo Lists based on persisted controller state
    final trackedTodoIds = controller.trackedTodoIds;
    final trackedTodos = trackedTodoIds == null
        ? controller.todos
        : controller.todos.where((t) => trackedTodoIds.contains(t.id)).toList();

    // Data Calculation
    final activeNotes = controller.notes.length;
    final activeTodos = trackedTodos.length;
    final totalTasks = trackedTodos.fold(
      0,
      (sum, todo) => sum + todo.tasks.length,
    );
    final completedTasks = trackedTodos.fold(
      0,
      (sum, todo) => sum + todo.tasks.where((t) => t.completed).length,
    );
    final completionRate = totalTasks > 0 ? (completedTasks / totalTasks) : 0.0;

    final pinnedCount =
        controller.notes.where((n) => n.pinned).length +
        trackedTodos.where((t) => t.pinned).length;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
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
              leading: Center(
                child: GlowPressable(
                  onTap: () => Navigator.pop(context),
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
              title: Text('DASHBOARD', style: theme.appBarTitleStyle),
              centerTitle: true,
              actions: [
                Center(
                  child: GlowPressable(
                    onTap: _showStatsMenu,
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
                const SizedBox(width: 8),
              ],
              shape: theme.appBarBorder,
            ),
          ),
        ),
      ),
      body: NeonBackground(
        theme: theme,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            top:
                MediaQuery.of(context).padding.top +
                kToolbarHeight +
                AppScale.size(12),
            bottom: MediaQuery.of(context).padding.bottom + AppScale.size(12),
            left: AppScale.size(20),
            right: AppScale.size(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProfessionalProductivityCard(
                theme: theme,
                completionRate: completionRate,
                completed: completedTasks,
                total: totalTasks,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      theme: theme,
                      title: 'NOTES',
                      value: '$activeNotes',
                      icon: Icons.description_outlined,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMetricCard(
                      theme: theme,
                      title: 'LISTS',
                      value: '$activeTodos',
                      icon: Icons.checklist_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      theme: theme,
                      title: 'PINNED',
                      value: '$pinnedCount',
                      icon: Icons.push_pin_outlined,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMetricCard(
                      theme: theme,
                      title: 'TOTAL TASKS',
                      value: '$totalTasks',
                      icon: Icons.bolt,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildMetricCard(
                theme: theme,
                title: 'TASK PROGRESS',
                child: Column(
                  children: [
                    _buildProgressBar(
                      theme: theme,
                      label: 'Completed',
                      count: completedTasks,
                      total: totalTasks,
                      color: theme.primaryColor,
                    ),
                    const SizedBox(height: 16),
                    _buildProgressBar(
                      theme: theme,
                      label: 'Pending',
                      count: totalTasks - completedTasks,
                      total: totalTasks,
                      color: theme.deleteIconColor.withValues(alpha: 0.6),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStatsMenu() {
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
                    maxWidth: MediaQuery.of(context).size.width * 0.6,
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
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              AppDialogButton(
                                label: 'TRACK ALL TODOS',
                                color: theme.primaryColor,
                                onTap: () {
                                  Navigator.pop(context);
                                  widget.controller.updateTrackedTodoIds(null);
                                },
                              ),
                              const SizedBox(height: 8),
                              AppDialogButton(
                                label: 'SELECT LISTS',
                                color: theme.primaryColor,
                                onTap: () {
                                  Navigator.pop(context);
                                  _showTodoSelectionDialog();
                                },
                              ),
                              const SizedBox(height: 8),
                              AppDialogButton(
                                label: 'CLOSE',
                                color: Colors.white38,
                                onTap: () => Navigator.pop(context),
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

  void _showTodoSelectionDialog() {
    final theme = ThemeController().currentTheme;
    final allTodos = widget.controller.todos;
    final currentSelection = widget.controller.trackedTodoIds;
    Set<int> tempSelection = Set.from(
      currentSelection ?? allTodos.map((e) => e.id!),
    );

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
                padding: const EdgeInsets.symmetric(horizontal: 32),
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
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.7,
                        ),
                        padding: const EdgeInsets.all(24),
                        decoration: theme.dialogDecoration,
                        child: StatefulBuilder(
                          builder: (context, setDialogState) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'SELECT TRACKED LISTS',
                                  textAlign: TextAlign.center,
                                  style: theme.dialogTitleStyle
                                ),
                                const SizedBox(height: 20),
                                Flexible(
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Column(
                                      children: allTodos.map((todo) {
                                        final isSelected = tempSelection
                                            .contains(todo.id);
                                        return GlowPressable(
                                          onTap: () {
                                            setDialogState(() {
                                              if (isSelected) {
                                                if (tempSelection.length > 1) {
                                                  tempSelection.remove(todo.id);
                                                }
                                              } else {
                                                tempSelection.add(todo.id!);
                                              }
                                            });
                                          },
                                          borderRadius: 12,
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              bottom: 8,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? theme.primaryColor
                                                        .withValues(alpha: 0.1)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: isSelected
                                                    ? theme.primaryColor
                                                          .withValues(
                                                            alpha: 0.4,
                                                          )
                                                    : theme.appBarIconColor
                                                          .withValues(
                                                            alpha: 0.1,
                                                          ),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  isSelected
                                                      ? Icons.check_circle
                                                      : Icons.circle_outlined,
                                                  color: isSelected
                                                      ? theme.primaryColor
                                                      : theme.appBarIconColor
                                                            .withValues(
                                                              alpha: 0.3,
                                                            ),
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    todo.title,
                                                    style: theme.entryTitleStyle
                                                        .copyWith(
                                                          fontSize: 18,
                                                          color: isSelected
                                                              ? theme
                                                                    .appBarIconColor
                                                              : theme
                                                                    .appBarIconColor
                                                                    .withValues(
                                                                      alpha:
                                                                          0.6,
                                                                    ),
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                AppDialogButton(
                                  label: 'APPLY SELECTION',
                                  color: theme.primaryColor,
                                  onTap: () {
                                    Navigator.pop(context);
                                    if (tempSelection.length ==
                                        allTodos.length) {
                                      widget.controller.updateTrackedTodoIds(
                                        null,
                                      );
                                    } else {
                                      widget.controller.updateTrackedTodoIds(
                                        tempSelection,
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 8),
                                AppDialogButton(
                                  label: 'CANCEL',
                                  color: Colors.white38,
                                  onTap: () => Navigator.pop(context),
                                ),
                              ],
                            );
                          },
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
  }

  Widget _buildProfessionalProductivityCard({
    required AppTheme theme,
    required double completionRate,
    required int completed,
    required int total,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardBackground,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        border: Border.all(
          color: theme.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'TASK EFFICIENCY',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.themeItemStatusStyle.copyWith(
                    fontSize: 12,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor.withValues(alpha: 0.8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  'ACTIVE',
                  style: theme.themeItemStatusStyle.copyWith(
                    fontSize: 9,
                    color: theme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Stack(
            alignment: Alignment.center,
            children: [
              // Glow Effect
              Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withValues(alpha: 0.15),
                      blurRadius: 40,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 160,
                width: 160,
                child: CircularProgressIndicator(
                  value: completionRate,
                  strokeWidth: 14,
                  strokeCap: StrokeCap.round,
                  backgroundColor: theme.primaryColor.withValues(
                    alpha: 0.05,
                  ),
                  color: theme.primaryColor,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(completionRate * 100).toInt()}%',
                    style: theme.appBarTitleStyle.copyWith(
                      fontSize: 42,
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'SUCCESS RATE',
                    style: theme.themeItemStatusStyle.copyWith(
                      fontSize: 10,
                      letterSpacing: 1.5,
                      color: theme.appBarIconColor.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            _getProfessionalStatus(completionRate),
            textAlign: TextAlign.center,
            style: theme.entryTitleStyle.copyWith(
              fontSize: 18,
              letterSpacing: 0.5,
              color: theme.appBarIconColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Processed $completed of $total operational tasks.',
            textAlign: TextAlign.center,
            style: theme.entrySubtitleStyle.copyWith(
              fontSize: 14,
              color: theme.appBarIconColor.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required AppTheme theme,
    required String title,
    String? value,
    IconData? icon,
    Widget? child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardBackground,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        border: Border.all(
          color: theme.primaryColor.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.themeItemStatusStyle.copyWith(
                    fontSize: 12,
                    letterSpacing: 1.5,
                    color: theme.primaryColor.withValues(alpha: 0.6),
                  ),
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 4),
                Icon(
                  icon,
                  color: theme.primaryColor.withValues(alpha: 0.4),
                  size: 18,
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          if (value != null)
            Text(
              value,
              style: theme.appBarTitleStyle.copyWith(
                fontSize: 28,
                color: theme.primaryColor,
              ),
            ),
          ?child,
        ],
      ),
    );
  }

  Widget _buildProgressBar({
    required AppTheme theme,
    required String label,
    required int count,
    required int total,
    required Color color,
  }) {
    final percent = total > 0 ? (count / total) : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.entrySubtitleStyle.copyWith(fontSize: 16),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$count',
              style: theme.entrySubtitleStyle.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 8,
            backgroundColor: theme.appBarIconColor.withValues(alpha: 0.05),
            color: color,
          ),
        ),
      ],
    );
  }

  String _getProfessionalStatus(double rate) {
    if (rate >= 1.0) return "MAXIMUM OPERATIONAL EFFICIENCY";
    if (rate >= 0.8) return "EXCEPTIONAL PERFORMANCE DETECTED";
    if (rate >= 0.6) return "STABLE PRODUCTIVITY FLOW";
    if (rate >= 0.4) return "PROGRESSING THROUGH OBJECTIVES";
    if (rate >= 0.2) return "INITIAL CORE TASKS RESOLVED";
    if (rate > 0) return "TASK EXECUTION INITIATED";
    return "AWAITING NEW OBJECTIVES";
  }
}

