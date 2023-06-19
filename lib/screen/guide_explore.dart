// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:travelgram/guide/guide_preview.dart';

class Guide {
  final String description;
  final String duration;
  final String imageUrl;
  final String location;
  final String postId;
  final String ratingCount;
  final String price;
  final String rating;
  final Timestamp time;
  final String uId;

  Guide({
    required this.description,
    required this.duration,
    required this.imageUrl,
    required this.location,
    required this.postId,
    required this.ratingCount,
    required this.rating,
    required this.price,
    required this.time,
    required this.uId,
  });
}

class GuideExplore extends StatefulWidget {
  const GuideExplore({super.key});

  @override
  State<GuideExplore> createState() => _GuideExploreState();
}

class _GuideExploreState extends State<GuideExplore> {
  final List<Guide> _foods = [];
  String searchText = "";

  Future<void> _fetchPosts() async {
    try {
      final postDocs =
          await FirebaseFirestore.instance.collection('guides').get();
      print(postDocs.docs);
      for (var postDoc in postDocs.docs) {
        final userId = postDoc['uId'];

        final userDoc =
            await FirebaseFirestore.instance.collection('users').get();
        final userData = postDoc.data() as Map<String, dynamic>;
        final rating = postDoc['rating'].toString();
        final ratingC = postDoc['ratingCount'].toString();
        final price = postDoc['price'].toString();
        final post = Guide(
          description: postDoc['description'],
          duration: postDoc['duration'],
          imageUrl: postDoc['imageUrl'],
          location: postDoc['location'],
          rating: rating,
          ratingCount: ratingC,
          postId: postDoc['postId'],
          uId: postDoc['uId'],
          time: postDoc['time'],
          price: price,
        );
        //thiruvananthapuram,kerala
        //thriuvananthapuram,kerala
        _foods.add(post);
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
                text: 'Find best guide for\n',
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
                itemCount: _foods.length,
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  if (searchText == '' ||
                      _foods[index]
                          .location
                          .toLowerCase()
                          .contains(searchText.toLowerCase())) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => GuidePreivew(snap: _foods[index])));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                _foods[index].imageUrl,
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
                                          backgroundColor: Colors.green[100]
                                          // NetworkImage(_foods[index].dpurl),
                                          ),
                                      Text(
                                        _foods[index].location,
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
        ],
      ),
    );
  }
}
