import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cutalk/pages/Content_page.dart';
import 'package:cutalk/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [
                  Color.fromRGBO(74, 0, 224, 1),
                  Color.fromRGBO(142, 45, 226, 1)
                ])),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: MediaQuery.of(context).size.width / 1.2,
              height: MediaQuery.of(context).size.height / 2.4,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "En yeni sohbetler",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    StreamBuilder<QuerySnapshot>(
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var docs = snapshot.data!.docs;
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: docs.length > 2 ? 3 : 0,
                            itemBuilder: (context, index) {
                              return ListTile(
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
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage:
                                      AssetImage("assets/images/user_40px.png"),
                                ),
                                title: FutureBuilder(
                                  future: GetUserName(docs, index),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        snapshot.data.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      );
                                    } else {
                                      return Text("İsim alınamadı");
                                    }
                                  },
                                ),
                                subtitle: Text(
                                  docs[index]["content"],
                                  maxLines: 2,
                                  style: TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                          );
                        } else {
                          return Text(
                            "Sohbet Yüklenemedi",
                          );
                        }
                      },
                      stream: FirebaseFirestore.instance
                          .collection("talk")
                          .orderBy("timestamp", descending: true)
                          .limit(3)
                          .snapshots(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Text(
                "Duyurular",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 67.0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: MediaQuery.of(context).size.height / 2.4,
                  child: Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  GetUserName(List<QueryDocumentSnapshot<Object?>> docs, int index) async {
    var _UserDoc = await FirebaseFirestore.instance.collection("user");
    var _result =
        await _UserDoc.where("id", isEqualTo: docs[index]["ownerid"]).get();
    return _result.docs[0]["name"];
  }
}
