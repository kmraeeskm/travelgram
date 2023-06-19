import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String mail;
  final String uid;
  final String phone;
  final String username;
  final String photourl;
  final String type;

  const UserModel({
    required this.mail,
    required this.uid,
    required this.phone,
    required this.username,
    required this.type,
    required this.photourl,
  });

  Map<String, dynamic> toJson() => {
        'email': mail,
        'uid': uid,
        'photourl': photourl,
        'username': username,
        'phone': phone,
        'type': type,
      };
  static UserModel fromsnap(DocumentSnapshot snap) {
    var snapshot = (snap.data() as Map<String, dynamic>);
    return UserModel(
        type: snap["type"],
        mail: snap['email'],
        uid: snap['uid'],
        phone: snap['phone'],
        username: snap['username'],
        photourl: snap['photourl']);
  }
}
