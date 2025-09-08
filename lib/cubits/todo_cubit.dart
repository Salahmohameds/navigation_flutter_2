import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/todo_model.dart';

class TodoCubit extends Cubit<List<TodoModel>> {
  TodoCubit() : super([]);

  void addTodo(String title) {
    if (title.trim().isNotEmpty) {
      final todo = TodoModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.trim(),
      );
      final updatedTodos = List<TodoModel>.from(state)..add(todo);
      emit(updatedTodos);
    }
  }

  void toggleTodo(String id) {
    final updatedTodos = state.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(isCompleted: !todo.isCompleted);
      }
      return todo;
    }).toList();
    emit(updatedTodos);
  }

  void removeTodo(String id) {
    final updatedTodos = state.where((todo) => todo.id != id).toList();
    emit(updatedTodos);
  }

  void clearCompleted() {
    final updatedTodos = state.where((todo) => !todo.isCompleted).toList();
    emit(updatedTodos);
  }
}
