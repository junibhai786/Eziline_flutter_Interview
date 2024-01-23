import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:http/http.dart'as http;
// Import statements...

class NormalUserHomeScreen extends StatefulWidget {
  NormalUserHomeScreen({super.key});

  @override
  State<NormalUserHomeScreen> createState() => _NormalUserHomeScreenState();
}

class _NormalUserHomeScreenState extends State<NormalUserHomeScreen> {
  List tasks = [];
  Future<void> getData() async {
    String url = 'http://192.168.18.14/job_interview/get_task.php';
    try {
      var response = await http.get(Uri.parse(url));
      setState(() {
        tasks=jsonDecode(response.body);
      });
    } catch (e) {
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
        title: Text('Normal User'),
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
                    Color? taskColor =
                    index % 2 == 0 ? Colors.blue[100] : Colors.green[100];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GlassmorphicContainer(
                        // Container settings...
                        width: 400,
                        height: 80,
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
                        child: ListTile(
                          title: Text(
                            tasks[index]['title'],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            tasks[index]['description'],
                            style: const TextStyle(fontSize: 14,color: Colors.yellow,fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                            icon: InkWell(
                              onTap: () {
                               // deleteRecord(tasks[index]['task_id']);
                              },
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=>Feedback()));
                                },
                                child: const Icon(
                                  Icons.feedback,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () {
                              // Implement logic for providing feedback
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
class Feedback extends StatefulWidget {
  const Feedback({super.key});

  @override
  State<Feedback> createState() => _FeedbackState();
}

class _FeedbackState extends State<Feedback> {
  TextEditingController postTitleController = TextEditingController();
  TextEditingController messageController=TextEditingController();


  Future<void> sendFeedback() async {
    String url = 'http://192.168.18.14/job_interview/save_feedback.php';
    try {
      var response = await http.post(Uri.parse(url), body: {
        'task_title': postTitleController.text,
        'message': messageController.text,
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          print('Feedback sent successfully!');
          postTitleController.clear();
          messageController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Task Sent Successfully!'),
            ),
          );
        } else {
          print('Failed to send feedback. Error: ${data['error']}');
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body:Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(34),
                child: TextField(
                  controller: postTitleController,
                  decoration: const InputDecoration(labelText: 'Post Title'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(34),
                child: TextField(
                  controller:messageController,
                  decoration: const InputDecoration(labelText: 'Message To Admin!'),
                ),
              ),
              ElevatedButton(onPressed:(){
                sendFeedback();
              },
                  child: Text('Submit '))
            ],
          )
        ),
      ),
    );
  }
}


