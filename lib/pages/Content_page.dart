import 'package:cutalk/models/Talkmodel.dart';
import 'package:cutalk/models/Usermodel.dart';
import 'package:flutter/material.dart';

class ContentPage extends StatefulWidget {
  ContentPage({Key? key, required this.talk,required this.user}) : super(key: key);

  Talk? talk;
  UserP? user;
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
