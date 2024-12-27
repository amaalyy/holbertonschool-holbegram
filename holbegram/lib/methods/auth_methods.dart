import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import '../models/user.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    String bio = "",
    String photoUrl = "",
    Uint8List? file,
  }) async {
    String res = "An error occurred";

    try {
      if (email.isEmpty || password.isEmpty || username.isEmpty) {
        return "Please fill all the fields";
      }

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = userCredential.user!;

      Users newUser = Users(
        uid: user.uid,
        email: email,
        username: username,
        bio: bio,
        photoUrl: photoUrl,
        followers: [],
        following: [],
        posts: [],
        saved: [],
        searchKey: username[0].toUpperCase(),
      );

      await _firestore.collection("users").doc(user.uid).set(newUser.toJson());

      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<Users?> getUserDetails(String userId) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection("users").doc(userId).get();
      if (snapshot.exists) {
        return Users.fromSnap(snapshot);
      }
    } catch (e) {
      throw Exception("Error fetching user details: $e");
    }
    return null;
  }
}
