import 'package:flutter/material.dart';

class ContentPage extends StatefulWidget {
  ContentPage({Key? key, required this.Content, required this.ImagePath})
      : super(key: key);

  String? Content;
  String? ImagePath;
  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: Container(
            color: Colors.red,
          )),
          Expanded(
              child: Container(
            color: Colors.green,
          ))
        ],
      ),
    );
  }
}
