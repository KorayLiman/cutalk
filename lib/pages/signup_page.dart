import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late String Username;
    late String UserSurname;
    late String Email;
    late String Password;
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (input) {
                if (input!.length < 2) {
                  return "İsim 2 haneden büyük olmalı";
                } else {}
              },
              decoration: InputDecoration(
                  hintText: "Ad",
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (input) {
                if (input!.length < 2) {
                  return "Soyad 2 haneden büyük olmalı";
                } else {}
              },
              decoration: InputDecoration(
                  hintText: "Soyad",
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
                onPressed: () {},
                child: const Text("Kayıt ol"),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
