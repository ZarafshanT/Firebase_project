import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowImage extends StatefulWidget {
  final String? userId;

  const ShowImage({super.key, this.userId});

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .collection('images')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          //final data = snapshot.data;
          print(snapshot.hasData);
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No image uploaded'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final url = snapshot.data!.docs[index]['downloadUrl'];

                return CachedNetworkImage(
                  imageUrl: url,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.error)),
                  height: 50.h,
                  fit: BoxFit.cover,
                );
              },
            );
          }
        },
      ),
    );
  }

  _appBar() {
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
      child: AppBar(
        title: Text(
          'Image display',
          style: TextStyle(
            fontSize: 15.sp,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.amber,
      ),
      preferredSize: Size.fromHeight(appBarHeight),
    );
  }
}
