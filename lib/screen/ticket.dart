// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:intl/intl.dart';

import '../auth/user_provider.dart';

class Ticket extends StatelessWidget {
  String formatDateRange(String startDate, String endDate) {
    print(startDate);
    print(endDate);
    final startDateTime = DateTime.parse(startDate);
    print(startDateTime);
    final endDateTime = DateTime.parse(endDate);

    final startFormatted = DateFormat.MMMMd().format(startDateTime);
    final endFormatted = DateFormat.MMMMd().format(endDateTime);

    return '$startFormatted to $endFormatted';
  }

  Ticket({super.key, required this.docID});

  final String docID;
  bool _passed = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userModel = userProvider.userModel;
    CollectionReference users = _firestore.collection('bookings');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(docID).get(),
      builder: (((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> snap =
              snapshot.data!.data() as Map<String, dynamic>;
          String dateRange = formatDateRange(
              snap["dates"].toString().split(" ")[0],
              snap["dates"].toString().split(" ")[3].replaceAll("-", ""));
          return Container(
            child: GestureDetector(
              onTap: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => NewDetailsScrollable(dSnap: snap),
                //   ),
                // );
              },
              child: SizedBox(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 235, 230, 229),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(21),
                            topRight: Radius.circular(
                              21,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(userModel!.username),
                                FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection('hotels')
                                      .doc(snap['hostelId'])
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Text('');
                                    }
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }
                                    if (snapshot.hasData) {
                                      final hostelData = snapshot.data!.data()
                                          as Map<String, dynamic>;

                                      print(hostelData);

                                      final hostelName =
                                          hostelData['name'] ?? '';
                                      return Text(hostelName);
                                    }
                                    return Text('Hostel Name');
                                  },
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                QrImage(
                                  data: snap['bookingId'],
                                  version: QrVersions.auto,
                                  size: 100.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: const Color.fromARGB(255, 102, 157, 202),
                        child: Row(
                          children: [
                            const SizedBox(
                              height: 20,
                              width: 10,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: LayoutBuilder(
                                  builder: (BuildContext context,
                                      BoxConstraints constraints) {
                                    return Flex(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      direction: Axis.horizontal,
                                      mainAxisSize: MainAxisSize.max,
                                      children: List.generate(
                                        (constraints.constrainWidth() / 15)
                                            .floor(),
                                        (index) => const SizedBox(
                                          width: 5,
                                          height: 1,
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                              width: 10,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 102, 157, 202),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(21),
                            bottomRight: Radius.circular(
                              21,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(snap['rooms'].toString()),
                                    Text('Rooms'),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(dateRange),
                                    Text('Date'),
                                  ],
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
            ),
          );
        }
        return CircularProgressIndicator();
      })),
    );
  }
}
