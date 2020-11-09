import 'package:flutter/material.dart';
import 'package:todo_list_ap2/models/Todo.dart';

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

  String _label = "Adiconar";

  Todo _editedTodo;

  @override
  void initState() {
    super.initState();
    if (widget.todo == null) {
      _editedTodo = Todo();
    } else {
      _editedTodo = Todo.fromMap(widget.todo.toMap());

      _label = "Salvar alterações";
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
          backgroundColor: Colors.teal,
          title: Text("Nova tarefa"),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.only(bottom: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
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
              ButtonTheme(
                minWidth: 300,
                height: 40.0,
                child: RaisedButton(
                  onPressed: () {
                    if (_editedTodo.title != null &&
                        _editedTodo.title.isNotEmpty) {
                      Navigator.pop(context, _editedTodo);
                    } else {
                      FocusScope.of(context).requestFocus(_titleFocus);
                    }
                  },
                  child: Text(_label),
                  textColor: Colors.white,
                  color: Colors.teal,
                ),
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
