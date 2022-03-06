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
      drawer: Drawer(),
      appBar: AppBar(
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
        bottom: TabBar(controller: _tabController, tabs: [
          Tab(
            child: Icon(
              Icons.home,
            ),
          ),
          Tab(child: Icon(Icons.message)),
          Tab(
            child: Icon(Icons.announcement),
          )
        ]),
      ),
      body: TabBarView(
          controller: _tabController,
          children: [LandingPage(), TalkPage(), Container()]),
    );
  }
}
