import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/theme/pallete.dart';

class TweetIconButton extends StatelessWidget {
  final String _pathName;
  final String _text;
  final VoidCallback? _onTap;

  const TweetIconButton(
      {Key? key, required String pathName, required String text, VoidCallback? onTap})
      : _pathName = pathName,
        _text = text,
        _onTap = onTap,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Row(
        children: [
          SvgPicture.asset(_pathName, color: Pallete.greyColor,),
          Container(margin: const EdgeInsets.all(6),
              child: Text(_text, style: const TextStyle(fontSize: 16,),)),
        ],
      ),
    );
  }
}
