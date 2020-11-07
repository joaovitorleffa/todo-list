import 'package:flutter/material.dart';
import 'package:todo_list_ap2/helpers/TodoHelper.dart';
import 'package:todo_list_ap2/pages/todo_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TodoHelper helper = TodoHelper();

  List<Todo> todos = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getAllTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tarefas"),
        backgroundColor: Colors.pink,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTodoPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12.0),
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return _todoCard(context, index);
        },
      ),
    );
  }

  Widget _todoCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(todos[index].title ?? "",
                  style:
                      TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
              Text(todos[index].description ?? "",
                  style: TextStyle(fontSize: 18.0)),
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showTodoPage(todo: todos[index]);
                        },
                        child: Text("Editar",
                            style:
                                TextStyle(color: Colors.pink, fontSize: 20.0)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: FlatButton(
                        onPressed: () {
                          helper.deleteTodo(todos[index].id);
                          setState(() {
                            todos.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                        child: Text("Excluir",
                            style:
                                TextStyle(color: Colors.pink, fontSize: 20.0)),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void _showTodoPage({Todo todo}) async {
    final recTodo = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TodoPage(todo: todo)));
    if (recTodo != null) {
      if (todo != null) {
        await helper.updateTodo(recTodo);
      } else {
        await helper.saveTodo(recTodo);
      }
      _getAllTodos();
    }
  }

  void _getAllTodos() {
    helper.getAllTodos().then((list) {
      setState(() {
        todos = list;
      });
    });
  }
}
