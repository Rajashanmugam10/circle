import 'package:circle/tools/test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Individualgroup extends StatefulWidget {
  const Individualgroup({Key? key, required this.grpname}) : super(key: key);
  final String grpname;
  @override
  State<Individualgroup> createState() => _IndividualgroupState();
}

TextEditingController _search = TextEditingController();

class _IndividualgroupState extends State<Individualgroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            const Text('About'),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.grpname,
              style: const TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height / 1,
          width: double.infinity,
          child: Column(children: [
            Container(
              height: MediaQuery.of(context).size.height / 1,
              width: double.infinity,
              child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(widget.grpname)
                      .doc(widget.grpname)
                      .snapshots(),
                  builder:
                      ((context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      List request = data['request'];
                      List following = data['users'];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 1,
                          width: double.infinity,
                          child: Column(children: [
                            Container(
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.blue,
                                      blurRadius: 10.0,
                                    ),
                                  ],
                                  color: Colors.white38,
                                  borderRadius: BorderRadius.circular(10)),
                              width: MediaQuery.of(context).size.width / 1,
                              height: MediaQuery.of(context).size.height / 4,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, left: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'admin:',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                data['createdby'],
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'created on:',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                DateFormat.MMMMEEEEd().format(
                                                  data['created'].toDate(),
                                                ),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                        (FirebaseAuth.instance.currentUser!.uid
                                                    .toString() ==
                                                data['uid'])
                                            ? TextButton.icon(
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          'delete group')
                                                      .add({
                                                    'admin': data['createdby'],
                                                    'uid': data['uid'],
                                                    'group name':
                                                        data['group name']
                                                  });
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'group will be delete within 2 days');
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                label: const Text(
                                                  'Delete group',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ))
                                            : const Text(
                                                'special access for admin ',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold))
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: ClipOval(
                                            child: Image.network(
                                              data['admin'],
                                              fit: BoxFit.cover,
                                              height: 80,
                                              width: 80,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'request users',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 17,
                                    ),
                                    Text(
                                      (request.length).toString(),
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      'following users',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      (following.length).toString(),
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'followers',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                    onPressed: () => showBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2,
                                            child: Column(children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextFieldInput(
                                                    textEditingController:
                                                        _search,
                                                    hintText: 'search user',
                                                    textInputType:
                                                        TextInputType.name),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Text((following
                                                      .contains(_search.text))
                                                  ? 'yes ${_search.text} is here '
                                                  : 'no ${_search.text} is not here '),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              const Text(
                                                  'Searching users is in developing stage!')
                                            ]),
                                          );
                                        }),
                                    icon: const Icon(Icons.search))
                              ],
                            ),
                            Flexible(
                              child: ListView.builder(
                                  itemCount: following.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: GestureDetector(
                                        onTap: () => showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                    "Are you want to remove  ${following[index]}"),
                                                actions: [
                                                  MaterialButton(
                                                    onPressed: () {
                                                      (FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid ==
                                                              data['uid'])
                                                          ? {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      widget
                                                                          .grpname)
                                                                  .doc(widget
                                                                      .grpname)
                                                                  .update({
                                                                'request':
                                                                    FieldValue
                                                                        .arrayRemove([
                                                                  {
                                                                    following[
                                                                        index]
                                                                  }
                                                                ])
                                                              }),
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      widget
                                                                          .grpname)
                                                                  .doc(widget
                                                                      .grpname)
                                                                  .update({
                                                                'users': FieldValue
                                                                    .arrayRemove([
                                                                  following[
                                                                      index]
                                                                ])
                                                              }),
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'users')
                                                                  .doc(FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid)
                                                                  .update({
                                                                'group': FieldValue
                                                                    .arrayRemove([
                                                                  widget.grpname
                                                                ])
                                                              }),
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'deleted the request '),
                                                            }
                                                          : (Fluttertoast.showToast(
                                                              msg:
                                                                  'your are not admin'));
                                                    },
                                                    child: const Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  )
                                                ],
                                              );
                                            }),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          height: 70,
                                          child: Center(
                                            child: Text(
                                              '${following[index]}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ]),
                        ),
                      );
                    }
                    return const Text('testing');
                  })),
            )
          ]),
        ),
      ),
    );
  }

  // search() async {
  //   StreamBuilder<DocumentSnapshot>(
  //       stream: FirebaseFirestore.instance
  //           .collection(widget.grpname)
  //           .doc(widget.grpname)
  //           .snapshots(),
  //       builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(
  //             child: CircularProgressIndicator(),
  //           );

  //         }
  //       if(snapshot.hasData){

  //         Map<String, dynamic> data =
  //                     snapshot.data!.data() as Map<String, dynamic>;
  //                     return Center(child:(_search.text)?Text(data):Text("data"),);
  //       }
  //       });

}
