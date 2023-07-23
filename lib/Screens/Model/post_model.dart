import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String title;

  Post({required this.id, required this.title});

  // Factory method to create a Post instance from Firestore document data
  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Post(id: doc.id, title: data['title']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }
}
