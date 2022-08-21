import 'package:circle/screens/saved.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import 'chat.dart';
import 'individual.dart';
import 'post.dart';
import 'showcomments.dart';

class Group extends StatefulWidget {
  Group(
      {Key? key,
      required this.saved,
      required this.friends,
      required this.uid,
      required this.grpname,
      required this.Name,
      required this.photo})
      : super(key: key);
  final String grpname;
  final String Name, uid;
  List friends, saved;
  final String photo;
  @override
  State<Group> createState() => _GroupState();
}

class _GroupState extends State<Group> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Individualgroup(
                                        grpname: widget.grpname,
                                      )));
                            },
                            child: Text(
                              widget.grpname,
                              style: const TextStyle(fontSize: 15),
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Chat(
                                        grpname: widget.grpname,
                                        uid: FirebaseAuth
                                            .instance.currentUser!.uid,
                                        photo: widget.photo,
                                        username: widget.Name,
                                      )));
                            },
                            child: const Text(
                              'Chat',
                              style: TextStyle(fontSize: 15),
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Post(
                                        grpname: widget.grpname,
                                      )));
                            },
                            child: const Text(
                              'Post',
                              style: TextStyle(fontSize: 15),
                            )),
                      ],
                    ),
                  ),
                  Flexible(
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection(widget.grpname)
                            .doc('post')
                            .collection(widget.grpname)
                            .orderBy('dateposted', descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text("Error Occured");
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset('assets/blog.json',
                                    height:
                                        MediaQuery.of(context).size.height / 2),
                                const Text(
                                  'no post',
                                ),
                              ],
                            );
                          }
                          if (snapshot.hasData) {
                            final data = snapshot.requireData;

                            return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  // DocumentSnapshot ds = snapshot.data!.docs[];
                                  List count = data.docs[index]['likes'];
                                  String saveid = const Uuid().v1();
                                  List list = [data.docs[index]['username']];
                                  String postid = data.docs[index]['postid'];
                                  bool _like = false;

                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Row(
                                            children: [
                                              const Text(
                                                'blog:',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                data.docs[index]['blog'],
                                                style: const TextStyle(
                                                    // color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              (FirebaseAuth.instance
                                                          .currentUser!.uid ==
                                                      data.docs[index]['uid'])
                                                  ? IconButton(
                                                      onPressed: () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                widget.grpname)
                                                            .doc('post')
                                                            .collection(
                                                                widget.grpname)
                                                            .doc(
                                                                data.docs[index]
                                                                    ['postid'])
                                                            .delete();
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'post deleted');
                                                      },
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ))
                                                  : (widget.saved
                                                          .contains(saveid))
                                                      ? const Text('data')
                                                      : TextButton.icon(
                                                          onPressed: () {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)
                                                                .update({
                                                              'saved': FieldValue
                                                                  .arrayUnion(
                                                                      [saveid])
                                                            });

                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)
                                                                .collection(
                                                                    'saved')
                                                                .doc(saveid)
                                                                .set({
                                                              'photourl': data
                                                                          .docs[
                                                                      index]
                                                                  ['posturl'],
                                                              'group': widget
                                                                  .grpname,
                                                              'saveid': saveid,
                                                              'blog': data.docs[
                                                                      index]
                                                                  ['blog'],
                                                              'description': data
                                                                          .docs[
                                                                      index][
                                                                  'description'],
                                                              'savedtime':
                                                                  DateTime
                                                                      .now(),
                                                              'postedby': data
                                                                          .docs[
                                                                      index]
                                                                  ['username'],
                                                              'photo': data
                                                                          .docs[
                                                                      index]
                                                                  ['proImage']
                                                            });
                                                            Fluttertoast
                                                                .showToast(
                                                                    msg:
                                                                        'saved');
                                                          },
                                                          icon: const Icon(
                                                              Icons.save),
                                                          label: const Text(
                                                              'save')),
                                              (FirebaseAuth.instance
                                                          .currentUser!.uid ==
                                                      data.docs[index]['uid'])
                                                  ? (const Text('circle'))
                                                  : (IconButton(
                                                      onPressed: () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(
                                                                data.docs[index]
                                                                    ['uid'])
                                                            .collection(
                                                                'friends')
                                                            .doc(FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid)
                                                            .set({
                                                          'uid': FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid,
                                                          'username':
                                                              widget.Name,
                                                          'photo': widget.photo,
                                                          'group':
                                                              widget.grpname,
                                                          "rname":
                                                              data.docs[index]
                                                                  ['username'],
                                                          "ruid":
                                                              data.docs[index]
                                                                  ['uid'],
                                                          'rphoto':
                                                              data.docs[index]
                                                                  ['proImage']
                                                        });
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(
                                                                data.docs[index]
                                                                    ['uid'])
                                                            .update({
                                                          'friends request':
                                                              FieldValue
                                                                  .arrayUnion([
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid
                                                          ])
                                                        });
                                                        // String requestid =
                                                        //     const Uuid().v1();

                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'friend request sent');
                                                      },
                                                      icon: const Icon(
                                                        Icons.people,
                                                        color: Colors.blue,
                                                      ),
                                                    ))
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            bool like = true;
                                            (_like = !_like)
                                                ? {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            widget.grpname)
                                                        .doc('post')
                                                        .collection(
                                                            widget.grpname)
                                                        .doc(data.docs[index]
                                                            ['postid'])
                                                        .update({
                                                      "likes":
                                                          FieldValue.arrayUnion(
                                                              [widget.Name])
                                                    }),
                                                    print('added')
                                                  }
                                                : {
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            widget.grpname)
                                                        .doc('post')
                                                        .collection(
                                                            widget.grpname)
                                                        .doc(data.docs[index]
                                                            ['postid'])
                                                        .update({
                                                      "likes": FieldValue
                                                          .arrayRemove(
                                                              [widget.Name])
                                                    }),
                                                    print('removed')
                                                  };
                                          },
                                          child: Card(
                                            elevation: 30,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20)),
                                              side: BorderSide(
                                                  width: 2,
                                                  color: Colors.black),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              child: SingleChildScrollView(
                                                child: Column(children: [
                                                  Stack(children: [
                                                    Image.network(
                                                      data.docs[index]
                                                          ['posturl'],
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      height: 350,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              top: 10),
                                                      child: Text(
                                                        DateFormat.yMMMd()
                                                            .format(data
                                                                .docs[index][
                                                                    'dateposted']
                                                                .toDate()),
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ]),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    child: ExpansionTile(
                                                      title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              CircleAvatar(
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        data.docs[index]
                                                                            [
                                                                            'proImage']),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Column(
                                                                children: [
                                                                  Text(
                                                                    data.docs[
                                                                            index]
                                                                        [
                                                                        'username'],
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          // Text(data.docs[index]
                                                          //     ['blog']),
                                                          Row(
                                                            children: [
                                                              (count.contains(
                                                                      widget
                                                                          .Name))
                                                                  ? Lottie.asset(
                                                                      'assets/like.json',
                                                                      height:
                                                                          50)
                                                                  : Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          bottom:
                                                                              2),
                                                                      child: IconButton(
                                                                          onPressed: () =>
                                                                              Fluttertoast.showToast(msg: 'Tap for like, doubleTap for unlike'),
                                                                          icon: const Icon(Icons.thumbs_up_down))),
                                                              IconButton(
                                                                  onPressed: () => Navigator
                                                                      .push(
                                                                          context,
                                                                          (MaterialPageRoute(
                                                                              builder: (context) =>
                                                                                  Showcomments(
                                                                                    uid: widget.uid,
                                                                                    Name: widget.Name,
                                                                                    photo: widget.photo,
                                                                                    postid: postid,
                                                                                    team: widget.grpname,
                                                                                  )))),
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .comment_rounded)),
                                                              IconButton(
                                                                  tooltip:
                                                                      'share',
                                                                  onPressed:
                                                                      () async {
                                                                    await Share.share(
                                                                        '${data.docs[index]['description']} + Posted by ${data.docs[index]['username']}',
                                                                        subject:
                                                                            ' blog :  ${data.docs[index]['blog']} posted by ${data.docs[index]['username']}');
                                                                  },
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .share_sharp))
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            data.docs[index]
                                                                ['description'],
                                                            textAlign: TextAlign
                                                                .justify,
                                                            style:
                                                                const TextStyle(
                                                                    wordSpacing:
                                                                        1.0,
                                                                    letterSpacing:
                                                                        .4),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 50,
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          }
                          return const Text('jbhb');
                        }),
                  ),
                ],
              ))),
    );
  }
}
