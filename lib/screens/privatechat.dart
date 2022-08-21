import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';

import 'singlepersonchat.dart';

class PrivateChat extends StatefulWidget {
  const PrivateChat({Key? key}) : super(key: key);

  @override
  State<PrivateChat> createState() => _PrivateChatState();
}

late DocumentSnapshot snapshot;

class _PrivateChatState extends State<PrivateChat> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: StreamBuilder(
                  stream: (FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('friends')
                      .snapshots()),
                  builder: ((BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                          child: Column(
                        children: [
                          Lottie.asset('assets/request.json',
                              height: MediaQuery.of(context).size.height / 3),
                          const Text('No friend request'),
                        ],
                      ));
                    }
                    if (snapshot.hasData) {
                      final data = snapshot.requireData;
                      {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'friend request',
                                    ),
                                  )),
                              Flexible(
                                child: ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      void getData() async {
                                        final x = await FirebaseFirestore
                                            .instance
                                            .collection('users')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .get();

                                        var rajan = x.get("email");

                                        print(rajan);
                                      }

                                      return Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10, left: 5, top: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: CircleAvatar(
                                                      maxRadius: 30,
                                                      minRadius: 20,
                                                      backgroundImage:
                                                          NetworkImage(
                                                              data.docs[index]
                                                                  ['photo']),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(data.docs[index]
                                                          ['username']),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                          'from ${data.docs[index]['group']} '),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(
                                                                data.docs[index]
                                                                    ['uid'])
                                                            .collection(
                                                                'privatechat')
                                                            .doc(
                                                                data.docs[index]
                                                                    ['rname'])
                                                            .set({
                                                          'username':
                                                              data.docs[index]
                                                                  ['rname'],
                                                          'uid':
                                                              data.docs[index]
                                                                  ['ruid'],
                                                          'photo':
                                                              data.docs[index]
                                                                  ['rphoto'],
                                                          'key': FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid +
                                                              data.docs[index]
                                                                  ['uid']
                                                        });

                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid)
                                                            .collection(
                                                                'friends')
                                                            .doc(
                                                                data.docs[index]
                                                                    ['uid'])
                                                            .delete();
                                                        String privatechatid =
                                                            const Uuid().v1();
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid)
                                                            .collection(
                                                                'privatechat')
                                                            .doc(data
                                                                    .docs[index]
                                                                ['username'])
                                                            .set({
                                                          'username':
                                                              data.docs[index]
                                                                  ['username'],
                                                          'uid':
                                                              data.docs[index]
                                                                  ['uid'],
                                                          'photo':
                                                              data.docs[index]
                                                                  ['photo'],
                                                          'privatechatid':
                                                              privatechatid,
                                                          'key': FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid +
                                                              data.docs[index]
                                                                  ['uid']
                                                        });

                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid)
                                                            .update({
                                                          'friends': FieldValue
                                                              .arrayUnion(data
                                                                      .docs[
                                                                  index]['uid'])
                                                        });

                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'added in your friend list');
                                                      },
                                                      icon: const Icon(
                                                        Icons.add,
                                                        color: Colors.blue,
                                                      )),
                                                  IconButton(
                                                      onPressed: () async {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid)
                                                            .update({
                                                          'friends request':
                                                              FieldValue
                                                                  .arrayRemove([
                                                            data.docs[index]
                                                                ['uid']
                                                          ])
                                                        });
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid)
                                                            .collection(
                                                                'friends')
                                                            .doc(
                                                                data.docs[index]
                                                                    ['uid'])
                                                            .delete();
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'request deleted');
                                                      },
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ))
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                    return const Text('data');
                  }),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 2,
            child: Container(
              color: Colors.red,
              height: 2,
              width: double.infinity,
            ),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Chat',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: StreamBuilder(
              stream: (FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('privatechat')
                  .snapshots()),
              builder: ((BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Column(
                    children: [
                      Lottie.asset('assets/friends.json',
                          height: MediaQuery.of(context).size.height / 2.5),
                      const Text('No friends to chat'),
                    ],
                  ));
                }
                if (snapshot.hasData) {
                  final data = snapshot.requireData;
                  {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onLongPress: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height: 200,
                                      width: 200,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              'delete ${data.docs[index]['username']}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection('users')
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser!.uid)
                                                      .collection('privatechat')
                                                      .doc(data.docs[index]
                                                          ['username'])
                                                      .delete();

                                                  Fluttertoast.showToast(
                                                      msg: 'deleted');
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'delete',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ))
                                          ]),
                                    );
                                  });
                            },
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => Singlepersonchat(
                                        personname: data.docs[index]
                                            ['username'],
                                        privatekey: data.docs[index]['key'],
                                        uid: data.docs[index]['uid']))),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, left: 5, top: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            maxRadius: 30,
                                            minRadius: 20,
                                            backgroundImage: NetworkImage(
                                                data.docs[index]['photo']),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Text(data.docs[index]['username'])
                                        ],
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .update({
                                              'friends request':
                                                  FieldValue.arrayRemove(
                                                      [data.docs[index]['uid']])
                                            });
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .collection('privatechat')
                                                .doc(data.docs[index]
                                                    ['username'])
                                                .delete();
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ))
                                    ],
                                  )),
                            ),
                          );
                        });
                  }
                }
                return const Text('data');
              }),
            ),
          ),
        ],
      )),
    );
  }
}
