import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cutalk/models/Usermodel.dart';

class Talk {
  Talk({ required this.Content, required this.ownerid});
 
  String? Content;
  String? ownerid;

  factory Talk.create(
      {
      required String? Content,
      required String? Ownerid}) {
    return Talk( Content: Content, ownerid: Ownerid);
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
