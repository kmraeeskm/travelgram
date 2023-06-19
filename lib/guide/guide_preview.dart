// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travelgram/screen/chat_sccreen.dart';
import 'package:travelgram/screen/rate.dart';

import '../screen/review_modal_sheet.dart';

class GuidePreivew extends StatefulWidget {
  var snap;
  GuidePreivew({super.key, required this.snap});

  @override
  State<GuidePreivew> createState() => _GuidePlacePreivew();
}

class _GuidePlacePreivew extends State<GuidePreivew> {
  String c = '';
  String p = '';
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _hotelNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  String lalo = '';

  @override
  void initState() {
    super.initState();
    try {} catch (e) {
      print(e.toString());
    }
  }

  String chatRoomID(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      print("$user1$user2");
      return "$user1$user2";
    } else {
      print("$user1$user2");
      return "$user2$user1";
    }
  }

  Future<Map<String, dynamic>> fetchRatingData() async {
    print("invoked");
    final documentSnapshot = await FirebaseFirestore.instance
        .collection('comments')
        .doc(widget.snap.uId)
        .collection(widget.snap.postId)
        .doc('rating')
        .get();

    final ratingData = documentSnapshot.data();
    print(ratingData);
    if (ratingData == null) {
      return {
        'rating': 0,
      };
    }
    return ratingData as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.snap.data);
    _priceController.text = '${widget.snap.price} Rs';
    _durationController.text = '${widget.snap.duration} hrs';
    _descriptionController.text = widget.snap.description;
    _ratingController.text = '${widget.snap.rating} / 5';

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: height,
            width: width,
            child: Stack(
              children: [
                Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFA0A5BD), Color(0xFFB9B8C8)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: height * 0.53,
                              width: width,
                              child: Image.network(
                                widget.snap.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
                Positioned(
                  top: height * 0.38,
                  left: 15,
                  child: SizedBox(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(146, 255, 255, 255),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(widget.snap.location),
                            ),
                          ),
                        ],
                      ),
                      // TextField(
                      //   controller: _foodController,
                      //   decoration: InputDecoration(
                      //     border: InputBorder.none,
                      //     hintText: 'Food Name',
                      //   ),
                      //   style: TextStyle(
                      //     color: Colors.black,
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: height * 0.03,
                      //   ),
                      // ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 15,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => RatingGuide(
                                guideId: widget.snap.uId,
                                postId: widget.snap.postId,
                              )));
                    },
                    child: SizedBox(
                      width: 120,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(48, 255, 255, 255),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('write a review'),
                              ),
                            ),
                          ],
                        ),
                        // TextField(
                        //   controller: _foodController,
                        //   decoration: InputDecoration(
                        //     border: InputBorder.none,
                        //     hintText: 'Food Name',
                        //   ),
                        //   style: TextStyle(
                        //     color: Colors.black,
                        //     fontWeight: FontWeight.bold,
                        //     fontSize: height * 0.03,
                        //   ),
                        // ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: height * 0.45,
                  child: SizedBox(
                    height: height * 0.55,
                    width: width,
                    child: Container(
                      width: 180,
                      height: 170,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromARGB(255, 222, 221, 228),
                                Color.fromARGB(195, 230, 227, 230)
                              ])),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color.fromARGB(218, 241, 241, 241)),
                                width: width * 0.4,
                                height: height * 0.08,
                                child: Center(
                                  child: Row(
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Color(0xFFfcf4e4),
                                          ),
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.price_change,
                                              size: 16,
                                            ),
                                            color: Color(0xFF756d54),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 45,
                                              width: 65,
                                              child: TextField(
                                                enabled: false,
                                                controller: _priceController,
                                                decoration: InputDecoration(
                                                  hintText: 'Rs',
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color.fromARGB(218, 241, 241, 241)),
                                width: width * 0.4,
                                height: height * 0.08,
                                child: Center(
                                  child: Row(
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Color(0xFFfcf4e4),
                                          ),
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.punch_clock_outlined,
                                              size: 16,
                                            ),
                                            color: Color(0xFF756d54),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 45,
                                              width: 50,
                                              child: TextField(
                                                enabled: false,
                                                controller: _durationController,
                                                decoration: InputDecoration(
                                                  hintText: 'Hrs',
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      context: context,
                                      builder: (context) {
                                        return ReviewModalSheet(
                                          postID: widget.snap.postId,
                                          uId: widget.snap.uId,
                                        );
                                      });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(20),
                                      color:
                                          Color.fromARGB(218, 241, 241, 241)),
                                  width: width * 0.4,
                                  height: height * 0.08,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Color(0xFFfcf4e4),
                                          ),
                                          child: Icon(
                                            Icons.stars,
                                            color: Colors.yellow,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              child: FutureBuilder<
                                                  Map<String, dynamic>>(
                                                future: fetchRatingData(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<
                                                            Map<String,
                                                                dynamic>>
                                                        snapshot) {
                                                  if (snapshot.hasError) {
                                                    return Text(
                                                        'Error: ${snapshot.error}');
                                                  }

                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return CircularProgressIndicator();
                                                  }
                                                  print("snapshot");
                                                  print(snapshot);

                                                  final ratingData = snapshot
                                                          .data!['rating'] ??
                                                      0;
                                                  print("ratingData");
                                                  print(ratingData);

                                                  return Text(ratingData
                                                      .toStringAsFixed(1));
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(20),
                                color: Color.fromARGB(218, 241, 241, 241)),
                            width: width * 0.9,
                            height: height * 0.15,
                            child: Center(
                              child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color(0xFFfcf4e4),
                                      ),
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.note_alt_rounded,
                                          size: 16,
                                        ),
                                        color: Color(0xFF756d54),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 95,
                                          width: width * 0.7,
                                          child: TextField(
                                            enabled: false,
                                            maxLines: 3,
                                            controller: _descriptionController,
                                            decoration: InputDecoration(
                                              hintText:
                                                  'specialities & features',
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: width * 0.6,
                            height: width * 0.15,
                            child: GestureDetector(
                              onTap: () {
                                String roomID =
                                    chatRoomID(user.uid, widget.snap.uId);

                                print(user.uid + 'xxxxxxxxxxxxxxxxxxxxxxxxxx');
                                print(
                                    widget.snap.uId + 'yyyyyyyyyyyyyyyyyyyyy');
                                print(roomID + 'zzzzzzzzzzzzzzzzzzzzzzzzzzzzz');
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ChatScreenTest(
                                      //i was hereguideId
                                      guideId: widget.snap.uId,
                                      roomID: roomID,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.black,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'Chat',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Container(
                  //   height: height * 0.5,
                  //   width: width,
                  //   decoration: BoxDecoration(
                  //     gradient: LinearGradient(
                  //       colors: [Color(0xFFdedde4), Color(0xFFe6e3e6)],
                  //       begin: Alignment.topCenter,
                  //       end: Alignment.bottomCenter,
                  //     ),
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       Text('Tomato'),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //         children: [
                  //           Container(
                  //             decoration: BoxDecoration(
                  //               shape: BoxShape.circle,
                  //               color: Colors.black,
                  //             ),
                  //             width: width * 0.15,
                  //             height: height * 0.15,
                  //             child: Center(
                  //               child: Text(
                  //                 'S',
                  //                 style: TextStyle(
                  //                   color: Colors.white,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //           Container(
                  //             decoration: BoxDecoration(
                  //               shape: BoxShape.circle,
                  //               color: Colors.black,
                  //             ),
                  //             width: width * 0.15,
                  //             height: height * 0.15,
                  //             child: Center(
                  //               child: Text(
                  //                 'M',
                  //                 style: TextStyle(
                  //                   color: Colors.white,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //           Container(
                  //             decoration: BoxDecoration(
                  //               shape: BoxShape.circle,
                  //               color: Colors.black,
                  //             ),
                  //             width: width * 0.15,
                  //             height: height * 0.15,
                  //             child: Center(
                  //               child: Text(
                  //                 'L',
                  //                 style: TextStyle(
                  //                   color: Colors.white,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       )
                  //     ],
                  //   ),
                  // ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomClipperRectangle extends CustomClipper<Path> {
  final double sizeW;
  final double sizeH;

  CustomClipperRectangle({required this.sizeW, required this.sizeH});
  @override
  Path getClip(Size size) {
    const double radius = 24.0; // Radius of curved corners
    final Path path = Path();

    // Move to top left corner
    path.moveTo(0.0, 0.0);

    // Draw top right curved corner
    path.lineTo(sizeW / 3 - radius, 0.0);
    path.quadraticBezierTo(
        size.width / 3, 0.0, size.width / 3 + radius + 10, radius);

    path.lineTo(sizeW / 2, radius);

    path.quadraticBezierTo(size.width / 2 + radius, radius,
        size.width / 2 + radius + 20, 0.0); // Top right curve

    // Draw bottom right corner
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(
        size.width, 0, size.width, radius); // Bottom right curve
    path.lineTo(size.width, size.height);
    // Draw bottom left corner
    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height);
    path.lineTo(0.0, radius); // Bottom left curve

    // Draw top left corner
    path.quadraticBezierTo(0.0, 0.0, radius, 0.0); // Top left curve

    path.close(); // Close the path

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
