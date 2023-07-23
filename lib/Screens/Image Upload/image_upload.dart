import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_project/Screens/Widgets/Buttons/custom_button.dart';
import 'package:flutter_firebase_auth_project/Screens/Widgets/Extensions/sizedbox_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../Widgets/Text/textstyle.dart';

class ImageUpload extends StatefulWidget {
  String? userId;

  ImageUpload({Key? key, this.userId}) : super(key: key);

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File? _image;
  final imagePicker = ImagePicker();
  String? downloadUrl;

  Future imagePickerMethod() async {
    final pick = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        showSnackBar("No file selected", Duration(milliseconds: 400));
      }
    });
  }

  Future uploadImage() async {
    final postId = DateTime.now().microsecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    if (_image == null) {
      showSnackBar("Please select an image first", Duration(milliseconds: 400));
      return;
    }

    Reference ref = FirebaseStorage.instance
        .ref()
        .child('${widget.userId}/images')
        .child('post_$postId')
        .child('${DateTime.now()}.png');
    UploadTask uploadTask = ref.putFile(_image!);

    TaskSnapshot taskSnapshot = await uploadTask;
    downloadUrl = await taskSnapshot.ref.getDownloadURL();
    print(downloadUrl);
    showSnackBar("Image uploaded successfully!", Duration(milliseconds: 1500));
    await firebaseFirestore
        .collection('users')
        .doc(widget.userId)
        .collection('images')
        .add({'downloadUrl': downloadUrl});
  }

  void showSnackBar(String snackText, Duration duration) {
    final snackBar = SnackBar(content: Text(snackText), duration: duration);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.r),
          child: SizedBox(
            height: 500,
            width: double.infinity,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: 320,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: _image == null
                          ? const Center(child: Text('No image selected'))
                          : Image.file(_image!),
                    ),
                  ),
                ),
                30.sbh,
                MyButton(
                  text: 'Select Images',
                  mystyle: btntextStyle(
                      17, Color(0xffFFFFFF), FontWeight.w500, FontStyle.normal),
                  onPressed: () {
                    imagePickerMethod();
                  },
                ),
                10.sbh,
                MyButton(
                  text: 'Upload Images',
                  mystyle: btntextStyle(
                      17, Color(0xffFFFFFF), FontWeight.w500, FontStyle.normal),
                  onPressed: () {
                    uploadImage();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _appBar() {
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
      child: AppBar(
        title: Text(
          'Image Upload',
          style: TextStyle(
              fontSize: 15, color: Colors.black, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.amber,
      ),
      preferredSize: Size.fromHeight(appBarHeight),
    );
  }
}
