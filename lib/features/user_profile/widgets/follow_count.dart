import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/pallete.dart';

class FollowCount extends StatelessWidget {
  final int _count;
  final String _text;

  const FollowCount({Key? key, required int count, String? text})
      : _count = count,
        _text = text ?? '',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    const fontSize = 18.0;
    return Row(
      children: [
        Text(
          '$_count',
          style: const TextStyle(
              color: Pallete.whiteColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 3,
        ),
        Text(
          _text,
          style: const TextStyle(
            color: Pallete.greyColor,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}
