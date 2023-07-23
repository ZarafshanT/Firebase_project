import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_project/Screens/CRUD_Methods/FireBae%20FireStore%20Post/create_post.dart';
import 'package:flutter_firebase_auth_project/Screens/Widgets/Extensions/sizedbox_extension.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Model/post_model.dart';
import '../../Widgets/Text/custom_text.dart';
import '../../Widgets/Text/textstyle.dart';

class PostReadUpdateScreen extends StatefulWidget {
  const PostReadUpdateScreen({super.key});

  @override
  State<PostReadUpdateScreen> createState() => _PostReadUpdateScreenState();
}

class _PostReadUpdateScreenState extends State<PostReadUpdateScreen> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance.collection('posts').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('posts');
  final searchfilter = TextEditingController();
  final editcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 30.h),
        child: Column(
          children: [
            TextFormField(
                controller: searchfilter,
                decoration: const InputDecoration(
                    hintText: 'Search', border: OutlineInputBorder()),
                onChanged: (String? value) {
                  setState(() {});
                }),
            10.sbh,
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  List<Post> posts = snapshot.data!.docs
                      .map((doc) => Post.fromFirestore(doc))
                      .toList();

                  return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        String title = posts[index].title.toString();
                        final id = posts[index].id.toString();
                        // Get the data from the document using data() method.
                        if (searchfilter.text.isEmpty) {
                          return ListTile(
                            title: Text(posts[index].title),
                            subtitle: Text(posts[index].id),
                            trailing: PopupMenuButton(
                              icon: const Icon(Icons.more_vert_outlined),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                        showMyDialog(title, id);
                                      },
                                      leading: Icon(Icons.edit),
                                      title: Text('Edit'),
                                    )),
                                PopupMenuItem(
                                    child: ListTile(
                                  onTap: () {
                                    Navigator.pop(context);
                                    ref.doc(id.toString()).delete();
                                  },
                                  leading: Icon(Icons.delete),
                                  title: Text('Delete'),
                                )),
                              ],
                            ),
                          );
                        } else if (posts[index].title.toLowerCase().contains(
                            searchfilter.text.toLowerCase().toString())) {
                          return ListTile(
                            title: Text(posts[index].title),
                            subtitle: Text(posts[index].id),
                          );
                        } else {
                          return Container();
                        }
                      });
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const createPostScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editcontroller.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update'),
            content: TextFormField(
              controller: editcontroller,
              decoration: const InputDecoration(
                hintText: 'Edit',
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    ref.doc(id.toString()).update({
                      'title': editcontroller.text.toLowerCase()
                    }).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Post Updated'),
                        backgroundColor: Colors.green,
                      ));
                      Navigator.pop(context);
                    }).onError((error, stackTrace) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(error.toString()),
                        backgroundColor: Colors.red,
                      ));
                    });
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.green),
                  )),
            ],
          );
        });
  }

  _appBar() {
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
        child: AppBar(
          title: ReusableText(
              text: 'Read Post Using Firebae Firestore',
              style: txtStyle(
                  15, Colors.black, FontWeight.w700, FontStyle.normal)),
          backgroundColor: Colors.amber,
        ),
        preferredSize: Size.fromHeight(appBarHeight));
  }
}
