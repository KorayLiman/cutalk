import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cutalk/models/Usermodel.dart';

class Talk {
  Talk({required this.user, required this.Content, required this.ownerid});
  UserP? user;
  String? Content;
  String? ownerid;

  factory Talk.create(
      {required UserP user,
      required String? Content,
      required String? Ownerid}) {
    return Talk(user: user, Content: Content, ownerid: Ownerid);
  }

  static CreateTalk({required Talk, String? content, String? ownerid}){
     FirebaseFirestore.instance.collection("talk").add({
                            "content": content,
                            "timestamp": DateTime.now(),
                            "imagepath": null,
                            "ownerid":ownerid
                          });
  }
}
