import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_project/Screens/CRUD_Methods/Realtime%20Database/add_post.dart';
import 'package:flutter_firebase_auth_project/Screens/Widgets/Extensions/sizedbox_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Widgets/Text/custom_text.dart';
import '../../Widgets/Text/textstyle.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('post');
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
            20.sbh,
            // Expanded(
            //   child: StreamBuilder(
            //       stream: ref.onValue,
            //       builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            //         if (!snapshot.hasData) {
            //           return const CircularProgressIndicator();
            //         } else {
            //           Map<dynamic, dynamic> map =
            //               snapshot.data!.snapshot.value as dynamic;
            //           List<dynamic> list = [];
            //           list.clear();
            //           list = map.values.toList();
            //           return ListView.builder(
            //               itemCount: snapshot.data!.snapshot.children.length,
            //               itemBuilder: (context, index) {
            //                 return ListTile(
            //                   title: Text(list[index]['title']),
            //                 );
            //               });
            //         }
            //       }),
            // ),
            Expanded(
              child: FirebaseAnimatedList(
                  query: ref,
                  itemBuilder: (context, snapshot, animation, index) {
                    final title = snapshot.child('title').value.toString();
                    final id = snapshot.child('id').value.toString();

                    if (searchfilter.text.isEmpty) {
                      return ListTile(
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle: Text(snapshot.child('id').value.toString()),
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
                                ref
                                    .child(
                                        snapshot.child('id').value.toString())
                                    .remove();
                              },
                              leading: Icon(Icons.delete),
                              title: Text('Delete'),
                            )),
                          ],
                        ),
                      );
                    } else if (title
                        .toLowerCase()
                        .contains(searchfilter.text.toLowerCase().toString())) {
                      return ListTile(
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle: Text(snapshot.child('id').value.toString()),
                      );
                    } else {
                      return Container();
                    }
                  }),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPostScreen()));
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
              decoration: InputDecoration(
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
                    Navigator.pop(context);
                    ref.child(id).update({
                      'title': editcontroller.text.toLowerCase()
                    }).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Post Updated'),
                        backgroundColor: Colors.green,
                      ));
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
              text: 'Read and update data',
              style: txtStyle(
                  15, Colors.black, FontWeight.w700, FontStyle.normal)),
          backgroundColor: Colors.amber,
        ),
        preferredSize: Size.fromHeight(appBarHeight));
  }
}
