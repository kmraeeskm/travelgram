// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stepper_counter_swipe/stepper_counter_swipe.dart';
import 'package:travelgram/screen/rate.dart';
import 'package:travelgram/screen/review_modal_sheet.dart';
import 'package:uuid/uuid.dart';

class FoodDetails extends StatefulWidget {
  const FoodDetails({
    super.key,
    required this.imageUrl,
    required this.hotelName,
    required this.foodName,
    required this.location,
    required this.rating,
    required this.uId,
    required this.postId,
    this.fromFood = false,
  });
  final String imageUrl;
  final String hotelName;
  final String foodName;
  final String location;
  final String rating;
  final String uId;
  final String postId;
  final bool fromFood;

  @override
  State<FoodDetails> createState() => _FoodStateDetails();
}

class _FoodStateDetails extends State<FoodDetails> {
  String c = '';
  String p = '';
  int foodcount = 1;

  @override
  void initState() {
    super.initState();
    try {
      // getUserLocation();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Map<String, dynamic>> fetchRatingData() async {
    final documentSnapshot = await FirebaseFirestore.instance
        .collection('comments')
        .doc(widget.uId)
        .collection(widget.postId)
        .doc('rating')
        .get();

    final ratingData = documentSnapshot.data();

    return ratingData as Map<String, dynamic>;
  }

  Future orderFood() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    String BookingId = const Uuid().v1();
    await _firestore.collection('orders').doc(widget.postId).set({'set': ''});
    String docId = selectedDateTime.toString().split(" ")[0];
    try {
      await _firestore
          .collection('orders')
          .doc(widget.postId)
          .collection(docId)
          .doc(BookingId)
          .set({
        'bookingId': BookingId,
        'uId': user.uid,
        'amount': foodcount,
        'time': DateTime.now(),
        'datetime': selectedDateTime,
        'foodName': widget.foodName,
        'foodId': widget.postId,
      });
    } catch (e) {
      print(e.toString());
    }

    try {
      _firestore.collection('foods').doc(widget.postId).update({
        'orders': FieldValue.arrayUnion([BookingId])
      });
    } catch (e) {
      print(e.toString());
    }
    try {
      _firestore.collection('users').doc(user.uid).update({
        'orders': FieldValue.arrayUnion([BookingId])
      });
    } catch (e) {
      print(e.toString());
    }
  }

  late DateTime selectedDateTime;
  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDateTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
    if (selectedDateTime != null) {
      orderFood();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        SizedBox(
                          height: height * 0.53,
                          width: width,
                          child: Image.network(
                            fit: BoxFit.cover,
                            widget.imageUrl,
                          ),
                        ),
                      ],
                    )),
                Positioned(
                  top: 15,
                  left: 15,
                  child: SizedBox(
                    child: Center(
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(59, 255, 255, 255),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FutureBuilder<Map<String, dynamic>>(
                                future: fetchRatingData(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<Map<String, dynamic>>
                                        snapshot) {
                                  double ratingData = 0;
                                  if (snapshot.hasError) {
                                    ratingData = 0;
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  }
                                  print(snapshot.data);
                                  if (snapshot.data != null) {
                                    ratingData = snapshot.data!['rating'] ?? 0;
                                  }

                                  return Text(ratingData.toStringAsFixed(1));
                                },
                              ),
                              IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      context: context,
                                      builder: (context) {
                                        return ReviewModalSheet(
                                          postID: widget.postId,
                                          uId: widget.uId,
                                        );
                                      });
                                },
                                icon: Icon(CupertinoIcons.star_fill),
                                color: Color.fromARGB(255, 224, 211, 21),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
                Positioned(
                  top: height * 0.5,
                  child: SizedBox(
                    height: height * 0.5,
                    width: width,
                    child: Container(
                      width: 180,
                      height: 130,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
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
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.foodName,
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.hotelName,
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(20),
                                color: Color.fromARGB(218, 241, 241, 241)),
                            width: width * 0.7,
                            height: height * 0.08,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                        Icons.location_on,
                                        size: 16,
                                      ),
                                      color: Color(0xFF756d54),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.location,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => RatingGuide(
                                        guideId: widget.uId,
                                        postId: widget.postId,
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
      bottomNavigationBar: Visibility(
        visible: !widget.fromFood,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          color: Colors.white,
          height: 80,
          child: Row(
            children: [
              Container(
                width: 100,
                child: StepperSwipe(
                  stepperValue: 1,
                  initialValue: 1,
                  withPlusMinus: true,
                  withFastCount: true,
                  speedTransitionLimitCount: 40,
                  onChanged: (int value) {
                    foodcount = value;
                  },
                  firstIncrementDuration: Duration(milliseconds: 250),
                  secondIncrementDuration: Duration(microseconds: 1),
                  direction: Axis.horizontal,
                  dragButtonColor: Color(0xFFbd91d4),
                  maxValue: 500,
                  minValue: 0,
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    _selectDateTime(context);
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
                          'order now',
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
