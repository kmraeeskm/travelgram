// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stepper_counter_swipe/stepper_counter_swipe.dart';
import 'package:travelgram/screen/add_post.dart';
import 'package:travelgram/screen/date.dart';
import 'package:travelgram/screen/home_screen.dart';
import 'package:travelgram/screen/hotel/booking_confirm.dart';
import 'package:travelgram/utils/show_more.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:travelgram/.env';

class HotelDetails extends StatefulWidget {
  var snap;
  HotelDetails({super.key, required this.snap});

  @override
  State<HotelDetails> createState() => _HotelDetailsState();
}

class _HotelDetailsState extends State<HotelDetails> {
  List<DateTime> _disabledDates = [
    DateTime.now().add(Duration(days: 1)),
    DateTime.now().add(Duration(days: 2)),
    DateTime.now().add(Duration(days: 3)),
  ];
  DateTime? startDate;
  int roomcount = 1;
  DateTime? endDate;
  Map<String, dynamic>? paymentIntent;

  Future uploadHostel() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    String BookingId = const Uuid().v1();

    try {
      _firestore.collection('bookings').doc(BookingId).set({
        'bookingId': BookingId,
        'uId': user.uid,
        'hostelId': widget.snap['postId'],
        'time': DateTime.now(),
        'dates': '$startDate - $endDate',
        'rooms': roomcount,
      });
    } catch (e) {
      print(e.toString());
    }

    try {
      _firestore.collection('hotels').doc(widget.snap['postId']).update({
        'bookings': FieldValue.arrayUnion([BookingId])
      });
    } catch (e) {
      print(e.toString());
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $sk',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          Text("Payment Successfull"),
                        ],
                      ),
                    ],
                  ),
                ));

        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));
        Navigator.of(context).pop();
        await uploadHostel();
        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  Future<void> selectDates() async {
    String str = '';
    showCustomDateRangePicker(
      context,
      dismissible: true,
      minimumDate: DateTime.now().subtract(const Duration(days: 30)),
      maximumDate: DateTime.now().add(const Duration(days: 30)),
      endDate: endDate,
      startDate: startDate,
      backgroundColor: Colors.white,
      primaryColor: Color.fromARGB(255, 204, 89, 127),
      onApplyClick: (start, end) async {
        setState(() {
          endDate = end;
          startDate = start;
          str = 'success';
        });
        await makePayment();
      },
      onCancelClick: () {
        setState(() {
          endDate = null;
          startDate = null;
        });
      },
    );
  }

  Future<void> makePayment() async {
    try {
      print(widget.snap['rate'].runtimeType);
      print(roomcount.runtimeType);
      print(widget.snap['rate'] * roomcount);
      int price = (widget.snap['rate'] * roomcount);
      print(price);
      print(price.runtimeType);
      paymentIntent = await createPaymentIntent(price.toString(), 'INR');
      //Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
                  // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Travel Gram'))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  Future showRoomCountDialog(BuildContext context) {
    print('H');
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        print('hello ');
        return AlertDialog(
          title: Text('Number of Rooms'),
          content: Container(
            height: 60,
            child: StepperSwipe(
              stepperValue: 10,
              initialValue: 0,
              withPlusMinus: true,
              withFastCount: true,
              speedTransitionLimitCount: 40,
              onChanged: (int value) {
                roomcount = value;
              },
              firstIncrementDuration: Duration(milliseconds: 250),
              secondIncrementDuration: Duration(microseconds: 1),
              direction: Axis.horizontal,
              dragButtonColor: Color(0xFFbd91d4),
              maxValue: 500,
              minValue: 0,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Perform any desired action when the user clicks the "OK" button
                // Access the roomCount variable here
                Navigator.pop(context); // Close the dialog box

                await uploadHostel();
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                // Perform any desired action when the user clicks the "Cancel" button
                Navigator.pop(context); // Close the dialog box
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: width * 0.9,
                  height: height * 0.5,
                  child: Stack(
                    children: [
                      Positioned(
                        left: width * 0.02,
                        child: SizedBox(
                          width: width * 0.9,
                          height: height * 0.5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                widget.snap['imageUrl'],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: height * 0.15,
                          child: ListView.builder(
                            itemCount: 4,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return HotelExtras(
                                width: width,
                                height: height,
                                url: widget.snap['subPics'][0],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  widget.snap['name'],
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  widget.snap['location'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                ExpandableShowMoreWidget(
                  text: widget.snap['description'],
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        color: Colors.white,
        height: 80,
        child: Row(
          children: [
            Container(
              width: 100,
              child: StepperSwipe(
                stepperValue: 1,
                initialValue: 1,
                withPlusMinus: true,
                withFastCount: true,
                speedTransitionLimitCount: 40,
                onChanged: (int value) {
                  roomcount = value;
                },
                firstIncrementDuration: Duration(milliseconds: 250),
                secondIncrementDuration: Duration(microseconds: 1),
                direction: Axis.horizontal,
                dragButtonColor: Color(0xFFbd91d4),
                maxValue: 500,
                minValue: 0,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  await selectDates();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Book now',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HotelExtras extends StatelessWidget {
  const HotelExtras({
    super.key,
    required this.width,
    required this.height,
    required this.url,
  });

  final double width;
  final String url;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: width * 0.3,
        height: height * 0.15,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image(
            fit: BoxFit.cover,
            image: NetworkImage(
              url,
            ),
          ),
        ),
      ),
    );
  }
}
