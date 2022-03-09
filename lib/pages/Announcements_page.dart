import 'package:flutter/material.dart';

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Center(
              child: Image(
            image: AssetImage(
              "assets/images/construction_40px.png",
            ),
          )),
          Center(child: Text("Duyurular bölümü yapım aşamasındadır"))
        ],
      ),
    );
  }
}
