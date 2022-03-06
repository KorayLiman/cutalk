class Comment {
  Comment({required this.Ownerid, required this.Content,});
  String? Ownerid;
  String? Content;
  

  factory Comment.create({required String? Ownerid, required String? Content}) {
    return Comment(Ownerid: Ownerid, Content: Content,);
  }
}
