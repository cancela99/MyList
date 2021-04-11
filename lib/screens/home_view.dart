import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mylist/screens/add_todo.dart';
import 'package:mylist/screens/todo_details.dart';
import 'package:mylist/net/flutterfire.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  showSnackBar(context, document) {
    Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Tarefa ' + document.data()['taskname'] + ' apagada.'),
    ));
  }

  _deleteTodo(index, snapshot){
    setState(() {
      snapshot.documents.removeAt(index);
    });
  }

  Widget todoTemplate(document, id, list) {
    return Dismissible(
        key: Key(UniqueKey().toString()),
        onDismissed: (DismissDirection direction) {
          String uid = FirebaseAuth.instance.currentUser.uid;

          showDialog(
            context: context,
            builder: (BuildContext context) {

              Widget eliminarButton = FlatButton(
                child: new Text("Sim"),
                onPressed: () async {
                  String uid = FirebaseAuth.instance.currentUser.uid;
                  await FirebaseFirestore.instance.collection('Users').doc(uid).collection('Todos').doc(id).delete();
                  _deleteTodo(id, list);
                  //build(context);
                  Navigator.of(context).pop();
                },
              );
              Widget cancelarButton = FlatButton(
                child: new Text("Cancelar"),
                onPressed: () {
                  //build(context);
                  //list.insert(int.tryParse(id), document);
                  build(context);
                  Navigator.of(context).pop();
                },
              );

              return AlertDialog(
                title: new Text("Aviso!"),
                content: new Text("Deseja realmente eliminar a tarefa?"),
                actions: [
                  eliminarButton,
                  cancelarButton,
                ],
                elevation: 24.0,

              );
            },
          );

          //showSnackBar(context, document);
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(12.0),
          margin: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 0),
          child: Icon(Icons.delete, color: Colors.white,),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child:
        Card(
          color: Colors.blueAccent,
          margin: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 0),
          child: new InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TodoDetails(),
                    settings: RouteSettings(
                      arguments: document,
                    )),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    child:
                    Text(
                      document.data()['taskname'],
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.0),
                  Container(
                    child:
                    Text(
                      document.data()['description'],
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white70,
                      ),
                    ),
                  ),
            ]),
          ),
        ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .collection('Todos')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return new Text('Press button to start');
                case ConnectionState.waiting:
                  return new Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  if (snapshot.hasError) {
                    return new Text('Error: ${snapshot.error}');
                  } else {
                    return ListView(
                      children: snapshot.data.docs.map((document) {
                        final list = snapshot.data.docs;
                        return Container(
                            child: todoTemplate(document, document.id, list),
                        );
                      }).toList(),
                    );
                  }
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTodo()),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
    );
  }
}
