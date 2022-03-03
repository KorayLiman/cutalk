import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirestoreOperations {
  static AddUser(GoogleSignInAccount googleUser) {
     CollectionReference users = FirebaseFirestore.instance.collection("user");
    
    users.add({"name": googleUser.displayName});
  }
}
