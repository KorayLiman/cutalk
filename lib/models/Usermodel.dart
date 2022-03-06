class UserP {
  UserP(
      {required this.id,
      required this.name,
      required this.imagepath,
      required this.email,required this.password});
  String? id;
  String? name;
  String? email;
  String? imagepath = "assets/images/user_30px.png";
  String? password;
}
