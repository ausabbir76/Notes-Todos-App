import '../domain/note_item.dart';
import '../domain/todo_list_item.dart';

abstract interface class NotesTodosStore {
  Future<List<NoteItem>> getNotes();
  Future<int> insertNote(NoteItem item);
  Future<int> updateNote(NoteItem item);
  Future<int> deleteNote(int id);

  Future<List<TodoListItem>> getTodoLists();
  Future<int> insertTodoList(TodoListItem item);
  Future<int> updateTodoList(TodoListItem item);
  Future<int> deleteTodoList(int id);
}
