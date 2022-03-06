import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cutalk/models/Comment.dart';
import 'package:cutalk/models/Talkmodel.dart';
import 'package:cutalk/models/Usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ContentPage extends StatefulWidget {
  ContentPage(
      {Key? key,
      required this.userid,
      required this.content,
      required this.currentTalk})
      : super(key: key);

  String? userid;
  String? content;
  QueryDocumentSnapshot<Object?> currentTalk;

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: ListTile(
                    title: TextFormField(
                      autofocus: true,
                      onFieldSubmitted: (value) async {
                        var connectivityResult =
                            await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.mobile ||
                            connectivityResult == ConnectivityResult.wifi) {
                          var currentDoc = await FirebaseFirestore.instance
                              .doc("talk/${widget.currentTalk.id}")
                              .get();
                          List<dynamic> tempList =
                              currentDoc.data()!["comments"];
                          tempList.add(value);
                          await FirebaseFirestore.instance
                              .collection("talk")
                              .doc(widget.currentTalk.id)
                              .update({
                            "comments": FieldValue.arrayUnion(tempList)
                          });
                          setState(() {});
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                );
              });
        },
        child: Icon(Icons.comment),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Konuşma"),
      ),
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
                                    backgroundColor: Colors.transparent,
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        "Yorumlar",
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: FutureBuilder(
                            future: GetCommentList(),
                            builder: ((context, snapshot) {
                                if (snapshot.hasError) {
                                return Center(
                                  child: Text("Yorum yok"),
                                );
                              } else if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                                
                              } else {
                                var list = snapshot.data as List;
                                list = list.reversed.toList();
                                return ListView.separated(
                                  itemCount: list.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: FutureBuilder(
                                        future: GetUserImage(widget.userid),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return CircleAvatar(
                                                backgroundColor:
                                                    Colors.transparent,
                                                backgroundImage: NetworkImage(
                                                    snapshot.data.toString()));
                                          } else {
                                            return Image.asset(
                                              "assets/images/user_30px.png",
                                            );
                                          }
                                        },
                                      ),
                                      title: Text(list[index]),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return Divider(
                                      thickness: 1,
                                    );
                                  },
                                );
                              }
                            }))),
                  ],
                ),
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

  Future<List> GetCommentList() async {
    return widget.currentTalk["comments"];
  }
}
