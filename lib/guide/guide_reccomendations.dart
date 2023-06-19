// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
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

class GuideReccomendations extends StatefulWidget {
  final String location;
  const GuideReccomendations({super.key, required this.location});

  @override
  State<GuideReccomendations> createState() => _GuideReccomendationsState();
}

class _GuideReccomendationsState extends State<GuideReccomendations> {
  final List<Guide> _foods = [];
  String searchText = "";

  Future<void> _fetchPosts() async {
    try {
      String loc = widget.location.toLowerCase();
      final postDocs = await FirebaseFirestore.instance
          .collection('guides')
          .where('location', isEqualTo: loc)
          .get();
      print(loc);
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
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16,
              ),
              child: ListView.builder(
                itemCount: _foods.length,
                scrollDirection: Axis.horizontal,
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
