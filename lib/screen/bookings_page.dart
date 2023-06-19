import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelgram/screen/ticket.dart';

import '../auth/user_provider.dart';

class BookingsPage extends StatelessWidget {
  const BookingsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userModel = userProvider.userModel;
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings'),
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection('bookings')
            .where('uId', isEqualTo: userModel!.uid)
            .get(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No bookings found.'),
            );
          } else {
            final bookings = snapshot.data!.docs;
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (BuildContext context, int index) {
                final booking = bookings[index].data();
                // Display booking data as needed
                return Ticket(docID: booking['bookingId']);
              },
            );
          }
        },
      ),
    );
  }
}
