import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/pallete.dart';

class AuthField extends StatelessWidget {
  final bool _isObscured;
  final TextEditingController _textEditingController;
  final String _hint;
  const AuthField(
      {Key? key,
      required TextEditingController textEditingController,
      required String hint,
      bool isObscured = false})
       : _textEditingController = textEditingController,
         _hint = hint,
         _isObscured = isObscured,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _textEditingController,
      obscureText: _isObscured,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Pallete.blueColor,
            width: 3, // 선굵기이구나.
          ),
        ),
        // focus 가 아닐때도 border 가 보이도록 하는것.
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Pallete.greyColor,
          )
        ),
        contentPadding: const EdgeInsets.all(22),
        hintText: _hint,
        hintStyle: const TextStyle(fontSize: 18),
      ),
    );
  }
}
