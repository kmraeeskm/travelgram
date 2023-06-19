// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Rating extends StatefulWidget {
  const Rating({
    super.key,
    required this.mentorID,
    required this.type,
  });
  final String mentorID;
  final String type;

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _comment = TextEditingController();
  void addRating() async {
    // final docRef =
    //     FirebaseFirestore.instance.collection('users').doc(widget.mentorID);
    // final docSnapshot = await docRef.get();

    // final oldRating = docSnapshot.data()!['rating'];
    // final oldReviewCount = docSnapshot.data()!['ratingCount'];

    // final newRatingCount = oldReviewCount + 1;
    // final newRating = (oldRating * oldReviewCount + stars) / newRatingCount;
    // await docRef.update({
    //   'rating': newRating,
    //   'ratingCount': newRatingCount,
    // });

    final CollectionReference commentsCollection =
        FirebaseFirestore.instance.collection('comments');
    final DocumentReference ratingDocumentRef = commentsCollection
        .doc(widget.mentorID)
        .collection(widget.type)
        .doc('rating');

// Check if the document exists
    final DocumentSnapshot ratingSnapshot = await ratingDocumentRef.get();
    if (!ratingSnapshot.exists) {
      // Create the document if it doesn't exist
      await ratingDocumentRef.set({
        'rating': 0,
        'ratingCount': 0,
      });
    }

// Read the rating value from the document
    final docSnapshot = await ratingDocumentRef.get();

    // final oldRating = ratingSnapshot.get('rating');
    // final oldReviewCount = ratingSnapshot.get('ratingCount');
    final oldRating = docSnapshot['rating'];
    final oldReviewCount = docSnapshot['ratingCount'];

    final newRatingCount = oldReviewCount + 1;
    final newRating = (oldRating * oldReviewCount + stars) / newRatingCount;
    await ratingDocumentRef.update({
      'rating': newRating,
      'ratingCount': newRatingCount,
    });

    //end
    // Update the document

    String commentID = const Uuid().v1();
    await _firestore
        .collection('comments')
        .doc(widget.mentorID)
        .collection(widget.type)
        .doc(commentID)
        .set({
      'comment': _comment.text.trim(),
      'from': user.uid,
    });

    Navigator.pop(context);
  }

  int stars = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image(
              image: AssetImage('assets/rating.png'),
            ),
            Column(
              children: [
                Text(
                  'Rate your',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Text(
                  'experience',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 80,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        stars = 1;
                      });
                      print(stars);
                    },
                    child: stars >= 1
                        ? FaIcon(
                            FontAwesomeIcons.star,
                            color: Colors.yellow,
                          )
                        : FaIcon(
                            FontAwesomeIcons.star,
                            color: Colors.white,
                          ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        stars = 2;
                      });
                      print(stars);
                    },
                    child: stars >= 2
                        ? FaIcon(
                            FontAwesomeIcons.star,
                            color: Colors.yellow,
                          )
                        : FaIcon(
                            FontAwesomeIcons.star,
                            color: Colors.white,
                          ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        stars = 3;
                      });
                      print(stars);
                    },
                    child: stars >= 3
                        ? FaIcon(
                            FontAwesomeIcons.star,
                            color: Colors.yellow,
                          )
                        : FaIcon(
                            FontAwesomeIcons.star,
                            color: Colors.white,
                          ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        stars = 4;
                      });
                    },
                    child: stars >= 4
                        ? FaIcon(
                            FontAwesomeIcons.star,
                            color: Colors.yellow,
                          )
                        : FaIcon(
                            FontAwesomeIcons.star,
                            color: Colors.white,
                          ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        stars = 5;
                      });
                    },
                    child: stars >= 5
                        ? FaIcon(
                            FontAwesomeIcons.star,
                            color: Colors.yellow,
                          )
                        : FaIcon(
                            FontAwesomeIcons.star,
                            color: Colors.white,
                          ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(30),
              height: 120, // set the desired height of the container
              child: TextField(
                controller: _comment,
                maxLines: 4, // set the maximum number of lines
                decoration: InputDecoration(
                  hintText: 'Write your review here...',
                  border:
                      OutlineInputBorder(), // add a border to the text field
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                addRating();
              },
              child: Container(
                width: 100,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                ),
                child: Center(child: Text('Send')),
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
