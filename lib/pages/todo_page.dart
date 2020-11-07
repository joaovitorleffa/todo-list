import 'package:flutter/material.dart';
import 'package:todo_list_ap2/helpers/TodoHelper.dart';

class TodoPage extends StatefulWidget {
  final Todo todo;
  TodoPage({this.todo});

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _titleFocus = FocusNode();

  bool _userEdited = false;

  Todo _editedTodo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.todo == null) {
      _editedTodo = Todo();
    } else {
      _editedTodo = Todo.fromMap(widget.todo.toMap());

      _titleController.text = _editedTodo.title;
      _descriptionController.text = _editedTodo.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: Text(_editedTodo.title ?? "Nova tarefa"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedTodo.title != null && _editedTodo.title.isNotEmpty) {
              Navigator.pop(context, _editedTodo);
            } else {
              FocusScope.of(context).requestFocus(_titleFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.pink,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _titleController,
                focusNode: _titleFocus,
                decoration: InputDecoration(labelText: "Título"),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedTodo.title = text;
                  });
                },
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Descrição"),
                onChanged: (text) {
                  _userEdited = true;
                  _editedTodo.description = text;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar alterações?"),
              content: Text("Suas alterações serão perdidas"),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar"),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text("Sim"),
                )
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
