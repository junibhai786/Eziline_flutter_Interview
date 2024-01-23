import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task App',
      home: TaskScreen(),
    );
  }
}

class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTaskScreen()),
            );
          },
          child: Text('Add Task'),
        ),
      ),
    );
  }
}

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final   TextEditingController idcontroller=TextEditingController();

  Future<void> addTask() async {
    final String apiUrl = 'http://192.168.18.14/job_interview/Manager_Api,s%20Files/add_task.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'title': titleController.text,
          'description': descriptionController.text,
          'id':'5'
        },
      );

      if (response.statusCode == 200) {
        // Task added successfully, handle the response accordingly
        print('Task added successfully');
        print(response.body);
        // Optionally, you can navigate back to the previous screen or perform any other action.
        Navigator.pop(context);
      } else {
        // Error adding task, handle the error accordingly
        print('Failed to add task');
        print(response.body);
      }
    } catch (error) {
      // Handle network or other errors
      print('Error adding task: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                addTask(); // Call the addTask function
              },
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
