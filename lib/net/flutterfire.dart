import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

Future<bool> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> register(String email, String password) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(), password: password.trim());
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('A password fornecida não é robusta o suficiente!');
    } else if (e.code == 'email-already-in-use') {
      print('Já existe uma conta com esse email!');
    }
    return false;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future<String> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
  } on FirebaseAuthException catch (e) {
    return e.message;
  } catch (e) {
    rethrow;
  }
}

class EmailValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Email can't be empty!";
    }
    return null;
  }
}

Future<bool> addTodo(String priority, String task, String description) async {
  try {
    String id = 't000' + '0';
    //int a = countTotalTasks();
    DateTime dateNow = DateTime.now();
    String dateStart = DateFormat('dd/MM/yyyy HH:mm:ss').format(dateNow);

    //countTotalTasks();

    /*if(a != null){
      id = 't000' + '2';
    }*/

    String uid = FirebaseAuth.instance.currentUser.uid;
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Todos')
        .doc(id);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (priority == null) {
        priority = "N/A";
      } else if (task == null) {
        task = "N/A";
      } else if (description == null) {
        description = "N/A";
      }

      if (!snapshot.exists) {
        documentReference.set({'description': description});
        documentReference.set({'taskname': task});
        documentReference.set({'datestart': dateStart});
        documentReference.set({'priority': priority});
        return true;
      }

      String newDescription = snapshot.data()['description'] = description;
      String newTaskName = snapshot.data()['taskname'] = task;
      String newDateStart = snapshot.data()['datestart'] = dateStart;
      String newPriority = snapshot.data()['priority'] = priority;

      transaction.update(documentReference, {'taskname': newTaskName});
      transaction.update(documentReference, {'description': newDescription});
      transaction.update(documentReference, {'datestart': newDateStart});
      transaction.update(documentReference, {'priority': newPriority});

      return true;
    });
  } catch (ex) {
    return false;
  }
}


removeTodo() {
  try {
    String uid = FirebaseAuth.instance.currentUser.uid;
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Todos')
        .doc();

    documentReference.delete().whenComplete(() => print("Apagado com sucesso!"));
    return true;
  } catch (ex) {
    return false;
  }
}

class A {
  Future<int> getInt(lngt) {
    return Future.value(lngt);
  }
}

class B {
  checkValue(lngt) async {
    final val = await A().getInt(lngt);
    //print(val == 10 ? "yes" : "no");
    print("******************** Total de tasks: $val ********************");
  }
}

Future<int> countTotalTasks() async {
  try {
    String uid = FirebaseAuth.instance.currentUser.uid;
    //DocumentReference documentReference = FirebaseFirestore.instance.collection('Users').doc(uid).collection('Todos').snapshots().length;

    //print("******************** Total de tasks: $totalTasks ********************");

    //return totalTasks;
  } catch (ex) {
    return null;
  }
}
