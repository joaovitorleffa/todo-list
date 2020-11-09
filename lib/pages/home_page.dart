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
    super.initState();

    _getAllTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tarefas"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTodoPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
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
        _showTodoPage(todo: todos[index]);
      },
      onLongPress: () {
        helper.deleteTodo(todos[index].id);
        setState(() {
          todos.removeAt(index);
        });
      },
    );
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
