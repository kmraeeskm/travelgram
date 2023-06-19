// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:boxicons/boxicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:travelgram/auth/auth_methods.dart';
import 'package:travelgram/auth/user_provider.dart';
import 'package:travelgram/screen/food/Food_details.dart';
import 'package:travelgram/screen/food/edit_food.dart';
import 'package:travelgram/screen/home_screen.dart';
import 'package:travelgram/screen/login_screen.dart';
import 'package:travelgram/screen/reccomendations_screen.dart';

class BookMarksPage extends StatefulWidget {
  const BookMarksPage({super.key});

  @override
  State<BookMarksPage> createState() => _BookMarksPageState();
}

class _BookMarksPageState extends State<BookMarksPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  List<dynamic> postIDsOfUser = [];
  List<QueryDocumentSnapshot> documents = [];
  void signOutUser() async {
    await authmethods().signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => loginscreen(),
      ),
    );
  }

  Future getpostIDsOfUser(String type) async {
    print(type);
    if (type == 'traveller') {
      await _firestore.collection('users').doc(user.uid).get().then((doc) {
        postIDsOfUser = doc.data()!['bookmarks'];
      });
    } else {
      if (type == 'hotel') {
        await _firestore.collection('users').doc(user.uid).get().then((doc) {
          print(doc.data()!['hotels']);
          postIDsOfUser = doc.data()!['hotels'];
        });
      } else {
        if (type == 'food') {
          await _firestore.collection('users').doc(user.uid).get().then((doc) {
            print(doc.data()!['foods']);
            postIDsOfUser = doc.data()!['foods'];
          });
        } else {
          await _firestore.collection('users').doc(user.uid).get().then((doc) {
            print(doc.data()!['guides']);
            postIDsOfUser = doc.data()!['guides'];
          });
        }
      }
    }
  }

  Future getPosts(List<dynamic> postIds, String type) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    List<Future<QuerySnapshot>> futures = [];

    if (type == 'traveller') {
      for (String id in postIds) {
        futures.add(_firestore
            .collection('posts')
            .where('postId', isEqualTo: id)
            .get());
      }
    } else {
      if (type == 'hotel') {
        for (String id in postIds) {
          futures.add(_firestore
              .collection('hotels')
              .where('postId', isEqualTo: id)
              .get());
        }
      } else {
        if (type == 'food') {
          for (String id in postIds) {
            print(id);
            futures.add(_firestore
                .collection('foods')
                .where('postId', isEqualTo: id)
                .get());
          }
        } else {
          for (String id in postIds) {
            print(id);
            futures.add(_firestore
                .collection('guides')
                .where('postId', isEqualTo: id)
                .get());
          }
        }
      }
    }

    List<QuerySnapshot> snapshots = await Future.wait(futures);

    documents = [];

    for (QuerySnapshot snapshot in snapshots) {
      print(snapshot.docs);
      print(snapshot.docs.first);

      try {
        documents.add(snapshot.docs.first);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userModel = userProvider.userModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bookmarks',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: FutureBuilder(
                  future: getpostIDsOfUser(userModel!.type),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }
                    if (postIDsOfUser.isEmpty) {
                      return Center(
                        child: Text('No bookmarks found.'),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (userModel.type == "hotel") {
                        return Center(
                          child: Text('Reviews coming soon'),
                        );
                      }
                      if (userModel.type == "food") {
                        return Column(
                          children: [
                            Expanded(
                              child: FutureBuilder(
                                future: getPosts(postIDsOfUser, userModel.type),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: LoadingAnimationWidget.waveDots(
                                          color: Colors.white, size: 40),
                                    );
                                  }

                                  if (snapshot.hasError) {
                                    return Text(snapshot.error.toString());
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {}

                                  return MasonryGridView.builder(
                                      itemCount: documents.length,
                                      gridDelegate:
                                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                      ),
                                      itemBuilder: (context, index) {
                                        Map<String, dynamic> data =
                                            documents[index].data()
                                                as Map<String, dynamic>;
                                        print(data);

                                        return Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: GestureDetector(
                                              onTap: () {
                                                String rating =
                                                    data['rating'].toString();
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            FoodDetails(
                                                              imageUrl: data[
                                                                  'imageUrl'],
                                                              foodName:
                                                                  data['food'],
                                                              hotelName: rating,
                                                              location: data[
                                                                  'location'],
                                                              rating: data[
                                                                  'location'],
                                                              postId: data[
                                                                  'postId'],
                                                              uId: data['uId'],
                                                            )));
                                              },
                                              onLongPress: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            EditFood(
                                                              imageUrl: data[
                                                                  'imageUrl'],
                                                              foodName:
                                                                  data['food'],
                                                              hotelName:
                                                                  data['hotel'],
                                                              location: data[
                                                                  'location'],
                                                              postId: data[
                                                                  'postId'],
                                                            )));
                                              },
                                              child: Image.network(
                                                  data['imageUrl']),
                                            ),
                                          ),
                                        );
                                      });
                                },
                              ),
                            ),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          Expanded(
                            child: FutureBuilder(
                              future: getPosts(postIDsOfUser, userModel.type),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: LoadingAnimationWidget.waveDots(
                                        color: Colors.white, size: 40),
                                  );
                                }

                                if (snapshot.hasError) {
                                  return Text(snapshot.error.toString());
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.done) {}

                                return MasonryGridView.builder(
                                    itemCount: documents.length,
                                    gridDelegate:
                                        SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                    ),
                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> data =
                                          documents[index].data()
                                              as Map<String, dynamic>;
                                      print(data);

                                      return Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        ReccomenadtionsScreen(
                                                          postId:
                                                              data['postId'],
                                                        )));
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child:
                                                Image.network(data['imageUrl']),
                                          ),
                                        ),
                                      );
                                    });
                              },
                            ),
                          ),
                        ],
                      );
                    }
                    return Container();
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
