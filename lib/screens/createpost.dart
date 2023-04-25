import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:final_test/screens/feedpage.dart';

class Post {
  final String email;
  final String post;
  final String time;

  const Post({
    required this.email,
    required this.post,
    required this.time,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      email: json['email'],
      post: json['post'],
      time: json['timestamp'],
    );
  }
}

Future<dynamic> createPost(String email, post, BuildContext context) async {
  final response = await http.post(
    Uri.parse('https://projectapp-te3jzdumhq-lm.a.run.app/posts'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'post': post,
    }),
  );

  if (response.statusCode == 201) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FeedPage(),
      ),
    );
    // return Post.fromJson(jsonDecode(response.body));
  } else {
    String errorMessage = 'Failed to create Post, email entered may not exist.';
    throw FlutterError(errorMessage);
  }
}

class createposts extends StatefulWidget {
  const createposts({super.key});

  @override
  State<createposts> createState() => _postState();
}

class _postState extends State<createposts> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _postController = TextEditingController();
  Future<Post>? _futurePost;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Post creation page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 84, 84, 100),
        appBar: AppBar(
          title: const Text('Post creation page'),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: (_futurePost == null) ? buildColumn() : buildFutureBuilder(),
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
          controller: _emailController,
          decoration: const InputDecoration(
              hintText: 'Enter Email',
              hintStyle: TextStyle(color: Colors.white)),
          onChanged: (value) {
            setState(() {});
          },
        ),
        const SizedBox(height: 30.0),
        TextField(
          controller: _postController,
          decoration: const InputDecoration(
              hintText: 'Make a post',
              hintStyle: TextStyle(color: Colors.white)),
          onChanged: (value) {
            setState(() {});
          },
        ),
        const SizedBox(height: 32.0),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _futurePost = createPost(
                      _emailController.text, _postController.text, context)
                  as Future<Post>?;
            });
          },
          child: const Text('Create Post'),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget buildFutureBuilder() {
    return FutureBuilder<Post>(
      future: _futurePost,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.email);
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              '${snapshot.error}',
              style: TextStyle(
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
