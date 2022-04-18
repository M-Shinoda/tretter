import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'boards_view.dart';

class HomeView extends HookWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final radiusDuble = useState(0.0);
    useEffect(() {
      final timer =
          Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
        radiusDuble.value += 0.01;
        if (radiusDuble.value >= 3.1) radiusDuble.value = 0;
      });
      return timer.cancel;
    }, []);
    return MaterialApp(
        home: Scaffold(
            body: Container(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                          'This is Demo Home View Select debug Developing View'),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      ElevatedButton(
                          onPressed: () async {
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const BoardsView()));
                          },
                          child: const Text('Board View'))
                    ]),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: FractionalOffset.topLeft,
                      end: FractionalOffset.bottomRight,
                      colors: [
                        const Color(0xffe4a972).withOpacity(0.6),
                        const Color(0xff9941d8).withOpacity(0.6),
                      ],
                      stops: const [
                        0.0,
                        1.0,
                      ],
                      transform: GradientRotation(radiusDuble.value)),
                ))));
  }
}
