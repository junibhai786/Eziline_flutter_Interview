import 'dart:convert';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
class getFeedbacks extends StatefulWidget {
  const getFeedbacks({super.key});

  @override
  State<getFeedbacks> createState() => _getFeedbacksState();
}

class _getFeedbacksState extends State<getFeedbacks> {
  List tasks = [];
  Future<void> getData() async {
    String url = 'http://192.168.18.14/job_interview/Manager_Api,s%20Files/feedbacks.php';
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
        title: Text('Feedbacks List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'feedbacks',
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
                            tasks[index]['task_title'],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            tasks[index]['message'],
                            style: const TextStyle(fontSize: 14,color: Colors.yellow,fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                            icon: InkWell(
                              onTap: () {
                                // deleteRecord(tasks[index]['task_id']);
                              },
                              child: InkWell(
                                onTap: (){
                                 // Navigator.push(context,MaterialPageRoute(builder: (context)=>Feedback()));
                                },
                                child: const Icon(
                                  Icons.emoji_events,
                                  color: Colors.red,
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
