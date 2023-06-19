// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:boxicons/boxicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:travelgram/auth/user_provider.dart';
import 'package:travelgram/screen/home_screen.dart';
import 'package:travelgram/utils/button_widget.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  String c = '';
  String p = '';
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _locController = TextEditingController();

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
      _locController.text = '$c,$p';
    });
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

  bool _isloading = false;

  Future uploadFile() async {
    setState(() {
      _isloading = true;
    });
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    var data = snap.data();
    if (data != null) {
      Map<String, dynamic> snapd = data as Map<String, dynamic>;
      if (snapd['type'] == 'traveller') {
        final file = File(pickedFile!.path!);
        final destination = 'posts/${pickedFile!.name}';

        task = FirebaseApi.uploadFile(destination, file);
        setState(() {});

        final snapshot = await task!.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();
        String location =
            _locController.text.replaceAll(" ", "").trim().toLowerCase();
        String postId = const Uuid().v1();
        try {
          await _firestore.collection('posts').doc(postId).set({
            'postId': postId,
            'uId': user.uid,
            'imageUrl': urlDownload,
            'location': location,
            'time': DateTime.now(),
            'description': _descController.text,
            'name': snapd['username'],
            'proPic': snapd['photourl'],
            'likes': [],
          });
        } catch (e) {
          print(e.toString());
        }

        try {
          await _firestore.collection('users').doc(user.uid).update({
            'posts': FieldValue.arrayUnion([postId])
          });
        } catch (e) {
          print(e.toString());
        }
      } else {
        if (snapd['type'] == 'hotel') {
          final file = File(pickedFile!.path!);
          final destination = 'hotels/${pickedFile!.name}';

          task = FirebaseApi.uploadFile(destination, file);
          setState(() {});

          final snapshot = await task!.whenComplete(() {});
          final urlDownload = await snapshot.ref.getDownloadURL();

          String postId = const Uuid().v1();
          try {
            await _firestore.collection('hotels').doc(postId).set({
              'postId': postId,
              'uId': user.uid,
              'imageUrl': urlDownload,
              'location': '$c,$p',
              'time': DateTime.now(),
              'description': _descController.text,
              'name': snapd['username'],
              'proPic': snapd['photourl'],
              'likes': [],
            });
          } catch (e) {
            print(e.toString());
          }

          try {
            await _firestore.collection('users').doc(user.uid).update({
              'hotels': FieldValue.arrayUnion([postId])
            });
          } catch (e) {
            print(e.toString());
          }
        }
      }
    }
    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userModel = userProvider.userModel;

    final fileName =
        pickedFile != null ? basename(pickedFile!.name) : 'No File Selected';
    if (pickedFile != null) print(pickedFile!.path!);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Post',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        // actions: [
        //   AppBarIcon(
        //     iconData: Boxicons.bx_chat,
        //     color: Colors.white,
        //     iconColor: Colors.black,
        //   ),
        //   SizedBox(
        //     width: 16,
        //   ),
        //   AppBarIcon(
        //     iconData: Boxicons.bx_message,
        //     color: Colors.white,
        //     iconColor: Colors.black,
        //   ),
        //   SizedBox(
        //     width: 16,
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              if (pickedFile == null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(
                    image: AssetImage('assets/upload_image.gif'),
                  ),
                ),
              if (pickedFile != null)
                SizedBox(
                  height: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      File(
                        pickedFile!.path!,
                      ),
                    ),
                  ),
                ),
              if (pickedFile == null)
                GestureDetector(
                  onTap: selectFile,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Icon(
                          Boxicons.bxs_hand,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFbd91d4),
                    ),
                  ),
                ),
              // ButtonWidget(
              //   text: '',
              //   icon: Boxicons.bxs_hand,
              //   onClicked: selectFile,
              // ),
              if (pickedFile != null)
                ButtonWidget(
                  text: 'Replace File',
                  icon: Icons.attach_file,
                  onClicked: selectFile,
                ),
              const SizedBox(height: 8),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 185, 184, 184),
                      spreadRadius: 0,
                      blurRadius: 4,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: TextField(
                                    controller: _locController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Text('location'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.chevron_right_sharp),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 185, 184, 184),
                      spreadRadius: 0,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _descController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Say something about this place',
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFbd91d4),
                  ),
                  onPressed: () async {
                    await uploadFile();
                    Navigator.popUntil(context, (route) => route.isFirst);

                    final snackBar = SnackBar(
                      /// need to set following properties for best effect of awesome_snackbar_content
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Yay',
                        message: 'Post Added',

                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                        contentType: ContentType.success,
                      ),
                    );

                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                  },
                  child: _isloading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Add post',
                          style: TextStyle(color: Colors.white),
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

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
