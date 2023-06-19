// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:boxicons/boxicons.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:travelgram/auth/user_provider.dart';
import 'package:travelgram/page_for_hotel.dart';
import 'package:travelgram/screen/hotel/qr_scanner.dart';
import 'package:travelgram/screen/hotel/userlist.dart';

class DashBoardHostel extends StatefulWidget {
  const DashBoardHostel({super.key});

  @override
  State<DashBoardHostel> createState() => _DashBoardHostelState();
}

class _DashBoardHostelState extends State<DashBoardHostel> {
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    bool isTodayBetweenDates(DateTime startDate, DateTime endDate) {
      final now = DateTime.now();
      return now.isAfter(startDate) && now.isBefore(endDate);
    }

    bool isStartDateUpcoming(DateTime startDate) {
      final now = DateTime.now();
      return now.isBefore(startDate);
    }

    int inmates = 0;
    List<String> cInmates = [];
    List<String> uInmates = [];

    Future check(List<String> xp) async {
      for (var x in xp) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('bookings')
            .doc(x)
            .get();

        final bookingData = doc.data() as Map<String, dynamic>;
        if (bookingData != null && bookingData.containsKey('dates')) {
          final dates = bookingData['dates'];
          final startDate = DateTime.parse(dates.toString().split(' ')[0]);
          final endDate = DateTime.parse(dates.toString().split(' ')[3]);
          if (isTodayBetweenDates(startDate, endDate)) {
            inmates += 1;
            cInmates.add(x);
          } else {
            if (isStartDateUpcoming(startDate)) {
              print('upcoming');
              uInmates.add(x);
            } else {
              print('Today is not between the specified dates.');
            }
          }
        }
      }
      print(cInmates);
      print(uInmates);
    }

    final double height = MediaQuery.of(context).size.height;

    final userProvider = Provider.of<UserProvider>(context);
    final userModel = userProvider.userModel;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(
          'Travelgram',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QRScanner(),
              ),
            ),
            child: AppBarIcon(
              iconData: Boxicons.bx_qr,
              color: Colors.white,
              iconColor: Colors.black,
            ),
          ),
          SizedBox(
            width: 16,
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (context, snapshota) {
            if (snapshota.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            print('#1');
            final data = snapshota.data!.data() as Map<String, dynamic>;
            print("data");
            print(data);
            print("data");
            if (!data.containsKey('hotels')) {
              return Center(
                child: Text('Please Add your hotel to continue'),
              );
            }
            // print(data['hotels'][0]);
            return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('hotels')
                    .doc(data['hotels'][0])
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data!.data() == null) {
                    return Center(
                      child: Text('Please Add hotels to continue'),
                    );
                  }

                  print('#2');
                  print(snapshot.data!.data());

                  print('#3');
                  print("snapshot.data!.data()");
                  print(snapshot.data!.data());
                  final datas = snapshot.data!.data() as Map<String, dynamic>;
                  print("datas");
                  print(datas);
                  print("data.containsKey('bookings')");
                  print(datas.containsKey('bookings'));
                  if (datas != null && datas.containsKey('bookings')) {
                    final bookings = List<String>.from(datas['bookings']);
                    print(bookings);

                    return FutureBuilder<dynamic>(
                        future: check(bookings),
                        builder: (context, snapshot) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text.rich(
                                  TextSpan(
                                    text: 'Hello\n',
                                    style: TextStyle(
                                      fontSize: height * 0.035,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '${userModel!.username} 🛏️\n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: height * 0.04,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.05,
                              ),
                              SizedBox(
                                  height: height * 0.35,
                                  child: CircularSeekBar(
                                    width: double.infinity,
                                    height: 250,
                                    progress: double.parse(inmates.toString()),
                                    barWidth: 8,
                                    startAngle: 45,
                                    sweepAngle: 270,
                                    strokeCap: StrokeCap.butt,
                                    progressGradientColors: const [
                                      Colors.red,
                                      Colors.orange,
                                      Colors.yellow,
                                      Colors.green,
                                      Colors.blue,
                                      Colors.indigo,
                                      Colors.purple
                                    ],
                                    innerThumbRadius: 5,
                                    innerThumbStrokeWidth: 3,
                                    innerThumbColor: Colors.white,
                                    outerThumbRadius: 5,
                                    outerThumbStrokeWidth: 10,
                                    outerThumbColor: Colors.blueAccent,
                                    dashWidth: 1,
                                    dashGap: 2,
                                    animation: true,
                                    // valueNotifier: _valueNotifier,
                                    child: Center(
                                      child: ValueListenableBuilder(
                                          valueListenable: _valueNotifier,
                                          builder: (_, double value, __) =>
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                      '$inmates/${datas["roomCount"]}',
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                  Text('Capacity',
                                                      style: TextStyle()),
                                                ],
                                              )),
                                    ),
                                  )),
                              SizedBox(
                                height: 200,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // Navigator.of(context).push(
                                        //   MaterialPageRoute(
                                        //     builder: (_) => Patients(),
                                        //   ),
                                        // );
                                      },
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      UserListForAnalysis(
                                                        ids: cInmates,
                                                      )));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(30),
                                            ),
                                            color: Color(0xFFe5e5fe),
                                          ),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.23,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.38,
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(18.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        // borderRadius: BorderRadius.circular(100),
                                                        color: Color(
                                                          0xFFd7d5fc,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Center(
                                                          child: FaIcon(
                                                              FontAwesomeIcons
                                                                  .peopleLine),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 60,
                                                    ),
                                                    Text(
                                                      'Current\nInmates',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    // FutureBuilder<int>(
                                                    //     future: getPatientsCount(user.uid),
                                                    //     builder: (context, snapshot) {
                                                    //       if (snapshot.hasData) {
                                                    //         int count = snapshot.data!;
                                                    //         return Text('$count pharmacies');
                                                    //       }
                                                    //       return Container();
                                                    //     }),
                                                  ],
                                                ),
                                              ),
                                              Positioned(
                                                top: 10,
                                                right: 10,
                                                child: FaIcon(
                                                  FontAwesomeIcons.hotel,
                                                  color: Color(0xFFd7d5fc),
                                                  size: 40,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    UserListForAnalysis(
                                                      c: false,
                                                      ids: uInmates,
                                                    )));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          color: Color(0xFFe5e5fe),
                                        ),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.23,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.38,
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(18.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      color: Color(
                                                        0xFFd7d5fc,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Center(
                                                        child: FaIcon(
                                                            FontAwesomeIcons
                                                                .peopleGroup),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 60,
                                                  ),
                                                  Text(
                                                    'Upcoming Inmates',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  // FutureBuilder<int>(
                                                  //     future: getPatientsCount(user.uid),
                                                  //     builder: (context, snapshot) {
                                                  //       if (snapshot.hasData) {
                                                  //         int count = snapshot.data!;
                                                  //         return Text('$count pharmacies');
                                                  //       }
                                                  //       return Container();
                                                  //     }),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              top: 10,
                                              right: 10,
                                              child: FaIcon(
                                                FontAwesomeIcons.hotel,
                                                color: Color(0xFFd7d5fc),
                                                size: 40,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        });
                    // return ListView.builder(
                    //   itemCount: bookings.length,
                    //   itemBuilder: (BuildContext context, int index) {
                    //     print(bookings.length);

                    //   },
                    // );
                  } else {
                    return Center(
                      child: Text('No bookings yet'),
                    );
                  }
                });
          }),
    );
  }
}
