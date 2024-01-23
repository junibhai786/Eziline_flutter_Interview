import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateTaskScreen extends StatefulWidget {
  final String title;
  final String description;

  UpdateTaskScreen( this.title,this.description);

  @override
  _UpdateTaskScreenState createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
 TextEditingController titleController=TextEditingController();
 TextEditingController descriptionController=TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    descriptionController = TextEditingController(text: widget.description);
  }

  Future<void> updateTask() async {
    // Make a request to your PHP API to update the task
    final response = await http.post(
      Uri.parse("http://192.168.18.14/job_interview/Manager_Api,s%20Files/update_task.php"),
      body: {
       // 'taskId': widget.id.toString(),
        'title': titleController.text,
        'description': descriptionController.text,
      },
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task has been deleted!'),
          ),
        );
        print("Task updated successfully");
        // You can navigate to another screen or perform any other action here
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Task has been Updatad!'),
            )
        );
      }
    } else {
      // Handle HTTP error
      print("HTTP Error: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Call the updateTask function when the button is pressed
                updateTask();
              },
              child: Text('Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}

