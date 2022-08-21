import 'dart:typed_data';
import 'package:circle/services/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> postupload({
    required String descrption,
    required String username,
    required Uint8List file,
  }) async {
    String res = "error occured";
    try {
      if (descrption.isNotEmpty || username.isNotEmpty || file.isNotEmpty) {
        String post = await StorageMethods().Uploadpost('posts', file, false);
        await _firebaseFirestore.collection('posts').add({
          'username': username,
          'post': post,
          'descrption': descrption,
        });
        res = 'Success';
      }
    } on FirebaseAuthException catch (e) {
      res = "Post can't uploaded";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required Uint8List file,
  }) async {
    String res = "error occured";
    try {
      if (password.isNotEmpty ||
          email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          file.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);
        String photourl = await StorageMethods()
            .uploadImageToStorage('profilepics', file, false);

        await _firebaseFirestore.collection('users').doc(cred.user!.uid).set({
          'username': username,
          'uid': cred.user!.uid,
          'email': email,
          'photourl': photourl,
          'admin': [],
          'request': [],
          'saved': [],
          'password': password,
          'group': [],
          'friends request': [],
        });

        res = "Success";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        res = "the email is invalid";
      } else if (e.code == "weak-password") {
        res = 'password should be at least 6 characters';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    String res = "error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Success";
      } else {
        res = "enter all the fields";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
