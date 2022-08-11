import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import '../tools/test.dart';

class Addcomment extends StatefulWidget {
  const Addcomment(
      {Key? key,
      required this.Name,
      required this.photo,
      required this.team,
      required this.postid})
      : super(key: key);
  final String Name;
  final String photo;
  final String postid;
  final String team;
  @override
  State<Addcomment> createState() => _AddcommentState();
}

@override
// void dispose() {
//   _commentcontroller.dispose();
// }

TextEditingController _commentcontroller = TextEditingController();

class _AddcommentState extends State<Addcomment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 200,
          width: MediaQuery.of(context).size.width / 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.Name + "'s" + ' comments',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFieldInput(
                    textEditingController: _commentcontroller,
                    hintText: 'comments...',
                    maxLines: true,
                    textInputType: TextInputType.name),
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: TextButton(
                    onPressed: () async {
                      String commentid = const Uuid().v1();
                      await FirebaseFirestore.instance
                          .collection(widget.team)
                          .doc('post')
                          .collection(widget.team)
                          .doc(widget.postid)
                          .collection('comments')
                          .doc(commentid)
                          .set({
                        'username': widget.Name,
                        'uid': FirebaseAuth.instance.currentUser!.uid,
                        'profilephoto': widget.photo,
                        'comment': _commentcontroller.text,
                        'commentid': commentid,
                        'votes': []
                      });
                      _commentcontroller.clear();
                      Fluttertoast.showToast(msg: 'commented');
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'submit',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
