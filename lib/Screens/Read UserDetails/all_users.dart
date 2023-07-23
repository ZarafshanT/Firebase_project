import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Widgets/Text/custom_text.dart';
import '../Widgets/Text/textstyle.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final user = FirebaseAuth.instance.currentUser!;
  final firestore = FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: SafeArea(
            child: Column(children: [
          StreamBuilder<QuerySnapshot>(
              stream: firestore,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blueAccent,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            // onTap: ,
                            title: Text(snapshot.data!.docs[index]['uid']),
                            subtitle:
                                Text(snapshot.data!.docs[index]['firstname']),
                          );
                        }),
                  );
                }
                return const Text('no data available');
              })
        ])));
  }

  _appBar() {
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
      child: AppBar(
        title: Text(
          'All users list',
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
