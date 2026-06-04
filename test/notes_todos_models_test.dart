import 'package:flutter_test/flutter_test.dart';
import 'package:notes_todos/src/features/notes_todos/data/notes_todos_repository.dart';
import 'package:notes_todos/src/features/notes_todos/domain/note_item.dart';
import 'package:notes_todos/src/features/notes_todos/domain/search_result.dart';
import 'package:notes_todos/src/features/notes_todos/domain/todo_list_item.dart';
import 'package:notes_todos/src/features/notes_todos/domain/todo_task.dart';
import 'package:notes_todos/src/features/notes_todos/presentation/notes_todos_controller.dart';

void main() {
  group('Notes and todos models', () {
    test('NoteItem maps to and from database rows', () {
      final now = DateTime(2026, 5, 23, 12, 30);
      final note = NoteItem(
        id: 7,
        title: 'Plan',
        content: 'Clean the project',
        createdAt: now,
        updatedAt: now,
        pinned: true,
      );

      final restored = NoteItem.fromMap(note.toMap());

      expect(restored.id, 7);
      expect(restored.title, 'Plan');
      expect(restored.content, 'Clean the project');
      expect(restored.createdAt, now);
      expect(restored.updatedAt, now);
      expect(restored.pinned, isTrue);
    });

    test('TodoTask maps to and from JSON', () {
      final now = DateTime(2026, 6, 2, 10, 0);
      final task = TodoTask(
        text: 'Ship app',
        completed: true,
        dueAt: now,
      );

      final restored = TodoTask.fromJson(task.toJson());

      expect(restored.text, 'Ship app');
      expect(restored.completed, isTrue);
      expect(restored.dueAt, now);
    });

    test('TodoListItem copyWith updates tasks immutably', () {
      final now = DateTime(2026, 5, 23);
      final todo = TodoListItem(
        id: 1,
        title: 'Launch',
        tasks: const [TodoTask(text: 'Test')],
        createdAt: now,
        updatedAt: now,
      );

      final updated = todo.copyWith(
        tasks: const [TodoTask(text: 'Test', completed: true)],
      );

      expect(todo.tasks.single.completed, isFalse);
      expect(updated.tasks.single.completed, isTrue);
    });
  });

  group('NotesTodosController', () {
    test('sorts loaded notes by pinned and then updated time', () async {
      final older = DateTime(2026, 5, 23);
      final newer = DateTime(2026, 5, 24);
      final repository = _FakeNotesTodosRepository(
        notes: [
          NoteItem(
            id: 1,
            title: 'Older',
            content: '',
            createdAt: older,
            updatedAt: older,
          ),
          NoteItem(
            id: 2,
            title: 'Newer',
            content: '',
            createdAt: older,
            updatedAt: newer,
          ),
          NoteItem(
            id: 3,
            title: 'Pinned Older',
            content: '',
            createdAt: older,
            updatedAt: older,
            pinned: true,
          ),
        ],
      );
      final controller = NotesTodosController(repository: repository);

      await controller.load();

      expect(controller.notes.map((note) => note.title), [
        'Pinned Older',
        'Newer',
        'Older',
      ]);

      controller.setSortOrder(SortOrder.oldestFirst);

      expect(controller.notes.map((note) => note.title), [
        'Pinned Older',
        'Older',
        'Newer',
      ]);
      controller.dispose();
    });
  });
}

class _FakeNotesTodosRepository implements NotesTodosRepository {
  _FakeNotesTodosRepository({
    List<NoteItem>? notes,
    List<TodoListItem>? todos,
  })  : _notes = [...?notes],
        _todos = [...?todos];

  final List<NoteItem> _notes;
  final List<TodoListItem> _todos;
  Set<int>? _trackedTodoIds;

  @override
  Future<Set<int>?> getTrackedTodoIds() async => _trackedTodoIds;

  @override
  Future<void> saveTrackedTodoIds(Set<int>? ids) async {
    _trackedTodoIds = ids;
  }

  @override
  Future<List<NoteItem>> getActiveNotes() async =>
      _notes.where((n) => !n.archived && n.deletedAt == null).toList();

  @override
  Future<List<NoteItem>> getArchivedNotes() async =>
      _notes.where((n) => n.archived && n.deletedAt == null).toList();

  @override
  Future<List<NoteItem>> getTrashedNotes() async =>
      _notes.where((n) => n.deletedAt != null).toList();

  @override
  Future<int> saveNote(NoteItem note) async {
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index == -1) {
      final id = _notes.length + 1;
      _notes.add(note.copyWith(id: id));
      return id;
    } else {
      _notes[index] = note;
      return note.id!;
    }
  }

  @override
  Future<void> deleteNote(int id) async {
    _notes.removeWhere((n) => n.id == id);
  }

  @override
  Future<List<TodoListItem>> getActiveTodoLists() async =>
      _todos.where((t) => !t.archived && t.deletedAt == null).toList();

  @override
  Future<List<TodoListItem>> getArchivedTodoLists() async =>
      _todos.where((t) => t.archived && t.deletedAt == null).toList();

  @override
  Future<List<TodoListItem>> getTrashedTodoLists() async =>
      _todos.where((t) => t.deletedAt != null).toList();

  @override
  Future<int> saveTodoList(TodoListItem todo) async {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index == -1) {
      final id = _todos.length + 1;
      _todos.add(todo.copyWith(id: id));
      return id;
    } else {
      _todos[index] = todo;
      return todo.id!;
    }
  }

  @override
  Future<void> deleteTodoList(int id) async {
    _todos.removeWhere((t) => t.id == id);
  }

  @override
  Future<List<NoteItem>> getPinnedNotes() async =>
      _notes.where((n) => n.pinned && !n.archived && n.deletedAt == null).toList();

  @override
  Future<List<TodoListItem>> getPinnedTodoLists() async =>
      _todos.where((t) => t.pinned && !t.archived && t.deletedAt == null).toList();

  @override
  Future<void> togglePinNote(NoteItem note) async => saveNote(note.copyWith(pinned: !note.pinned));

  @override
  Future<void> archiveNote(NoteItem note) async => saveNote(note.copyWith(archived: true, pinned: false));

  @override
  Future<void> unarchiveNote(NoteItem note) async => saveNote(note.copyWith(archived: false));

  @override
  Future<void> trashNote(NoteItem note) async => saveNote(note.copyWith(deletedAt: DateTime.now(), pinned: false));

  @override
  Future<void> restoreNote(NoteItem note) async => saveNote(note.copyWith(clearDeletedAt: true));

  @override
  Future<void> togglePinTodoList(TodoListItem todo) async => saveTodoList(todo.copyWith(pinned: !todo.pinned));

  @override
  Future<void> archiveTodoList(TodoListItem todo) async => saveTodoList(todo.copyWith(archived: true, pinned: false));

  @override
  Future<void> unarchiveTodoList(TodoListItem todo) async => saveTodoList(todo.copyWith(archived: false));

  @override
  Future<void> trashTodoList(TodoListItem todo) async => saveTodoList(todo.copyWith(deletedAt: DateTime.now(), pinned: false));

  @override
  Future<void> restoreTodoList(TodoListItem todo) async => saveTodoList(todo.copyWith(clearDeletedAt: true));

  Future<void> togglePinNotes(Iterable<int> ids) async {
    for (final id in ids) {
      final index = _notes.indexWhere((n) => n.id == id);
      if (index != -1) _notes[index] = _notes[index].copyWith(pinned: !_notes[index].pinned);
      final tIndex = _todos.indexWhere((t) => t.id == id);
      if (tIndex != -1) _todos[tIndex] = _todos[tIndex].copyWith(pinned: !_todos[tIndex].pinned);
    }
  }

  Future<void> archiveNotes(Iterable<int> ids) async {
    for (final id in ids) {
      final index = _notes.indexWhere((n) => n.id == id);
      if (index != -1) _notes[index] = _notes[index].copyWith(archived: true, pinned: false);
    }
  }

  Future<void> archiveTodoLists(Iterable<int> ids) async {
    for (final id in ids) {
      final index = _todos.indexWhere((t) => t.id == id);
      if (index != -1) _todos[index] = _todos[index].copyWith(archived: true, pinned: false);
    }
  }

  Future<void> unarchiveNotes(Iterable<int> ids) async {
    for (final id in ids) {
      final index = _notes.indexWhere((n) => n.id == id);
      if (index != -1) _notes[index] = _notes[index].copyWith(archived: false);
    }
  }

  Future<void> unarchiveTodoLists(Iterable<int> ids) async {
    for (final id in ids) {
      final index = _todos.indexWhere((t) => t.id == id);
      if (index != -1) _todos[index] = _todos[index].copyWith(archived: false);
    }
  }

  Future<void> restoreNotes(Iterable<int> ids) async {
    for (final id in ids) {
      final index = _notes.indexWhere((n) => n.id == id);
      if (index != -1) _notes[index] = _notes[index].copyWith(clearDeletedAt: true);
    }
  }

  Future<void> restoreTodoLists(Iterable<int> ids) async {
    for (final id in ids) {
      final index = _todos.indexWhere((t) => t.id == id);
      if (index != -1) _todos[index] = _todos[index].copyWith(clearDeletedAt: true);
    }
  }

  @override
  Future<List<SearchResult>> search(String query) async => [];

  @override
  Future<String> exportBackup() async => '';

  @override
  Future<void> importBackup(String json) async {}
}
