import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/note_item.dart';
import '../domain/todo_list_item.dart';
import 'notes_todos_store.dart';

class WebPreferencesNotesTodosStore implements NotesTodosStore {
  static const String _notesKey = 'notes_todos_web_notes';
  static const String _todosKey = 'notes_todos_web_todos';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  @override
  Future<List<NoteItem>> getNotes() async {
    final rows = await _readRows(_notesKey);
    return rows.map(NoteItem.fromMap).toList()
      ..sort((a, b) {
        if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
        return b.updatedAt.compareTo(a.updatedAt);
      });
  }

  @override
  Future<int> insertNote(NoteItem item) async {
    final rows = await _readRows(_notesKey);
    final id = _nextId(rows);
    rows.add(item.copyWith(id: id).toMap());
    await _writeRows(_notesKey, rows);
    return id;
  }

  @override
  Future<int> updateNote(NoteItem item) async {
    final id = item.id;
    if (id == null) return 0;
    final rows = await _readRows(_notesKey);
    final index = rows.indexWhere((row) => row['id'] == id);
    if (index == -1) return 0;
    rows[index] = item.toMap();
    await _writeRows(_notesKey, rows);
    return 1;
  }

  @override
  Future<int> deleteNote(int id) async {
    final rows = await _readRows(_notesKey);
    final initialLength = rows.length;
    rows.removeWhere((row) => row['id'] == id);
    await _writeRows(_notesKey, rows);
    return initialLength == rows.length ? 0 : 1;
  }

  @override
  Future<List<TodoListItem>> getTodoLists() async {
    final rows = await _readRows(_todosKey);
    return rows.map(TodoListItem.fromMap).toList()
      ..sort((a, b) {
        if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
        return b.updatedAt.compareTo(a.updatedAt);
      });
  }

  @override
  Future<int> insertTodoList(TodoListItem item) async {
    final rows = await _readRows(_todosKey);
    final id = _nextId(rows);
    rows.add(item.copyWith(id: id).toMap());
    await _writeRows(_todosKey, rows);
    return id;
  }

  @override
  Future<int> updateTodoList(TodoListItem item) async {
    final id = item.id;
    if (id == null) return 0;
    final rows = await _readRows(_todosKey);
    final index = rows.indexWhere((row) => row['id'] == id);
    if (index == -1) return 0;
    rows[index] = item.toMap();
    await _writeRows(_todosKey, rows);
    return 1;
  }

  @override
  Future<int> deleteTodoList(int id) async {
    final rows = await _readRows(_todosKey);
    final initialLength = rows.length;
    rows.removeWhere((row) => row['id'] == id);
    await _writeRows(_todosKey, rows);
    return initialLength == rows.length ? 0 : 1;
  }

  Future<List<Map<String, dynamic>>> _readRows(String key) async {
    final prefs = await _preferences;
    final rawValue = prefs.getString(key);
    if (rawValue == null || rawValue.isEmpty) return <Map<String, dynamic>>[];
    final rawRows = jsonDecode(rawValue) as List<dynamic>;
    return rawRows.map((row) => Map<String, dynamic>.from(row as Map)).toList();
  }

  Future<void> _writeRows(String key, List<Map<String, dynamic>> rows) async {
    final prefs = await _preferences;
    await prefs.setString(key, jsonEncode(rows));
  }

  int _nextId(List<Map<String, dynamic>> rows) {
    if (rows.isEmpty) return 1;
    final maxId = rows
        .map((row) => row['id'] as int? ?? 0)
        .reduce((value, element) => value > element ? value : element);
    return maxId + 1;
  }
}
