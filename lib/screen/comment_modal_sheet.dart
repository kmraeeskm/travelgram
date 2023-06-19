import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelgram/auth/user_provider.dart';

class CommentModalSheet extends StatefulWidget {
  final String postID;
  final String name;

  const CommentModalSheet(
      {super.key, required this.postID, required this.name});

  @override
  State<CommentModalSheet> createState() => _CommentModalSheetState();
}

class _CommentModalSheetState extends State<CommentModalSheet> {
  final TextEditingController commentText = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  Future<List<Map<String, dynamic>>> getComments() async {
    final documentSnapshot = await FirebaseFirestore.instance
        .collection('comments')
        .doc(widget.postID)
        .get();

    final commentData = documentSnapshot.data();
    print(commentData);

    if (commentData != null) {
      return [commentData];
    } else {
      return [];
    }
  }

  void addComment() async {
    print("starting");
    final comment = {"user_id": user.uid, "comment_text": commentText.text};

    try {
      await FirebaseFirestore.instance
          .collection("comments")
          .doc(widget.postID)
          .set({
        "comments": FieldValue.arrayUnion(
          [comment],
        ),
      }, SetOptions(merge: true));
    } catch (e) {
      e.toString();
    }
    commentText.clear();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userModel = userProvider.userModel;
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(children: [
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
          const Divider(
            color: Color.fromARGB(255, 143, 143, 143),
          ),
          Row(
            children: [
              CircleAvatar(
                  backgroundImage: NetworkImage(userModel!.photourl),
                  child: Container(height: 20, width: 20, child: Text(''))),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: commentText,
                  decoration: InputDecoration(
                    hintText: 'Add comment',
                    hintStyle: TextStyle(fontSize: 13),
                    border: InputBorder.none,
                  ),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    addComment();
                  },
                  child: Icon(Icons.send)),
            ],
          ),
          const Divider(
            color: Color.fromARGB(255, 143, 143, 143),
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: getComments(),
            builder: (BuildContext context,
                AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
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
                  return Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data![0]['comments'].length,
                            itemBuilder: (BuildContext context, int index) {
                              final comment =
                                  snapshot.data![0]['comments'][index];
                              print("snapshot.data!.length");
                              print(snapshot.data!.length);
                              print("snapshot.data!.length");
                              print("comment");
                              print(comment);
                              print("comment");
                              print(comment['user_id']);
                              return FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(comment['user_id'])
                                    .get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container();
                                  } else if (!snapshot.hasData) {
                                    return Center(
                                        child: Text('User not found.'));
                                  } else {
                                    final user = snapshot.data;
                                    return ListTile(
                                      title: Text(user!['username']),
                                      subtitle: Text(comment['comment_text']),
                                    );
                                  }
                                },
                              );
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
        ]),
      ),
    );
  }
}
