// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelgram/screen/food/foodBookings.dart';

import '../../auth/user_provider.dart';
import 'review_modal_sheet.dart';

class Foods extends StatefulWidget {
  const Foods({super.key});

  @override
  State<Foods> createState() => _FoodsState();
}

class _FoodsState extends State<Foods> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userModel = userProvider.userModel;
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
                    children: [],
                  ),
                ),
                Positioned(
                  top: 15,
                  left: 15,
                  child: SizedBox(
                    height: 40,
                    width: 200,
                    child: Text(
                      'Your Foods',
                      style: TextStyle(
                        fontSize: height * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: height * 0.1,
                  child: SizedBox(
                    height: height * 0.9,
                    width: width,
                    child: Container(
                      width: 180,
                      height: 130,
                      padding: EdgeInsets.only(top: 20),
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
                      child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        future: FirebaseFirestore.instance
                            .collection('foods')
                            .where('uId', isEqualTo: userModel!.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // While data is being fetched, show a loading indicator
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.data == null) {
                            // If an error occurs, display an error message
                            return Text('Add Some Foods');
                          } else {
                            // If data fetching is successful, process the documents
                            final List<
                                    QueryDocumentSnapshot<Map<String, dynamic>>>
                                documents = snapshot.data!.docs;

                            return Column(
                              children: documents.map((doc) {
                                final food = doc.get('food') as String;
                                final rating = doc.get('rating');
                                final image = doc.get('imageUrl') as String;
                                final id = doc.get('postId') as String;

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          FoodBookings(
                                                            foodId: id,
                                                          )));
                                            },
                                            child: CircleAvatar(
                                              radius: 30,
                                              backgroundImage:
                                                  NetworkImage(image),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                food,
                                                style: TextStyle(
                                                  fontSize: height * 0.02,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        context: context,
                                                        builder: (context) {
                                                          return ReviewModalSheet(
                                                            postID: id,
                                                          );
                                                        });
                                                  },
                                                  child: Text('view reviews')),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(rating.toString()),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            CupertinoIcons.star_fill,
                                            color: Color.fromARGB(
                                                255, 224, 211, 21),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          }
                        },
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
