import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imgpick = ImagePicker();
  XFile? _file = await _imgpick.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('NO Image is selected');
}

showSnakBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
