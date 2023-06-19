import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserListForAnalysis extends StatefulWidget {
  List<String> ids;
  final bool c;
  UserListForAnalysis({super.key, required this.ids, this.c = true});

  @override
  State<UserListForAnalysis> createState() => _UserListForAnalysisState();
}

class _UserListForAnalysisState extends State<UserListForAnalysis> {
  List<dynamic> participantIDs = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  getParticipantIDs() async {
    participantIDs = widget.ids;
    print(participantIDs);
  }

  @override
  void initState() {
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    print("setting back to 0");
    participantIDs = [];
    return FutureBuilder(
      future: getParticipantIDs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              widget.c ? 'Current Inmates' : 'Upcoming Inmates',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
          body: SizedBox(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: participantIDs.length > 0
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: participantIDs.length,
                        itemBuilder: (BuildContext context, int index) {
                          CollectionReference user =
                              _firestore.collection('bookings');
                          return FutureBuilder<DocumentSnapshot>(
                            future: user.doc(participantIDs[index]).get(),
                            builder: (((context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                print(snapshot.data!.data());
                                Map<String, dynamic> snap = snapshot.data!
                                    .data() as Map<String, dynamic>;
                                print("snap");
                                print(snap);
                                return FutureBuilder<DocumentSnapshot>(
                                    future: _firestore
                                        .collection('users')
                                        .doc(snap['uId'])
                                        .get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        String dateRange = formatDateRange(
                                            snap["dates"]
                                                .toString()
                                                .split(" ")[0],
                                            snap["dates"]
                                                .toString()
                                                .split(" ")[3]
                                                .replaceAll("-", ""));
                                        print(snapshot.data!.data());
                                        Map<String, dynamic> eventSnap =
                                            snapshot.data!.data()
                                                as Map<String, dynamic>;
                                        print("eventSnap");
                                        print(eventSnap);
                                        return GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            height: 100,
                                            margin: EdgeInsets.only(bottom: 16),
                                            decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 228, 228, 228),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    blurRadius: 4,
                                                    color: Color(0xFFBCCEF8),
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            CircleAvatar(
                                                              radius: 30,
                                                              backgroundColor:
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          224,
                                                                          223,
                                                                          223),
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                eventSnap[
                                                                    'photourl'],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              width: 100,
                                                              child: Text(
                                                                eventSnap[
                                                                    'username'],
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                width: 100,
                                                                child: Text(
                                                                  eventSnap[
                                                                      'email'],
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                )),
                                                            // Text(
                                                            //   snap['college']
                                                            //       .toString()
                                                            //       .substring(
                                                            //           0,
                                                            //           snap['college']
                                                            //                   .toString()
                                                            //                   .length -
                                                            //               8),
                                                            //   style: const TextStyle(
                                                            //       fontSize: 12),
                                                            // ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Chip(
                                                      label: Text(dateRange),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      return Container();
                                    });
                              }
                              return Container();
                            })),
                          );
                        },
                      )
                    : Center(
                        child: widget.c
                            ? Text('No one\'s staying now')
                            : Text('No upcoming bookings'),
                      )),
          ),
        );
      },
    );
  }
}
