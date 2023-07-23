import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_project/Screens/Widgets/Buttons/custom_button.dart';
import 'package:flutter_firebase_auth_project/Screens/Widgets/Extensions/sizedbox_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Model/post_model.dart';
import '../../Widgets/Text/custom_text.dart';
import '../../Widgets/Text/textstyle.dart';
import '../../Widgets/Textformfield/custom_textformfield.dart';

class createPostScreen extends StatefulWidget {
  const createPostScreen({super.key});

  @override
  State<createPostScreen> createState() => _createPostScreenState();
}

class _createPostScreenState extends State<createPostScreen> {
  final postcontroller = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    postcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          children: [
            MyTextFormField(
              controller: postcontroller,
              hintText: 'Whats on your mind ?',
              onSaved: (value) {},
            ),
            30.sbh,
            MyButton(
                text: 'Add on firestore',
                mystyle: btntextStyle(
                    17, Color(0xffFFFFFF), FontWeight.w500, FontStyle.normal),
                onPressed: () {
                  Navigator.pop(context);
                  addPostWithCurrentUser();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Post Added"),
                      backgroundColor: Colors.green,
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  Future<void> addPostWithCurrentUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final postCollection = FirebaseFirestore.instance.collection('posts');

      final title = postcontroller.text.toString();

      // Create a new Post instance with the current data
      final post = Post(
          id: DateTime.now().millisecondsSinceEpoch.toString(), title: title);

      try {
        // Use the toMap() method to convert the Post instance to a map
        await postCollection.doc(post.id).set(post.toMap());
        // ignore: use_build_context_synchronously
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  _appBar() {
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
        child: AppBar(
          title: ReusableText(
              text: 'Add Post Using Firebae Firestore',
              style: txtStyle(
                  15, Colors.black, FontWeight.w700, FontStyle.normal)),
          backgroundColor: Colors.amber,
        ),
        preferredSize: Size.fromHeight(appBarHeight));
  }
}
