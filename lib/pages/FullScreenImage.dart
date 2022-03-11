import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  const FullScreenImage({Key? key, required this.snapshot}) : super(key: key);

  final AsyncSnapshot<Object?> snapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Image.network(
          snapshot.data.toString(),
          fit: BoxFit.fill,
        ),
      ),
      appBar: AppBar(),
    );
  }
}
