class Todo {
  String description;
  int done;
  int priority;
  String uid;

  Todo({this.description, this.done, this.priority, this.uid});
}

class TodoList {
  List<Todo> todoList;

  TodoList({this.todoList});
}