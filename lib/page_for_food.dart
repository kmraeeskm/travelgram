// ignore_for_file: prefer_const_constructors, camel_case_types, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travelgram/screen/food/AddFood.dart';
import 'package:travelgram/screen/food/foodBookings.dart';
import 'package:travelgram/screen/profile.dart';
import 'screen/food/foods.dart';

class IndexPageFood extends StatefulWidget {
  const IndexPageFood({super.key});

  @override
  State<IndexPageFood> createState() => Index_PageState();
}

class Index_PageState extends State<IndexPageFood> {
  int cIndex = 0;
  List pages = [
    Foods(),
    AddFood(),
    ProfilePage(),
  ];

  void onTap(index) {
    setState(() {
      cIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: pages[cIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 8.0, horizontal: MediaQuery.of(context).size.width * 0.2),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 185, 184, 184),
                  spreadRadius: 0,
                  blurRadius: 4,
                )
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  onTap(0);
                },
                child: AppBarIcon(
                  iconData: CupertinoIcons.home,
                  color: cIndex == 0 ? Color(0xFFbd91d4) : Colors.white,
                  iconColor: cIndex == 0 ? Colors.white : Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  onTap(1);
                },
                child: AppBarIcon(
                  iconData: CupertinoIcons.add,
                  color: cIndex == 1 ? Color(0xFFbd91d4) : Colors.white,
                  iconColor: cIndex == 1 ? Colors.white : Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  onTap(2);
                },
                child: AppBarIcon(
                  iconData: CupertinoIcons.profile_circled,
                  color: cIndex == 2 ? Color(0xFFbd91d4) : Colors.white,
                  iconColor: cIndex == 2 ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBarIcon extends StatelessWidget {
  const AppBarIcon({
    super.key,
    required this.iconData,
    required this.color,
    required this.iconColor,
  });
  final IconData iconData;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 236, 236, 236),
            spreadRadius: 3,
            blurRadius: 4,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          iconData,
          color: iconColor,
        ),
      ),
    );
  }
}
