import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Reply extends StatefulWidget {
  const Reply({Key? key, required this.chatid, required this.grpname})
      : super(key: key);
  final String chatid, grpname;
  @override
  State<Reply> createState() => _ReplyState();
}

class _ReplyState extends State<Reply> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(widget.grpname)
                      .doc('chat')
                      .collection('chat')
                      .doc(widget.chatid)
                      .collection('reply')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text('no reply'),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Text('error');
                    }
                    if (snapshot.hasData) {
                      final data = snapshot.requireData;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'replies',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        side: BorderSide(
                                            width: 2, color: Colors.black),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                // CircleAvatar(
                                                //   backgroundImage: NetworkImage(
                                                //       data.docs[index]['photo']),
                                                // ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    data.docs[index]
                                                        ['username'],
                                                    style: const TextStyle(
                                                        color: Colors.blue),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, bottom: 10),
                                            child: Text(
                                              data.docs[index]['reply'],
                                              style: const TextStyle(
                                                letterSpacing: .3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      );
                    }
                    return const Text('null');
                  })),
        ),
      ),
    );
  }
}
