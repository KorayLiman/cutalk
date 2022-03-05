import 'package:cutalk/pages/Talk_Page.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
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
          children: [Container(), TalkPage(), Container()]),
    );
  }
}
