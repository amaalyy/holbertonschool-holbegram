import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage({
    required bool isPost,
    required String childName,
    required Uint8List file,
  }) async {
    try {
      Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);
      
      if (isPost) {
        String id = const Uuid().v1();
        ref = ref.child(id);
      }
      
      UploadTask uploadTask = ref.putData(file);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception("Error uploading image: $e");
    }
  }
}
