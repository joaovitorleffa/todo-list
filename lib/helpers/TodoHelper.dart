import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_list_ap2/models/Todo.dart';

class TodoHelper {
  static final TodoHelper _instance = TodoHelper.internal();

  factory TodoHelper() => _instance;

  TodoHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'todo_app.db');

    return openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      final String sql =
          "CREATE TABLE $todoTable($idColumn INTEGER PRIMARY KEY, $titleColumn TEXT, $descriptionColumn TEXT)";
      await db.execute(sql);
    });
  }

  Future<Todo> insertTodo(Todo todo) async {
    Database dbTodo = await db;
    todo.id = await dbTodo.insert(todoTable, todo.toMap());
    return todo;
  }

  Future<Todo> getTodo(int id) async {
    Database dbTodo = await db;
    List<Map> maps = await dbTodo.query(todoTable,
        columns: [idColumn, titleColumn, descriptionColumn],
        where: "$id = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Todo.fromMap(maps.first);
    }
  }

  Future<int> deleteTodo(int id) async {
    Database dbTodo = await db;
    return await dbTodo
        .delete(todoTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateTodo(Todo todo) async {
    Database dbTodo = await db;
    return await dbTodo.update(todoTable, todo.toMap(),
        where: "$idColumn = ?", whereArgs: [todo.id]);
  }

  Future<List> getAllTodos() async {
    Database dbTodo = await db;
    List listMap = await dbTodo.rawQuery("SELECT * FROM $todoTable");

    List<Todo> listTodo = List();
    for (Map map in listMap) {
      listTodo.add(Todo.fromMap(map));
    }

    return listTodo;
  }

  Future close() async {
    Database dbTodo = await db;
    dbTodo.close();
  }
}
