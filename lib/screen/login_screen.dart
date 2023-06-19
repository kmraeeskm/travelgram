import 'package:flutter/material.dart';
import 'package:travelgram/auth/auth_methods.dart';
import 'package:travelgram/indexPage.dart';
import 'package:travelgram/main.dart';
import 'package:travelgram/screen/home_screen.dart';
import 'package:travelgram/screen/signup_screen.dart';
import 'package:travelgram/utils/utils.dart';

class loginscreen extends StatefulWidget {
  const loginscreen({super.key});

  @override
  State<loginscreen> createState() => _loginscreenState();
}

class _loginscreenState extends State<loginscreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  bool _isloading = false;
  void navigatetosingnup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const signupscreen(),
      ),
    );
  }

  void loginUser() async {
    setState(() {
      _isloading = true;
    });
    String results = await authmethods().loginuser(
      email: _email.text,
      password: _pass.text,
    );
    if (results == 'succes') {
      // print("object")
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => MyApp()));
    } else {
      showSnakBar(results, context);
    }
    setState(() {
      _isloading = false;
    });
  }

  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFc3dbf4),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 100),
                Image.asset('assets/PlaneLoop.gif', height: 240),
                const SizedBox(height: 60),
                TextField(
                  controller: _email,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'mail id'),
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  controller: _pass,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'password'),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: loginUser,
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
                        : const Text('Log in'),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text('Dont have an account?  '),
                    ),
                    GestureDetector(
                      onTap: navigatetosingnup,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          'Signup',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
