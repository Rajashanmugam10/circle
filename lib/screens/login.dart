import 'package:circle/screens/homepage.dart';
import 'package:circle/screens/otp.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../services/auth_methods.dart';
import '../services/profile_pic.dart';
import '../tools/test.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
  }

  void login() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().login(
        email: _emailcontroller.text, password: _passwordcontroller.text);
    if (res == 'Success') {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(res, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 1,
              ),
              Container(
                height: 200,
                width: 200,
                child: Image.asset(
                  'assets/2b55.png',
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFieldInput(
                  textEditingController: _emailcontroller,
                  hintText: "enter your mail",
                  textInputType: TextInputType.emailAddress),
              const SizedBox(
                height: 36,
              ),
              TextFieldInput(
                textEditingController: _passwordcontroller,
                hintText: "enter your passcode",
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: InkWell(
                  onTap: () async {
                    (_emailcontroller.text.isNotEmpty)
                        ? {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                                email: _emailcontroller.text),
                            Fluttertoast.showToast(
                                msg: 'password reset link will send to email '),
                          }
                        : Fluttertoast.showToast(msg: 'enter the email id');
                  },
                  child: const Text(
                    'forgot password',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                  onTap: login,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.blue,
                        )
                      : Container(
                          child: const Text("log-in"),
                          width: 200,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.blue),
                        )),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: const Text("don't have an account?"),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Otp(
                                    email: '',
                                  )));
                    },
                    child: Container(
                      child: const Text(
                        'Sign-up',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
