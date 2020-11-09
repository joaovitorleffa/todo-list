final String todoTable = "todoTable";
final String idColumn = "idColumn";
final String titleColumn = "titleColumn";
final String descriptionColumn = "descriptionColumn";

class Todo {
  int id;
  String title;
  String description;

  Todo();

  Todo.fromMap(Map map) {
    id = map[idColumn];
    title = map[titleColumn];
    description = map[descriptionColumn];
  }

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
    return "Todo(id: $id, title: $title, decription: $description)";
  }
}
