import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReviewModalSheet extends StatefulWidget {
  final String postID;
  final String uId;

  const ReviewModalSheet({
    Key? key,
    required this.postID,
    required this.uId,
  }) : super(key: key);

  @override
  State<ReviewModalSheet> createState() => _ReviewModalSheetState();
}

class _ReviewModalSheetState extends State<ReviewModalSheet> {
  final TextEditingController commentText = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      fetchComments() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('comments')
        .doc(widget.uId)
        .collection(widget.postID)
        .get();

    final comments = querySnapshot.docs;
    if (comments.length > 0) {
      return comments;
    } else {
      return [];
    }
  }

  Future<String?> getUsername(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      final userData = userDoc.data();
      return userData?['username'] as String?;
    } else {
      return null;
    }
  }

  Future<String?> getUserPhotoUrl(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      final userData = userDoc.data();
      return userData?['photourl'] as String?;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Text(
                        'Comments',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
                Row(children: [
                  const Icon(Icons.toggle_off_outlined),
                  const SizedBox(
                    width: 5,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close)),
                ])
              ],
            ),
            FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
              future: fetchComments(),
              builder: (BuildContext context,
                  AsyncSnapshot<
                          List<QueryDocumentSnapshot<Map<String, dynamic>>>>
                      snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data == []) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text('No comments found.'),
                      ),
                    ],
                  );
                } else {
                  print("found data");
                  print(snapshot.data);
                  if (snapshot.data!.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text('No comments found.'),
                        ),
                      ],
                    );
                  } else {
                    final comments = snapshot.data ?? [];
                    return Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: comments.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (comments[index].id == "rating") {
                                  // Handle rating comment separately if needed
                                  return SizedBox();
                                } else {
                                  final comment = comments[index].data();
                                  final text = comment['comment'] as String?;
                                  final userId = comment['from'] as String?;

                                  return FutureBuilder<String?>(
                                    future: getUserPhotoUrl(userId!),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<String?>
                                            photoUrlSnapshot) {
                                      if (photoUrlSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return SizedBox();
                                      } else if (photoUrlSnapshot.hasData &&
                                          photoUrlSnapshot.data != null) {
                                        final photoUrl = photoUrlSnapshot.data!;
                                        return ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(photoUrl),
                                          ),
                                          title: FutureBuilder<String?>(
                                            future: getUsername(userId),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<String?>
                                                    usernameSnapshot) {
                                              if (usernameSnapshot
                                                      .connectionState ==
                                                  ConnectionState.waiting) {
                                                return SizedBox();
                                              } else if (usernameSnapshot
                                                      .hasData &&
                                                  usernameSnapshot.data !=
                                                      null) {
                                                final username =
                                                    usernameSnapshot.data!;
                                                return Text(username);
                                              } else {
                                                return SizedBox();
                                              }
                                            },
                                          ),
                                          subtitle: Text(text!),
                                        );
                                      } else {
                                        return SizedBox();
                                      }
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
