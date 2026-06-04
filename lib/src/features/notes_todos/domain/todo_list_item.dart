import 'dart:convert';
import 'todo_task.dart';

class TodoListItem {
  const TodoListItem({
    this.id,
    required this.title,
    required this.tasks,
    required this.createdAt,
    required this.updatedAt,
    this.pinned = false,
    this.archived = false,
    this.deletedAt,
    this.dueAt,
    this.completedAt,
  });

  final int? id;
  final String title;
  final List<TodoTask> tasks;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool pinned;
  final bool archived;
  final DateTime? deletedAt;
  final DateTime? dueAt;
  final DateTime? completedAt;

  TodoListItem copyWith({
    int? id,
    String? title,
    List<TodoTask>? tasks,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? pinned,
    bool? archived,
    DateTime? deletedAt,
    DateTime? dueAt,
    DateTime? completedAt,
    bool clearDeletedAt = false,
    bool clearDueAt = false,
    bool clearCompletedAt = false,
  }) {
    return TodoListItem(
      id: id ?? this.id,
      title: title ?? this.title,
      tasks: tasks ?? this.tasks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      pinned: pinned ?? this.pinned,
      archived: archived ?? this.archived,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
      dueAt: clearDueAt ? null : (dueAt ?? this.dueAt),
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'tasks': jsonEncode(tasks.map((task) => task.toJson()).toList()),
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'pinned': pinned ? 1 : 0,
      'archived': archived ? 1 : 0,
      'deleted_at': deletedAt?.millisecondsSinceEpoch,
      'due_at': dueAt?.millisecondsSinceEpoch,
      'completed_at': completedAt?.millisecondsSinceEpoch,
    };
  }

  factory TodoListItem.fromMap(Map<String, dynamic> map) {
    final dynamic rawTasksData = map['tasks'];
    final List<dynamic> rawTasks = rawTasksData is String 
        ? jsonDecode(rawTasksData) as List<dynamic>
        : rawTasksData as List<dynamic>;

    return TodoListItem(
      id: map['id'] as int?,
      title: map['title'] as String,
      tasks: rawTasks
          .map((item) => TodoTask.fromJson(Map<String, dynamic>.from(item as Map)))
          .where((task) => task.text.trim().isNotEmpty)
          .toList(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
      pinned: (map['pinned'] as int? ?? 0) == 1,
      archived: (map['archived'] as int? ?? 0) == 1,
      deletedAt: map['deleted_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deleted_at'] as int)
          : null,
      dueAt: map['due_at'] != null ? DateTime.fromMillisecondsSinceEpoch(map['due_at'] as int) : null,
      completedAt: map['completed_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['completed_at'] as int)
          : null,
    );
  }
}
