import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:final_test/screens/createuser.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String dob;
  final String year;
  final String major;
  final String hostel;
  final String favfood;
  final String favmovie;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.dob,
    required this.year,
    required this.major,
    required this.hostel,
    required this.favfood,
    required this.favmovie,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id'] ?? '',
      name: json['user_name'] ?? '',
      email: json['email'] ?? '',
      dob: json['DOB'],
      year: json['year_group'],
      major: json['major'],
      hostel: json['onCampus'],
      favfood: json['favorite_food'],
      favmovie: json['favorite_movie'],
    );
  }
}

Future<User> viewUser(String id) async {
  final response = await http.get(
    Uri.parse('https://projectapp-te3jzdumhq-lm.a.run.app/users/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return User.fromJson(jsonData);
  } else {
    throw Exception('Failed to find user.');
  }
}

class ViewUsers extends StatefulWidget {
  const ViewUsers({Key? key}) : super(key: key);

  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<ViewUsers> {
  final TextEditingController _idController = TextEditingController();

  Future<User>? _futureviewUser;

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  void _showUserDialog(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('User Information'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDataField('Name:', user.name),
                _buildDataField('Email:', user.email),
                _buildDataField('Date of Birth:', user.dob),
                _buildDataField('Year:', user.year),
                _buildDataField('Major:', user.major),
                _buildDataField('Hostel:', user.hostel),
                _buildDataField('Favorite Food:', user.favfood),
                _buildDataField('Favorite Movie:', user.favmovie),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDataField(String label, String value) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label $value",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 84, 84, 100),
      appBar: AppBar(
        title: const Text('View User'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _idController,
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Enter User ID',
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _futureviewUser = viewUser(_idController.text);
                });
              },
              child: const Text('View User'),
            ),
            const SizedBox(height: 16.0),
            FutureBuilder<User>(
              future: _futureviewUser,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _showUserDialog(snapshot.data!);
                    });
                    return const SizedBox.shrink();
                  } else if (snapshot.hasError) {
                    return Text(
                      '${snapshot.error}',
                      style: TextStyle(color: Colors.white),
                    );
                  }
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
