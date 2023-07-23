import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_project/Screens/HomeScreen/homescreen.dart';
import 'package:flutter_firebase_auth_project/Screens/Widgets/Buttons/custom_button.dart';
import 'package:flutter_firebase_auth_project/Screens/Widgets/Extensions/sizedbox_extension.dart';
import 'package:flutter_firebase_auth_project/Screens/Widgets/Textformfield/custom_textformfield.dart';
import 'package:flutter_firebase_auth_project/Screens/Widgets/Text/textstyle.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../SignUp Screen/signup.dart';
import '../Widgets/Text/custom_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  MyTextFormField(
                      hintText: 'Enter Your Email',
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ('please Enter Valid Email');
                        }
                        if (!RegExp('[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]')
                            .hasMatch(value)) {
                          return ('Please Enter Valid Email');
                        }
                        return null;
                      },
                      onSaved: (value) {
                        emailController.text = value!;
                      }),
                  10.sbh,
                  MyTextFormField(
                      hintText: 'Enter Your Password',
                      isPassword: true,
                      controller: passwordController,
                      validator: (value) {
                        RegExp regex = RegExp(r'^.{6,}$');
                        if (value!.isEmpty) {
                          return ("password is required for login");
                        }
                        if (!regex.hasMatch(value)) {
                          return ('please enter valid password (min 6 character)');
                        }
                        return null;
                      },
                      onSaved: (value) {
                        emailController.text = value;
                      }),
                  25.sbh,
                  MyButton(
                    width: 343.w,
                    height: 48.h,
                    onPressed: () {
                      signIn(emailController.text, passwordController.text);
                    },
                    text: 'Login',
                    mystyle: btntextStyle(17, Color(0xffFFFFFF),
                        FontWeight.w500, FontStyle.normal),
                  ),
                  27.sbh,
                  Divider(
                    thickness: 1.h,
                    indent: 102,
                    endIndent: 103,
                    color: Color(0xffFF9900),
                  ),
                  5.sbh,
                  Padding(
                      padding: EdgeInsets.only(left: 50.w),
                      child: Row(
                        children: [
                          ReusableText(
                              text: 'Dont have an account?',
                              style: txtStyle(15, Color(0xffB6B6B6),
                                  FontWeight.w400, FontStyle.normal)),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUp()));
                              },
                              child: ReusableText(
                                  text: 'SignUp',
                                  style: txtStyle(17, const Color(0xffFF9900),
                                      FontWeight.w500, FontStyle.normal)))
                        ],
                      )),
                ],
              ),
            )),
      ),
    );
  }

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("login succesful"),
                  backgroundColor: Colors.green,
                )),
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                )
              })
          .catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Error: $e',
          ),
          backgroundColor: Colors.red,
        ));
      });
    }
  }
}
