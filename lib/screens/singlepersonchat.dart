import 'package:circle/tools/test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:uuid/uuid.dart';

class Singlepersonchat extends StatefulWidget {
  const Singlepersonchat(
      {Key? key,
      required this.personname,
      required this.privatekey,
      required this.uid})
      : super(key: key);
  final personname, uid, privatekey;

  @override
  State<Singlepersonchat> createState() => _SinglepersonchatState();
}

TextEditingController text = TextEditingController();

class _SinglepersonchatState extends State<Singlepersonchat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.personname)),
      body: Center(
        child: Stack(children: [
          Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('personalchat')
                        .doc('personalchat')
                        .collection(widget.privatekey)
                        .orderBy('date', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Lottie.asset('assets/chat.json'),
                              const Text('chat now swipe right')
                            ],
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        final data = snapshot.requireData;
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Column(children: [
                                (data.docs[index]['uid'] ==
                                        FirebaseAuth.instance.currentUser!.uid)
                                    ? SwipeTo(
                                        onRightSwipe: () {
                                          showBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return Container(
                                                    height: 100,
                                                    width: double.infinity,
                                                    child: Center(
                                                        child: Column(
                                                      children: [
                                                        Text(
                                                          DateFormat.yMMMEd()
                                                              .format(data
                                                                  .docs[index]
                                                                      ['date']
                                                                  .toDate()),
                                                        ),
                                                        (FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid ==
                                                                data.docs[index]
                                                                    ['uid'])
                                                            ? IconButton(
                                                                onPressed: () {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'personalchat')
                                                                      .doc(
                                                                          'personalchat')
                                                                      .collection(FirebaseAuth
                                                                              .instance
                                                                              .currentUser!
                                                                              .uid +
                                                                          widget
                                                                              .uid)
                                                                      .doc(data.docs[
                                                                              index]
                                                                          [
                                                                          'chattime'])
                                                                      .delete();
                                                                  Fluttertoast
                                                                      .showToast(
                                                                          msg:
                                                                              'deleted');
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red,
                                                                ))
                                                            : const Text(
                                                                'by circle')
                                                      ],
                                                    )));
                                              });
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              child: Stack(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Card(
                                                          elevation: 45,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              data.docs[index]
                                                                  ['msg'],
                                                              style: const TextStyle(
                                                                  wordSpacing:
                                                                      .7,
                                                                  letterSpacing:
                                                                      .5),
                                                            ),
                                                          )),
                                                    ),
                                                  ]),
                                            )
                                          ],
                                        ),
                                      )
                                    : SwipeTo(
                                        onRightSwipe: () {
                                          showBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return Container(
                                                    height: 100,
                                                    width: double.infinity,
                                                    child: Center(
                                                        child: Column(
                                                      children: [
                                                        Text(
                                                          DateFormat.yMMMEd()
                                                              .format(data
                                                                  .docs[index]
                                                                      ['date']
                                                                  .toDate()),
                                                        ),
                                                      ],
                                                    )));
                                              });
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              child: Stack(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Card(
                                                          elevation: 45,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              data.docs[index]
                                                                  ['msg'],
                                                              style: const TextStyle(
                                                                  wordSpacing:
                                                                      .7,
                                                                  letterSpacing:
                                                                      .4),
                                                            ),
                                                          )),
                                                    ),
                                                  ]),
                                            )
                                          ],
                                        ),
                                      )
                              ]);
                            });
                      }
                      return Center(
                        child: Column(
                          children: [
                            Lottie.asset('assets/chat.json',
                                height: MediaQuery.of(context).size.height / 2),
                            const Text('Start chatting')
                          ],
                        ),
                      );
                    }),
              ),
              TextFieldInput(
                  textEditingController: text,
                  hintText: 'chat',
                  textInputType: TextInputType.name)
            ],
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            String chatid = const Uuid().v1();
            FirebaseFirestore.instance
                .collection('personalchat')
                .doc('personalchat')
                .collection(widget.privatekey)
                .doc(chatid)
                .set({
              'msg': text.text,
              'chattime': chatid,
              'date': DateTime.now(),
              'uid': FirebaseAuth.instance.currentUser!.uid
            });
            text.clear();
          },
          child: const Icon(
            Icons.send,
          )),
    );
  }
}
