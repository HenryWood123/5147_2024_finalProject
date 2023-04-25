import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:final_test/screens/createuser.dart';

Future<User> viewUser(String id) async {
  final response = await http.get(
    Uri.parse('https://projectapp-te3jzdumhq-lm.a.run.app/users/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 201) {
    final jsonData = jsonDecode(response.body);
    return User.fromJson(jsonData);
  } else {
    throw Exception('Failed to find user.');
  }
}

Future<User> editUser(
    String id, dob, year, major, hostel, favfood, favmovie) async {
  final response = await http.patch(
    Uri.parse('https://projectapp-te3jzdumhq-lm.a.run.app/users/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      if (dob != null) 'DOB': dob,
      if (year != null) 'year_group': year,
      if (major != null) 'major': major,
      if (hostel != null) 'onCampus': hostel,
      if (favfood != null) 'favorite_food': favfood,
      if (favmovie != null) 'favorite_movie': favmovie,
    }),
  );
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body.toString());
    return User.fromJson(jsonData);
  } else {
    String errorMessage = 'User updated but program thinks it did not work.';
    throw FlutterError(errorMessage);
  }
}

class EditUser extends StatefulWidget {
  const EditUser({Key? key}) : super(key: key);

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _hostelController = TextEditingController();
  final TextEditingController _favfoodController = TextEditingController();
  final TextEditingController _favmovieController = TextEditingController();

  Future<User>? _futureEditUser;
  bool _showEditFields = false;

  @override
  void dispose() {
    _idController.dispose();
    _dobController.dispose();
    _yearController.dispose();
    _majorController.dispose();
    _hostelController.dispose();
    _favfoodController.dispose();
    _favmovieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 84, 84, 100),
        appBar: AppBar(
          title: const Text('Edit User'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _idController,
                  decoration: const InputDecoration(
                      hintText: 'Enter User ID',
                      hintStyle: TextStyle(color: Colors.white)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _dobController,
                  decoration: const InputDecoration(
                      hintText: 'Date of Birth',
                      hintStyle: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _yearController,
                  decoration: const InputDecoration(
                      hintText: 'Year',
                      hintStyle: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _majorController,
                  decoration: const InputDecoration(
                      hintText: 'Major',
                      hintStyle: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _hostelController,
                  decoration: const InputDecoration(
                      hintText: 'Hostel',
                      hintStyle: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _favfoodController,
                  decoration: const InputDecoration(
                      hintText: 'Favorite Food',
                      hintStyle: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _favmovieController,
                  decoration: const InputDecoration(
                      hintText: 'Favorite Movie',
                      hintStyle: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _futureEditUser = editUser(
                          _idController.text,
                          _dobController.text.isNotEmpty
                              ? _dobController.text
                              : null,
                          _yearController.text.isNotEmpty
                              ? _yearController.text
                              : null,
                          _majorController.text.isNotEmpty
                              ? _majorController.text
                              : null,
                          _hostelController.text.isNotEmpty
                              ? _hostelController.text
                              : null,
                          _favfoodController.text.isNotEmpty
                              ? _favfoodController.text
                              : null,
                          _favmovieController.text.isNotEmpty
                              ? _favmovieController.text
                              : null,
                        );
                      });
                    }
                  },
                  child: const Text('Update User'),
                ),
                const SizedBox(height: 32.0),
                FutureBuilder<User>(
                  future: _futureEditUser,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data!.toString());
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
