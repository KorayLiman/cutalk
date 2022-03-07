import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cutalk/models/Usermodel.dart';

class Talk {
  Talk({required this.Content, required this.ownerid, required this.timestamp,required this.ViewCount});

  String? Content;
  String? ownerid;
  int? ViewCount;

  DateTime? timestamp;

  factory Talk.create(
      {required String? Content,
      required String? Ownerid,
      required DateTime timestamp,
      required int? ViewCount}) {
    return Talk(Content: Content, ownerid: Ownerid, timestamp: timestamp,ViewCount: ViewCount);
  }

  static CreateTalk({required Talk, String? content, String? ownerid}) {
    FirebaseFirestore.instance.collection("talk").add({
      "content": content,
      "timestamp": DateTime.now(),
      "imagepath": null,
      "ownerid": ownerid,
    });
  }
}
