import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cutalk/Talk.dart';
import 'package:cutalk/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class TalkPage extends StatefulWidget {
  const TalkPage({Key? key}) : super(key: key);

  @override
  State<TalkPage> createState() => _TalkPageState();
}

class _TalkPageState extends State<TalkPage> {
  late final Future<List<Talk>> _TalkList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_TalkList = Talk.GetTalkList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () async {
              if (GoogleSignIn().currentUser != null) {}
              await GoogleSignIn().disconnect();
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: ((context) => LoginPage())),
                  (route) => false);
            },
            child: const Text("SignOut")),
      ),
    );
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