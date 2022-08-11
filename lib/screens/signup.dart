import 'dart:typed_data';

import 'package:circle/screens/homepage.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';

import '../services/auth_methods.dart';
import '../services/profile_pic.dart';
import '../tools/test.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key, required this.email}) : super(key: key);
  final String email;
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  final TextEditingController _usernamecontroller = TextEditingController();

  Uint8List? _image;
  bool _isloading = false;
  @override
  void dispose() {
    super.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();

    _usernamecontroller.dispose();
  }

  void SelectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signupuser() async {
    setState(() {
      _isloading = true;
    });
    (_emailcontroller.value.text == widget.email)
        ? {
            (_emailcontroller.value.text.isNotEmpty &&
                    _passwordcontroller.value.text.isNotEmpty &&
                    _image!.isNotEmpty)
                ? {
                    await AuthMethods().signUpUser(
                      email: _emailcontroller.text,
                      password: _passwordcontroller.text,
                      username: _usernamecontroller.text,
                      file: _image!,
                    ),
                    // setState(() {
                    //   _isloading = false;
                    // });
                    setState(() {
                      _isloading = false;
                    }),

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                        (route) => false),
                    // Navigator.pushAndRemoveUntil(MaterialPageRoute(
                    //     builder: (context) => const HomePage())),
                    Fluttertoast.showToast(msg: 'account is created,welcome'),
                  }
                : Fluttertoast.showToast(msg: 'fill all entries')
          }
        : Fluttertoast.showToast(msg: 'email must be same');
    setState(() {
      _isloading = false;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Flexible(
              child: Container(),
              flex: 2,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/2b55.png',
                  color: Colors.red,
                  height: 190,
                ),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 55, backgroundImage: MemoryImage(_image!))
                        : const CircleAvatar(
                            radius: 55,
                            backgroundImage: NetworkImage(
                                "https://images.app.goo.gl/A93hxt3UvYAAiz5J6")),
                    Positioned(
                        bottom: -10,
                        left: 45,
                        child: IconButton(
                            onPressed: () => SelectImage(),
                            icon: const Icon(
                              Icons.add_a_photo,
                            )))
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            TextFieldInput(
                textEditingController: _emailcontroller,
                hintText: "EMAIL",
                textInputType: TextInputType.emailAddress),
            const SizedBox(
              height: 20,
            ),
            TextFieldInput(
              textEditingController: _passwordcontroller,
              hintText: "enter your password",
              textInputType: TextInputType.text,
              isPass: true,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFieldInput(
                textEditingController: _usernamecontroller,
                hintText: "Username",
                textInputType: TextInputType.text),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
                onTap: () => signupuser(),
                child: Container(
                  child: _isloading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text("Sign-up"),
                  width: 200,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.red),
                )),
            const SizedBox(
              height: 12,
            ),
            Flexible(
              child: Container(),
              flex: 2,
            )
          ]),
        ),
      ),
    );
  }
}
