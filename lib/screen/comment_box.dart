// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class CommentBox extends StatelessWidget {
  CommentBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(),
        SizedBox(
          width: 5,
        ),
        Column(
          children: [Text('username'), Text('msg')],
        )
      ],
    );
  }
}
