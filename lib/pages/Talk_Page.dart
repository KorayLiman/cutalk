import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cutalk/models/Talkmodel.dart';
import 'package:cutalk/pages/Content_page.dart';

import 'package:cutalk/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class TalkPage extends StatefulWidget {
  const TalkPage({Key? key}) : super(key: key);

  @override
  State<TalkPage> createState() => _TalkPageState();
}

class _TalkPageState extends State<TalkPage> {
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
                        onFieldSubmitted: (value) {
                          if (value.length > 0) {
                            var newTalk = Talk.create(
                                Content: value,
                                timestamp: DateTime.now(),
                                ViewCount: 0,
                                Commentcount: 0,
                                Ownerid:
                                    FirebaseAuth.instance.currentUser?.uid);

                            print(FirebaseAuth.instance.currentUser?.uid);
                            FirebaseFirestore.instance.collection("talk").add({
                              "content": newTalk.Content,
                              "ownerid": newTalk.ownerid,
                              "timestamp": DateTime.now(),
                              "comments": FieldValue.arrayUnion([]),
                              "viewcount": 0,
                              "commentcount": 0
                            });
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Konuşmanızı buraya yazınız"),
                        autofocus: true,
                      ),
                    ),
                  );
                });
          },
          child: Icon(
            Icons.add,
            size: 24,
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("talk")
              .orderBy("timestamp", descending: true)
              .limit(100)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Hata"),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var docs = snapshot.data!.docs;
              return ListView.builder(
                  itemExtent: 190,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    Timestamp t = docs[index]["timestamp"];

                    return FutureBuilder(
                        future: GetImageUrl(docs[index]["ownerid"]),
                        builder: (context, snapshow) {
                          if (!snapshow.hasData) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onLongPress: () async {
                                  var connectivityResult = await (Connectivity()
                                      .checkConnectivity());
                                  if (connectivityResult ==
                                          ConnectivityResult.mobile ||
                                      connectivityResult ==
                                          ConnectivityResult.wifi) {
                                    if (docs[index]["ownerid"] ==
                                        FirebaseAuth
                                            .instance.currentUser?.uid) {
                                      showMenu(
                                          context: context,
                                          position: RelativeRect.fromLTRB(
                                              0,
                                              MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              MediaQuery.of(context).size.width,
                                              0),
                                          items: [
                                            PopupMenuItem(
                                                child: TextButton.icon(
                                                    onPressed: () async {
                                                      QuerySnapshot<
                                                              Map<String,
                                                                  dynamic>>
                                                          snp =
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "comments")
                                                              .where("ownerid",
                                                                  isEqualTo:
                                                                      docs[index]
                                                                          .id)
                                                              .get();
                                                      snp.docs
                                                          .forEach((element) {
                                                        element.reference
                                                            .delete();
                                                      });

                                                      await FirebaseFirestore
                                                          .instance
                                                          .runTransaction(
                                                              (Transaction
                                                                  myTransaction) async {
                                                        await myTransaction
                                                            .delete(snapshot
                                                                .data!
                                                                .docs[index]
                                                                .reference);
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                    icon: Icon(Icons.delete),
                                                    label: const Text(
                                                        "Gönderiyi sil")))
                                          ]);
                                    }
                                  }
                                },
                                onTap: (() async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => ContentPage(
                                              content: docs[index]["content"],
                                              userid: docs[index]["ownerid"],
                                              currentTalk: docs[index]))));
                                  await FirebaseFirestore.instance
                                      .doc("talk/${docs[index].id}")
                                      .set({
                                    "viewcount": FieldValue.increment(1)
                                  }, SetOptions(merge: true));
                                }),
                                child: Material(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    Colors.transparent,
                                                backgroundImage: AssetImage(
                                                    "assets/images/user_40px.png"),
                                              )),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              FutureBuilder(
                                                  future: GetName(
                                                      docs[index]["ownerid"]),
                                                  builder: (context, snapshot) {
                                                    return Text(snapshot.data
                                                        .toString());
                                                  }),
                                              DefaultTextStyle.merge(
                                                  child: Text(formatter.format(DateTime
                                                      .fromMillisecondsSinceEpoch(t
                                                          .toDate()
                                                          .millisecondsSinceEpoch))))
                                            ],
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: AutoSizeText(
                                          docs[index]["content"],
                                          maxLines: 4,
                                          minFontSize: 16,
                                          maxFontSize: 18,
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 24,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 16.0),
                                          child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0.0),
                                                  child: TextButton.icon(
                                                      onPressed: () {},
                                                      icon: Icon(
                                                        Icons.comment,
                                                        color: Colors.black,
                                                      ),
                                                      label: Text(
                                                        docs[index]
                                                                ["commentcount"]
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      )),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0.0),
                                                  child: TextButton.icon(
                                                    icon: Icon(
                                                      Icons.remove_red_eye,
                                                      color: Colors.black,
                                                    ),
                                                    label: Text(
                                                        docs[index]["viewcount"]
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                    onPressed: () {},
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onLongPress: () async {
                                  var connectivityResult = await (Connectivity()
                                      .checkConnectivity());
                                  if (connectivityResult ==
                                          ConnectivityResult.mobile ||
                                      connectivityResult ==
                                          ConnectivityResult.wifi) {
                                    if (docs[index]["ownerid"] ==
                                        FirebaseAuth
                                            .instance.currentUser?.uid) {
                                      showMenu(
                                          context: context,
                                          position: RelativeRect.fromLTRB(
                                              0,
                                              MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              MediaQuery.of(context).size.width,
                                              0),
                                          items: [
                                            PopupMenuItem(
                                                child: TextButton.icon(
                                                    onPressed: () async {
                                                      QuerySnapshot<
                                                              Map<String,
                                                                  dynamic>>
                                                          snp =
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "comments")
                                                              .where("ownerid",
                                                                  isEqualTo:
                                                                      docs[index]
                                                                          .id)
                                                              .get();
                                                      snp.docs
                                                          .forEach((element) {
                                                        element.reference
                                                            .delete();
                                                      });

                                                      await FirebaseFirestore
                                                          .instance
                                                          .runTransaction(
                                                              (Transaction
                                                                  myTransaction) async {
                                                        await myTransaction
                                                            .delete(snapshot
                                                                .data!
                                                                .docs[index]
                                                                .reference);
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                    icon: Icon(Icons.delete),
                                                    label: const Text(
                                                        "Gönderiyi sil")))
                                          ]);
                                    }
                                  }
                                },
                                onTap: (() async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => ContentPage(
                                              content: docs[index]["content"],
                                              userid: docs[index]["ownerid"],
                                              currentTalk: docs[index]))));
                                  await FirebaseFirestore.instance
                                      .doc("talk/${docs[index].id}")
                                      .set({
                                    "viewcount": FieldValue.increment(1)
                                  }, SetOptions(merge: true));
                                }),
                                child: Material(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    Colors.transparent,
                                                backgroundImage: NetworkImage(
                                                    snapshow.data.toString()),
                                              )),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              FutureBuilder(
                                                  future: GetName(
                                                      docs[index]["ownerid"]),
                                                  builder: (context, snapshot) {
                                                    return Text(snapshot.data
                                                        .toString());
                                                  }),
                                              DefaultTextStyle.merge(
                                                  child: Text(formatter.format(DateTime
                                                      .fromMillisecondsSinceEpoch(t
                                                          .toDate()
                                                          .millisecondsSinceEpoch))))
                                            ],
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: AutoSizeText(
                                          docs[index]["content"],
                                          maxLines: 4,
                                          minFontSize: 16,
                                          maxFontSize: 18,
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 24,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 16.0),
                                          child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0.0),
                                                  child: TextButton.icon(
                                                      onPressed: () {},
                                                      icon: Icon(
                                                        Icons.comment,
                                                        color: Colors.black,
                                                      ),
                                                      label: Text(
                                                        docs[index]
                                                                ["commentcount"]
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      )),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0.0),
                                                  child: TextButton.icon(
                                                    icon: Icon(
                                                      Icons.remove_red_eye,
                                                      color: Colors.black,
                                                    ),
                                                    label: Text(
                                                        docs[index]["viewcount"]
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                    onPressed: () {},
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        });
                    // return Padding(
                    //   padding:
                    //       const EdgeInsets.only(top: 12.0, right: 10, left: 10),
                    //   child: Card(
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(18)),
                    //     elevation: 8,
                    //     child: Stack(
                    //       children: [
                    //         ListTile(
                    //           contentPadding:
                    //               EdgeInsets.only(top: 20, bottom: 10, left: 5),
                    //           leading:
                    //               Image.asset("assets/images/discussion.png"),
                    // trailing: DefaultTextStyle.merge(
                    //     child: Text(formatter.format(
                    //         DateTime.fromMillisecondsSinceEpoch(
                    //             docs[index]["timestamp"])))),
                    //           title: Text(
                    //             docs[index]["content"],
                    //             overflow: TextOverflow.ellipsis,
                    //             maxLines: 2,
                    //             style: TextStyle(fontSize: 18),
                    //           ),

                    //           trailing: Icon(Icons.arrow_forward_ios),
                    //           onTap: () {
                    //             Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                     builder: ((context) => ContentPage(
                    //                         content: docs[index]["content"],
                    //                         userid: docs[index]["ownerid"],
                    //                         currentTalk: docs[index]))));
                    //           },
                    //           onLongPress: () async {
                    //             var connectivityResult =
                    //                 await (Connectivity().checkConnectivity());
                    //             if (connectivityResult ==
                    //                     ConnectivityResult.mobile ||
                    //                 connectivityResult ==
                    //                     ConnectivityResult.wifi) {
                    //               if (docs[index]["ownerid"] ==
                    //                   FirebaseAuth.instance.currentUser?.uid) {
                    //                 showMenu(
                    //                     context: context,
                    //                     position: RelativeRect.fromLTRB(
                    //                         0,
                    //                         MediaQuery.of(context).size.height,
                    //                         MediaQuery.of(context).size.width,
                    //                         0),
                    //                     items: [
                    //                       PopupMenuItem(
                    //                           child: TextButton.icon(
                    //                               onPressed: () async {
                    //                                 QuerySnapshot<
                    //                                         Map<String,
                    //                                             dynamic>> snp =
                    //                                     await FirebaseFirestore
                    //                                         .instance
                    //                                         .collection(
                    //                                             "comments")
                    //                                         .where("ownerid",
                    //                                             isEqualTo:
                    //                                                 docs[index]
                    //                                                     .id)
                    //                                         .get();
                    //                                 snp.docs.forEach((element) {
                    //                                   element.reference
                    //                                       .delete();
                    //                                 });

                    //                                 await FirebaseFirestore
                    //                                     .instance
                    //                                     .runTransaction((Transaction
                    //                                         myTransaction) async {
                    //                                   await myTransaction
                    //                                       .delete(snapshot
                    //                                           .data!
                    //                                           .docs[index]
                    //                                           .reference);
                    //                                   Navigator.pop(context);
                    //                                 });
                    //                               },
                    //                               icon: Icon(Icons.delete),
                    //                               label: const Text(
                    //                                   "Gönderiyi sil")))
                    //                     ]);
                    //               }
                    //             }
                    //           },
                    //         ),
                    //         Align(
                    //           alignment: Alignment.bottomRight,
                    //           child: Padding(
                    //             padding: const EdgeInsets.only(right: 8.0),
                    // child: DefaultTextStyle.merge(
                    //     child: Text(formatter.format(
                    //         DateTime.fromMillisecondsSinceEpoch(t
                    //             .toDate()
                    //             .millisecondsSinceEpoch)))),
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // );
                  });
            }
          },
        ));
  }

  GetUserImage(String? userid) async {
    var _UserDoc = await FirebaseFirestore.instance.collection("user");
    var _result = await _UserDoc.where("id", isEqualTo: userid).get();
    return _result.docs[0]["imagepath"];
  }

  Future<String> GetName(String? userid) async {
    var _UserDoc =
        await FirebaseFirestore.instance.collection("user").doc(userid).get();

    return _UserDoc["name"];
  }

  GetImageUrl(String id) async {
    var userdoc =
        await FirebaseFirestore.instance.collection("user").doc(id).get();
    return userdoc["imagepath"];
  }
}
// FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//         builder: ((BuildContext context,
//             AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
//           return Container();
//         }),
//       )




// Scaffold(
//       body: Center(
//         child: TextButton(
//             onPressed: () async {
//               if (GoogleSignIn().currentUser != null) {}
//               await GoogleSignIn().disconnect();
//               await FirebaseAuth.instance.signOut();
//               Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: ((context) => LoginPage())),
//                   (route) => false);
//             },
//             child: const Text("SignOut")),
//       ),
//     )