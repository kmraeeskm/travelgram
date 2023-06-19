// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:travelgram/screen/food/Food_details.dart';

class Food {
  final String food;
  final String hotel;
  final String imageUrl;
  final String location;
  final String rating;
  final String ratingCount;
  final String postId;
  final String uId;

  Food({
    required this.food,
    required this.hotel,
    required this.imageUrl,
    required this.location,
    required this.rating,
    required this.ratingCount,
    required this.postId,
    required this.uId,
  });
}

class FoodReccomendations extends StatefulWidget {
  final String location;
  const FoodReccomendations({super.key, required this.location});

  @override
  State<FoodReccomendations> createState() => _FoodReccomendationsState();
}

class _FoodReccomendationsState extends State<FoodReccomendations> {
  final List<Food> _foods = [];
  String searchText = "";

  Future<void> _fetchPosts() async {
    try {
      String loc = widget.location.toLowerCase();
      final postDocs = await FirebaseFirestore.instance
          .collection('foods')
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
        final post = Food(
          food: postDoc['food'],
          hotel: postDoc['hotel'],
          imageUrl: postDoc['imageUrl'],
          location: postDoc['location'],
          rating: rating,
          ratingCount: ratingC,
          postId: postDoc['postId'],
          uId: postDoc['uId'],
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
                scrollDirection: Axis.horizontal,
                itemCount: _foods.length,
                itemBuilder: (context, index) {
                  if (searchText == '' ||
                      _foods[index]
                          .location
                          .toLowerCase()
                          .contains(searchText.toLowerCase())) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => FoodDetails(
                                foodName: _foods[index].food,
                                hotelName: _foods[index].hotel,
                                imageUrl: _foods[index].imageUrl,
                                location: _foods[index].location,
                                postId: _foods[index].postId,
                                rating: _foods[index].rating,
                                uId: _foods[index].uId,
                                fromFood: false,
                              ),
                            ),
                          );
                        },
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
