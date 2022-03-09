import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cutalk/models/Comment.dart';
import 'package:cutalk/models/Talkmodel.dart';
import 'package:cutalk/models/Usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

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
                          FirebaseFirestore.instance
                              .collection("comments")
                              .add({
                            "ownerid": FirebaseAuth.instance.currentUser?.uid,
                            "ownertalkid": widget.currentTalk.id,
                            "timestamp": DateTime.now(),
                            "content": value
                          });
                          FirebaseFirestore.instance
                              .collection("talk")
                              .doc(widget.currentTalk.id.toString())
                              .set({"commentcount": FieldValue.increment(1)},
                                  SetOptions(merge: true));
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
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
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
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 12),
                    child: Column(
                      children: [
                        FutureBuilder(
                            future: GetName(widget.currentTalk["ownerid"]),
                            builder: ((context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(snapshot.data.toString());
                              } else
                                return Text("İsim alınamadı");
                            })),
                        DefaultTextStyle.merge(
                            child: Text(formatter.format(
                                DateTime.fromMillisecondsSinceEpoch(widget
                                    .currentTalk["timestamp"]
                                    .toDate()
                                    .millisecondsSinceEpoch)))),
                      ],
                    ),
                  ),
                ],
              )),
          Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    widget.content.toString(),
                    textAlign: TextAlign.start,
                  ),
                ),
              )),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Yorumlar"),
                TextButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.comment,
                      color: Colors.black,
                    ),
                    label: Text(
                      widget.currentTalk["commentcount"].toString(),
                      style: TextStyle(color: Colors.black),
                    ))
              ],
            ),
          )),
          Expanded(
              flex: 8,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: StreamBuilder<QuerySnapshot>(
                          builder: ((context, snapshot) {
                            if (snapshot.hasError) {
                              var er = snapshot.error.toString;
                              print(er);
                              return Center(child: Text(""));
                            } else if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              var docs = snapshot.data!.docs;

                              return ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: ((context, index) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: AssetImage(
                                            "assets/images/user_30px.png"),
                                      ),
                                      title: FutureBuilder(
                                        future: GetCommentUserName(docs, index),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                                snapshot.data.toString());
                                          } else {
                                            return Text("İsim alınamadı");
                                          }
                                        },
                                      ),
                                      subtitle: Text(
                                          docs[index]["content"].toString()),
                                    );
                                  }),
                                  separatorBuilder: (context, index) {
                                    return Divider(
                                      thickness: 1,
                                    );
                                  },
                                  itemCount: docs.length);
                            }
                          }),
                          stream: FirebaseFirestore.instance
                              .collection("comments")
                              .where("ownertalkid",
                                  isEqualTo: widget.currentTalk.id)
                              .orderBy("timestamp", descending: true)
                              .limit(100)
                              .snapshots(),
                        )),
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

  GetCommentUserName(
      List<QueryDocumentSnapshot<Object?>> docs, int index) async {
    var _CommentDoc = await FirebaseFirestore.instance.collection("user");
    var _result =
        await _CommentDoc.where("id", isEqualTo: docs[index]["ownerid"]).get();
    return _result.docs[0]["name"].toString();
  }
}
