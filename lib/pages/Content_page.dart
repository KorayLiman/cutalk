import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cutalk/models/Talkmodel.dart';
import 'package:cutalk/models/Usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ContentPage extends StatefulWidget {
  ContentPage({
    Key? key,
    required this.userid,
    required this.content,
  }) : super(key: key);

  String? userid;
  String? content;
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
              flex: 7,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12.0, left: 8),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: FutureBuilder(
                            future: GetUserImage(widget.userid),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(snapshot.data.toString()));
                              } else {
                                return Image.asset(
                                  "assets/images/user_30px.png",
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 2,
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, top: 15.0),
                          child: Text(
                            widget.content!,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0, bottom: 8),
                child: FutureBuilder(
                    future: GetName(widget.userid),
                    builder: ((context, snapshot) {
                      return Text(snapshot.data.toString());
                    })),
              ),
            ),
            flex: 1,
          ),
          Expanded(
              flex: 8,
              child: Container(
                color: Colors.green,
              ))
        ],
      ),
    );
  }

  Future<String> GetName(String? userid) async {
    var _UserDoc = await FirebaseFirestore.instance.collection("user");
    var _result = await _UserDoc.where("id", isEqualTo: userid).get();
    return _result.docs[0]["name"];
  }

  GetUserImage(String? userid) async {
    var _UserDoc = await FirebaseFirestore.instance.collection("user");
    var _result = await _UserDoc.where("id", isEqualTo: userid).get();
    return _result.docs[0]["imagepath"];
  }
}
