import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Adminmaintain extends StatefulWidget {
  const Adminmaintain({Key? key, required this.grp}) : super(key: key);
  final String grp;
  @override
  State<Adminmaintain> createState() => _AdminmaintainState();
}

class _AdminmaintainState extends State<Adminmaintain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 1,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(widget.grp)
                    .doc(widget.grp)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Error Occured");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;

                    List accept = data['request'];
                    for (var users in accept) {
                      return ListView.builder(
                          itemCount: 1,
                          itemBuilder: (BuildContext context, snapshot) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Center(
                                    child: Text(
                                  users,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            );
                          });
                    }
                  }
                  return const Text('data');
                })));
  }
}
