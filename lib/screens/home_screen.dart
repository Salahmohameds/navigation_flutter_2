import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/todo_cubit.dart';
import '../models/todo_model.dart';
import '../components/todo_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();

  void onCancel(BuildContext context) {
    controller.clear();
    Navigator.of(context).pop();
  }

  void onSave(BuildContext context) {
    context.read<TodoCubit>().addTodo(controller.text);
    controller.clear();
    Navigator.of(context).pop();
  }

  void createNewTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter task name',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => onCancel(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => onSave(context),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Todo App',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
        elevation: 0,
      ),
      body: BlocBuilder<TodoCubit, List<TodoModel>>(
        builder: (context, todoList) {
          if (todoList.isEmpty) {
            return const Center(
              child: Text(
                'No todos yet. Add your first todo!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              return TodoTile(
                taskName: todoList[index].title,
                isCompleted: todoList[index].isCompleted,
                onChanged: (value) {
                  context.read<TodoCubit>().toggleTodo(todoList[index].id);
                },
                onEdit: () {
                  _showEditDialog(context, todoList[index]);
                },
                onDelete: () {
                  context.read<TodoCubit>().removeTodo(todoList[index].id);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createNewTask(context);
        },
        backgroundColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, TodoModel todo) {
    final editController = TextEditingController(text: todo.title);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(
              hintText: 'Enter task name',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (editController.text.trim().isNotEmpty) {
                  // Update the todo with new title
                  final updatedTodo = todo.copyWith(
                    title: editController.text.trim(),
                  );
                  // Remove old todo and add updated one
                  context.read<TodoCubit>().removeTodo(todo.id);
                  context.read<TodoCubit>().addTodo(updatedTodo.title);
                  Navigator.pop(context);
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
