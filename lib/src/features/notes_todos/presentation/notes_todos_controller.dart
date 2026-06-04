import 'package:flutter/material.dart';

import '../data/notes_todos_repository.dart';
import '../domain/note_item.dart';
import '../domain/search_result.dart';
import '../domain/todo_list_item.dart';
import '../domain/todo_task.dart';

enum SortOrder {
  newestFirst,
  oldestFirst,
}

enum ViewState { active, archived, trash }

enum UndoType { trash, restore, archive, unarchive, pin, unpin, delete, save, create, reorder }

class UndoAction {
  UndoAction({
    required this.type,
    required this.message,
    this.notes,
    this.todos,
    this.previousViewState,
  }) : id = UniqueKey();

  final Key id;
  final UndoType type;
  final String message;
  final List<NoteItem>? notes;
  final List<TodoListItem>? todos;
  final ViewState? previousViewState;
}

class NotesTodosController extends ChangeNotifier {
  NotesTodosController({NotesTodosRepository? repository})
    : _repository = repository ?? NotesTodosRepository() {
    load();
  }

  final NotesTodosRepository _repository;
  List<NoteItem> _notes = <NoteItem>[];
  List<TodoListItem> _todos = <TodoListItem>[];
  List<SearchResult> _searchResults = <SearchResult>[];
  Set<int>? _trackedTodoIds;
  SortOrder _sortOrder = SortOrder.newestFirst;
  ViewState _viewState = ViewState.active;
  bool _loading = true;
  bool _disposed = false;
  String _searchQuery = '';
  int _loadSequence = 0;
  int _searchSequence = 0;

  UndoAction? _lastAction;
  UndoAction? get lastAction => _lastAction;
  bool get canUndo => _lastAction != null;

  List<NoteItem> get notes {
    if (isSearching) {
      final results = _searchResults
          .map((result) => result.note)
          .whereType<NoteItem>()
          .toList();
      return _sortItems(results);
    }
    return List.unmodifiable(_notes);
  }

  List<TodoListItem> get todos {
    if (isSearching) {
      final results = _searchResults
          .map((result) => result.todoList)
          .whereType<TodoListItem>()
          .toList();
      return _sortItems(results);
    }
    return List.unmodifiable(_todos);
  }

  List<SearchResult> get searchResults => List.unmodifiable(_searchResults);
  SortOrder get sortOrder => _sortOrder;
  ViewState get viewState => _viewState;
  bool get loading => _loading;
  String get searchQuery => _searchQuery;
  bool get isSearching => _searchQuery.isNotEmpty;
  Set<int>? get trackedTodoIds => _trackedTodoIds;

  Future<void> load() async {
    final sequence = ++_loadSequence;
    _loading = true;
    _notify();

    final trackedTodoIds = await _repository.getTrackedTodoIds();
    if (_disposed || sequence != _loadSequence) return;
    
    late final List<NoteItem> loadedNotes;
    late final List<TodoListItem> loadedTodos;
    switch (_viewState) {
      case ViewState.active:
        loadedNotes = await _repository.getActiveNotes();
        loadedTodos = await _repository.getActiveTodoLists();
        break;
      case ViewState.archived:
        loadedNotes = await _repository.getArchivedNotes();
        loadedTodos = await _repository.getArchivedTodoLists();
        break;
      case ViewState.trash:
        loadedNotes = await _repository.getTrashedNotes();
        loadedTodos = await _repository.getTrashedTodoLists();
        break;
    }

    if (_disposed || sequence != _loadSequence) return;
    _trackedTodoIds = trackedTodoIds;
    _notes = loadedNotes;
    _todos = loadedTodos;
    
    _applySort();
    _loading = false;
    _notify();
  }

  Future<void> updateTrackedTodoIds(Set<int>? ids) async {
    _trackedTodoIds = ids;
    await _repository.saveTrackedTodoIds(ids);
    _notify();
  }

  void setViewState(ViewState state) {
    if (_viewState == state) return;
    _viewState = state;
    load();
  }

  Future<void> search(String query) async {
    final sequence = ++_searchSequence;
    _searchQuery = query;
    if (query.isEmpty) {
      _searchResults = [];
    } else {
      final results = await _repository.search(query);
      if (_disposed || sequence != _searchSequence) return;
      _searchResults = results;
    }
    _notify();
  }

  void _recordAction(UndoAction action) {
    _lastAction = action;
    _notify();
  }

  void clearLastAction() {
    _lastAction = null;
    _notify();
  }

  Future<void> undo() async {
    if (_lastAction == null) return;
    final action = _lastAction!;
    _lastAction = null;

    switch (action.type) {
      case UndoType.pin:
      case UndoType.unpin:
        if (action.notes != null) {
          for (final note in action.notes!) {
            await _repository.togglePinNote(note);
          }
        }
        if (action.todos != null) {
          for (final todo in action.todos!) {
            await _repository.togglePinTodoList(todo);
          }
        }
        break;
      case UndoType.archive:
      case UndoType.unarchive:
        if (action.notes != null) {
          for (final note in action.notes!) {
            if (action.type == UndoType.archive) {
              await _repository.unarchiveNote(note);
            } else {
              await _repository.archiveNote(note);
            }
          }
        }
        if (action.todos != null) {
          for (final todo in action.todos!) {
            if (action.type == UndoType.archive) {
              await _repository.unarchiveTodoList(todo);
            } else {
              await _repository.archiveTodoList(todo);
            }
          }
        }
        break;
      case UndoType.trash:
      case UndoType.restore:
        if (action.notes != null) {
          for (final note in action.notes!) {
            if (action.type == UndoType.trash) {
              await _repository.restoreNote(note);
            } else {
              await _repository.trashNote(note);
            }
          }
        }
        if (action.todos != null) {
          for (final todo in action.todos!) {
            if (action.type == UndoType.trash) {
              await _repository.restoreTodoList(todo);
            } else {
              await _repository.trashTodoList(todo);
            }
          }
        }
        break;
      case UndoType.delete:
        // Permanent delete is not undoable
        break;
      case UndoType.create:
        if (action.notes != null) {
          for (final note in action.notes!) {
            if (note.id != null) await _repository.deleteNote(note.id!);
          }
        }
        if (action.todos != null) {
          for (final todo in action.todos!) {
            if (todo.id != null) await _repository.deleteTodoList(todo.id!);
          }
        }
        break;
      case UndoType.save:
        if (action.notes != null) {
          for (final note in action.notes!) {
            if (note.id != null) await _repository.saveNote(note);
          }
        }
        if (action.todos != null) {
          for (final todo in action.todos!) {
            if (todo.id != null) await _repository.saveTodoList(todo);
          }
        }
        break;
      case UndoType.reorder:
        break;
    }

    await load();
  }

  // Pin actions
  Future<void> togglePinNote(NoteItem note) async {
    await _repository.togglePinNote(note);
    _recordAction(UndoAction(
      type: note.pinned ? UndoType.unpin : UndoType.pin,
      message: note.pinned ? 'Note unpinned' : 'Note pinned',
      notes: [note],
    ));
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = note.copyWith(pinned: !note.pinned);
      _applySort();
      _notify();
    }
  }

  Future<void> togglePinTodoList(TodoListItem todo) async {
    await _repository.togglePinTodoList(todo);
    _recordAction(UndoAction(
      type: todo.pinned ? UndoType.unpin : UndoType.pin,
      message: todo.pinned ? 'List unpinned' : 'List pinned',
      todos: [todo],
    ));
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo.copyWith(pinned: !todo.pinned);
      _applySort();
      _notify();
    }
  }

  Future<void> togglePinNotes(Iterable<int> ids) async {
    final idSet = ids.toSet();
    final affected = <NoteItem>[];
    for (final id in idSet) {
      final note = _notes.firstWhere((n) => n.id == id);
      affected.add(note);
      await _repository.togglePinNote(note);
      final index = _notes.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notes[index] = note.copyWith(pinned: !note.pinned);
      }
    }
    _recordAction(UndoAction(
      type: UndoType.pin,
      message: '${affected.length} notes updated',
      notes: affected,
    ));
    _applySort();
    _notify();
  }

  Future<void> togglePinTodoLists(Iterable<int> ids) async {
    final idSet = ids.toSet();
    final affected = <TodoListItem>[];
    for (final id in idSet) {
      final todo = _todos.firstWhere((t) => t.id == id);
      affected.add(todo);
      await _repository.togglePinTodoList(todo);
      final index = _todos.indexWhere((t) => t.id == id);
      if (index != -1) {
        _todos[index] = todo.copyWith(pinned: !todo.pinned);
      }
    }
    _recordAction(UndoAction(
      type: UndoType.pin,
      message: '${affected.length} lists updated',
      todos: affected,
    ));
    _applySort();
    _notify();
  }

  // Archive actions
  Future<void> archiveNote(NoteItem note) async {
    await _repository.archiveNote(note);
    _recordAction(UndoAction(
      type: UndoType.archive,
      message: 'Note archived',
      notes: [note],
    ));
    _notes.removeWhere((n) => n.id == note.id);
    _notify();
  }

  Future<void> unarchiveNote(NoteItem note) async {
    await _repository.unarchiveNote(note);
    _recordAction(UndoAction(
      type: UndoType.unarchive,
      message: 'Note unarchived',
      notes: [note],
    ));
    _notes.removeWhere((n) => n.id == note.id);
    _notify();
  }

  Future<void> archiveTodoList(TodoListItem todo) async {
    await _repository.archiveTodoList(todo);
    _recordAction(UndoAction(
      type: UndoType.archive,
      message: 'List archived',
      todos: [todo],
    ));
    _todos.removeWhere((t) => t.id == todo.id);
    _notify();
  }

  Future<void> unarchiveTodoList(TodoListItem todo) async {
    await _repository.unarchiveTodoList(todo);
    _recordAction(UndoAction(
      type: UndoType.unarchive,
      message: 'List unarchived',
      todos: [todo],
    ));
    _todos.removeWhere((t) => t.id == todo.id);
    _notify();
  }

  Future<void> archiveNotes(Iterable<int> ids) async {
    final idSet = ids.toSet();
    final affected = <NoteItem>[];
    for (final id in idSet) {
      final note = _notes.firstWhere((n) => n.id == id);
      affected.add(note);
      await _repository.archiveNote(note);
    }
    _recordAction(UndoAction(
      type: UndoType.archive,
      message: '${affected.length} notes archived',
      notes: affected,
    ));
    _notes.removeWhere((n) => idSet.contains(n.id));
    _notify();
  }

  Future<void> archiveTodoLists(Iterable<int> ids) async {
    final idSet = ids.toSet();
    final affected = <TodoListItem>[];
    for (final id in idSet) {
      final todo = _todos.firstWhere((t) => t.id == id);
      affected.add(todo);
      await _repository.archiveTodoList(todo);
    }
    _recordAction(UndoAction(
      type: UndoType.archive,
      message: '${affected.length} lists archived',
      todos: affected,
    ));
    _todos.removeWhere((t) => idSet.contains(t.id));
    _notify();
  }

  Future<void> unarchiveNotes(Iterable<int> ids) async {
    final idSet = ids.toSet();
    final affected = <NoteItem>[];
    for (final id in idSet) {
      final note = _notes.firstWhere((n) => n.id == id);
      affected.add(note);
      await _repository.unarchiveNote(note);
    }
    _recordAction(UndoAction(
      type: UndoType.unarchive,
      message: '${affected.length} notes unarchived',
      notes: affected,
    ));
    _notes.removeWhere((n) => idSet.contains(n.id));
    _notify();
  }

  Future<void> unarchiveTodoLists(Iterable<int> ids) async {
    final idSet = ids.toSet();
    final affected = <TodoListItem>[];
    for (final id in idSet) {
      final todo = _todos.firstWhere((t) => t.id == id);
      affected.add(todo);
      await _repository.unarchiveTodoList(todo);
    }
    _recordAction(UndoAction(
      type: UndoType.unarchive,
      message: '${affected.length} lists unarchived',
      todos: affected,
    ));
    _todos.removeWhere((t) => idSet.contains(t.id));
    _notify();
  }

  // Trash actions
  Future<void> trashNote(NoteItem note) async {
    await _repository.trashNote(note);
    _recordAction(UndoAction(
      type: UndoType.trash,
      message: 'Note moved to Trash',
      notes: [note],
    ));
    _notes.removeWhere((n) => n.id == note.id);
    _notify();
  }

  Future<void> restoreNote(NoteItem note) async {
    await _repository.restoreNote(note);
    _recordAction(UndoAction(
      type: UndoType.restore,
      message: 'Note restored',
      notes: [note],
    ));
    _notes.removeWhere((n) => n.id == note.id);
    _notify();
  }

  Future<void> trashTodoList(TodoListItem todo) async {
    await _repository.trashTodoList(todo);
    _recordAction(UndoAction(
      type: UndoType.trash,
      message: 'List moved to Trash',
      todos: [todo],
    ));
    _todos.removeWhere((t) => t.id == todo.id);
    _notify();
  }

  Future<void> restoreTodoList(TodoListItem todo) async {
    await _repository.restoreTodoList(todo);
    _recordAction(UndoAction(
      type: UndoType.restore,
      message: 'List restored',
      todos: [todo],
    ));
    _todos.removeWhere((t) => t.id == todo.id);
    _notify();
  }

  Future<void> restoreNotes(Iterable<int> ids) async {
    final idSet = ids.toSet();
    final affected = <NoteItem>[];
    for (final id in idSet) {
      final note = _notes.firstWhere((n) => n.id == id);
      affected.add(note);
      await _repository.restoreNote(note);
    }
    _recordAction(UndoAction(
      type: UndoType.restore,
      message: '${affected.length} notes restored',
      notes: affected,
    ));
    _notes.removeWhere((n) => idSet.contains(n.id));
    _notify();
  }

  Future<void> restoreTodoLists(Iterable<int> ids) async {
    final idSet = ids.toSet();
    final affected = <TodoListItem>[];
    for (final id in idSet) {
      final todo = _todos.firstWhere((t) => t.id == id);
      affected.add(todo);
      await _repository.restoreTodoList(todo);
    }
    _recordAction(UndoAction(
      type: UndoType.restore,
      message: '${affected.length} lists restored',
      todos: affected,
    ));
    _todos.removeWhere((t) => idSet.contains(t.id));
    _notify();
  }

  // Permanent Delete
  Future<void> purgeNote(int id) async {
    await _repository.deleteNote(id);
    _notes.removeWhere((n) => n.id == id);
    clearLastAction();
    _notify();
  }

  Future<void> purgeTodoList(int id) async {
    await _repository.deleteTodoList(id);
    _todos.removeWhere((t) => t.id == id);
    clearLastAction();
    _notify();
  }

  void setSortOrder(SortOrder order) {
    if (_sortOrder == order) return;
    _sortOrder = order;
    _applySort();
    _notify();
  }

  void _applySort() {
    _notes = _sortItems(_notes);
    _todos = _sortItems(_todos);
  }

  List<T> _sortItems<T>(List<T> items) {
    DateTime updatedAtOf(T item) {
      if (item is NoteItem) return item.updatedAt;
      if (item is TodoListItem) return item.updatedAt;
      return DateTime.fromMillisecondsSinceEpoch(0);
    }

    bool isPinned(T item) {
      if (item is NoteItem) return item.pinned;
      if (item is TodoListItem) return item.pinned;
      return false;
    }

    return [...items]..sort((a, b) {
      if (isPinned(a) && !isPinned(b)) return -1;
      if (!isPinned(a) && isPinned(b)) return 1;

      if (_sortOrder == SortOrder.newestFirst) {
        return updatedAtOf(b).compareTo(updatedAtOf(a));
      } else {
        return updatedAtOf(a).compareTo(updatedAtOf(b));
      }
    });
  }

  Future<NoteItem> saveNote({
    NoteItem? existing,
    required String title,
    required String content,
    bool? pinned,
    bool? archived,
    DateTime? deletedAt,
  }) async {
    final now = DateTime.now();
    final isCreate = existing?.id == null;
    final normalizedTitle = _defaultTitle(title, 'Untitled Note');
    final item = isCreate
        ? NoteItem(
            title: normalizedTitle,
            content: content.trim(),
            createdAt: now,
            updatedAt: now,
            pinned: pinned ?? false,
            archived: archived ?? false,
            deletedAt: deletedAt,
          )
        : existing?.copyWith(
            title: normalizedTitle,
            content: content.trim(),
            updatedAt: now,
            pinned: pinned,
            archived: archived,
            deletedAt: deletedAt,
          );

    final id = await _repository.saveNote(item!);
    final savedItem = item.id == null ? item.copyWith(id: id) : item;
    final undoNote = isCreate ? savedItem : existing!;

    _recordAction(UndoAction(
      type: isCreate ? UndoType.create : UndoType.save,
      message: isCreate ? 'Note created' : 'Changes saved',
      notes: [undoNote],
    ));

    if (isCreate) {
      _notes = [savedItem, ..._notes];
    } else {
      _notes = _notes.map((n) => n.id == savedItem.id ? savedItem : n).toList();
    }

    _applySort();
    _notify();
    return savedItem;
  }

  Future<void> deleteNote(int id) async {
    _notes.firstWhere((n) => n.id == id);
    await _repository.deleteNote(id);
    _notes = _notes.where((item) => item.id != id).toList();
    _notify();
  }

  Future<void> deleteNotes(Iterable<int> ids) async {
    final idSet = ids.toSet();
    if (idSet.isEmpty) return;

    final affectedNotes = <NoteItem>[];
    for (final id in idSet) {
      final note = _notes.firstWhere((n) => n.id == id);
      affectedNotes.add(note);
      if (_viewState == ViewState.trash) {
        await _repository.deleteNote(id);
      } else {
        await _repository.trashNote(note);
      }
    }
    
    if (_viewState != ViewState.trash) {
      _recordAction(UndoAction(
        type: UndoType.trash,
        message: '${affectedNotes.length} notes moved to Trash',
        notes: affectedNotes,
      ));
    } else {
      clearLastAction();
    }

    _notes = _notes.where((item) => !idSet.contains(item.id)).toList();
    _notify();
  }

  Future<TodoListItem> saveTodoList({
    TodoListItem? existing,
    required String title,
    required List<TodoTask> tasks,
    bool? pinned,
    bool? archived,
    DateTime? deletedAt,
  }) async {
    final now = DateTime.now();
    final isCreate = existing?.id == null;
    final normalizedTasks = tasks
        .map((task) => task.copyWith(text: task.text.trim()))
        .where((task) => task.text.isNotEmpty)
        .toList();
    final item = isCreate
        ? TodoListItem(
            title: _defaultTitle(title, 'Untitled Todo'),
            tasks: normalizedTasks,
            createdAt: now,
            updatedAt: now,
            pinned: pinned ?? false,
            archived: archived ?? false,
            deletedAt: deletedAt,
          )
        : existing?.copyWith(
            title: _defaultTitle(title, 'Untitled Todo'),
            tasks: normalizedTasks,
            updatedAt: now,
            pinned: pinned,
            archived: archived,
            deletedAt: deletedAt,
          );

    final id = await _repository.saveTodoList(item!);
    final savedItem = item.id == null ? item.copyWith(id: id) : item;
    final undoTodo = isCreate ? savedItem : existing!;

    _recordAction(UndoAction(
      type: isCreate ? UndoType.create : UndoType.save,
      message: isCreate ? 'List created' : 'Changes saved',
      todos: [undoTodo],
    ));

    if (isCreate) {
      _todos = [savedItem, ..._todos];
    } else {
      _todos = _todos.map((t) => t.id == savedItem.id ? savedItem : t).toList();
    }

    _applySort();
    _notify();
    return savedItem;
  }

  Future<void> deleteTodoList(int id) async {
    _todos.firstWhere((t) => t.id == id);
    await _repository.deleteTodoList(id);
    _todos = _todos.where((item) => item.id != id).toList();
    _notify();
  }

  Future<void> deleteTodoLists(Iterable<int> ids) async {
    final idSet = ids.toSet();
    if (idSet.isEmpty) return;

    final affectedTodos = <TodoListItem>[];
    for (final id in idSet) {
      final todo = _todos.firstWhere((t) => t.id == id);
      affectedTodos.add(todo);
      if (_viewState == ViewState.trash) {
        await _repository.deleteTodoList(id);
      } else {
        await _repository.trashTodoList(todo);
      }
    }

    if (_viewState != ViewState.trash) {
      _recordAction(UndoAction(
        type: UndoType.trash,
        message: '${affectedTodos.length} lists moved to Trash',
        todos: affectedTodos,
      ));
    } else {
      clearLastAction();
    }

    _todos = _todos.where((item) => !idSet.contains(item.id)).toList();
    _notify();
  }

  void reorderNotes(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = _notes.removeAt(oldIndex);
    _notes.insert(newIndex, item);
    _notify();
  }

  void reorderTodos(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = _todos.removeAt(oldIndex);
    _todos.insert(newIndex, item);
    _notify();
  }

  Future<void> toggleTask(TodoListItem list, int index) async {
    if (index < 0 || index >= list.tasks.length) return;
    final tasks = [...list.tasks];
    final task = tasks[index];
    final now = DateTime.now();
    tasks[index] = task.copyWith(
      completed: !task.completed,
      completedAt: !task.completed ? now : null,
    );
    await saveTodoList(existing: list, title: list.title, tasks: tasks);
  }

  Future<void> removeTask(TodoListItem list, int index) async {
    if (index < 0 || index >= list.tasks.length) return;
    final tasks = [...list.tasks]..removeAt(index);
    await saveTodoList(existing: list, title: list.title, tasks: tasks);
  }

  String _defaultTitle(String title, String fallback) {
    final trimmed = title.trim();
    return trimmed.isEmpty ? fallback : trimmed;
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
