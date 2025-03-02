import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

enum Priority { Low, Medium, High }

extension PriorityExtension on Priority {
  String get name {
    switch (this) {
      case Priority.Low:
        return 'Low';
      case Priority.Medium:
        return 'Medium';
      case Priority.High:
        return 'High';
    }
  }

  int get value {
    switch (this) {
      case Priority.Low:
        return 1;
      case Priority.Medium:
        return 2;
      case Priority.High:
        return 3;
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task List App with Priority',
      home: TaskListScreen(),
    );
  }
}

class Task {
  String name;
  bool isCompleted;
  Priority priority;

  Task({required this.name, this.isCompleted = false, required this.priority});
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  final TextEditingController _taskController = TextEditingController();
  Priority selectedPriority = Priority.Low;

  void _addTask() {
    String taskName = _taskController.text;
    if (taskName.isNotEmpty) {
      setState(() {
        tasks.add(Task(name: taskName, priority: selectedPriority));
      });
      _taskController.clear();
    }
  }

  void _toggleTaskCompletion(int index, bool? value) {
    setState(() {
      tasks[index].isCompleted = value ?? false;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }
  void _sortTasksByPriority() {
    setState(() {
      tasks.sort((a, b) => b.priority.value.compareTo(a.priority.value));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List App with Priority'),
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: _sortTasksByPriority,
            tooltip: 'Sort by Priority',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      labelText: 'Enter task',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                DropdownButton<Priority>(
                  value: selectedPriority,
                  onChanged: (Priority? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedPriority = newValue;
                      });
                    }
                  },
                  items: Priority.values.map((Priority priority) {
                    return DropdownMenuItem<Priority>(
                      value: priority,
                      child: Text(priority.name),
                    );
                  }).toList(),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTask,
                  child: Text('Add'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  final task = tasks[index];
                  return ListTile(
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (bool? value) {
                        _toggleTaskCompletion(index, value);
                      },
                    ),
                    title: Text(
                      '${task.name} (Priority: ${task.priority.name})',
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteTask(index);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


