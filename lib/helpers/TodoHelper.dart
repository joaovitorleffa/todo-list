import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String todoTable = "todoTable";
final String idColumn = "idColumn";
final String titleColumn = "titleColumn";
final String descriptionColumn = "descriptionColumn";

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
    // caminho onde será criado o arquivo do sqlite
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'todo_app.db');

    return openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      final String sql =
          "CREATE TABLE $todoTable($idColumn INTEGER PRIMARY KEY, $titleColumn TEXT, $descriptionColumn TEXT)";
      await db.execute(sql);
    });
  }

  Future<Todo> saveTodo(Todo todo) async {
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

  Future<int> getNumber() async {
    Database dbTodo = await db;
    return Sqflite.firstIntValue(
        await dbTodo.rawQuery("SELECT COUNT(*) FROM $todoTable"));
  }

  Future close() async {
    Database dbTodo = await db;
    dbTodo.close();
  }
}

class Todo {
  int id;
  String title;
  String description;

  Todo();

  // pega os dados da base de dados e passa para a classe Todo
  Todo.fromMap(Map map) {
    id = map[idColumn];
    title = map[titleColumn];
    description = map[descriptionColumn];
  }

  // pega os dados da classe e seta nas colunas da base de dados
  Map toMap() {
    Map<String, dynamic> map = {
      titleColumn: title,
      descriptionColumn: description,
    };
    if (id != null) {
      map[idColumn] = id;
    }

    return map;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "Todo(id: $id, title: $title, decription: $description)";
  }
}
