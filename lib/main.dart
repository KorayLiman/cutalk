import 'package:cutalk/firebase_options.dart';
import 'package:cutalk/pages/Homepage.dart';
import 'package:cutalk/pages/Talk_Page.dart';
import 'package:cutalk/pages/login_page.dart';
import 'package:cutalk/pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(color: Colors.blue.shade800),
          scaffoldBackgroundColor: Colors.grey.shade200),
      title: 'CuTalk',
      home:
          FirebaseAuth.instance.currentUser == null ? LoginPage() : HomePage(),
    );
  }
}
