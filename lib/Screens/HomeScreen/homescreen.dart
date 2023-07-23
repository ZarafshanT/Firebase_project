import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_project/Screens/CRUD_Methods/FireBae%20FireStore%20Post/create_post.dart';
import 'package:flutter_firebase_auth_project/Screens/CRUD_Methods/FireBae%20FireStore%20Post/read_update_post.dart';
import 'package:flutter_firebase_auth_project/Screens/CRUD_Methods/Realtime%20Database/add_post.dart';
import 'package:flutter_firebase_auth_project/Screens/CRUD_Methods/Realtime%20Database/read_update.dart';
import 'package:flutter_firebase_auth_project/Screens/Image%20Upload/image_upload.dart';
import 'package:flutter_firebase_auth_project/Screens/Image%20Upload/show_image.dart';
import 'package:flutter_firebase_auth_project/Screens/Login%20Screen/login.dart';
import 'package:flutter_firebase_auth_project/Screens/Model/user_model.dart';
import 'package:flutter_firebase_auth_project/Screens/Widgets/Extensions/sizedbox_extension.dart';
import 'package:flutter_firebase_auth_project/Screens/Widgets/Text/custom_text.dart';
import 'package:flutter_firebase_auth_project/Screens/Widgets/Text/textstyle.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Read UserDetails/all_users.dart';
import '../Widgets/Buttons/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<UserModel> _userFetch;

  @override
  void initState() {
    super.initState();
    _userFetch = _fetchUserDetails();
  }

  Future<UserModel> _fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    // The retrieved document data (snapshot.data()) is passed to UserModel.fromMap() to create a UserModel object.
    // The fromMap() function converts the Firestore document data
    //(a Map<String, dynamic>) into a UserModel object by mapping the values to the corresponding properties in the model class.
    return UserModel.fromMap(snapshot.data());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 50.h),
            child: Center(
              child: Column(children: [
                ReusableText(
                  text: 'Welcome Back',
                  style: txtStyle(
                      26, Colors.amber, FontWeight.w500, FontStyle.normal),
                ),
                10.sbh,
                FutureBuilder<UserModel>(
                  future: _userFetch,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Column(
                        children: [
                          ReusableText(
                            text: 'First Name: ${snapshot.data!.firstname}'
                                ' '
                                '${snapshot.data!.lastname}',
                            style: txtStyle(15, Colors.black, FontWeight.w500,
                                FontStyle.normal),
                          ),
                          10.sbh,
                          ReusableText(
                            text: 'Email: ${snapshot.data!.email}',
                            style: txtStyle(15, Colors.black, FontWeight.w500,
                                FontStyle.normal),
                          ),
                          20.sbh,
                          MyButton(
                            text: 'Upload Images',
                            mystyle: btntextStyle(17, Color(0xffFFFFFF),
                                FontWeight.w500, FontStyle.normal),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ImageUpload(
                                            userId: snapshot.data!.uid,
                                          )));
                            },
                          ),
                          10.sbh,
                          MyButton(
                            text: 'Show Images',
                            mystyle: btntextStyle(17, Color(0xffFFFFFF),
                                FontWeight.w500, FontStyle.normal),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const ShowImage()));
                            },
                          ),
                          10.sbh,
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => const UserDetails(),
                              ));
                            },
                            child: Container(
                              height: 50.h,
                              width: 150.w,
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Center(
                                child: ReusableText(
                                  text: 'All User Details',
                                  style: txtStyle(12, Colors.black,
                                      FontWeight.w500, FontStyle.normal),
                                ),
                              ),
                            ),
                          ),
                          10.sbh,
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => PostReadUpdateScreen(),
                              ));
                            },
                            child: Container(
                              height: 50.h,
                              width: 150.w,
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Center(
                                child: ReusableText(
                                  text: 'FireBase FireStore',
                                  style: txtStyle(12, Colors.black,
                                      FontWeight.w500, FontStyle.normal),
                                ),
                              ),
                            ),
                          ),
                          20.sbh,
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => PostScreen(),
                              ));
                            },
                            child: Container(
                              height: 50.h,
                              width: 150.w,
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Center(
                                child: ReusableText(
                                  text: 'RealTime Database',
                                  style: txtStyle(12, Colors.black,
                                      FontWeight.w500, FontStyle.normal),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                )
              ]),
            )));
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ));
  }

  _appBar() {
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
        child: AppBar(
            title: ReusableText(
                text: 'Profile',
                style: txtStyle(
                    15, Colors.black, FontWeight.bold, FontStyle.normal)),
            backgroundColor: Colors.amber,
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    logout(context);
                  },
                  icon: Icon(Icons.login_outlined))
            ]),
        preferredSize: Size.fromHeight(appBarHeight));
  }
}
