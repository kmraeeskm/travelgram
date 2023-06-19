import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReviewModalSheet extends StatefulWidget {
  final String postID;

  const ReviewModalSheet({
    super.key,
    required this.postID,
  });

  @override
  State<ReviewModalSheet> createState() => _ReviewModalSheetState();
}

class _ReviewModalSheetState extends State<ReviewModalSheet> {
  final TextEditingController commentText = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  Future<List<Map<String, dynamic>>> getReviews() async {
    final documentSnapshot = await FirebaseFirestore.instance
        .collection('reviews')
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

  @override
  Widget build(BuildContext context) {
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
                      'Reviews',
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
          FutureBuilder<List<Map<String, dynamic>>>(
            future: getReviews(),
            builder: (BuildContext context,
                AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData || snapshot.data == []) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text('No Reviews found.'),
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
                        child: Text('No Reviews found.'),
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
