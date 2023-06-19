// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:travelgram/screen/hotel/hotel_details.dart';

class Hotel {
  // final List<String> bookings;
  // final List<String> subPics;
  final String description;
  final String imageUrl;
  final String location;
  // final List<dynamic> likes;
  // final String name;
  final String postId;
  final int roomCount;
  final Timestamp time;
  final String uId;

  Hotel({
    // required this.bookings,
    // required this.subPics,
    required this.description,
    required this.imageUrl,
    required this.location,
    // required this.likes,
    // required this.name,
    required this.postId,
    required this.roomCount,
    required this.time,
    required this.uId,
  });
}

class HotelReccomendations extends StatefulWidget {
  final String location;
  const HotelReccomendations({super.key, required this.location});

  @override
  State<HotelReccomendations> createState() => _HotelReccomendationsState();
}

class _HotelReccomendationsState extends State<HotelReccomendations> {
  final List<Hotel> _foods = [];
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> _foods2 = [];
  String searchText = "";

  Future<void> _fetchPosts() async {
    try {
      String loc = widget.location.toLowerCase();
      print("loc");
      print(loc);
      final postDocs = await FirebaseFirestore.instance
          .collection('hotels')
          .where('location', isEqualTo: loc)
          .get();
      for (var postDoc in postDocs.docs) {
        final userId = postDoc['uId'];
        print(userId);
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        final userData = userDoc.data() as Map<String, dynamic>;
        // List<String> bookins = [];
        // final rating = postDoc['rating'].toString();
        // final ratingC = postDoc['ratingCount'].toString();
        // final price = postDoc['price'].toString();
        // for (var x in userData['bookings']) {
        //   bookins.add(x);
        // }
        // print(bookins);
        final post = Hotel(
          // subPics: postDoc['subPics'],
          description: postDoc['description'],
          // bookings: bookins,
          imageUrl: postDoc['imageUrl'],
          location: postDoc['location'],
          // likes: postDoc['likes'],
          // name: userData['name'],
          postId: postDoc['postId'],
          uId: postDoc['uId'],
          time: postDoc['time'],
          roomCount: postDoc['roomCount'],
        );
        //thiruvananthapuram,kerala
        //thriuvananthapuram,kerala
        _foods.add(post);
        _foods2.add(postDoc);
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
                              builder: (_) => HotelDetails(
                                snap: _foods2[index],
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
