import 'package:flutter/material.dart';

class ContentPage extends StatefulWidget {
  ContentPage(
      {Key? key,
      required this.Title,
      required this.Content,
      required this.ImagePath})
      : super(key: key);
  String Title;
  String Content;
  String ImagePath;
  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
