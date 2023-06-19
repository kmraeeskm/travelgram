import 'package:flutter/material.dart';

class ExpandableShowMoreWidget extends StatefulWidget {
  final String text;
  final double height;
  const ExpandableShowMoreWidget(
      {super.key, required this.text, required this.height});

  @override
  State<ExpandableShowMoreWidget> createState() =>
      _ExpandableShowMoreWidgetState();
}

class _ExpandableShowMoreWidgetState extends State<ExpandableShowMoreWidget> {
  late String firstHalf;
  late String secondHalf;

  bool hiddenText = true;

  @override
  void initState() {
    super.initState();

    double textHeight = widget.height;
    if (widget.text.length > textHeight) {
      firstHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf =
          widget.text.substring(textHeight.toInt() + 1, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty
          ? Text(
              firstHalf,
              style: const TextStyle(height: 1.6),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hiddenText ? ('$firstHalf...') : firstHalf + secondHalf,
                  style: const TextStyle(height: 1.6),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      hiddenText = !hiddenText;
                    });
                  },
                  child: Text(
                    hiddenText ? 'show more' : 'show less',
                    style: const TextStyle(color: Colors.blue),
                  ),
                )
              ],
            ),
    );
  }
}
