import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travelgram/utils/reciever.dart';
import 'package:travelgram/utils/sender.dart';

class ChatScreenTest extends StatefulWidget {
  final String roomID;
  final String guideId;

  const ChatScreenTest({
    Key? key,
    required this.roomID,
    required this.guideId,
  }) : super(key: key);

  @override
  _ChatScreenTestState createState() => _ChatScreenTestState();
}

class _ChatScreenTestState extends State<ChatScreenTest> {
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User user = FirebaseAuth.instance.currentUser!;

  Future setData() async {
    try {
      await _firestore.collection('chats').doc(widget.roomID).set({'set': '1'});
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    setData();
  }

  Future<void> sendMessage() async {
    final message = {
      "by": user.uid,
      "message": _message.text,
      "type": 'text',
      "time": DateTime.now(),
    };

    try {
      await _firestore
          .collection('chats')
          .doc(widget.roomID)
          .collection('messages')
          .add(message);
    } catch (e) {
      print(e.toString());
    }

    _message.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chats')
                    .doc(widget.roomID)
                    .collection('messages')
                    .orderBy("time", descending: true)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData ||
                      snapshot.data?.docs.isEmpty == true) {
                    return Center(child: Text('No messages'));
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final message = snapshot.data?.docs[index].data()
                          as Map<String, dynamic>;
                      final messageText = message['message'] ?? '';
                      final messageBy = message['by'] ?? '';

                      if (messageBy == user.uid) {
                        return RecieverBox(
                          message: messageText,
                        );
                      } else {
                        return SenderBox(
                          uid: messageBy,
                          message: messageText,
                        );
                      }
                    },
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _message,
                    decoration: InputDecoration(
                      hintText: 'Enter message...',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: sendMessage,
                  child: Text('Send'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
