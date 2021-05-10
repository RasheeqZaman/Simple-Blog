import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Blog App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Simple Blog'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> blogName = ["A", "B", "C"];

  @override
  void initState(){
    super.initState();
    fetchBlogs();
  }

  Future<List<Blog>> fetchBlogs() async{
    http.Response response = await http.get(
        Uri.parse("https://raw.githubusercontent.com/Muhaiminur/muhaiminur.github.io/master/misfitflutter.tech"),
        headers: {
          "Accept": "application/json"
        }
    );
    return parseBlogs(response.body);
  }

  List<Blog> parseBlogs(String responseBody) {
    dynamic parsed = json.decode(responseBody)['blogs'];
    return parsed.map<Blog>((json)=> Blog.fromMap(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: buildList(),
    );
  }

  Widget buildList() {
    return ListView.builder(
      itemCount: blogName.length,
      itemBuilder: (context, pos){
        return Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Card(
            color: Colors.blue,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
              child: Text(
                blogName[pos],
                style: TextStyle(
                  fontSize: 16.0,
                  height: 1.6
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class Blog {
  final String id, title, desc, coverPhoto;
  final List<String> categories;
  final Author author;

  Blog(this.id, this.title, this.desc, this.coverPhoto, this.categories, this.author);

  factory Blog.fromMap(Map<String, dynamic> json) {
    print(json['id']);
    print(json['categories'][0]);
    print(json['author']['name']);
    return Blog(
      json['id'].toString(),
      json['title'],
      json['description'],
      json['cover_photo'],
      new List<String>.from(json['categories']),
      new Author(
        json['author']['id'].toString(),
        json['author']['name'],
        json['author']['avatar'],
        json['author']['profession'],
      )
    );
  }
}

class Author {
  final String id, name, avatar, profession;

  Author(this.id, this.name, this.avatar, this.profession);
}
