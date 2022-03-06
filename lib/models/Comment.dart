import 'package:cutalk/models/Talkmodel.dart';

class Comment {
  Comment(
      {required this.Ownerid, required this.Content, required this.OwnerTalkId});
  String? Ownerid;
  String? Content;
  String? OwnerTalkId;

  factory Comment.create(
      {required String? Ownerid,
      required String? Content,
      required String? OwnerTalkId}) {
    return Comment(Ownerid: Ownerid, Content: Content, OwnerTalkId: OwnerTalkId);
  }
}
