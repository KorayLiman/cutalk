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
      drawer: Drawer(),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(74, 0, 224, 1),
        elevation: 0,
        actions: [
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
}
