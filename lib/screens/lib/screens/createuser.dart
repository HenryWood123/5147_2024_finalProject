import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:final_test/screens/homepage.dart';

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

  const User(
      {required this.id,
      required this.name,
      required this.email,
      required this.dob,
      required this.year,
      required this.major,
      required this.hostel,
      required this.favfood,
      required this.favmovie});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['user_id'],
        name: json['user_name'],
        email: json['email'],
        dob: json['DOB'],
        year: json['year_group'],
        major: json['major'],
        hostel: json['onCampus'],
        favfood: json['favorite_food'],
        favmovie: json['Favorite_movie']);
  }
}

Future<dynamic> createUser(String id, name, email, dob, year, major, hostel,
    favfood, favmovie, BuildContext context) async {
  final response = await http.post(
    Uri.parse('https://projectapp-te3jzdumhq-lm.a.run.app/users'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'user_id': id,
      'user_name': name,
      'email': email,
      'DOB': dob,
      'year_group': year,
      'major': major,
      'onCampus': hostel,
      'favorite_food': favfood,
      'favorite_movie': favmovie
    }),
  );

  if (response.statusCode == 201) {
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User created'),
        content: const Text('User account has been created successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  } else {
    throw Exception('Failed to create User, User may already exist.');
  }
}

class createusers extends StatefulWidget {
  const createusers({super.key});

  @override
  State<createusers> createState() => _UsersState();
}

class _UsersState extends State<createusers> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _hostelController = TextEditingController();
  final TextEditingController _favfoodController = TextEditingController();
  final TextEditingController _favmovieController = TextEditingController();
  Future<User>? _futureUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User creation page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 84, 84, 100),
        appBar: AppBar(
          title: const Text('User creation page'),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: (_futureUser == null) ? buildColumn() : buildFutureBuilder(),
          ),
        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 16.0),
        TextField(
          controller: _idController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
              hintText: 'Enter ID', hintStyle: TextStyle(color: Colors.white)),
          onChanged: (value) {
            setState(() {});
          },
        ),
        const SizedBox(height: 16.0),
        TextField(
          controller: _nameController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
              hintText: 'Enter Name',
              hintStyle: TextStyle(color: Colors.white)),
          onChanged: (value) {
            setState(() {});
          },
        ),
        const SizedBox(height: 16.0),
        TextField(
          controller: _emailController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
              hintText: 'Enter Email',
              hintStyle: TextStyle(color: Colors.white)),
          onChanged: (value) {
            setState(() {});
          },
        ),
        const SizedBox(height: 16.0),
        TextField(
          controller: _dobController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
              hintText: 'Enter DOB  dd/mm/yyyy',
              hintStyle: TextStyle(color: Colors.white)),
          onChanged: (value) {
            setState(() {});
          },
        ),
        const SizedBox(height: 16.0),
        TextField(
          controller: _yearController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
              hintText: 'Enter Year Group',
              hintStyle: TextStyle(color: Colors.white)),
          onChanged: (value) {
            setState(() {});
          },
        ),
        const SizedBox(height: 16.0),
        TextField(
          controller: _majorController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
              hintText: 'Enter Major',
              hintStyle: TextStyle(color: Colors.white)),
          onChanged: (value) {
            setState(() {});
          },
        ),
        const SizedBox(height: 16.0),
        TextField(
          controller: _hostelController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
              hintText: 'Enter Hostel',
              hintStyle: TextStyle(color: Colors.white)),
          onChanged: (value) {
            setState(() {});
          },
        ),
        const SizedBox(height: 16.0),
        TextField(
          controller: _favfoodController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
              hintText: 'Enter Favorite Food',
              hintStyle: TextStyle(color: Colors.white)),
          onChanged: (value) {
            setState(() {});
          },
        ),
        const SizedBox(height: 16.0),
        TextField(
          controller: _favmovieController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
              hintText: 'Enter Favorite Movie',
              hintStyle: TextStyle(color: Colors.white)),
          onChanged: (value) {
            setState(() {});
          },
        ),
        const SizedBox(height: 32.0),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _futureUser = createUser(
                _idController.text,
                _nameController.text,
                _emailController.text,
                _dobController.text,
                _yearController.text,
                _majorController.text,
                _hostelController.text,
                _favfoodController.text,
                _favmovieController.text,
                context,
              ) as Future<User>?;
            });
          },
          child: const Text('Create User'),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget buildFutureBuilder() {
    return FutureBuilder<User>(
      future: _futureUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.email);
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              '${snapshot.error}',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
