// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelgram/screen/home_screen.dart';

class BookConfirm extends StatefulWidget {
  BookConfirm({
    super.key,
    // required this.datetime,
  });
  // final String datetime;
  // final String doc;
  @override
  State<BookConfirm> createState() => _BookConfirmState();
}

class _BookConfirmState extends State<BookConfirm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Center(
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(0xFFfde1d3),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                Positioned(
                  left: 180,
                  top: 80,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFFfae0e3),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                Positioned(
                  left: 40,
                  top: 80,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(0xFFe2e8fc),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                Center(
                  child: const Image(
                    image: AssetImage('assets/book.png'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Thanks for',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            Text(
              'booking 👍',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromARGB(255, 221, 239, 255),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              children: [
                                // Text(widget.datetime.split('-')[0]),
                                // Text(DateFormat('MMMM')
                                //     .format(DateTime.now())
                                //     .toString()
                                //     .substring(0, 3)),
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(
                              0xFF9391e3,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          // Text(
                          //   widget.doc,
                          //   style: TextStyle(
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          // Text(
                          //   '${widget.datetime.split('-')[1]}: 00 ${widget.datetime.split('-')[2]}',
                          // ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => HomeScreen()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(
                          0xFF9391e3,
                        ),
                        borderRadius: BorderRadius.circular(40)),
                    height: 40.0,
                    width: 80.0,
                    child: Center(
                      child: Text(
                        'ok',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
