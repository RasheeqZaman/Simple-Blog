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
      debugShowCheckedModeBanner: false,
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

  Future<List<Blog>> blogs;

  @override
  void initState(){
    super.initState();
    blogs = fetchBlogs();
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
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
          child: FutureBuilder<List<Blog>>(
            future: blogs,
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData ? BlogBoxList(items: snapshot.data) : Center(child: CircularProgressIndicator());
            },
          ),
      ),
    );
  }
}

class BlogBoxList  extends StatelessWidget {
  final List<Blog> items;
  BlogBoxList({Key key, this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, pos){
        return GestureDetector(
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Stack(
              children: <Widget>[
                Image.network(
                  items[pos].coverPhoto,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                      items[pos].title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                          backgroundColor: Colors.black.withOpacity(0.5)
                      )
                  ),
                )
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 5,
            margin: EdgeInsets.all(10),
          ),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlogPage(item: items[pos]),
              ),
            );
          },
        );
      },
    );
  }

}

class BlogPage extends StatelessWidget{
  final Blog item;

  BlogPage({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(this.item.title),),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.network(
                  item.coverPhoto,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text("ID: " + this.item.id),
                            Text(this.item.title, style:
                            TextStyle(fontWeight: FontWeight.bold)),
                            Text(this.item.desc),
                            Text(this.item.categories.join(", ")),
                            Image.network(
                              item.author.avatar,
                              width: 70,
                              height: 70,
                              fit: BoxFit.fill,
                            ),
                            Text(this.item.author.name),
                            Text(this.item.author.profession),
                          ],
                        )
                    )
                )
              ]
          ),
        ),
      ),
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
