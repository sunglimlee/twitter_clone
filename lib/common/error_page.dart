import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String _errorMessage;

  const ErrorText({Key? key, String errorMessage = 'Error Occurred. Sorry'})
      : _errorMessage = errorMessage,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(_errorMessage),
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
    return Scaffold(
      body: ErrorText(errorMessage: _errorMessage),
    );
  }
}
