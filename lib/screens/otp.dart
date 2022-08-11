import 'dart:ui';

import 'package:circle/screens/homepage.dart';
import 'package:circle/screens/signup.dart';
import 'package:email_auth/email_auth.dart';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import '../tools/test.dart';

class Otp extends StatefulWidget {
  const Otp({Key? key, required this.email}) : super(key: key);
  final String email;
  @override
  State<Otp> createState() => _OtpState();
}

bool _visible = true;
TextEditingController _emailcontroller = TextEditingController();
TextEditingController _otpcontroller = TextEditingController();
EmailAuth emailAuth = EmailAuth(sessionName: "Sample session");
void verify(context) {
  var res = emailAuth.validateOtp(
      recipientMail: _emailcontroller.value.text,
      userOtp: _otpcontroller.value.text);
  (res)
      ? {
          Fluttertoast.showToast(msg: 'otp verified'),
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => Signup(email: _emailcontroller.text))))
        }
      : Fluttertoast.showToast(msg: 'otp incorrect');
}

void sendOtp() async {
  bool result = await emailAuth.sendOtp(
      recipientMail: _emailcontroller.value.text, otpLength: 5);
}

class _OtpState extends State<Otp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Lottie.asset('assets/email.json'),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldInput(
                  textEditingController: _emailcontroller,
                  hintText: 'enter mail',
                  textInputType: TextInputType.emailAddress),
              const SizedBox(
                height: 20,
              ),
              TextFieldInput(
                  textEditingController: _otpcontroller,
                  hintText: 'enter otp',
                  textInputType: TextInputType.number),
              Visibility(
                visible: _visible,
                child: TextButton(
                    onPressed: () {
                      {
                        sendOtp();
                        Fluttertoast.showToast(
                            msg: 'otp will send to this mail');
                        setState(() {
                          _visible = !_visible;
                        });
                      }
                    },
                    child: const Text('send otp')),
              ),
              TextButton(
                  onPressed: () {
                    verify(context);
                  },
                  child: const Text('verify'))
            ],
          ),
        ),
      ),
    );
  }
}
