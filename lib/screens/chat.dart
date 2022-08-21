import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:uuid/uuid.dart';

import '../services/profile_pic.dart';
import '../services/storage.dart';
import '../tools/test.dart';
import 'reply.dart';

class Chat extends StatefulWidget {
  final String grpname, uid, photo, username;
  const Chat({
    Key? key,
    required this.grpname,
    required this.photo,
    required this.uid,
    required this.username,
  }) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

TextEditingController _chat = TextEditingController();
TextEditingController _reply = TextEditingController();

class _ChatState extends State<Chat> {
  Uint8List? _file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                iconSize: 30,
                splashColor: Colors.white,
                color: (_file != null) ? Colors.red : Colors.white,
                onPressed: () => _selectimage(context),
                icon: const Icon(Icons.photo_library_outlined)),
            IconButton(
                splashColor: Colors.white,
                onPressed: () {
                  send();
                },
                icon: const Icon(
                  Icons.send,
                ))
          ],
          title:
              // TextField(
              //   controller: reply,
              // )
              TextFieldInput(
                  textEditingController: _chat,
                  hintText: "chat...",
                  textInputType: TextInputType.multiline),
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(widget.grpname)
                  .doc('chat')
                  .collection('chat')
                  .orderBy('chattime', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("Error Occured");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/chatting.json'),
                      const Text(
                        'new chat always on top',
                      ),
                      const Text(
                        'swipe to reply',
                      ),
                      const Text('tap the message to see replies')
                    ],
                  );
                }

                if (snapshot.hasData) {
                  final data = snapshot.requireData;
                  print(FirebaseAuth.instance.currentUser!.uid);

                  return ListView.separated(
                      separatorBuilder: ((context, index) => const SizedBox(
                            height: 15,
                          )),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            (data.docs[index]['uid'] ==
                                    FirebaseAuth.instance.currentUser!.uid)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      data.docs[index]['img'] == "1"
                                          ? ClipRRect(
                                              child: SizedBox(
                                              width: 300,
                                              height: 300,
                                              child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    Container(
                                                        width: double.infinity,
                                                        child: Image.network(
                                                            data.docs[index]
                                                                ['posturl'])),
                                                    Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: TextButton(
                                                        child: const Text(
                                                            'read  message'),
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Row(
                                                                  children: [
                                                                    ClipOval(
                                                                      child: Image
                                                                          .network(
                                                                        data.docs[index]
                                                                            [
                                                                            'profile'],
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        height:
                                                                            60,
                                                                        width:
                                                                            60,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            20),
                                                                    Text(data.docs[
                                                                            index]
                                                                        [
                                                                        'username'])
                                                                  ],
                                                                ),
                                                                content: Text(
                                                                    data.docs[
                                                                            index]
                                                                        [
                                                                        'msg']),
                                                                actions: [
                                                                  FlatButton(
                                                                    textColor:
                                                                        Colors
                                                                            .black,
                                                                    onPressed:
                                                                        () async {
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(widget
                                                                              .grpname)
                                                                          .doc(
                                                                              'chat')
                                                                          .collection(
                                                                              'chat')
                                                                          .doc(data.docs[index]
                                                                              [
                                                                              'chatid'])
                                                                          .delete();
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                      'Delete',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                  ),
                                                                  FlatButton(
                                                                    textColor:
                                                                        Colors
                                                                            .black,
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(context).push(MaterialPageRoute(
                                                                          builder: (context) => Reply(
                                                                                grpname: widget.grpname,
                                                                                chatid: data.docs[index]['chatid'],
                                                                              )));
                                                                    },
                                                                    child: const Text(
                                                                        'Show reply',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.blue)),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ]),
                                            ))
                                          : InkWell(
                                              onTap: () => showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Row(
                                                      children: [
                                                        ClipOval(
                                                          child: Image.network(
                                                            data.docs[index]
                                                                ['profile'],
                                                            fit: BoxFit.cover,
                                                            height: 60,
                                                            width: 60,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 20),
                                                        Text(data.docs[index]
                                                            ['username'])
                                                      ],
                                                    ),
                                                    content: Text(data
                                                        .docs[index]['msg']),
                                                    actions: [
                                                      FlatButton(
                                                        textColor: Colors.black,
                                                        onPressed: () async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(widget
                                                                  .grpname)
                                                              .doc('chat')
                                                              .collection(
                                                                  'chat')
                                                              .doc(data.docs[
                                                                      index]
                                                                  ['chatid'])
                                                              .delete();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ),
                                                      FlatButton(
                                                        textColor: Colors.black,
                                                        onPressed: () {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          Reply(
                                                                            grpname:
                                                                                widget.grpname,
                                                                            chatid:
                                                                                data.docs[index]['chatid'],
                                                                          )));
                                                        },
                                                        child: const Text(
                                                            'Show reply',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue)),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                child: Stack(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    children: [
                                                      Card(
                                                          elevation: 45,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                                data.docs[index]
                                                                    ['msg']),
                                                          )),
                                                    ]),
                                              ),
                                            )
                                    ],
                                  )
                                : Row(
                                    children: [
                                      data.docs[index]['img'] == "1"
                                          ? SwipeTo(
                                              onRightSwipe: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) {
                                                      return Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: EdgeInsets.only(
                                                                      top: 10,
                                                                      left: 10,
                                                                      bottom: MediaQuery.of(
                                                                              context)
                                                                          .viewInsets
                                                                          .bottom),
                                                                  child: Row(
                                                                    children: [
                                                                      Flexible(
                                                                          child: TextFieldInput(
                                                                              hintText: 'reply',
                                                                              textEditingController: _reply,
                                                                              textInputType: TextInputType.name)),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            FirebaseFirestore.instance.collection(widget.grpname).doc('chat').collection('chat').doc(data.docs[index]['chatid']).collection('reply').add({
                                                                              'reply': _reply.text,
                                                                              'username': widget.username,
                                                                              'uid': widget.uid,
                                                                              'photo': widget.photo,
                                                                              'time': DateTime.now(),
                                                                            });
                                                                            _reply.clear();
                                                                          },
                                                                          icon:
                                                                              const Icon(Icons.send)),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Flexible(
                                                            child: StreamBuilder<
                                                                    QuerySnapshot>(
                                                                stream: FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        widget
                                                                            .grpname)
                                                                    .doc('chat')
                                                                    .collection(
                                                                        'chat')
                                                                    .doc(data.docs[
                                                                            index]
                                                                        [
                                                                        'chatid'])
                                                                    .collection(
                                                                        'reply')
                                                                    .orderBy(
                                                                        'time',
                                                                        descending:
                                                                            true)
                                                                    .snapshots(),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  if (snapshot
                                                                          .connectionState ==
                                                                      ConnectionState
                                                                          .waiting) {
                                                                    return const Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          CircularProgressIndicator(),
                                                                    );
                                                                  }
                                                                  if (!snapshot
                                                                      .hasData) {
                                                                    return const Center(
                                                                      child: Text(
                                                                          'no reply'),
                                                                    );
                                                                  }
                                                                  if (snapshot
                                                                      .hasData) {
                                                                    final data =
                                                                        snapshot
                                                                            .requireData;
                                                                    return ListView
                                                                        .builder(
                                                                            itemCount:
                                                                                snapshot.data!.docs.length,
                                                                            itemBuilder: (context, index) {
                                                                              return Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Card(
                                                                                  shape: const RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.all(
                                                                                      Radius.circular(20),
                                                                                    ),
                                                                                    side: BorderSide(width: 2, color: Colors.black),
                                                                                  ),
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: Row(
                                                                                          children: [
                                                                                            CircleAvatar(
                                                                                              backgroundImage: NetworkImage(data.docs[index]['photo']),
                                                                                            ),
                                                                                            const SizedBox(
                                                                                              width: 5,
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                              child: Text(
                                                                                                data.docs[index]['username'],
                                                                                                style: const TextStyle(color: Colors.blue),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Align(
                                                                                        alignment: Alignment.center,
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.only(bottom: 10),
                                                                                          child: Text(
                                                                                            data.docs[index]['reply'],
                                                                                            style: const TextStyle(
                                                                                              letterSpacing: .3,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            });
                                                                  }
                                                                  return const Text(
                                                                      'null');
                                                                }),
                                                          )
                                                        ],
                                                      );
                                                    });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    side: const BorderSide(
                                                        width: 2,
                                                        color: Colors.white),
                                                  ),
                                                  elevation: 20,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.6,
                                                    child: Column(children: [
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: CircleAvatar(
                                                              backgroundImage:
                                                                  NetworkImage(data
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      'profile']),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(data.docs[index]
                                                              ['username']),
                                                        ],
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 5),
                                                          child: Text(
                                                            DateFormat
                                                                    .MMMMEEEEd()
                                                                .format(data
                                                                    .docs[index]
                                                                        [
                                                                        'chattime']
                                                                    .toDate()),
                                                          ),
                                                        ),
                                                      ),
                                                      Image.network(
                                                          data.docs[index]
                                                              ['posturl']),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Text(
                                                          data.docs[index]
                                                              ['msg'],
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    ]),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : SwipeTo(
                                              onRightSwipe: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) {
                                                      return Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: EdgeInsets.only(
                                                                      top: 10,
                                                                      left: 10,
                                                                      bottom: MediaQuery.of(
                                                                              context)
                                                                          .viewInsets
                                                                          .bottom),
                                                                  child: Row(
                                                                    children: [
                                                                      Flexible(
                                                                          child: TextFieldInput(
                                                                              hintText: 'reply',
                                                                              textEditingController: _reply,
                                                                              textInputType: TextInputType.name)),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            FirebaseFirestore.instance.collection(widget.grpname).doc('chat').collection('chat').doc(data.docs[index]['chatid']).collection('reply').add({
                                                                              'reply': _reply.text,
                                                                              'username': widget.username,
                                                                              'uid': widget.uid,
                                                                              'photo': widget.photo,
                                                                              'time': DateTime.now(),
                                                                            });
                                                                            _reply.clear();
                                                                          },
                                                                          icon:
                                                                              const Icon(Icons.send)),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Flexible(
                                                            child: StreamBuilder<
                                                                    QuerySnapshot>(
                                                                stream: FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        widget
                                                                            .grpname)
                                                                    .doc('chat')
                                                                    .collection(
                                                                        'chat')
                                                                    .doc(data.docs[
                                                                            index]
                                                                        [
                                                                        'chatid'])
                                                                    .collection(
                                                                        'reply')
                                                                    .snapshots(),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  if (snapshot
                                                                          .connectionState ==
                                                                      ConnectionState
                                                                          .waiting) {
                                                                    return const Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          CircularProgressIndicator(),
                                                                    );
                                                                  }
                                                                  if (!snapshot
                                                                      .hasData) {
                                                                    return const Center(
                                                                      child: Text(
                                                                          'no reply'),
                                                                    );
                                                                  }
                                                                  if (snapshot
                                                                      .hasData) {
                                                                    final data =
                                                                        snapshot
                                                                            .requireData;
                                                                    return ListView
                                                                        .builder(
                                                                            itemCount:
                                                                                snapshot.data!.docs.length,
                                                                            itemBuilder: (context, index) {
                                                                              return Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Card(
                                                                                  shape: const RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.all(
                                                                                      Radius.circular(20),
                                                                                    ),
                                                                                    side: BorderSide(width: 2, color: Colors.black),
                                                                                  ),
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: Row(
                                                                                          children: [
                                                                                            CircleAvatar(
                                                                                              backgroundImage: NetworkImage(data.docs[index]['photo']),
                                                                                            ),
                                                                                            const SizedBox(
                                                                                              width: 5,
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                              child: Text(
                                                                                                data.docs[index]['username'],
                                                                                                style: const TextStyle(color: Colors.blue),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Align(
                                                                                        alignment: Alignment.center,
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.only(bottom: 10),
                                                                                          child: Text(
                                                                                            data.docs[index]['reply'],
                                                                                            style: const TextStyle(
                                                                                              letterSpacing: .3,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            });
                                                                  }
                                                                  return const Text(
                                                                      'null');
                                                                }),
                                                          )
                                                        ],
                                                      );
                                                    });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    side: const BorderSide(
                                                        width: 2,
                                                        color: Colors.white),
                                                  ),
                                                  elevation: 20,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.5,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        data.docs[index]
                                                                            [
                                                                            'profile']),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(data
                                                                    .docs[index]
                                                                ['username']),
                                                          ],
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 5),
                                                            child: Text(
                                                              DateFormat
                                                                      .MMMMEEEEd()
                                                                  .format(data
                                                                      .docs[
                                                                          index]
                                                                          [
                                                                          'chattime']
                                                                      .toDate()),
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20,
                                                                    bottom: 10,
                                                                    top: 10),
                                                            child: Text(
                                                              data.docs[index]
                                                                  ['msg'],
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )),
                                    ],
                                  )
                          ],
                        );
                      });
                }

                return const Center(child: Text('jd'));
              },
            )));
  }

  _selectimage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('share'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('take photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('take photo from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void send() {
    // String posturl = await StorageMethods()
    //     .uploadImageToStorage(widget.grpname, _file!, true);
    // String postid = const Uuid().v1();

    (_file != null)
        ? withimg()
        : (_chat.text.isEmpty)
            ? Fluttertoast.showToast(msg: 'no message')
            : withoutimg();
  }

  withimg() async {
    String posturl = await StorageMethods()
        .uploadImageToStorage(widget.grpname, _file!, true);
    String postid = const Uuid().v1();
    String chatid = const Uuid().v1();
    FirebaseFirestore.instance
        .collection(widget.grpname)
        .doc('chat')
        .collection('chat')
        .doc(chatid)
        .set({
      'username': widget.username,
      'uid': widget.uid,
      'profile': widget.photo,
      'msg': _chat.text,
      'img': '1',
      'chattime': DateTime.now(),
      'chatid': chatid,
      'posturl': posturl,
      'image': postid,
      'group': widget.grpname
    });
    setState(() {
      _file = null;
      _chat.clear();
    });
  }

  withoutimg() {
    String chatid = const Uuid().v1();
    FirebaseFirestore.instance
        .collection(widget.grpname)
        .doc('chat')
        .collection('chat')
        .doc(chatid)
        .set({
      'username': widget.username,
      'uid': widget.uid,
      'profile': widget.photo,
      'msg': _chat.text,
      'chattime': DateTime.now(),
      'img': '0',
      'chatid': chatid,
      'group': widget.grpname
    });
    _chat.clear();
  }
}
