import 'package:circle/screens/saved.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expendable_fab/expendable_fab.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:quds_popup_menu/quds_popup_menu.dart';

import 'addin.dart';
import 'admin.dart';
import 'community.dart';
import 'group.dart';
import 'privatechat.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _text = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Column(children: [
              Flexible(
                child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                        List<QudsPopupMenuBase> getMenuItems() {
                          return [
                            QudsPopupMenuSection(
                                titleText: 'profile',
                                subTitle: const Text('See your profile'),
                                leading: const Icon(
                                  Icons.account_box,
                                  size: 40,
                                ),
                                subItems: [
                                  QudsPopupMenuItem(
                                      title: Image.network(data['photourl']),
                                      onPressed: () {}),
                                  QudsPopupMenuItem(
                                      title: Text(data['username']),
                                      onPressed: () {
                                        Fluttertoast.showToast(
                                            msg: 'hi' " " + data['username']);
                                      }),
                                  QudsPopupMenuItem(
                                      title: Text(data['email']),
                                      onPressed: () {}),
                                  QudsPopupMenuItem(
                                      title: Text(data['uid']),
                                      onPressed: () {
                                        Fluttertoast.showToast(
                                            msg: 'this is your uid' " " +
                                                data['uid']);
                                      }),
                                ]),
                            QudsPopupMenuDivider(),
                            QudsPopupMenuItem(
                                title: const Text(
                                  'Logout',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                }),
                            QudsPopupMenuItem(
                                title: const Text(
                                  'Delete account',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('delete users')
                                      .add({
                                    'username': data['username'],
                                    'uid': data['uid']
                                  });
                                  Fluttertoast.showToast(
                                      msg: 'account will be delete in 2 days');
                                }),
                            QudsPopupMenuDivider(),
                          ];
                        }

                        String Name = '${data['username']}';
                        String photo = '${data['photourl']}';
                        List<String> pointlist = ['${data['group']}'];
                        List v = data['group'];
                        String uid = '${data['uid']}';
                        // var i;
                        // for (i = 0; i < v.length; i++) {
                        //   print(v[i]);
                        // }
                        print(v);
                        Map map = v.asMap();
                        // print(map.values.toList());
                        // print(map[0]);
                        // print(map[1]);

                        return Container(
                            height: double.infinity,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text(map.length.toString()),

                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    height:
                                        MediaQuery.of(context).size.height / 1,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              QudsPopupButton(
                                                // backgroundColor: Colors.red,
                                                tooltip: 'T',
                                                items: getMenuItems(),
                                                child: ClipOval(
                                                  child: Image.network(
                                                    '${data['photourl']}',
                                                    fit: BoxFit.cover,
                                                    height: 60,
                                                    width: 60,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      TextButton.icon(
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            Community(
                                                                              photo: photo,
                                                                              username: Name,
                                                                            )));
                                                          },
                                                          icon: const Icon(
                                                              Icons.search),
                                                          label: const Text(
                                                            'create ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              Row(
                                                children: [
                                                  TextButton.icon(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const Raja()));
                                                      },
                                                      icon: const Icon(Icons
                                                          .admin_panel_settings_rounded),
                                                      label: const Text(
                                                        'admin',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                  TextButton.icon(
                                                      onPressed: () async {
                                                        await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Addin(
                                                                          name:
                                                                              Name,
                                                                          list: [
                                                                            data['group']
                                                                          ],
                                                                        )));
                                                      },
                                                      icon: const Icon(
                                                          Icons.search),
                                                      label: const Text(
                                                        'add ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  (v.isEmpty)
                                      ? Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              1,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Lottie.asset('assets/grp.json'),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              const Text(
                                                'no groups',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        )
                                      : Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(children: [
                                              Expanded(
                                                child: Container(
                                                  child: ListView.builder(
                                                      itemCount: map.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        // last edited
                                                        return GestureDetector(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 15),
                                                            child: Container(
                                                              height: 80,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                color: Colors
                                                                    .lightBlue,
                                                              ),
                                                              child: Center(
                                                                  child: Text(v[
                                                                          index]
                                                                      .toString())),
                                                            ),
                                                          ),
                                                          onLongPress: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return Center(
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          MediaQuery.of(context).size.height /
                                                                              5,
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          1.1,
                                                                      child: Column(
                                                                          children: [
                                                                            const Text('''are you sure to delete this group click delete icon'''),
                                                                            const SizedBox(
                                                                              height: 20,
                                                                            ),
                                                                            GestureDetector(
                                                                                child: const Icon(
                                                                                  Icons.delete_forever,
                                                                                  size: 30,
                                                                                ),
                                                                                onTap: () {
                                                                                  Fluttertoast.showToast(msg: 'contact your admin, if he/she denied your request circle will remove you within 2days');
                                                                                  FirebaseFirestore.instance.collection('delete').add({
                                                                                    'username': data['username'],
                                                                                    'uid': data['uid'],
                                                                                    'groupname': v[index].toString(),
                                                                                    'requestdate': DateTime.now()
                                                                                  });
                                                                                })
                                                                          ]),
                                                                    ),
                                                                  );
                                                                });
                                                          },
                                                          onTap: () async {
                                                            String _r =
                                                                v[index];
                                                            print(_r);
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            Group(
                                                                              saved: data['saved'],
                                                                              friends: data['friends request'],
                                                                              uid: uid,
                                                                              grpname: _r,
                                                                              Name: Name,
                                                                              photo: photo,
                                                                            )));
//
                                                          },
                                                        );
                                                      }),
                                                ),
                                              ),
                                            ]),
                                          ),
                                        )
                                ]));
                      }
                      return const Text(
                        "something",
                        style: TextStyle(color: Colors.white),
                      );
                    }),
              ),
            ]),
            floatingActionButton: FabCircularMenu(
                fabOpenIcon: const Icon(
                  Icons.view_agenda_rounded,
                  color: Colors.white,
                ),
                ringWidth: 50,
                ringColor: Colors.lightBlue,
                fabCloseColor: Colors.blue,
                fabOpenColor: Colors.red,
                animationDuration: const Duration(milliseconds: 400),
                ringDiameter: 300,
                alignment: Alignment.bottomRight,
                animationCurve: Curves.easeInQuad,
                children: <Widget>[
                  IconButton(
                      icon: const Icon(
                        Icons.update,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        showAboutDialog(
                            context: context,
                            children: [const Text('update will show here')],
                            applicationIcon: Image.asset(
                              'assets/2b55.png',
                              height: 70,
                            ),
                            applicationName: 'circle');
                        Fluttertoast.showToast(msg: 'update detials');
                      }),
                  IconButton(
                      icon: const Icon(
                        Icons.chat,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const PrivateChat()));
                      }),
                  IconButton(
                      icon: const Icon(
                        Icons.bookmark,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Saved()));
                      }),
                ])));
  }
}
