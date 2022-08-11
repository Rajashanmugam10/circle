import 'dart:typed_data';

import 'package:circle/services/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DocumentSnapshot snapshot;
  void getData() async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    snapshot = data;
  }

  Future<String> uploadpost(
    String descrption,
    Uint8List file,
    String uid,
    String blog,
    String username,
    String proImage,
    String grpname,
  ) async {
    getData();
    String res = "error occured";
    try {
      String photurl =
          await StorageMethods().uploadImageToStorage(grpname, file, true);
      String postid = const Uuid().v1();
      //firestore saving posts
      // POST SAVING METHODS IMPORTTANT!!!!!!!!!
      _firestore
          .collection(grpname)
          .doc('post')
          .collection(grpname)
          .doc(postid)
          .set({
        'blog': blog,
        'description': descrption,
        'uid': uid,
        'username': snapshot.get('username').toString(),
        'postid': postid,
        'dateposted': DateTime.now(),
        'posturl': photurl,
        'proImage': proImage,
        'likes': []
      });
      _firestore
          .collection(grpname)
          .doc('post')
          .collection(grpname)
          .doc(postid)
          .collection('comments')
          .doc()
          .update({});

      // _firestore.collection('posts').doc(postid).set({
      //   'description': descrption,
      //   'uid': uid,
      //   'username': snapshot.get('username').toString(),
      //   'postid': postid,
      //   'dateposted': DateTime.now(),
      //   'posturl': photurl,
      //   'proImage': proImage,
      //   'likes': []
      // });
      res = "Success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
