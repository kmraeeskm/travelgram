// ignore_for_file: prefer_const_constructors, camel_case_types, prefer_const_literals_to_create_immutables

import 'package:boxicons/boxicons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:travelgram/screen/add_post.dart';
import 'package:travelgram/screen/explore.dart';
import 'package:travelgram/screen/food_explore.dart';
import 'package:travelgram/screen/guide_explore.dart';
import 'package:travelgram/screen/home_screen.dart';
import 'package:travelgram/screen/hotel_screen.dart';
import 'package:travelgram/screen/profile.dart';

class IndexPageUser extends StatefulWidget {
  const IndexPageUser({super.key});

  @override
  State<IndexPageUser> createState() => Index_PageState();
}

class Index_PageState extends State<IndexPageUser> {
  int cIndex = 0;
  List pages = [
    HomeScreen(),
    FoodExplore(),
    Explore(),
    GuideExplore(),
    HotelScreen(),
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
          vertical: 8.0,
          horizontal: MediaQuery.of(context).size.width * 0.1,
        ),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  onTap(0);
                },
                child: AppBarIcon(
                  iconData: Boxicons.bx_home,
                  color: cIndex == 0 ? Color(0xFFbd91d4) : Colors.white,
                  iconColor: cIndex == 0 ? Colors.white : Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  onTap(1);
                },
                child: AppBarIcon(
                  iconData: Boxicons.bxs_pizza,
                  color: cIndex == 1 ? Color(0xFFbd91d4) : Colors.white,
                  iconColor: cIndex == 1 ? Colors.white : Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  onTap(2);
                },
                child: AppBarIcon(
                  iconData: Boxicons.bx_compass,
                  color: cIndex == 2 ? Color(0xFFbd91d4) : Colors.white,
                  iconColor: cIndex == 2 ? Colors.white : Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  onTap(3);
                },
                child: AppBarIcon(
                  iconData: CupertinoIcons.person_crop_circle_badge_checkmark,
                  color: cIndex == 3 ? Color(0xFFbd91d4) : Colors.white,
                  iconColor: cIndex == 3 ? Colors.white : Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  onTap(4);
                },
                child: AppBarIcon(
                  iconData: Boxicons.bx_building_house,
                  color: cIndex == 4 ? Color(0xFFbd91d4) : Colors.white,
                  iconColor: cIndex == 4 ? Colors.white : Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  onTap(5);
                },
                child: AppBarIcon(
                  iconData: CupertinoIcons.person,
                  color: cIndex == 5 ? Color(0xFFbd91d4) : Colors.white,
                  iconColor: cIndex == 5 ? Colors.white : Colors.black,
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
