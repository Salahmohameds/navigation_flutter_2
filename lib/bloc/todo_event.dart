import '../models/todo_model.dart';

abstract class TodoEvent {}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final TodoModel todoModel;
  AddTodo(this.todoModel);
}

class ToggleTodo extends TodoEvent {
  final String id;
  ToggleTodo(this.id);
}

class RemoveTodo extends TodoEvent {
  final String id;
  RemoveTodo(this.id);
}

class ClearCompleted extends TodoEvent {}
