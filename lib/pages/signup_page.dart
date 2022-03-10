import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cutalk/pages/Homepage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? Username = null;
    String? Email = null;
    String? Password = null;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Kayıt ol"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Image.asset(
              "assets/images/cu.png",
              scale: 3,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: TextFormField(
              onChanged: (value) {
                Username = value;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (input) {
                if (input!.length < 2) {
                  return "İsim 2 haneden büyük olmalı";
                } else {}
              },
              decoration: InputDecoration(
                  hintText: "Tam İsim",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                Email = value;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (input) {
                if (!EmailValidator.validate(input!)) {
                  return "Geçersiz mail";
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
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: TextFormField(
              onChanged: (value) {
                Password = value;
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
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  var connectivityResult =
                      await (Connectivity().checkConnectivity());
                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi) {
                    if (Username != null &&
                        Username!.length > 1 &&
                        Email != null &&
                        Email!.length > 4 &&
                        Password != null &&
                        Password!.length > 5) {
                      SignUp(Username!, Email!, Password!, context);
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("İsim, mail veya şifre hatalı"),
                            );
                          });
                    }
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Lütfen internete bağlanın"),
                          );
                        });
                  }
                },
                child: const Text("Kayıt ol"),
              ),
            ],
          ))
        ],
      ),
    );
  }

  void SignUp(String username, String email, String password,
      BuildContext context) async {
    var _UserDoc = await FirebaseFirestore.instance.collection("user");
    var _result = await _UserDoc.where("email", isEqualTo: email).get();
    if (_result.docs.isEmpty) {
      try {
        UserCredential _usercredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        await FirebaseFirestore.instance
            .collection("user")
            .doc(_usercredential.user!.uid)
            .set({
          "name": username,
          "email": email,
          "imagepath": null,
          "password": password,
          "id": FirebaseAuth.instance.currentUser?.uid
        });

        var _MyUser = _usercredential.user;
        // var _result1 = await _UserDoc.where(email, isEqualTo: "email").get();
        // FirebaseFirestore.instance
        //     .collection("user")
        //     .doc(_result1.docs[0].id)
        //     .set({"name": username}, SetOptions(merge: true));
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: ((context) => HomePage())),
            (route) => false);
        // if (!_MyUser!.emailVerified) {
        //   await _MyUser.sendEmailVerification();
        // }
      } catch (error) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(actions: [
                Text(
                    "Bu hatayla karşılaştıysanız isim mail ve şifrenizi harf ve rakam dışında karakter içermeyecek şekilde düzeltmeyi deneyin")
              ]);
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Mail kullanılıyor"),
            );
          });
    }
  }
}
