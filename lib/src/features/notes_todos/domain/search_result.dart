import 'note_item.dart';
import 'todo_list_item.dart';

enum SearchResultType { note, todoList }

class SearchResult {
  const SearchResult.note(this.note)
    : todoList = null,
      type = SearchResultType.note;

  const SearchResult.todoList(this.todoList)
    : note = null,
      type = SearchResultType.todoList;

  final SearchResultType type;
  final NoteItem? note;
  final TodoListItem? todoList;

  DateTime get updatedAt {
    return note?.updatedAt ?? todoList?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  bool get pinned {
    return note?.pinned ?? todoList?.pinned ?? false;
  }
}
