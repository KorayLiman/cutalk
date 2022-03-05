import 'package:cloud_firestore/cloud_firestore.dart';
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
              .orderBy("timestamp", descending: false)
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
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    Timestamp t = docs[index]["timestamp"];
                    return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4),
                        child: ListTile(
                          // trailing: DefaultTextStyle.merge(
                          //     child: Text(formatter.format(
                          //         DateTime.fromMillisecondsSinceEpoch(
                          //             docs[index]["timestamp"])))),
                          title: Text(
                            docs[index]["content"],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontSize: 18),
                          ),

                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          tileColor: Colors.grey.shade200.withOpacity(0.7),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => ContentPage(
                                        Content: docs[index]["content"],
                                        ImagePath: docs[index]["imagepath"]))));
                          },
                          // DefaultTextStyle.merge(
                          //     child: Text(formatter.format(
                          //         DateTime.fromMillisecondsSinceEpoch(
                          //             t.toDate().millisecondsSinceEpoch)))),
                        ));
                  });
            }
          },
        ));
  }
}

// FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//         builder: ((BuildContext context,
//             AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
//           return Container();
//         }),
//       )



// TextButton(
//             onPressed: () async {
//               if (GoogleSignIn().currentUser != null) {}
//               await GoogleSignIn().disconnect();
//               await FirebaseAuth.instance.signOut();
//               Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: ((context) => LoginPage())),
//                   (route) => false);
//             },
//             child: const Text("SignOut"))

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