import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_project/Screens/HomeScreen/homescreen.dart';
import 'package:flutter_firebase_auth_project/Screens/Model/user_model.dart';
import 'package:flutter_firebase_auth_project/Screens/Widgets/Buttons/custom_button.dart';
import 'package:flutter_firebase_auth_project/Screens/Widgets/Extensions/sizedbox_extension.dart';
import 'package:flutter_firebase_auth_project/Screens/Widgets/Textformfield/custom_textformfield.dart';
import 'package:flutter_firebase_auth_project/Screens/Widgets/Text/textstyle.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xffFF9900)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: SafeArea(
        child: Form(
          key: _formkey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                MyTextFormField(
                    hintText: 'Enter Your First Name',
                    controller: firstnameController,
                    validator: (value) {
                      RegExp regex = RegExp('[a-zA-Z]');
                      if (value!.isEmpty) {
                        return ("First Name cannot be empty");
                      }
                      if (!regex.hasMatch(value)) {
                        return ('please enter your valid Firstname');
                      }
                      return null;
                    },
                    onSaved: (value) {
                      firstnameController.text = value;
                    }),
                10.sbh,
                MyTextFormField(
                    hintText: 'Enter Your Last Name',
                    controller: lastnameController,
                    validator: (value) {
                      RegExp regex = RegExp('[a-zA-Z]');
                      if (value!.isEmpty) {
                        return ("First Name cannot be empty");
                      }
                      if (!regex.hasMatch(value)) {
                        return ('please enter your valid lastname');
                      }
                      return null;
                    },
                    onSaved: (value) {
                      lastnameController.text = value;
                    }),
                10.sbh,
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
                      emailController.text = value;
                    }),
                10.sbh,
                MyTextFormField(
                    hintText: 'Enter Your Password',
                    controller: passwordController,
                    isPassword: true,
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
                      passwordController.text = value;
                    }),
                10.sbh,
                MyTextFormField(
                  hintText: 'Enter Your Confirm Password',
                  controller: confirmpasswordController,
                  isPassword: true,
                  validator: (value) {
                    if (confirmpasswordController.text !=
                        passwordController.text) {
                      return "Password does not Match";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    confirmpasswordController.text = value;
                  },
                ),
                25.sbh,
                MyButton(
                  width: 343.w,
                  height: 48.h,
                  onPressed: () {
                    signup(emailController.text, passwordController.text);
                  },
                  text: 'SignUP',
                  mystyle: btntextStyle(17, const Color(0xffFFFFFF),
                      FontWeight.w500, FontStyle.normal),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signup(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore(context)})
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

  postDetailsToFirestore(BuildContext context) async {
    // calling our firestore
    // calling our usermodel
    // sending these vales

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstname = firstnameController.text;
    userModel.lastname = lastnameController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Account created Successfully"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
      (route) => false,
    );
  }
}
