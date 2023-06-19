// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:boxicons/boxicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:travelgram/screen/home_screen.dart';

import 'reccomendations_screen.dart';

class Post {
  final String name;
  final String location;
  final String imageurl;
  final String bio;
  final String dpurl;
  final String postId;

  Post({
    required this.name,
    required this.location,
    required this.imageurl,
    required this.bio,
    required this.dpurl,
    required this.postId,
  });
}

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final List<Post> _posts = [];
  String searchText = "";

  Future<void> _fetchPosts() async {
    try {
      final postDocs =
          await FirebaseFirestore.instance.collection('posts').get();

      for (var postDoc in postDocs.docs) {
        final userId = postDoc['uId'];

        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        final userData = userDoc.data() as Map<String, dynamic>;
        final post = Post(
          postId: postDoc['postId'],
          dpurl: userData['photourl'],
          bio: postDoc['description'],
          imageurl: postDoc['imageUrl'],
          location: postDoc['location'],
          name: userData['username'],
        );
        _posts.add(post);
      }

      setState(() {});
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Travelgram',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text.rich(
              TextSpan(
                text: 'Find best places for\n',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.035,
                ),
                children: [
                  TextSpan(
                    text: 'Your Special Moments!\n',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.04,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: CupertinoSearchTextField(
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                borderRadius: BorderRadius.circular(10.0),
                placeholder: 'Search places',
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16,
              ),
              child: MasonryGridView.builder(
                itemCount: _posts.length,
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  if (searchText == '' ||
                      _posts[index]
                          .location
                          .toLowerCase()
                          .contains(searchText.toLowerCase())) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ReccomenadtionsScreen(
                                    postId: _posts[index].postId,
                                  )));
                        },
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                _posts[index].imageurl,
                              ),
                            ),
                            Positioned(
                              top: 5,
                              left: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 10,
                                        backgroundImage:
                                            NetworkImage(_posts[index].dpurl),
                                      ),
                                      Text(
                                        _posts[index].location,
                                        style: TextStyle(fontSize: 10),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
          // Expanded(
          //   child: FutureBuilder(
          //     future: FirebaseFirestore.instance.collection('posts').get(),
          //     builder: (context, snapshot) {
          //       if (snapshot.hasData) {
          //         return MasonryGridView.builder(
          //             itemCount: snapshot.data!.size,
          //             gridDelegate:
          //                 SliverSimpleGridDelegateWithFixedCrossAxisCount(
          //               crossAxisCount: 3,
          //             ),
          //             itemBuilder: (context, index) {
          //               return Padding(
          //                 padding: const EdgeInsets.all(2.0),
          //                 child: ClipRRect(
          //                   borderRadius: BorderRadius.circular(10),
          //                   child: Image.network(
          //                     (snapshot.data! as dynamic).docs[index]
          //                         ['imageUrl'],
          //                   ),
          //                 ),
          //               );
          //             });
          //       } else {
          //         return Center(
          //           child: CircularProgressIndicator(),
          //         );
          //       }
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
