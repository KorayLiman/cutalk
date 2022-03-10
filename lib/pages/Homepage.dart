import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cutalk/pages/Announcements_page.dart';
import 'package:cutalk/pages/Landing_page.dart';
import 'package:cutalk/pages/Talk_Page.dart';
import 'package:cutalk/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromRGBO(74, 0, 224, 1),
          Color.fromRGBO(142, 45, 226, 1)
        ])),
        child: TabBar(controller: _tabController, tabs: [
          Tab(
            text: "Anasayfa",
            iconMargin: EdgeInsets.all(0),
            icon: Icon(
              Icons.home,
            ),
          ),
          Tab(
            icon: Icon(Icons.message),
            text: "Sohbet",
            iconMargin: EdgeInsets.all(0),
          ),
          Tab(
            icon: Icon(Icons.announcement),
            text: "Duyurular",
            iconMargin: EdgeInsets.all(0),
          )
        ]),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
                accountName: FutureBuilder(
                  future: GetUserName(FirebaseAuth.instance.currentUser?.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data.toString());
                    } else {
                      return Text("İsim alınamadı");
                    }
                  },
                ),
                accountEmail: Text(FirebaseAuth.instance.currentUser == null
                    ? "Mail alınamadı"
                    : FirebaseAuth.instance.currentUser!.email.toString()))
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(74, 0, 224, 1),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                showAboutDialog(
                    context: context,
                    applicationName: "Cü Talk",
                    applicationVersion: "v1.0",
                    children: [
                      // Text("1- Kullanıcılar sohbetlere fotoğraf ekleyebilecek"),
                      // Text("2- Kullanıcılar profil fotoğraflarını seçebilecek"),
                      // Text("3- Mail doğrulama getirilecek"),
                      // Text("4- Duyurular bölümü yapılacak"),
                      // Text("5- Firestore izinleri düzenlenecek"),
                      // Text("6- Sohbet ekleme arayüzü iyileştirilecek")
                    ]);
              },
              icon: Icon(Icons.question_mark)),
          IconButton(
              onPressed: () async {
                if (GoogleSignIn().currentUser != null) {
                  await GoogleSignIn().disconnect();
                }

                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: ((context) => LoginPage())),
                    (route) => false);
              },
              icon: Icon(Icons.logout))
        ],
        centerTitle: true,
        title: const Text("Cumhuriyet Üniversitesi"),
      ),
      body: TabBarView(
          controller: _tabController,
          children: [LandingPage(), TalkPage(), AnnouncementsPage()]),
    );
  }

  GetUserName(String? id) async {
    var _UserDoc = await FirebaseFirestore.instance.collection("user");
    var _result = await _UserDoc.where("id", isEqualTo: id).get();
    return _result.docs[0]["name"];
  }
}
