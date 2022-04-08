import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BoardsView extends HookWidget {
  const BoardsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(
                child: Container(
      color: Colors.cyan[50],
      child: const Center(
        child: Text('Center'),
      ),
    ))));
  }
}
