import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cutalk/pages/FullScreenImage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cutalk/models/Comment.dart';
import 'package:cutalk/models/Talkmodel.dart';
import 'package:cutalk/models/Usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  File? image;
  late firebase_storage.Reference ref;
  final ImagePicker _picker = ImagePicker();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
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
        actions: [
          IconButton(
              onPressed: () {
                if (widget.userid == FirebaseAuth.instance.currentUser?.uid) {
                  PickImages();
                }
              },
              icon: Icon(Icons.photo))
        ],
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
                                "assets/images/user_40px.png",
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
              flex: 2,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FutureBuilder(
                        future: GetUrl1(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FullScreenImage(snapshot: snapshot),
                                    ));
                              },
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            snapshot.data.toString()))),
                              ),
                            );
                          } else {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              child: AutoSizeText(
                                  "Lütfen 1 den fazla resim yüklemeyiniz ve resmi yükledikten sonra sayfayı yenileyiniz"),
                            );
                          }
                        }),
                    // FutureBuilder(
                    //     future: GetUrl2(),
                    //     builder: (context, snapshot) {
                    //       if (snapshot.hasData) {
                    //         return Container(
                    //           height: 100,
                    //           width: 100,
                    //           decoration: BoxDecoration(
                    //               image: DecorationImage(
                    //                   image: NetworkImage(
                    //                       snapshot.data.toString()))),
                    //         );
                    //       } else {
                    //         return Text("Resim yok");
                    //       }
                    //     })
                  ],
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
                                            "assets/images/user_40px.png"),
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

  void PickImages() async {
    final List<XFile>? image1 = await _picker.pickMultiImage();

    if (image1 != null) {
      for (int i = 0; i < image1.length; i++) {
        image = File(image1[i].path);
        ref = storage.ref().child("talkimages").child(i.toString());
        var UploadTask = ref.putFile(image!);
        var url = await (await UploadTask).ref.getDownloadURL();
        FirebaseFirestore.instance
            .collection("talk")
            .doc(widget.currentTalk.id)
            .set({
          "images": FieldValue.arrayUnion([url])
        }, SetOptions(merge: true));
      }
    }

    // image = File(image1!.path);
    // ref = storage
    //     .ref()
    //     .child("talkimages")
    //     .child("photo.png");
    // var UploadTask = ref.putFile(image!);
    // var url = await (await UploadTask).ref.getDownloadURL();

    // FirebaseFirestore.instance
    //     .collection("user")
    //     .doc(FirebaseAuth.instance.currentUser?.uid)
    //     .set({"imagepath": url}, SetOptions(merge: true));
    // setState(() {});
  }

  GetUrl1() async {
    var talkdoc = await FirebaseFirestore.instance
        .collection("talk")
        .doc(widget.currentTalk.id)
        .get();
    if (talkdoc["images"][0] != null) {
      return talkdoc["images"][0];
    } else {
      return "https://media.istockphoto.com/vectors/no-image-available-sign-vector-id922962354?k=20&m=922962354&s=612x612&w=0&h=f-9tPXlFXtz9vg_-WonCXKCdBuPUevOBkp3DQ-i0xqo=";
    }
  }

  GetUrl2() async {
    var talkdoc = await FirebaseFirestore.instance
        .collection("talk")
        .doc(widget.currentTalk.id)
        .get();
    if (talkdoc["images"][1] != null) {
      return talkdoc["images"][1];
    } else {
      return "https://media.istockphoto.com/vectors/no-image-available-sign-vector-id922962354?k=20&m=922962354&s=612x612&w=0&h=f-9tPXlFXtz9vg_-WonCXKCdBuPUevOBkp3DQ-i0xqo=";
    }
  }
}
