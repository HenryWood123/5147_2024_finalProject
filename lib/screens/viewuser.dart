import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:final_test/screens/createuser.dart';

class User {
  final String id;
  final String name;
  final String? email;
  final String? dob;
  final String? year;
  final String? major;
  final String? hostel;
  final String? favfood;
  final String? favmovie;

  User({
    required this.id,
    required this.name,
    this.email,
    this.dob,
    this.year,
    this.major,
    this.hostel,
    this.favfood,
    this.favmovie,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id'] ?? '',
      name: json['user_name'] ?? '',
      email: json['email'],
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
              decoration: const InputDecoration(
                hintText: 'Enter User ID',
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
            FutureBuilder<User>(
              future: _futureviewUser,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Name:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${snapshot.data!.name}'),
                        const SizedBox(height: 10),
                        const Text('Email:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${snapshot.data!.email}'),
                        const SizedBox(height: 10),
                        const Text('Date of Birth:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${snapshot.data!.dob}'),
                        const SizedBox(height: 10),
                        const Text('Year:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${snapshot.data!.year}'),
                        const SizedBox(height: 10),
                        const Text('Major:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${snapshot.data!.major}'),
                        const SizedBox(height: 10),
                        const Text('Hostel:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${snapshot.data!.hostel}'),
                        const SizedBox(height: 10),
                        const Text('Favorite Food:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${snapshot.data!.favfood}'),
                        const SizedBox(height: 10),
                        const Text('Favorite Movie:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${snapshot.data!.favmovie}'),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
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
