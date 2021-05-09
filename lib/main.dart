import 'package:flutter/material.dart';

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
