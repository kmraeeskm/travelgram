// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:travelgram/auth/user_provider.dart';
import 'package:travelgram/indexPage.dart';
import 'package:travelgram/page_for_user.dart';
import 'package:travelgram/screen/home_screen.dart';
import 'package:travelgram/screen/login_screen.dart';
import 'package:travelgram/auth/auth_methods.dart';

import '.env';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey = pk;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      brightness: Brightness.light,
      textTheme: GoogleFonts.latoTextTheme(),
      primaryColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0, // remove the drop shadow
      ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        title: 'Travelgram',
        home: UserAuth(),
      ),
    );
  }
}

class UserAuth extends StatelessWidget {
  const UserAuth({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    if (auth.isAuthenticated) {
      return Consumer<UserProvider>(builder: (context, userProvider, child) {
        if (userProvider.userModel == null) {
          // load the user data and update the provider
          final authmeth = authmethods();
          authmeth.getuserdetails().then((userModel) {
            userProvider.setUserModel(userModel);
          });
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return IndexPage();
      });
    } else {
      return loginscreen();
    }
  }
}
