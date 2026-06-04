class TodoTask {
  const TodoTask({
    required this.text,
    this.completed = false,
    this.dueAt,
    this.completedAt,
  });

  final String text;
  final bool completed;
  final DateTime? dueAt;
  final DateTime? completedAt;

  TodoTask copyWith({
    String? text,
    bool? completed,
    DateTime? dueAt,
    DateTime? completedAt,
  }) {
    return TodoTask(
      text: text ?? this.text,
      completed: completed ?? this.completed,
      dueAt: dueAt ?? this.dueAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'completed': completed,
      'due_at': dueAt?.millisecondsSinceEpoch,
      'completed_at': completedAt?.millisecondsSinceEpoch,
    };
  }

  factory TodoTask.fromJson(Map<String, dynamic> json) {
    return TodoTask(
      text: json['text'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
      dueAt: json['due_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['due_at'] as int)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['completed_at'] as int)
          : null,
    );
  }
}
