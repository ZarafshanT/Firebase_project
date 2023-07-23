import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_project/Screens/Widgets/Buttons/custom_button.dart';
import 'package:flutter_firebase_auth_project/Screens/Widgets/Extensions/sizedbox_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../Widgets/Text/custom_text.dart';
import '../../Widgets/Text/textstyle.dart';
import '../../Widgets/Textformfield/custom_textformfield.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final postcontroller = TextEditingController();
  final ref = FirebaseDatabase.instance.ref('post');

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
              text: 'Add',
              mystyle: btntextStyle(
                  17, Color(0xffFFFFFF), FontWeight.w500, FontStyle.normal),
              onPressed: () {
                String id = DateTime.now().millisecondsSinceEpoch.toString();
                ref.child(id).set({
                  'id': id,
                  'title': postcontroller.text.toString()
                }).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Post Added"),
                    backgroundColor: Colors.green,
                  ));
                }).onError((error, stackTrace) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(error.toString()),
                    backgroundColor: Colors.red,
                  ));
                });
              },
            )
          ],
        ),
      ),
    );
  }

  _appBar() {
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
        child: AppBar(
          title: ReusableText(
              text: 'Add Post using RealTime Database',
              style: txtStyle(
                  15, Colors.black, FontWeight.w700, FontStyle.normal)),
          backgroundColor: Colors.amber,
        ),
        preferredSize: Size.fromHeight(appBarHeight));
  }
}
