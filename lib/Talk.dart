

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Talk extends StatelessWidget {
  Talk({Key? key, required this.title}) : super(key: key);
  final String title;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Text(title);
  }

  Future<List<Talk>> GetTalkList() async {
    List<Talk> _MyList = [];
    var TalkDocuments = await _firestore.collection("talk").get();
    
    return _MyList;
  }
}
