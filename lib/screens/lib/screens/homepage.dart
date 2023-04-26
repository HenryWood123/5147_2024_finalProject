import 'package:final_test/screens/createpost.dart';
import 'package:final_test/screens/createuser.dart';
import 'package:final_test/screens/edituser.dart';
import 'package:final_test/screens/feedpage.dart';
import 'package:final_test/screens/viewuser.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 84, 84, 100),
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 16),
            const Text(
              'Welcome to my Webtech project App!',
              style: TextStyle(
                fontSize: 50,
                fontFamily: 'Comic Sans MS',
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeedPage(),
                  ),
                );
              },
              child: const Text('Go to Feed'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewUsers(),
                  ),
                );
              },
              child: const Text('View User'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => createposts(),
                  ),
                );
              },
              child: const Text('Create Post'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => createusers(),
                  ),
                );
              },
              child: const Text('Create User'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUser(),
                  ),
                );
              },
              child: const Text('Edit User'),
            ),
          ],
        ),
      ),
    );
  }
}
