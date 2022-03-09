import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cutalk/models/Usermodel.dart';

class Talk {
  Talk(
      {required this.Content,
      required this.ownerid,
      required this.timestamp,
      required this.ViewCount,
      required this.CommentCount});

  String? Content;
  String? ownerid;
  int? ViewCount;
  int? CommentCount;
  

  DateTime? timestamp;

  factory Talk.create(
      {required String? Content,
      required String? Ownerid,
      required DateTime timestamp,
      required int? ViewCount,
      required int? Commentcount,
      }) {
    return Talk(
        Content: Content,
        ownerid: Ownerid,
        timestamp: timestamp,
        ViewCount: ViewCount,
        CommentCount: Commentcount);
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
