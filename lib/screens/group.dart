import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'package:share_plus/share_plus.dart';

import 'chat.dart';
import 'individual.dart';
import 'post.dart';
import 'showcomments.dart';

class Group extends StatefulWidget {
  const Group(
      {Key? key,
      required this.uid,
      required this.grpname,
      required this.Name,
      required this.photo})
      : super(key: key);
  final String grpname;
  final String Name, uid;
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
                          if (snapshot.hasData) {
                            final data = snapshot.requireData;

                            return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  // DocumentSnapshot ds = snapshot.data!.docs[];
                                  List count = data.docs[index]['likes'];
                                  List list = [data.docs[index]['username']];
                                  String postid = data.docs[index]['postid'];
                                  bool _like = false;

                                  // Flexible(
                                  //   fit: FlexFit.loose,
                                  //   flex: 1,
                                  //   child: SingleChildScrollView(
                                  //       child: Expanded(
                                  //     child: Container(
                                  //         height: MediaQuery.of(context)
                                  //                 .size
                                  //                 .height /
                                  //             1,
                                  //         width:
                                  //             MediaQuery.of(context).size.width,
                                  //         child: Flexible(
                                  //           flex: 1,
                                  //           fit: FlexFit.loose,
                                  //           child: Column(children: [
                                  //             Row(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment
                                  //                         .spaceBetween,
                                  //                 crossAxisAlignment:
                                  //                     CrossAxisAlignment.start,
                                  //                 children: [
                                  //                   Row(
                                  //                     children: [
                                  //                       Padding(
                                  //                         padding:
                                  //                             const EdgeInsets
                                  //                                     .only(
                                  //                                 left: 5),
                                  //                         child: CircleAvatar(
                                  //                           backgroundImage:
                                  //                               NetworkImage(data
                                  //                                           .docs[
                                  //                                       index][
                                  //                                   'proImage']),
                                  //                         ),
                                  //                       ),
                                  //                       const SizedBox(
                                  //                         width: 20,
                                  //                       ),
                                  //                       Text(
                                  //                         data.docs[index]
                                  //                             ['username'],
                                  //                         style:
                                  //                             const TextStyle(
                                  //                                 fontSize: 16,
                                  //                                 color: Colors
                                  //                                     .blue),
                                  //                       ),
                                  //                       const SizedBox(
                                  //                         width: 5,
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                   Row(
                                  //                       mainAxisAlignment:
                                  //                           MainAxisAlignment
                                  //                               .spaceBetween,
                                  //                       crossAxisAlignment:
                                  //                           CrossAxisAlignment
                                  //                               .end,
                                  //                       children: [
                                  //                         GestureDetector(
                                  //                           onTap: () => (widget
                                  //                                       .uid ==
                                  //                                   data.docs[index]
                                  //                                       ['uid']
                                  //                               ? Fluttertoast.showToast(
                                  //                                   msg: 'likes:' +
                                  //                                       count
                                  //                                           .length
                                  //                                           .toString(),
                                  //                                   textColor:
                                  //                                       Colors
                                  //                                           .blue,
                                  //                                   fontSize:
                                  //                                       18)
                                  //                               : FirebaseFirestore
                                  //                                   .instance
                                  //                                   .collection(
                                  //                                       widget
                                  //                                           .grpname)
                                  //                                   .doc('post')
                                  //                                   .collection(
                                  //                                       widget
                                  //                                           .grpname)
                                  //                                   .doc(data.docs[index]['postid'])
                                  //                                   .update({
                                  //                                   "likes":
                                  //                                       FieldValue
                                  //                                           .arrayRemove([
                                  //                                     widget
                                  //                                         .Name
                                  //                                   ])
                                  //                                 })),
                                  //                           child: (count.contains(
                                  //                                   widget
                                  //                                       .Name))
                                  //                               ? Lottie.asset(
                                  //                                   'assets/like.json',
                                  //                                   height: 50)
                                  //                               : const Padding(
                                  //                                   padding: EdgeInsets.only(
                                  //                                       bottom:
                                  //                                           12),
                                  //                                   child: Icon(
                                  //                                     Icons
                                  //                                         .thumb_up,
                                  //                                   ),
                                  //                                 ),
                                  //                         ),

                                  //                         // IconButton(
                                  //                         //     onPressed: () => Navigator
                                  //                         //         .push(
                                  //                         //             context,
                                  //                         //             (MaterialPageRoute(
                                  //                         //                 builder: (context) =>
                                  //                         //                     Addcomment(
                                  //                         //                       Name: widget.Name,
                                  //                         //                       photo: widget.photo,
                                  //                         //                       postid: postid,
                                  //                         //                       team: widget.grpname,
                                  //                         //                     )))),
                                  //                         //     icon: const Icon(
                                  //                         //         Icons
                                  //                         //             .add_comment)),
                                  //                         IconButton(
                                  //                             onPressed: () => Navigator
                                  //                                 .push(
                                  //                                     context,
                                  //                                     (MaterialPageRoute(
                                  //                                         builder: (context) =>
                                  //                                             Showcomments(
                                  //                                               uid: widget.uid,
                                  //                                               Name: widget.Name,
                                  //                                               photo: widget.photo,
                                  //                                               postid: postid,
                                  //                                               team: widget.grpname,
                                  //                                             )))),
                                  //                             icon: const Icon(Icons
                                  //                                 .comment_rounded))
                                  //                       ]),
                                  //                 ]),
                                  //             Padding(
                                  //               padding:
                                  //                   const EdgeInsets.all(8.0),
                                  //               child: Flexible(
                                  //                   flex: 1,
                                  //                   fit: FlexFit.loose,
                                  //                   child: Align(
                                  //                     alignment:
                                  //                         Alignment.centerLeft,
                                  //                     child: ReadMoreText(
                                  //                       data.docs[index]
                                  //                           ['description'],
                                  //                       moreStyle:
                                  //                           const TextStyle(
                                  //                               fontSize: 16,
                                  //                               letterSpacing:
                                  //                                   .6,
                                  //                               color: Colors
                                  //                                   .blue),
                                  //                       trimLines: 7,
                                  //                       textAlign:
                                  //                           TextAlign.left,
                                  //                       preDataTextStyle:
                                  //                           const TextStyle(
                                  //                               fontWeight:
                                  //                                   FontWeight
                                  //                                       .bold),
                                  //                       style: const TextStyle(
                                  //                           fontSize: 15,
                                  //                           fontWeight:
                                  //                               FontWeight.w400,
                                  //                           color:
                                  //                               Colors.white),
                                  //                       colorClickableText:
                                  //                           Colors.blue,
                                  //                       trimMode: TrimMode.Line,
                                  //                       trimCollapsedText:
                                  //                           '...Show more',
                                  //                       trimExpandedText:
                                  //                           ' show less',
                                  //                     ),
                                  //                   )),
                                  //             ),
                                  //             GestureDetector(
                                  //               onDoubleTap: () async {
                                  //                 {
                                  //                   FirebaseFirestore.instance
                                  //                       .collection(
                                  //                           widget.grpname)
                                  //                       .doc('post')
                                  //                       .collection(
                                  //                           widget.grpname)
                                  //                       .doc(data.docs[index]
                                  //                           ['postid'])
                                  //                       .update({
                                  //                     "likes":
                                  //                         FieldValue.arrayUnion(
                                  //                             [widget.Name])
                                  //                   });
                                  //                 }

                                  //                 // print(data.docs[index]['likes']
                                  //                 //     .length);
                                  //               },
                                  //               child: AspectRatio(
                                  //                 aspectRatio: 16 / 9,
                                  //                 child: Image.network(
                                  //                   data.docs[index]['posturl'],
                                  //                   fit: BoxFit.fitHeight,
                                  //                   filterQuality:
                                  //                       FilterQuality.high,
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //             Padding(
                                  //               padding: const EdgeInsets.only(
                                  //                   top: 5),
                                  //               child: Row(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment.end,
                                  //                 crossAxisAlignment:
                                  //                     CrossAxisAlignment.end,
                                  //                 children: [
                                  //                   Text(
                                  //                     DateFormat.yMMMd().format(
                                  //                         data.docs[index]
                                  //                                 ['dateposted']
                                  //                             .toDate()),
                                  //                     style: const TextStyle(
                                  //                         fontSize: 16,
                                  //                         color: Colors
                                  //                             .lightBlueAccent),
                                  //                   ),
                                  //                   const SizedBox(
                                  //                     width: 20,
                                  //                   ),
                                  //                   const Text(
                                  //                     'about:',
                                  //                     style: TextStyle(
                                  //                       fontSize: 16,
                                  //                     ),
                                  //                   ),
                                  //                   const SizedBox(
                                  //                     width: 10,
                                  //                   ),
                                  //                   Text(
                                  //                     data.docs[index]['blog'],
                                  //                     style: const TextStyle(
                                  //                         fontSize: 16,
                                  //                         letterSpacing: .5,
                                  //                         color: Colors.blue),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //           ]),
                                  //         )),
                                  //   )),
                                  // );
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
                                              )
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
                                                            style:
                                                                const TextStyle(
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
//GestureDetector(
//                                                                                                           onDoubleTap: () => FirebaseFirestore.instance.collection(_r).doc(data.docs[index]['postid']).collection('comments').add({'comment': 'hi emma watson'}),
//                                                                                                           child: GestureDetector(
//                                                                                                             onDoubleTap: () async {
//                                                                                                               (_liked = !_liked)
//                                                                                                                   ? {
//                                                                                                                       FirebaseFirestore.instance.collection(_r).doc(data.docs[index]['postid']).update({
//                                                                                                                         "likes": FieldValue.arrayUnion([Name])
//                                                                                                                       }),
//                                                                                                                     }
//                                                                                                                   : FirebaseFirestore.instance.collection(_r).doc(data.docs[index]['postid']).update({
//                                                                                                                       "likes": FieldValue.arrayRemove([Name])
//                                                                                                                     });

//                                                                                                               print(data.docs[index]['likes'].length);
//                                                                                                             },
//                                                                                                             child: Card(
//                                                                                                               color: Colors.black,
//                                                                                                               elevation: 54,
//                                                                                                               child: Container(
//                                                                                                                 color: Colors.grey[900],
//                                                                                                                 height: MediaQuery.of(context).size.height / 1.8,
//                                                                                                                 width: MediaQuery.of(context).size.width / 1,
//                                                                                                                 child: Image.network(data.docs[index]['posturl']),
//                                                                                                               ),
//                                                                                                             ),
//                                                                                                           )),
//                                                                                                       Padding(
//                                                                                                         padding: const EdgeInsets.all(8.0),
//                                                                                                         child: Flexible(
//                                                                                                             flex: 1,
//                                                                                                             fit: FlexFit.loose,
//                                                                                                             child: Container(
//                                                                                                               height: 150,
//                                                                                                               width: double.infinity,
//                                                                                                               child: ReadMoreText(
//                                                                                                                 data.docs[index]['description'],
//                                                                                                                 moreStyle: const TextStyle(fontSize: 12, color: Colors.blue),
//                                                                                                                 trimLines: 3,
//                                                                                                                 textAlign: TextAlign.left,
//                                                                                                                 preDataTextStyle: const TextStyle(fontWeight: FontWeight.bold),
//                                                                                                                 style: const TextStyle(color: Colors.white),
//                                                                                                                 colorClickableText: Colors.blue,
//                                                                                                                 trimMode: TrimMode.Line,
//                                                                                                                 trimCollapsedText: '...Show more',
//                                                                                                                 trimExpandedText: ' show less',
//                                                                                                               ),
//                                                                                                               //  Text(
//                                                                                                               //   data.docs[index]['description'],
//                                                                                                               //   style: const TextStyle(fontSize: 14),
//                                                                                                               // )
//                                                                                                             )),
//                                                                                                       ),
//                                                                                                     ]),
//                                                                                                   ),
//                                                                                                 ),
//                                                                                               ]),
//                                                                                             );
//                                                                                           },
//                                                                                         ),
//                                                                                       );
