import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'boards_view.dart';

class HomeView extends HookWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
          const Text('This is Demo Home View Select debug Developing View'),
          const Padding(padding: EdgeInsets.only(top: 10)),
          ElevatedButton(
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const BoardsView()));
              },
              child: const Text('Board View'))
        ]))));
  }
}
