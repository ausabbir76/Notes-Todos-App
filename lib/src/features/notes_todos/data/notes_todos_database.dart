import 'package:flutter/foundation.dart';

import '../domain/note_item.dart';
import '../domain/todo_list_item.dart';
import 'notes_todos_store.dart';
import 'sqflite_notes_todos_store.dart';
import 'web_preferences_notes_todos_store.dart';

class NotesTodosDatabase implements NotesTodosStore {
  static final NotesTodosDatabase _instance = NotesTodosDatabase._internal();

  factory NotesTodosDatabase() => _instance;

  NotesTodosDatabase._internal()
    : _store = kIsWeb
          ? WebPreferencesNotesTodosStore()
          : SqfliteNotesTodosStore();

  final NotesTodosStore _store;

  @override
  Future<List<NoteItem>> getNotes() => _store.getNotes();

  @override
  Future<int> insertNote(NoteItem item) => _store.insertNote(item);

  @override
  Future<int> updateNote(NoteItem item) => _store.updateNote(item);

  @override
  Future<int> deleteNote(int id) => _store.deleteNote(id);

  @override
  Future<List<TodoListItem>> getTodoLists() => _store.getTodoLists();

  @override
  Future<int> insertTodoList(TodoListItem item) => _store.insertTodoList(item);

  @override
  Future<int> updateTodoList(TodoListItem item) => _store.updateTodoList(item);

  @override
  Future<int> deleteTodoList(int id) => _store.deleteTodoList(id);
}
