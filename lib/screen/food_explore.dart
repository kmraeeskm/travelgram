// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:boxicons/boxicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:travelgram/screen/food/Food_details.dart';
import 'package:travelgram/screen/home_screen.dart';

class Food {
  final String food;
  final String hotel;
  final String imageUrl;
  final String location;
  final String rating;
  final String ratingCount;
  final String uId;
  final String postId;

  Food({
    required this.food,
    required this.hotel,
    required this.imageUrl,
    required this.location,
    required this.rating,
    required this.ratingCount,
    required this.uId,
    required this.postId,
  });
}

class FoodExplore extends StatefulWidget {
  const FoodExplore({super.key});

  @override
  State<FoodExplore> createState() => _FoodExploreState();
}

class _FoodExploreState extends State<FoodExplore> {
  final List<Food> _foods = [];
  String searchText = "";

  Future<void> _fetchPosts() async {
    try {
      final postDocs =
          await FirebaseFirestore.instance.collection('foods').get();

      for (var postDoc in postDocs.docs) {
        final userId = postDoc['uId'];

        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        final userData = postDoc.data() as Map<String, dynamic>;
        final rating = postDoc['rating'].toString();
        final ratingC = postDoc['ratingCount'].toString();
        final post = Food(
          food: postDoc['food'],
          hotel: postDoc['hotel'],
          imageUrl: postDoc['imageUrl'],
          location: postDoc['location'],
          postId: postDoc['postId'],
          uId: postDoc['uId'],
          rating: rating,
          ratingCount: ratingC,
        );
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
                text: 'Find best foods for\n',
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
                placeholder: 'Search foods/locations/hotels',
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
                          .food
                          .toLowerCase()
                          .contains(searchText.toLowerCase()) ||
                      _foods[index]
                          .hotel
                          .toLowerCase()
                          .contains(searchText.toLowerCase()) ||
                      _foods[index]
                          .location
                          .toLowerCase()
                          .contains(searchText.toLowerCase())) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => FoodDetails(
                                    foodName: _foods[index].food,
                                    hotelName: _foods[index].hotel,
                                    imageUrl: _foods[index].imageUrl,
                                    location: _foods[index].location,
                                    rating: _foods[index].rating,
                                    postId: _foods[index].postId,
                                    uId: _foods[index].uId,
                                  )));
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
