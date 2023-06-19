import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travelgram/auth/storage_methods.dart';
import 'package:travelgram/models/posts.dart';
import 'package:uuid/uuid.dart';

class fireStoreMethods {
  final FirebaseFirestore _firebasefirestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

  Future<String> uploadPost(
    String discription,
    Uint8List file,
    String uid,
    String username,
    String profileimage,
  ) async {
    String res = "someerror occured";
    try {
      String postID = const Uuid().v1();
      print(postID);
      String posturl =
          await StorageMethods().uploadImageStorage('posts', file, true);
      Post post = Post(
          discription: discription,
          uid: uid,
          username: username,
          postID: postID,
          datePublished: DateTime.now(),
          posturl: posturl,
          profileimage: profileimage,
          likes: []);

      _firebasefirestore.collection('post').doc(postID).set(post.toJson());
      res = 'succes';
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<void> bookmark(String pId, List books) async {
    print(books);
    try {
      if (!books.contains(pId) || books.isEmpty) {
        print("adding");
        try {
          await _firebasefirestore.collection('users').doc(user.uid).update({
            'bookmarks': FieldValue.arrayUnion([pId])
          });
        } catch (e) {
          print(e.toString());
        }
      } else {
        print("removing");
        try {
          await _firebasefirestore.collection('users').doc(user.uid).update({
            'bookmarks': FieldValue.arrayRemove([pId])
          });
        } catch (e) {
          print(e.toString());
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> likepost(String postid, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firebasefirestore.collection('post').doc(postid).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firebasefirestore.collection('post').doc(postid).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postcomments(String postid, String text, String uid, String name,
      String profilepic) async {
    try {
      if (text.isNotEmpty) {
        print(text);
        String comentid = Uuid().v1();
        await _firebasefirestore
            .collection('post')
            .doc(postid)
            .collection('coments')
            .doc(comentid)
            .set({
          'profilepic': profilepic,
          'postid': postid,
          'text': text,
          'uid': uid,
          'name': name,
          'comentid': comentid,
          'datepublished': DateTime.now(),
        });
      } else {
        print('text is empty');
      }
    } catch (e) {
      print('hii');
      print(e.toString());
    }
  }

  Future<void> deletepost(String postID) async {
    try {
      await _firebasefirestore.collection('post').doc(postID).delete();
    } catch (e) {}
  }
}
