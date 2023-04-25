import 'dart:convert';
import 'package:http/http.dart' as http;

Future<http.Response> createUser(
    String id, name, email, dob, year, major, hostel, favfood, favmovie) {
  return http.post(
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
}
