// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class Bookings extends StatefulWidget {
  const Bookings({super.key});

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  String c = '';
  String p = '';

  @override
  void initState() {
    super.initState();
    try {
      getUserLocation();
    } catch (e) {
      print(e.toString());
    }
  }

  PlatformFile? pickedFile;
  UploadTask? task;
  File? file;
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.first;

    setState(() => pickedFile = path);
  }

  getUserLocation() async {
    PermissionStatus status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      status = await Permission.locationWhenInUse.request();
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await GeocodingPlatform.instance
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    print(placemark);
    String city = '${placemark.locality}';
    String administrativeArea = '${placemark.administrativeArea}';
    setState(() {
      c = city;
      p = administrativeArea;
    });
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
                        (pickedFile == null)
                            ? GestureDetector(
                                onTap: selectFile,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: height * 0.3,
                                      width: width,
                                      child: Image(
                                        image:
                                            AssetImage('assets/add_food.png'),
                                      ),
                                    ),
                                    Text('Add food photo'),
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: height * 0.53,
                                width: width,
                                child: Image.file(
                                  fit: BoxFit.cover,
                                  File(
                                    pickedFile!.path!,
                                  ),
                                ),
                              ),
                      ],
                    )),
                Positioned(
                  top: 15,
                  left: 15,
                  child: SizedBox(
                    height: 40,
                    width: 200,
                    child: Container(
                      padding: EdgeInsets.only(top: 13, left: 10),
                      decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Food Name',
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.03,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: height * 0.5,
                  child: SizedBox(
                    height: height * 0.5,
                    width: width,
                    child: ClipPath(
                      clipper:
                          CustomClipperRectangle(sizeW: width, sizeH: height),
                      child: Container(
                        width: 180,
                        height: 130,
                        decoration: BoxDecoration(
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
                            TextField(
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Hotel Name',
                              ),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: height * 0.025),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black,
                                  ),
                                  width: width * 0.1,
                                  height: height * 0.1,
                                  child: Center(
                                    child: Text(
                                      'S',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black,
                                  ),
                                  width: width * 0.1,
                                  height: height * 0.1,
                                  child: Center(
                                    child: Text(
                                      'M',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black,
                                  ),
                                  width: width * 0.1,
                                  height: height * 0.1,
                                  child: Center(
                                    child: Text(
                                      'L',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color.fromARGB(218, 241, 241, 241)),
                              width: width * 0.6,
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
                                            Icons.location_on,
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
                                          Text("$c, $p"),
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
                                  // Navigator.of(context).push(
                                  //     MaterialPageRoute(builder: (_) => DatePicker()));
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
                                        'Add now',
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
