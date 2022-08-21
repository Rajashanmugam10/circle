import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';

import '../services/firestore.dart';
import '../services/profile_pic.dart';

class Post extends StatefulWidget {
  const Post({Key? key, required this.grpname}) : super(key: key);
  final String grpname;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  Uint8List? _file;
  final TextEditingController _decprtioncontroller = TextEditingController();
  final TextEditingController _blog = TextEditingController();
  bool isloading = false;

  //TO GET CURRENT USER " SINGLE DATA AS SNAPSHOT"
  late DocumentSnapshot snapshot;
  void getData() async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    snapshot = data;
  }

  // String name = "Technology";
  void postimage() async {
    setState(() {
      isloading = true;
    });
    try {
      String res = await FirestoreMethods().uploadpost(
        _decprtioncontroller.text,
        _file!,
        snapshot.get('uid').toString(),
        _blog.text,
        snapshot.get('username').toString(),
        snapshot.get('photourl').toString(),
        widget.grpname,
      );

      if (res == "Success") {
        setState(() {
          isloading = false;
        });
        showSnackBar("posted ", context);
        Navigator.pop(context);
      } else {
        setState(() {
          isloading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  _selectimage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create post'),
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

  @override
  void dispose() {
    super.dispose();
    _decprtioncontroller.dispose();
  }

  String dropdownvalue = 'select group';

  @override
  Widget build(BuildContext context) {
    getData();

    return Scaffold(
        appBar: AppBar(
          title: Text('post in ' + widget.grpname),
          actions: [
            IconButton(
                icon: const Icon(Icons.upload),
                onPressed: () => (_blog.text.isEmpty ||
                        _decprtioncontroller.text.isEmpty)
                    ? Fluttertoast.showToast(msg: 'blog and message are empty')
                    : postimage()),
          ],
        ),
        body: _file != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  isloading
                      ? const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: CircularProgressIndicator(),
                        )
                      : Container(),
                  Container(
                    height: 200,
                    width: double.infinity,
                    child: Image(
                      image: MemoryImage(_file!),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _blog,
                      decoration: const InputDecoration(
                          hintText: "blog name", border: InputBorder.none),
                      maxLines: 1,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _decprtioncontroller,
                        decoration: const InputDecoration(
                            hintText: "add message", border: InputBorder.none),
                        maxLines: null,
                        expands: true,
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: GestureDetector(
                  child: const Icon(Icons.upload_file),
                  onTap: () => _selectimage(context),
                ),
              ));
  }
}
