import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travelgram/screen/chat_sccreen.dart';

class GuideHomeScreen extends StatefulWidget {
  final String currentUserId;

  GuideHomeScreen({required this.currentUserId});

  @override
  _GuideHomeScreenState createState() => _GuideHomeScreenState();
}

class _GuideHomeScreenState extends State<GuideHomeScreen> {
  Future<List<String>> fetchChatIds() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('chats').get();
    print(querySnapshot.docs.length);

    final chatIds = querySnapshot.docs
        .map((doc) => doc.id)
        .where((chatId) => chatId.contains(widget.currentUserId))
        .toList();
    print(chatIds);
    return chatIds;
  }

  String chatRoomID(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      print("$user1$user2");
      return "$user1$user2";
    } else {
      print("$user1$user2");
      return "$user2$user1";
    }
  }

  Future<DocumentSnapshot> fetchUserDocument(String userId) async {
    final userDocument =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    return userDocument;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Page'),
      ),
      body: FutureBuilder<List<String>>(
        future: fetchChatIds(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          final chatIds = snapshot.data ?? [];

          if (chatIds.isEmpty) {
            return Center(child: Text('No one has contacted you yet.'));
          }

          return ListView.builder(
            itemCount: chatIds.length,
            itemBuilder: (BuildContext context, int index) {
              final chatId = chatIds[index];

              final messageSenderId = chatId
                  .replaceAll(widget.currentUserId, '')
                  .replaceAll('_', '');
              print(messageSenderId);
              return FutureBuilder<DocumentSnapshot>(
                future: fetchUserDocument(messageSenderId),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                  if (userSnapshot.hasError) {
                    return Text('Error: ${userSnapshot.error}');
                  }

                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  final userData =
                      userSnapshot.data?.data() as Map<String, dynamic>;
                  final userName = userData['username'] ?? '';
                  final userImage = userData['photourl'] ?? '';
                  final userId = userData['uid'] ?? '';

                  return GestureDetector(
                    onTap: () {
                      String roomID = chatRoomID(
                          userId, FirebaseAuth.instance.currentUser!.uid);
                      print(roomID);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChatScreenTest(
                            //i was hereguideId
                            guideId: userId,
                            roomID: roomID,
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(userImage),
                      ),
                      title: Text(userName),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
