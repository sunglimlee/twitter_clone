import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String _errorMessage;

  const ErrorText({Key? key, String errorMessage = 'Error Occurred. Sorry'})
      : _errorMessage = errorMessage,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(children: [Text(_errorMessage)]),
    );
  }
}

class ErrorPage extends StatelessWidget {
  final String _errorMessage;

  const ErrorPage({Key? key, String errorMessage = 'Error Occurred. Sorry'})
      : _errorMessage = errorMessage,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        height: 200,
          child: SingleChildScrollView(child: ErrorText(errorMessage: _errorMessage))),
    );
  }
}
