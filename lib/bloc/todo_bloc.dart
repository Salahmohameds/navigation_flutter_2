import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/todo_model.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<ToggleTodo>(_onToggleTodo);
    on<RemoveTodo>(_onRemoveTodo);
    on<ClearCompleted>(_onClearCompleted);
  }

  final List<TodoModel> _todos = [];

  void _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) {
    emit(TodoLoading());
    try {
      emit(TodoLoaded(List.from(_todos)));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  void _onAddTodo(AddTodo event, Emitter<TodoState> emit) {
    try {
      _todos.add(event.todoModel);
      emit(TodoLoaded(List.from(_todos)));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  void _onToggleTodo(ToggleTodo event, Emitter<TodoState> emit) {
    try {
      final index = _todos.indexWhere((todo) => todo.id == event.id);
      if (index != -1) {
        _todos[index] = _todos[index].copyWith(
          isCompleted: !_todos[index].isCompleted,
        );
        emit(TodoLoaded(List.from(_todos)));
      }
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  void _onRemoveTodo(RemoveTodo event, Emitter<TodoState> emit) {
    try {
      _todos.removeWhere((todo) => todo.id == event.id);
      emit(TodoLoaded(List.from(_todos)));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }

  void _onClearCompleted(ClearCompleted event, Emitter<TodoState> emit) {
    try {
      _todos.removeWhere((todo) => todo.isCompleted);
      emit(TodoLoaded(List.from(_todos)));
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }
}
