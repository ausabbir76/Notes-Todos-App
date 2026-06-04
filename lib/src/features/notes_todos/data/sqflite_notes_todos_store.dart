import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../domain/note_item.dart';
import '../domain/todo_list_item.dart';
import 'notes_todos_store.dart';

class SqfliteNotesTodosStore implements NotesTodosStore {
  static const int _schemaVersion = 4;

  Database? _database;

  Future<Database> get _db async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notes_todos.db');
    return openDatabase(
      path,
      version: _schemaVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        pinned INTEGER NOT NULL DEFAULT 0,
        archived INTEGER NOT NULL DEFAULT 0,
        deleted_at INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE todo_lists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        tasks TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        pinned INTEGER NOT NULL DEFAULT 0,
        archived INTEGER NOT NULL DEFAULT 0,
        deleted_at INTEGER,
        due_at INTEGER,
        completed_at INTEGER
      )
    ''');

    await _createIndexes(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await _upgradeToVersion3(db);
    }
    if (oldVersion < 4) {
      await _upgradeToVersion4(db);
    }
    await _createIndexes(db);
  }

  Future<void> _upgradeToVersion3(Database db) async {
    const tables = ['notes', 'todo_lists'];
    for (final table in tables) {
      try {
        await db.execute(
          'ALTER TABLE $table ADD COLUMN pinned INTEGER NOT NULL DEFAULT 0',
        );
      } catch (_) {}
      try {
        await db.execute(
          'ALTER TABLE $table ADD COLUMN archived INTEGER NOT NULL DEFAULT 0',
        );
      } catch (_) {}
      try {
        await db.execute('ALTER TABLE $table ADD COLUMN deleted_at INTEGER');
      } catch (_) {}
    }
  }

  Future<void> _upgradeToVersion4(Database db) async {
    await db.execute('ALTER TABLE notes RENAME TO notes_old');
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        pinned INTEGER NOT NULL DEFAULT 0,
        archived INTEGER NOT NULL DEFAULT 0,
        deleted_at INTEGER
      )
    ''');
    await db.execute('''
      INSERT INTO notes (id, title, content, created_at, updated_at, pinned, archived, deleted_at)
      SELECT id, title, content, created_at, updated_at, pinned, archived, deleted_at FROM notes_old
    ''');
    await db.execute('DROP TABLE notes_old');

    await db.execute('ALTER TABLE todo_lists RENAME TO todo_lists_old');
    await db.execute('''
      CREATE TABLE todo_lists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        tasks TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        pinned INTEGER NOT NULL DEFAULT 0,
        archived INTEGER NOT NULL DEFAULT 0,
        deleted_at INTEGER,
        due_at INTEGER,
        completed_at INTEGER
      )
    ''');
    await db.execute('''
      INSERT INTO todo_lists (id, title, tasks, created_at, updated_at, pinned, archived, deleted_at, due_at, completed_at)
      SELECT id, title, tasks, created_at, updated_at, pinned, archived, deleted_at, due_at, completed_at FROM todo_lists_old
    ''');
    await db.execute('DROP TABLE todo_lists_old');
  }

  Future<void> _createIndexes(Database db) async {
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_notes_updated_at ON notes(updated_at DESC)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_todo_lists_updated_at ON todo_lists(updated_at DESC)',
    );
    await db.execute('CREATE INDEX IF NOT EXISTS idx_notes_pinned ON notes(pinned)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_notes_archived ON notes(archived)');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_notes_deleted_at ON notes(deleted_at)');
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_todo_lists_pinned ON todo_lists(pinned)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_todo_lists_archived ON todo_lists(archived)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_todo_lists_deleted_at ON todo_lists(deleted_at)',
    );
  }

  @override
  Future<List<NoteItem>> getNotes() async {
    final rows = await (await _db).query(
      'notes',
      orderBy: 'pinned DESC, updated_at DESC',
    );
    return rows.map(NoteItem.fromMap).toList();
  }

  @override
  Future<int> insertNote(NoteItem item) async {
    return (await _db).insert('notes', item.toMap());
  }

  @override
  Future<int> updateNote(NoteItem item) async {
    return (await _db).update(
      'notes',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  @override
  Future<int> deleteNote(int id) async {
    return (await _db).delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<TodoListItem>> getTodoLists() async {
    final rows = await (await _db).query(
      'todo_lists',
      orderBy: 'pinned DESC, updated_at DESC',
    );
    return rows.map(TodoListItem.fromMap).toList();
  }

  @override
  Future<int> insertTodoList(TodoListItem item) async {
    return (await _db).insert('todo_lists', item.toMap());
  }

  @override
  Future<int> updateTodoList(TodoListItem item) async {
    return (await _db).update(
      'todo_lists',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  @override
  Future<int> deleteTodoList(int id) async {
    return (await _db).delete('todo_lists', where: 'id = ?', whereArgs: [id]);
  }
}
