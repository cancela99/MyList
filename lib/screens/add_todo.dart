import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mylist/net/flutterfire.dart';

class AddTodo extends StatefulWidget {
  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  List<String> priorityValues = ['Baixa', 'Média', 'Alta'];
  String dropdownValue = 'Baixa';
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController taskName = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 1.3,
            child: TextFormField(
              controller: taskName,
              decoration: InputDecoration(
                labelText: "Nome da Tarefa",
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.3,
            child: TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: "Descrição da Tarefa",
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.3,
            child: DropdownButton(
              value: dropdownValue,
              onChanged: (String value) {
                setState(() {
                  dropdownValue = value;
                });
              },
              items: priorityValues.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width / 1.4,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.blueAccent,
            ),
            child: MaterialButton(
              onPressed: () async {
                //TODO - Adicionar Firestore
                await addTodo(dropdownValue, taskName.text, descriptionController.text);
                Navigator.of(context).pop();
              },
              child: Text(
                "Adicionar tarefa",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
