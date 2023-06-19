import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String discription;
  final String uid;

  final String username;
  final String postID;
  final datePublished;
  final String posturl;
  final String profileimage;
  final likes;

  const Post({
    required this.discription,
    required this.uid,
    required this.username,
    required this.postID,
    required this.datePublished,
    required this.posturl,
    required this.profileimage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        'discription': discription,
        'uid': uid,
        'datePublished': datePublished,
        'username': username,
        'postID': postID,
        'posturl': posturl,
        'profileimage': profileimage,
        'likes': likes,
      };
  static Post fromsnap(DocumentSnapshot snap) {
    var snapshot = (snap.data() as Map<String, dynamic>);
    return Post(
        discription: snap['discription'],
        uid: snap['uid'],
        datePublished: snap['datePublished'],
        username: snap['username'],
        profileimage: snap['profileimage'],
        likes: snap['likes'],
        postID: snap['postID'],
        posturl: snap['posturl']);
  }
}
