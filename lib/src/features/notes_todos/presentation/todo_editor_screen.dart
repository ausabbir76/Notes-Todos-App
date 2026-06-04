import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/layout/app_scale.dart';
import '../../../app/theme/theme_controller.dart';
import '../../../app/widgets/neon_background.dart';
import '../domain/todo_list_item.dart';
import '../domain/todo_task.dart';
import 'widgets/editor_chrome.dart';

class TodoEditorScreen extends StatefulWidget {
  const TodoEditorScreen({this.todo, this.focusNewItem = false, super.key});

  final TodoListItem? todo;
  final bool focusNewItem;

  @override
  State<TodoEditorScreen> createState() => _TodoEditorScreenState();
}

class _TodoEditorScreenState extends State<TodoEditorScreen> {
  late final TextEditingController _titleController;
  late List<_TaskDraft> _tasks;
  final FocusNode _titleFocusNode = FocusNode();
  
  final List<_TodoState> _history = [];
  bool _isUndoing = false;
  Timer? _historyDebounce;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    _tasks =
        widget.todo?.tasks
            .map(
              (task) => _TaskDraft(
                controller: TextEditingController(text: task.text),
                focusNode: FocusNode(),
                completed: task.completed,
              ),
            )
            .toList() ??
        <_TaskDraft>[];
        
    _titleController.addListener(_scheduleRecordState);
    for (final task in _tasks) {
      task.controller.addListener(_scheduleRecordState);
    }

    if (_tasks.isEmpty) {
      _addTask(autofocus: false, record: false);
    } else if (widget.focusNewItem) {
      _addTask(autofocus: true, record: false);
    }
    
    _recordState();
  }

  void _scheduleRecordState() {
    if (_isUndoing) return;
    _historyDebounce?.cancel();
    _historyDebounce = Timer(const Duration(milliseconds: 250), _recordState);
  }

  void _recordState() {
    if (_isUndoing) return;
    
    final currentState = _TodoState(
      title: _titleController.text,
      tasks: _tasks
          .map(
            (task) => _TaskItemState(
              text: task.controller.text,
              completed: task.completed,
            ),
          )
          .toList(),
    );

    if (_history.isEmpty || _history.last != currentState) {
      if (_history.length > 50) _history.removeAt(0);
      _history.add(currentState);
      if (mounted) setState(() {});
    }
  }

  void _undo() {
    if (_history.length <= 1) return;
    
    _isUndoing = true;
    _history.removeLast();
    final prevState = _history.last;

    setState(() {
      _titleController.text = prevState.title;
      
      final newTasks = <_TaskDraft>[];
      for (var i = 0; i < prevState.tasks.length; i++) {
        final taskState = prevState.tasks[i];
        
        if (i < _tasks.length) {
          final existing = _tasks[i];
          existing.controller.text = taskState.text;
          existing.completed = taskState.completed;
          newTasks.add(existing);
        } else {
          final controller = TextEditingController(text: taskState.text);
          controller.addListener(_scheduleRecordState);
          newTasks.add(_TaskDraft(
            controller: controller,
            focusNode: FocusNode(),
            completed: taskState.completed,
          ));
        }
      }
      
      for (var i = prevState.tasks.length; i < _tasks.length; i++) {
        _tasks[i].controller.removeListener(_scheduleRecordState);
        _tasks[i].controller.dispose();
        _tasks[i].focusNode.dispose();
      }
      
      _tasks = newTasks;
    });

    _isUndoing = false;
  }

  @override
  void dispose() {
    _historyDebounce?.cancel();
    _titleController.removeListener(_scheduleRecordState);
    _titleController.dispose();
    for (final task in _tasks) {
      task.controller.removeListener(_scheduleRecordState);
      task.controller.dispose();
      task.focusNode.dispose();
    }
    _titleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController().currentTheme;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: EditorTopBar(
        theme: theme,
        title: widget.todo == null ? 'New Todo' : '.....',
        onBack: () => Navigator.of(context).pop(),
        onSave: _save,
        onUndo: _history.length > 1 ? _undo : null,
      ),
      bottomNavigationBar: EditorBottomTitleBar(
        theme: theme,
        titleController: _titleController,
        titleFocusNode: _titleFocusNode,
        textInputAction: TextInputAction.done,
      ),
      body: NeonBackground(
        theme: theme,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final topPadding = MediaQuery.of(context).padding.top + AppScale.size(12);
            final bottomPadding = MediaQuery.of(context).padding.bottom + AppScale.size(12);
            final minContainerHeight = (constraints.maxHeight - topPadding - bottomPadding)
                    .clamp(0.0, double.infinity)
                    .toDouble();

            return SingleChildScrollView(
              padding: EdgeInsets.only(
                top: topPadding,
                bottom: bottomPadding,
                left: AppScale.size(20),
                right: AppScale.size(20),
              ),
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: minContainerHeight,
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 90),
                        decoration: theme.getEntryItemDecoration(false),
                      ),
                    ),
                    Padding(
                      padding: AppScale.only(
                        top: 20,
                        left: 20,
                        right: 20,
                        bottom: 40,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ReorderableListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            buildDefaultDragHandles: false,
                            onReorder: (oldIndex, newIndex) {
                              setState(() {
                                if (newIndex > oldIndex) newIndex -= 1;
                                final item = _tasks.removeAt(oldIndex);
                                _tasks.insert(newIndex, item);
                              });
                              _recordState();
                            },
                            proxyDecorator: (child, index, animation) {
                              return AnimatedBuilder(
                                animation: animation,
                                builder: (context, _) {
                                  return Material(
                                    color: Colors.transparent,
                                    child: child,
                                  );
                                },
                              );
                            },
                            header: null,
                            footer: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: AppScale.only(left: 20),
                                child: TextButton.icon(
                                  onPressed: _addTask,
                                  icon: Icon(Icons.add, color: theme.primaryColor),
                                  label: Text(
                                    'Add Item',
                                    style: theme.themeItemTitleStyle.copyWith(
                                      color: theme.primaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            children: [
                              for (var i = 0; i < _tasks.length; i++)
                                _TaskEditorRow(
                                  key: _tasks[i].key,
                                  index: i,
                                  draft: _tasks[i],
                                  onToggle: () {
                                    setState(() {
                                      _tasks[i].completed = !_tasks[i].completed;
                                    });
                                    _recordState();
                                  },
                                  onRemove: () => _removeTask(i),
                                  onAdd: _addTask,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    EditorTimestamp(
                      theme: theme,
                      timestamp: widget.todo?.createdAt ?? DateTime.now(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _addTask({bool autofocus = true, bool record = true}) {
    final focusNode = FocusNode();
    final controller = TextEditingController();
    controller.addListener(_scheduleRecordState);
    setState(() {
      _tasks.add(
        _TaskDraft(controller: controller, focusNode: focusNode),
      );
    });
    if (autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        focusNode.requestFocus();
      });
    }
    if (record) _recordState();
  }

  void _removeTask(int index) {
    final removed = _tasks.removeAt(index);
    removed.controller.removeListener(_scheduleRecordState);
    removed.controller.dispose();
    removed.focusNode.dispose();
    setState(() {});
    _recordState();
  }

  void _save() {
    Navigator.of(context).pop(
      TodoEditorResult(
        title: _titleController.text,
        tasks: _tasks
            .map(
              (task) => TodoTask(
                text: task.controller.text,
                completed: task.completed,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _TaskEditorRow extends StatelessWidget {
  const _TaskEditorRow({
    required this.draft,
    required this.index,
    required this.onToggle,
    required this.onRemove,
    required this.onAdd,
    super.key,
  });

  final _TaskDraft draft;
  final int index;
  final VoidCallback onToggle;
  final VoidCallback onRemove;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController().currentTheme;
    return Row(
      children: [
        ReorderableDragStartListener(
          index: index,
          child: Padding(
            padding: AppScale.only(right: 8),
            child: Icon(
              Icons.drag_indicator,
              color: theme.appBarIconColor.withValues(alpha: 0.3),
              size: 20,
            ),
          ),
        ),
        IconButton(
          onPressed: onToggle,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Icon(
            draft.completed ? Icons.check_box : Icons.check_box_outline_blank,
            color: theme.primaryColor,
            size: 22,
          ),
        ),
        SizedBox(width: AppScale.size(12)),
        Expanded(
          child: TextField(
            controller: draft.controller,
            focusNode: draft.focusNode,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            minLines: 1,
            onChanged: (value) {
              if (value.endsWith('\n')) {
                draft.controller.text = value.substring(0, value.length - 1);
                onAdd();
              }
            },
            style: theme.entrySubtitleStyle.copyWith(
              fontSize: 16,
              decoration: draft.completed ? TextDecoration.lineThrough : null,
            ),
            decoration: InputDecoration(
              hintText: 'Todo',
              hintStyle: theme.entrySubtitleStyle.copyWith(
                fontSize: 17,
                color: theme.appBarIconColor.withValues(alpha: .35),
              ),
              border: InputBorder.none,
            ),
          ),
        ),
        IconButton(
          onPressed: onRemove,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Icon(theme.icons.clear, color: theme.deleteIconColor, size: 20),
        ),
      ],
    );
  }
}

class _TaskDraft {
  _TaskDraft({
    required this.controller,
    required this.focusNode,
    this.completed = false,
  }) : key = UniqueKey();

  final TextEditingController controller;
  final FocusNode focusNode;
  final Key key;
  bool completed;
}

class TodoEditorResult {
  const TodoEditorResult({
    required this.title, 
    required this.tasks,
  });

  final String title;
  final List<TodoTask> tasks;
}

class _TodoState {
  const _TodoState({required this.title, required this.tasks});
  final String title;
  final List<_TaskItemState> tasks;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _TodoState &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          _listEquals(tasks, other.tasks);

  @override
  int get hashCode => title.hashCode ^ tasks.length;

  bool _listEquals(List<_TaskItemState> a, List<_TaskItemState> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

class _TaskItemState {
  const _TaskItemState({required this.text, required this.completed});
  final String text;
  final bool completed;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _TaskItemState &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          completed == other.completed;

  @override
  int get hashCode => text.hashCode ^ completed.hashCode;
}
