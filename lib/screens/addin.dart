import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Addin extends StatefulWidget {
  final String name;
  final List list;
  const Addin({
    Key? key,
    required this.name,
    required this.list,
  }) : super(key: key);

  @override
  State<Addin> createState() => _AddinState();
}

class _AddinState extends State<Addin> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 70,
              child: Center(
                child: Text(widget.name),
              ),
            ),
            Flexible(
                child: Container(
              height: 600,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('circle')
                      .doc('grp')
                      .collection('collection')
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
                    if (snapshot.hasData) {
                      for (var i in widget.list);
                      final data = snapshot.requireData;

                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            List list = data.docs[index]['request'];
                            return Container(
                                height: 100,
                                child: Card(
                                  color: Colors.blueGrey,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Text(data.docs[index]['name']),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: MaterialButton(
                                              color: (list.contains(FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid))
                                                  ? Colors.red
                                                  : Colors.blue,
                                              onPressed: () async {
                                                await FirebaseFirestore.instance
                                                    .collection('circle')
                                                    .doc('grp')
                                                    .collection('collection')
                                                    .doc(data.docs[index]
                                                        ['name'])
                                                    .update({
                                                  'request':
                                                      FieldValue.arrayUnion([
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid
                                                  ])
                                                });
                                                await FirebaseFirestore.instance
                                                    .collection(data.docs[index]
                                                        ['name'])
                                                    .doc(data.docs[index]
                                                        ['name'])
                                                    .update({
                                                  'request':
                                                      FieldValue.arrayUnion([
                                                    FirebaseAuth.instance
                                                            .currentUser!.uid +
                                                        "  " +
                                                        widget.name
                                                  ])
                                                });

                                                Fluttertoast.showToast(
                                                    msg: 'request is send');
                                              },
                                              child: const Text('request')),
                                        )
                                      ]),
                                ));
                          });
                    }
                    return const Text('jbhb');
                  }),
            ))
          ],
        ),
      ),
    );
  }
}
