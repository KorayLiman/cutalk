import 'package:cross_file/src/types/interface.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
