import 'package:flutter/material.dart';
import 'package:flutter_tests/todo_test/todo_provider.dart';
import 'package:provider/provider.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo app test"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: const ValueKey<String>("text_controller"),
                  controller: _textEditingController,
                  decoration: const InputDecoration(hintText: "Add text"),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                key: const ValueKey<String>("add_icon_button"),
                onPressed: () {
                  if (_textEditingController.text.trim().isEmpty) return;
                  todoProvider.addTodo(_textEditingController.text.trim());
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              key: const ValueKey<String>("todo_app_listview"),
              itemCount: todoProvider.todos.length,
              itemBuilder: (context, index) {
                final item = todoProvider.todos[index];
                return ListTile(
                  leading: SizedBox(
                    width: 50,
                    child: Text(
                      key: ValueKey("text_item_${item.id}"),
                      "${item.id}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  title: Text("${item.name}"),
                  trailing: IconButton(
                    key: ValueKey<String>("delete_button_${item.id}"),
                    onPressed: () {
                      todoProvider.removeTodo(item);
                    },
                    icon: const Icon(
                      Icons.delete,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
