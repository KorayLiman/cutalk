import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);
  String val = "";
  String pw = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Ayarlar"),
      ),
      body: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(hintText: "Yeni Kullanıcı Adı"),
            onFieldSubmitted: (value) async {
              val = value;
            },
            onChanged: (value) {
              val = value;
            },
          ),
          OutlinedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("user")
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .set({"name": val}, SetOptions(merge: true));

                val = "";
              },
              child: Text("Kullanıcı adı değiştir")),
          TextFormField(
            decoration: InputDecoration(hintText: "Yeni Şifre"),
            onFieldSubmitted: (value) async {
              pw = value;
            },
            onChanged: (value) {
              pw = value;
            },
          ),
          OutlinedButton(
              onPressed: () async {
                var doc = await FirebaseFirestore.instance
                    .collection("user")
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .get();
                if (doc["password"] != null) {
                  await FirebaseFirestore.instance
                      .collection("user")
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .set({"password": pw}, SetOptions(merge: true));
                  pw = "";
                }
              },
              child: const Text("Şifre değiştir"))
        ],
      ),
    );
  }
}
