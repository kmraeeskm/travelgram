// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:travelgram/screen/add_post.dart';
import 'package:uuid/uuid.dart';

class AddGuidePlace extends StatefulWidget {
  const AddGuidePlace({super.key});

  @override
  State<AddGuidePlace> createState() => _AddGuidePlaceState();
}

class _AddGuidePlaceState extends State<AddGuidePlace> {
  String c = '';
  String p = '';
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _hotelNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String lalo = '';

  void showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Uploading Data'),
          content: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  void hideProgressDialog(VoidCallback hideCallback) {
    hideCallback();
  }

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
      lalo = '${position.latitude} ${position.longitude}';
      c = city;
      p = administrativeArea;
      _locationController.text = '$c, $p';
    });
  }

  bool _isloading = false;

  Future uploadHostel() async {
    setState(() {
      _isloading = true;
    });
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    final fileMain = File(pickedFile!.path!);
    String postId = const Uuid().v1();
    final destination = 'foods/$postId';

    task = FirebaseApi.uploadFile(destination, fileMain);
    setState(() {});

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    String location =
        _locationController.text.replaceAll(" ", "").trim().toLowerCase();

    try {
      _firestore.collection('guides').doc(postId).set({
        'postId': postId,
        'uId': user.uid,
        'imageUrl': urlDownload,
        'location': location,
        'price': _priceController.text,
        'duration': _durationController.text,
        'description': _descriptionController.text,
        'time': DateTime.now(),
        'rating': 0,
        'ratingCount': 0,
      });
    } catch (e) {
      print(e.toString());
    }

    try {
      _firestore.collection('users').doc(user.uid).update({
        'guides': FieldValue.arrayUnion([postId])
      });
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      _isloading = false;
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
                                    Text('Add place photo'),
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
                  top: height * 0.36,
                  left: 15,
                  child: SizedBox(
                    width: 200,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(48, 255, 255, 255),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 45,
                            width: 150,
                            child: TextField(
                              enabled: false,
                              controller: _locationController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
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
                  top: height * 0.45,
                  child: SizedBox(
                    height: height * 0.45,
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
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 45,
                                              width: 50,
                                              child: TextField(
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
                              onTap: () async {
                                await uploadHostel();
                                final snackBar = SnackBar(
                                  /// need to set following properties for best effect of awesome_snackbar_content
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  content: AwesomeSnackbarContent(
                                    title: 'Yay',
                                    message: 'Wait people to contact you now.',

                                    /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                    contentType: ContentType.success,
                                  ),
                                );

                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(snackBar);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.black,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: _isloading
                                        ? const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text(
                                            'Add now',
                                            style:
                                                TextStyle(color: Colors.white),
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
