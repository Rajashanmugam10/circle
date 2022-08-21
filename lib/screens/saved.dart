import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'expand.dart';

class Saved extends StatefulWidget {
  const Saved({Key? key}) : super(key: key);

  @override
  State<Saved> createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('saved'),
        centerTitle: true,
      ),
      body: Center(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('saved')
                .orderBy('savedtime', descending: true)
                .snapshots(),
            builder:
                ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Column(
                  children: [
                    Lottie.asset('assets/bookmark.json'),
                    const Text('No Bookmarks')
                  ],
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final data = snapshot.requireData;
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Expand(
                                    postedby: data.docs[index]['postedby'],
                                    postuser: data.docs[index]['photo'],
                                    blog: data.docs[index]['blog'],
                                    photo: data.docs[index]['photourl'],
                                    discription: data.docs[index]
                                        ['description'],
                                  ))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(86, 104, 91, 91),
                                blurRadius: 10.0,
                              ),
                            ],
                          ),
                          height: MediaQuery.of(context).size.height / 3,
                          width: 300,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Hero(
                                    tag: data.docs[index]['photourl'],
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Image.network(
                                        data.docs[index]['photourl'],
                                        height:
                                            MediaQuery.of(context).size.height /
                                                3,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.5,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(right: 30),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'blog: ${data.docs[index]['blog']}',
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            'group: ${data.docs[index]['group']}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            'posted by ${data.docs[index]['postedby']}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            'saved time: ${DateFormat.yMMMd().format(data.docs[index]['savedtime'].toDate())}',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Text('tap the image to read '),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection('users')
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser!.uid)
                                                      .collection('saved')
                                                      .doc(data.docs[index]
                                                          ['saveid'])
                                                      .delete();
                                                  Fluttertoast.showToast(
                                                      msg: 'removed');
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                  size: 16,
                                                )),
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            })),
      ),
    );
  }
}
