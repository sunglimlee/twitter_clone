import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/pallete.dart';

class RoundedSmallButton extends StatelessWidget {
  final VoidCallback _onTap;
  final String _buttonLabel;
  final Color _backgroundColor;
  final Color _textColor;

  const RoundedSmallButton(
      {required VoidCallback onTap,
      required String buttonLabel,
      Color backgroundColor = Pallete.backgroundColor,
      Color textColor = Pallete.whiteColor,
      Key? key})
      : _onTap = onTap,
        _buttonLabel = buttonLabel,
        _backgroundColor = backgroundColor,
        _textColor = textColor,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap,
      child: Chip(
        label: Text(_buttonLabel.toString()),
        backgroundColor: _backgroundColor,
        labelPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        labelStyle: TextStyle(color: _textColor, fontSize: 16),
      ),
    );
  }
}
