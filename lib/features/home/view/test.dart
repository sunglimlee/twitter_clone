import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  static materialPageRoute() {
    return MaterialPageRoute(builder: (context) => const Test());
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Container(child: Text("test"),));
  }
}
