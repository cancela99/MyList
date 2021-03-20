import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class TodoDetails extends StatefulWidget {
  @override
  _TodoDetailsState createState() => _TodoDetailsState();
}

class _TodoDetailsState extends State<TodoDetails> {
  @override
  Widget build(BuildContext context) {
    QueryDocumentSnapshot document = ModalRoute.of(context).settings.arguments;
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 1.3,
            child: Text(
              "${document.data()['taskname']}",
              style: TextStyle(
                fontSize: 18.0
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.3,
            child: Text(
              "Descrição: ${document.data()['description']}",
              style: TextStyle(
                fontSize: 14.0
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.3,
            child: Text(
              "Prioridade: ${document.data()['priority']}",
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.3,
            child: Text(
              "Data: ${document.data()['datestart']}",
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 35),
          Container(
            width: MediaQuery.of(context).size.width / 1.3,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.greenAccent,
            ),
            child: MaterialButton(
              //onPressed: ,
              child: Text(
                "Concluir Tarefa"
                ,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
