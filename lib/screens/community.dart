import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import 'package:uuid/uuid.dart';

class Community extends StatefulWidget {
  const Community({Key? key, required this.username, required this.photo})
      : super(key: key);
  final username, photo;
  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  final TextEditingController _grpcontroller = TextEditingController();
  String postid = const Uuid().v1();
  List request = [];
  List users = [FirebaseAuth.instance.currentUser!.uid];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 54),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Lottie.asset('assets/community.json',
                  height: MediaQuery.of(context).size.height / 2.5),
              const SizedBox(
                height: 100,
              ),
              Container(
                height: 100,
                child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('circle')
                        .doc('collection')
                        .snapshots(),
                    builder:
                        ((context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        List raa = data['collections'];
                        Map map = raa.asMap();
                        return Column(
                          children: [
                            Flexible(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: TextField(
                                    controller: _grpcontroller,
                                    decoration: const InputDecoration(
                                        hintText: 'create new group',
                                        icon: Icon(Icons.group_add_sharp))),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            MaterialButton(
                              onPressed: () async {
                                (_grpcontroller.text.isNotEmpty)
                                    ? (raa.contains(_grpcontroller.text)
                                        ? (await Fluttertoast.showToast(
                                            msg:
                                                'this name was already registered'))
                                        : {
                                            Fluttertoast.showToast(
                                                msg:
                                                    ' group is successfully created '),
                                            FirebaseFirestore.instance
                                                .collection('circle')
                                                .doc('collection')
                                                .update({
                                              'collections':
                                                  FieldValue.arrayUnion(
                                                      [_grpcontroller.text])
                                            }),
                                            FirebaseFirestore.instance
                                                .collection('circle')
                                                .doc('grp')
                                                .collection('collection')
                                                .doc(_grpcontroller.text)
                                                .set({
                                              'name': _grpcontroller.text,
                                              'request': []
                                            }),
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .update({
                                              'group': FieldValue.arrayUnion(
                                                  [_grpcontroller.text])
                                            }),
                                            FirebaseFirestore.instance
                                                .collection(_grpcontroller.text)
                                                .doc(_grpcontroller.text)
                                                .set({
                                              'request': request,
                                              'users': users,
                                              'createdby': widget.username,
                                              'created': DateTime.now(),
                                              'admin': widget.photo,
                                              'uid': FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              'group name': _grpcontroller.text
                                            }),
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .update({
                                              'admin': FieldValue.arrayUnion(
                                                  [_grpcontroller.text])
                                            }),
                                            Navigator.pop(context),
                                          })
                                    : Fluttertoast.showToast(
                                        msg: 'please enter your group name');

                                // FirebaseFirestore.instance
                                //     .collection(_grpcontroller.text)
                                //     .doc('chat')
                                //     .collection('chat')
                                //     .add({
                                //   'username': '',
                                //   'uid': '',
                                //   'profile': '',
                                //   'msg':
                                //       'this chat is maintained by ${widget.username},SWIPE RIGHT to Action DOUBLETAP to see message',
                                //   'img': '0',
                                //   'posturl': '',
                                //   'image': '',
                                //   'group': ''
                                // });
                              },
                              color: Colors.red,
                              child: const Text('new group'),
                            ),
                          ],
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    })),
              )
            ],
          ),
        ),
      ),
    );
  }
}
