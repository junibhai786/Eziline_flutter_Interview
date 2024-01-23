import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:untitled/HomeScreen.dart';
import 'package:untitled/Normal_User_Home_Screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // Show an error message if email or password is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter both email and password'),
        ),
      );
      return;
    }

    final String apiUrl = 'http://192.168.18.14/job_interview/login_file.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        // Print the entire response for debugging
        print(data);

        if (data['status'] == 'success') {
          // Check if role_id is equal to 1 (admin) before navigating
          if (data['role_id'] == '1') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ManagerScreen()),
            );
          } else{
            // Handle login failure for non-admin users
            print(data['role_id']);
            print(data['user_id']);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  NormalUserHomeScreen()),
            );
          }
        } else {
          // Handle login failure (e.g., display error message)
          print('Login Failed');
          print(data['message']);
        }
      } else {
        // Handle HTTP error during login
        print('Error during login');
        print(response.body);
      }
    } catch (error) {
      // Handle network or other errors
      print('Error during login: $error');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
