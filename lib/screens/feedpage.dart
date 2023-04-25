import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late Stream<List<Post>> _streamPosts;

  @override
  void initState() {
    super.initState();
    _streamPosts = fetchPosts();
    Timer.periodic(const Duration(seconds: 10), (timer) {
      fetchPosts();
    });
  }

  Stream<List<Post>> fetchPosts() async* {
    final response = await http
        .get(Uri.parse('https://projectapp-te3jzdumhq-lm.a.run.app/posts'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final posts = data.map((post) => Post.fromJson(post)).toList();
      yield posts;
    } else {
      throw Exception('Failed to fetch posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feed page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 84, 84, 100),
        appBar: AppBar(
          shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 2,
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(10))
              .copyWith(
            side: const BorderSide(
              width: 2,
              color: Colors.white,
            ),
          ),
          title: const Text('Feed page'),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: const <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: Text('Item 1'),
              ),
              ListTile(
                title: Text('Item 2'),
              ),
            ],
          ),
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            width: MediaQuery.of(context).size.width * 0.8,
            child: StreamBuilder<List<Post>>(
              stream: _streamPosts,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final post = snapshot.data![index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12.0).copyWith(
                            left: 20,
                            right: 20,
                          ),
                          title: Text(
                            post.email,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(post.post,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                              )),
                          trailing: Text(
                            post.time.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 2,
                              color: Color.fromARGB(255, 38, 34, 34),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }
}
