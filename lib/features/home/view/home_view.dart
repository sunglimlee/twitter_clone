import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  static materialPageRoute() {
    return MaterialPageRoute(builder: (context) => const HomeView());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Center(child: Text("aa", style: TextStyle(color: Colors.red),)),
    );
  }
}
