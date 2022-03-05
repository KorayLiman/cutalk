import 'package:cloud_firestore/cloud_firestore.dart';

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
  final DateFormat formatter = DateFormat('MM/dd HH:mm:SS');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
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
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4),
                      child: ListTile(
                        // trailing: DefaultTextStyle.merge(
                        //     child: Text(formatter.format(
                        //         DateTime.fromMillisecondsSinceEpoch(
                        //             docs[index]["timestamp"])))),
                        title: Text(docs[index]["Title"]),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        tileColor: Colors.grey.shade300,
                      ),
                    );
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