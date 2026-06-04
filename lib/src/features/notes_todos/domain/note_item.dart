class NoteItem {
  const NoteItem({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.pinned = false,
    this.archived = false,
    this.deletedAt,
  });

  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool pinned;
  final bool archived;
  final DateTime? deletedAt;

  NoteItem copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? pinned,
    bool? archived,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return NoteItem(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      pinned: pinned ?? this.pinned,
      archived: archived ?? this.archived,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'content': content,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'pinned': pinned ? 1 : 0,
      'archived': archived ? 1 : 0,
      'deleted_at': deletedAt?.millisecondsSinceEpoch,
    };
  }

  factory NoteItem.fromMap(Map<String, dynamic> map) {
    return NoteItem(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
      pinned: (map['pinned'] as int? ?? 0) == 1,
      archived: (map['archived'] as int? ?? 0) == 1,
      deletedAt: map['deleted_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deleted_at'] as int)
          : null,
    );
  }
}
