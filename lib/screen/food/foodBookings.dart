import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FoodBookings extends StatefulWidget {
  final String foodId;

  const FoodBookings({super.key, required this.foodId});
  @override
  _FoodBookingsState createState() => _FoodBookingsState();
}

class _FoodBookingsState extends State<FoodBookings> {
  final List<DateTime> days = List<DateTime>.generate(
    8,
    (index) => DateTime.now().add(Duration(days: index)),
  );

  String selectedCollectionId = '';

  Future<List<QueryDocumentSnapshot>> fetchOrders(String collectionId) async {
    print('looing for $collectionId');
    print('looing for ${widget.foodId}');
    final snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.foodId)
        .collection(collectionId)
        .get();

    print(snapshot.docs);

    return snapshot.docs;
  }

  void navigateToOrders(BuildContext context, String collectionId) {
    setState(() {
      selectedCollectionId = collectionId;
    });
  }

  Future<DocumentSnapshot> fetchUser(String uId) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uId).get();

    return snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Bookings'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              itemBuilder: (context, index) {
                final DateTime day = days[index];
                final String dayText = day.day.toString();
                final String monthText = day.month.toString();
                final String formattedDate =
                    '${dayText.padLeft(2, '0')}/${monthText.padLeft(2, '0')}';

                final String collectionId =
                    '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';

                return GestureDetector(
                  onTap: () => navigateToOrders(context, collectionId),
                  child: Container(
                    width: 100,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(formattedDate),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: selectedCollectionId.isNotEmpty
                ? FutureBuilder<List<QueryDocumentSnapshot>>(
                    future: fetchOrders(selectedCollectionId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (snapshot.data == null ||
                          snapshot.data!.isEmpty) {
                        print(snapshot.data);
                        return Center(
                          child: Text('No orders for $selectedCollectionId'),
                        );
                      } else {
                        final orders = snapshot.data!;
                        return ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            final bookingId =
                                orders[index].get('bookingId').toString();
                            print(bookingId);

                            final foodName =
                                orders[index].get('foodName').toString();
                            print(foodName);

                            final amount =
                                orders[index].get('amount').toString();
                            final uId = orders[index].get('uId').toString();
                            print(orders);
                            print(amount);
                            print(uId);
                            return FutureBuilder<DocumentSnapshot>(
                              future: fetchUser(uId),
                              builder: (context, userSnapshot) {
                                if (userSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return ListTile(
                                    title: Text('Loading user...'),
                                  );
                                } else if (userSnapshot.hasError) {
                                  return ListTile(
                                    title: Text('Error loading user'),
                                  );
                                } else {
                                  // print(object)
                                  final userName = userSnapshot.data!
                                      .get('username')
                                      .toString();

                                  return ListTile(
                                    title: Text('Booking ID: $bookingId'),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Food Name: $foodName'),
                                        Text('Amount: $amount'),
                                        Text('User Name: $userName'),
                                      ],
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        );
                      }
                    },
                  )
                : Center(
                    child: Text('No collection selected'),
                  ),
          ),
        ],
      ),
    );
  }
}
