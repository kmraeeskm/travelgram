// ignore_for_file: prefer_const_constructors, unnecessary_new, sort_child_properties_last

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travelgram/auth/auth_methods.dart';
import 'package:travelgram/page_for_user.dart';
import 'package:travelgram/screen/home_screen.dart';
import 'package:travelgram/screen/login_screen.dart';
import 'package:travelgram/utils/utils.dart';

class signupscreen extends StatefulWidget {
  const signupscreen({super.key});

  @override
  State<signupscreen> createState() => _signupscreenState();
}

class _signupscreenState extends State<signupscreen> {
  List<String> type = ['traveller', 'hotel', 'guide', 'food']; // Option 2
  String _selectedUserType = 'traveller'; // Option 2

  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  bool _isloading = false;
  Uint8List? _image;

  void navigatetologin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const loginscreen(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _pass.dispose();
    _username.dispose();
    _phone.dispose();
  }

  void selectImage() async {
    Uint8List? im = await pickImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  void Signhotel() async {
    setState(() {
      _isloading = true;
    });
    String results = await authmethods().storehotel(
        username: _username.text,
        email: _email.text,
        phone: _phone.text,
        password: _pass.text,
        type: _selectedUserType,
        file: _image!);
    setState(() {
      _isloading = false;
    });
    if (results != 'succes') {
      showSnakBar(results, context);
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => loginscreen()));
    }
  }

  void Signfood() async {
    setState(() {
      _isloading = true;
    });
    String results = await authmethods().storehotel(
        username: _username.text,
        email: _email.text,
        phone: _phone.text,
        password: _pass.text,
        type: _selectedUserType,
        file: _image!);
    setState(() {
      _isloading = false;
    });
    if (results != 'succes') {
      showSnakBar(results, context);
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => loginscreen()));
    }
  }

  void SignuUser() async {
    setState(() {
      _isloading = true;
    });
    String results = await authmethods().signupuser(
        username: _username.text,
        email: _email.text,
        phone: _phone.text,
        password: _pass.text,
        type: "traveller",
        file: _image!);
    setState(() {
      _isloading = false;
    });
    if (results != 'succes') {
      showSnakBar(results, context);
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => loginscreen()));
    }
  }

  void Signguide() async {
    setState(() {
      _isloading = true;
    });

    String results = await authmethods().signupuser(
        username: _username.text,
        email: _email.text,
        phone: _phone.text,
        password: _pass.text,
        type: _selectedUserType,
        file: _image!);
    setState(() {
      _isloading = false;
    });
    if (results != 'succes') {
      showSnakBar(results, context);
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => loginscreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                color: Color(0xFFc3dbf4),
                child: Image(
                  image: AssetImage('assets/PlaneLoop.gif'),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(height: 150),
                    //Image.asset('assets/Travel-Icon-PNG-Transparent-Image.png',
                    //  height: 120),
                    //const SizedBox(height: 60),
                    Stack(
                      children: [
                        _image != null
                            ? CircleAvatar(
                                radius: 64,
                                backgroundImage: MemoryImage(_image!),
                              )
                            : const CircleAvatar(
                                radius: 64,
                                backgroundImage:
                                    AssetImage('assets/images.png')),
                        Positioned(
                          bottom: -5,
                          right: -5,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(Icons.add_a_photo),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // DropdownButton<String>(
                    //   items: <String>['A', 'B', 'C', 'D'].map((String value) {
                    //     return DropdownMenuItem<String>(
                    //       value: value,
                    //       child: Text(value),
                    //     );
                    //   }).toList(),
                    //   onChanged: (_) {},
                    // ),

                    DropdownButton(
                      hint: Text('Please choose a location'),
                      value: _selectedUserType,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedUserType = newValue!;
                        });
                      },
                      items: type.map((location) {
                        return DropdownMenuItem(
                          child: Text(location),
                          value: location,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _username,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Username',
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      controller: _email,
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Phone number',
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      controller: _phone,
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      controller: _pass,
                    ),
                    const SizedBox(height: 16),

                    InkWell(
                      onTap: () {
                        if (_selectedUserType == "traveller") {
                          SignuUser();
                        } else if (_selectedUserType == "hotel") {
                          Signhotel();
                        } else {
                          if (_selectedUserType == "food") {
                            Signhotel();
                          } else {
                            Signguide();
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const ShapeDecoration(
                          color: Color.fromARGB(255, 78, 154, 216),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        child: _isloading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Signup'),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text('have an account?  '),
                        ),
                        GestureDetector(
                          onTap: navigatetologin,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: const Text(
                              'login',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
