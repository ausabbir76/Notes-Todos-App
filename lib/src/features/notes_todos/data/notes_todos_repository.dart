import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/note_item.dart';
import '../domain/search_result.dart';
import '../domain/todo_list_item.dart';
import 'notes_todos_database.dart';
import 'notes_todos_store.dart';

class NotesTodosRepository {
  NotesTodosRepository({NotesTodosStore? store, NotesTodosDatabase? database})
      : _database = store ?? database ?? NotesTodosDatabase();

  final NotesTodosStore _database;
  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  // Dashboard Preferences
  Future<Set<int>?> getTrackedTodoIds() async {
    try {
      final prefs = await _getPrefs();
      final savedIds = prefs.getStringList('tracked_todo_ids');
      if (savedIds == null || savedIds.isEmpty) return null;
      return savedIds.map(int.parse).toSet();
    } catch (e) {
      debugPrint('Error getting tracked todo IDs: $e');
      return null;
    }
  }

  Future<void> saveTrackedTodoIds(Set<int>? ids) async {
    try {
      final prefs = await _getPrefs();
      if (ids == null) {
        await prefs.remove('tracked_todo_ids');
      } else {
        await prefs.setStringList('tracked_todo_ids', ids.map((e) => e.toString()).toList());
      }
    } catch (e) {
      debugPrint('Error saving tracked todo IDs: $e');
    }
  }

  // Notes
  Future<List<NoteItem>> getActiveNotes() async {
    try {
      final notes = await _database.getNotes();
      return notes.where((n) => !n.archived && n.deletedAt == null).toList();
    } catch (e) {
      debugPrint('Error getting active notes: $e');
      return [];
    }
  }

  Future<List<NoteItem>> getArchivedNotes() async {
    try {
      final notes = await _database.getNotes();
      return notes.where((n) => n.archived && n.deletedAt == null).toList();
    } catch (e) {
      debugPrint('Error getting archived notes: $e');
      return [];
    }
  }

  Future<List<NoteItem>> getTrashedNotes() async {
    try {
      final notes = await _database.getNotes();
      return notes.where((n) => n.deletedAt != null).toList();
    } catch (e) {
      debugPrint('Error getting trashed notes: $e');
      return [];
    }
  }

  Future<int> saveNote(NoteItem note) async {
    try {
      if (note.id == null) {
        return await _database.insertNote(note);
      } else {
        return await _database.updateNote(note);
      }
    } catch (e) {
      debugPrint('Error saving note: $e');
      return 0;
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await _database.deleteNote(id);
    } catch (e) {
      debugPrint('Error deleting note: $id: $e');
    }
  }

  // Todo Lists
  Future<List<TodoListItem>> getActiveTodoLists() async {
    try {
      final todos = await _database.getTodoLists();
      return todos.where((t) => !t.archived && t.deletedAt == null).toList();
    } catch (e) {
      debugPrint('Error getting active todo lists: $e');
      return [];
    }
  }

  Future<List<TodoListItem>> getArchivedTodoLists() async {
    try {
      final todos = await _database.getTodoLists();
      return todos.where((t) => t.archived && t.deletedAt == null).toList();
    } catch (e) {
      debugPrint('Error getting archived todo lists: $e');
      return [];
    }
  }

  Future<List<TodoListItem>> getTrashedTodoLists() async {
    try {
      final todos = await _database.getTodoLists();
      return todos.where((t) => t.deletedAt != null).toList();
    } catch (e) {
      debugPrint('Error getting trashed todo lists: $e');
      return [];
    }
  }

  Future<int> saveTodoList(TodoListItem todo) async {
    try {
      if (todo.id == null) {
        return await _database.insertTodoList(todo);
      } else {
        return await _database.updateTodoList(todo);
      }
    } catch (e) {
      debugPrint('Error saving todo list: $e');
      return 0;
    }
  }

  Future<void> deleteTodoList(int id) async {
    try {
      await _database.deleteTodoList(id);
    } catch (e) {
      debugPrint('Error deleting todo list $id: $e');
    }
  }

  // Items by State
  Future<List<NoteItem>> getPinnedNotes() async {
    try {
      final notes = await _database.getNotes();
      return notes.where((n) => n.pinned && !n.archived && n.deletedAt == null).toList();
    } catch (e) {
      debugPrint('Error getting pinned notes: $e');
      return [];
    }
  }

  Future<List<TodoListItem>> getPinnedTodoLists() async {
    try {
      final todos = await _database.getTodoLists();
      return todos.where((t) => t.pinned && !t.archived && t.deletedAt == null).toList();
    } catch (e) {
      debugPrint('Error getting pinned todo lists: $e');
      return [];
    }
  }

  // Management Actions
  Future<void> togglePinNote(NoteItem note) async {
    await saveNote(note.copyWith(pinned: !note.pinned));
  }

  Future<void> archiveNote(NoteItem note) async {
    await saveNote(note.copyWith(archived: true, pinned: false));
  }

  Future<void> unarchiveNote(NoteItem note) async {
    await saveNote(note.copyWith(archived: false));
  }

  Future<void> trashNote(NoteItem note) async {
    await saveNote(note.copyWith(deletedAt: DateTime.now(), pinned: false));
  }

  Future<void> restoreNote(NoteItem note) async {
    await saveNote(note.copyWith(clearDeletedAt: true));
  }

  Future<void> togglePinTodoList(TodoListItem todo) async {
    await saveTodoList(todo.copyWith(pinned: !todo.pinned));
  }

  Future<void> archiveTodoList(TodoListItem todo) async {
    await saveTodoList(todo.copyWith(archived: true, pinned: false));
  }

  Future<void> unarchiveTodoList(TodoListItem todo) async {
    await saveTodoList(todo.copyWith(archived: false));
  }

  Future<void> trashTodoList(TodoListItem todo) async {
    await saveTodoList(todo.copyWith(deletedAt: DateTime.now(), pinned: false));
  }

  Future<void> restoreTodoList(TodoListItem todo) async {
    await saveTodoList(todo.copyWith(clearDeletedAt: true));
  }

  // Search
  Future<List<SearchResult>> search(String query) async {
    final normalizedQuery = query.toLowerCase().trim();
    if (normalizedQuery.isEmpty) return [];

    try {
      final notes = await _database.getNotes();
      final todos = await _database.getTodoLists();

      final filteredNotes = notes.where((n) {
        return n.title.toLowerCase().contains(normalizedQuery) ||
            n.content.toLowerCase().contains(normalizedQuery);
      }).toList();

      final filteredTodos = todos.where((t) {
        return t.title.toLowerCase().contains(normalizedQuery) ||
            t.tasks.any((task) => task.text.toLowerCase().contains(normalizedQuery));
      }).toList();

      return [
        ...filteredNotes.map(SearchResult.note),
        ...filteredTodos.map(SearchResult.todoList),
      ];
    } catch (e) {
      debugPrint('Error during search: $e');
      return [];
    }
  }

  // Backup & Restore
  Future<String> exportBackup() async {
    try {
      final notes = await _database.getNotes();
      final todos = await _database.getTodoLists();
      
      final payload = {
        'version': 3, 
        'exported_at': DateTime.now().toIso8601String(),
        'notes': notes.map((n) => n.toMap()).toList(),
        'todo_lists': todos.map((t) => t.toMap()).toList(),
      };
      
      return jsonEncode(payload);
    } catch (e) {
      debugPrint('Error exporting backup: $e');
      return '';
    }
  }

  Future<void> importBackup(String json) async {
    try {
      final payload = jsonDecode(json) as Map<String, dynamic>;
      final notesRaw = payload['notes'] as List<dynamic>;
      final todosRaw = payload['todo_lists'] as List<dynamic>;

      for (final raw in notesRaw) {
        final note = NoteItem.fromMap(Map<String, dynamic>.from(raw));
        await _database.insertNote(note.copyWith(id: null));
      }

      for (final raw in todosRaw) {
        final todo = TodoListItem.fromMap(Map<String, dynamic>.from(raw));
        await _database.insertTodoList(todo.copyWith(id: null));
      }
    } catch (e) {
      debugPrint('Error importing backup: $e');
    }
  }
}
