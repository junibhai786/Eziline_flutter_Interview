import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:untitled/Manager/Add_Task_Manager.dart';
import 'package:http/http.dart'as http;
import 'package:untitled/Manager/Update_Task.dart';

import 'Manager/getFeedbacks.dart';

class ManagerScreen extends StatefulWidget {
  @override
  _ManagerScreenState createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  List tasks = [];

  Future<void> deleteRecord(String id) async {
    String url = 'http://192.168.18.14/job_interview/Manager_Api,s%20Files/delete_task.php';

    try {
      final res = await http.post(
        Uri.parse(url),
        body: {'task_id': id},
      );
      final response=jsonDecode(res.body);
      print(res.body);
      // Show a SnackBar indicating success
      if(response['success']=='true'){

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not delete the task'),
          ),
        );
        getData();
      }
      else {
        // Show a SnackBar indicating failure
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task has been deleted!'),
          ),
        );
        getData();
      }
    } catch (e) {
      print(e.toString());
    }
  }
  Future<void>getData()async{
    String url='http://192.168.18.14/job_interview/get_task.php';
    try{
      var response=await http.get(Uri.parse(url));
      setState(() {
        tasks=jsonDecode(response.body);
      });
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getData();
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manager Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task List',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    // Use different colors for different tasks
                    Color? taskColor = index % 2 == 0 ? Colors.blue[100] : Colors.green[100];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GlassmorphicContainer(
                        width: 400,
                        height: 80,
                        borderRadius: 20,
                        blur: 10,
                        border: 2,
                        linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [taskColor?.withOpacity(1.0) ?? Colors.transparent, taskColor!.withOpacity(1.0)],
                        ),
                        borderGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [taskColor.withOpacity(0.9), taskColor.withOpacity(0.9)],
                        ),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdateTaskScreen(
                               // tasks[index]['task_id'],
                              tasks[index]['title'], tasks[index]['description']
                            )));
                          },
                          child: ListTile(
                            title: Text(
                              tasks[index]['title'],
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              tasks[index]['description'],
                              style: const TextStyle(fontSize: 14),
                            ),
                            trailing: IconButton(
                              icon:InkWell(
                                onTap:(){
                                  deleteRecord(tasks[index]['task_id']);
                                },
                                  child: const Icon(Icons.delete,color: Colors.red,)),
                              onPressed: () {
                                // Implement logic for providing feedback
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

              ),

            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GlassmorphicContainer(
                    width: 120,
                    height: 40,
                    borderRadius: 20,
                    blur: 10,
                    border: 2,
                    linearGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.lightBlue[200]!,
                        Colors.lightGreen[200]!,
                      ],

                    ),
                    borderGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue.withOpacity(0.5),
                        Colors.blue.withOpacity(0.2),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement logic for adding a new task
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child:  Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: InkWell(
                          onTap: (){
                           Navigator.push(context,MaterialPageRoute(builder: (context)=>TaskScreen()));
                          },
                          child: const Text(
                            'Add Task',
                            style: TextStyle(fontSize: 14),
                            maxLines: 1, // Set maxLines to 1 to prevent text wrapping
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GlassmorphicContainer(
                    width: 120,
                    height: 40,
                    borderRadius: 20,
                    blur: 10,
                    border: 2,
                    linearGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.lightBlue,
                        Colors.lightGreen,
                      ],

                    ),
                    borderGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.lightBlue,
                        Colors.lightGreen,
                      ],

                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement logic for updating a task
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child:  Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>getFeedbacks()));
                          },
                          child: Text(
                            'Feedbacks',
                            style: TextStyle(fontSize: 14),
                            maxLines: 1, // Set maxLines to 1 to prevent text wrapping
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GlassmorphicContainer(
                    width: 120,
                    height: 40,
                    borderRadius: 20,
                    blur: 10,
                    border: 2,
                    linearGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.red.withOpacity(0.1),
                        Colors.red.withOpacity(0.05),
                      ],
                    ),
                    borderGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.red.withOpacity(0.5),
                        Colors.red.withOpacity(0.2),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement logic for deleting a task
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Delete Task',
                          style: TextStyle(fontSize: 14),
                          maxLines: 1, // Set maxLines to 1 to prevent text wrapping
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class Task {
  final int id;
  final String title;
  final String description;
  final String feedback;

  Task({required this.id, required this.title, required this.description, required this.feedback});
}

void main() {
  runApp(MaterialApp(
    home: ManagerScreen(),
  ));
}
