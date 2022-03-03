import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:clippy_flutter/arc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cutalk/FirestoreOperations.dart';
import 'package:cutalk/pages/Talk_Page.dart';
import 'package:cutalk/pages/signup_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //final EmailController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _UserSubscribe;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          Stack(
            children: [
              Arc(
                  height: 50,
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.blue,
                  )),
              Positioned(
                left: 25,
                right: 25,
                bottom: 50,
                child: Container(
                  alignment: Alignment.center,
                  height: 60,
                  child: AutoSizeText(
                    "CU Talk",
                    minFontSize: 12,
                    maxFontSize: 28,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (input) {
                      if (!EmailValidator.validate(input!)) {
                        return "Geçersiz mail adresi";
                      } else {}
                    },
                    decoration: InputDecoration(
                        hintText: "Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (input) {
                      if (input!.length < 6) {
                        return "Şifre 6 haneden büyük olmalı";
                      } else {}
                    },
                    decoration: InputDecoration(
                        hintText: "Şifre",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.login),
                          label: const Text("Giriş Yap"),
                        ),
                        TextButton.icon(
                            onPressed: () async {
                              await GoogleLogin();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => TalkPage())),
                                  (route) => false);
                            },
                            icon: Image.asset(
                              "assets/images/google.png",
                              scale: 5,
                            ),
                            label: const Text("Google ile giriş yap")),
                            GoogleSignInIconButton(clientId: "test",)
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => SignUpPage())));
                        },
                        child: const Text("Kayıt ol"))
                  ],
                ),
                Expanded(
                  child: Image.asset(
                    "assets/images/cu.png",
                    scale: 3,
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const AutoSizeText(
                    "Uygulama beta aşamasındadır. Hatalar için affedin",
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                    minFontSize: 12,
                  ),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<UserCredential> GoogleLogin() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    FirebaseFirestore.instance
        .collection("user")
        .get()
        .then((QuerySnapshot querySnapshot) {
      bool DoesExist = false;
      querySnapshot.docs.forEach((doc) {
        if (doc["name"] == googleUser!.displayName) {
          DoesExist = true;
        }
      });
      if (DoesExist == false) {
        FirestoreOperations.AddUser(googleUser!);
      }
    });
    //print(googleUser!.displayName);

    Navigator.push(
        context, MaterialPageRoute(builder: ((context) => TalkPage())));
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
