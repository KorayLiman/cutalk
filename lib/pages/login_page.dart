import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:clippy_flutter/arc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cutalk/FirestoreOperations.dart';
import 'package:cutalk/models/Usermodel.dart';
import 'package:cutalk/pages/Homepage.dart';
import 'package:cutalk/pages/Talk_Page.dart';
import 'package:cutalk/pages/signup_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //final EmailController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _UserSubscribe;
  late UserP user;
  late String password;
  late String email;
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
                    "CÜ Talk",
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
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      email = value;
                    },
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
                    onChanged: (value) {
                      password = value;
                    },
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
                          onPressed: () async {
                            bool result = await UserLogin();
                          },
                          icon: Icon(Icons.login),
                          label: const Text("Giriş Yap"),
                        ),
                        TextButton.icon(
                            onPressed: () async {
                              bool result = await GoogleLogin();
                              if (result) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => HomePage())),
                                    (route) => false);
                              }
                            },
                            icon: Image.asset(
                              "assets/images/google.png",
                              scale: 5,
                            ),
                            label: const Text("Google ile giriş yap")),
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

  Future<bool> GoogleLogin() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);

        FirebaseFirestore.instance
            .collection("user")
            .get()
            .then((QuerySnapshot querySnapshot) {
          bool DoesExist = false;
          querySnapshot.docs.forEach((doc) {
            if (doc["email"] == googleUser!.email) {
              DoesExist = true;
            }
          });
          if (DoesExist == false) {
            //FirestoreOperations.AddUser(googleUser!);
            var uuid = Uuid().v1();
            var name = googleUser?.displayName!;
            var email = googleUser?.email;
            var imagepath = null;
            user = UserP(
                id: FirebaseAuth.instance.currentUser?.uid,
                name: name,
                imagepath: imagepath,
                email: email,
                password: null);
            _firestore
                .collection("user")
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .set({
              "id": FirebaseAuth.instance.currentUser?.uid,
              "name": name,
              "imagepath": imagepath,
              "email": email,
              "password": null
            });
          }
        });
        return true;
      } catch (error) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Bir hata meydana geldi"),
              );
            });
        return false;
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Lütfen internete bağlanın"),
            );
          });
      return false;
    }

    //print(googleUser!.displayName);

    // Once signed in, return the UserCredential

    print("email: ${FirebaseAuth.instance.currentUser?.email}");
  }

  Future<bool> UserLogin() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        UserCredential _userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: ((context) => HomePage())),
            (route) => false);
        return true;
      } catch (error) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  "Yanlış email veya şifre",
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              );
            });
        return false;
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Lütfen internete bağlanın"),
            );
          });
      return false;
    }
  }
}
