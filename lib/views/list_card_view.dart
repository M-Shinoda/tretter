import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tretter/board_list.dart';

import '../api.dart';
import '../models/t_card.dart';

class CardsView extends HookWidget {
  const CardsView({required this.list, Key? key}) : super(key: key);
  final BoardList list;
  @override
  Widget build(BuildContext context) {
    final listCards = useState<List<TCard>>([]);
    final fetchListCards =
        useMemoized(() async => await dio.get('list/${list.id}/cards'), []);
    final fetchListCardsResponse = useFuture(fetchListCards);

    useEffect(() {
      if (fetchListCardsResponse.hasData) {
        final resListCards =
            (fetchListCardsResponse.data!.data as List<dynamic>).toList();
        for (var listCard in resListCards) {
          listCards.value.add(TCard.fromJson(listCard));
        }
      }
      return;
    }, [fetchListCardsResponse.data]);

    useEffect(() {
      final timer = Timer.periodic(const Duration(microseconds: 100), (t) {
        List<TCard> temp = listCards.value;
        for (var card in listCards.value) {
          if (card.dueDate == null) continue;
          final diff = DateTime.parse(card.dueDate!).difference(DateTime.now());
          final index = listCards.value.indexOf(card);
          temp[index] = card.copyWith(
              dueString: timerTextFormat(diff),
              remindColor: remindTimerToColor(diff));
        }
        temp.sort(
            (a, b) => a.dueString.toString().compareTo(b.dueString.toString()));
        listCards.value = [...(temp)];
      });
      return () {
        timer.cancel();
      };
    }, const []);

    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.cyan[50],
            body: Container(
                padding: const EdgeInsets.only(top: 70),
                child: Column(children: [
                  infoHeader(context, list),
                  Expanded(
                      child: SingleChildScrollView(
                          child: Column(children: [
                    ...listCards.value
                        .map((listCard) => listItem(context, listCard))
                  ])))
                ])),
            floatingActionButton: FloatingActionButton(
                onPressed: () {}, child: const Icon(CupertinoIcons.add))));
  }

  Widget listItem(BuildContext context, TCard card) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomRight,
                colors: [
                  const Color(0xeffefefe),
                  card.remindColor ?? const Color(0xffffffff)
                ],
                stops: const [
                  0.01,
                  0.5,
                ]),
            border: Border.all(color: const Color(0x16000000)),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 0.5,
                  blurRadius: 5,
                  offset: Offset(3, 3)),
            ]),
        child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Container()));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(card.name),
                Text(card.id),
                if (card.dueString != null) Text(card.dueString!)
              ],
            )));
  }

  String timerTextFormat(Duration due) {
    String hour;
    String minute;
    if (due.inHours <= 0 && due.inMinutes <= 0) return 'DEAD LINE';
    if (due.inHours < 10) {
      hour = '0' + due.inHours.toString();
    } else {
      hour = due.inHours.toString();
    }
    if ((due.inMinutes - due.inHours * 60) < 10) {
      minute = '0' + ((due.inMinutes - due.inHours * 60)).toString();
    } else {
      minute = (due.inMinutes - due.inHours * 60).toString();
    }
    return '$hour:$minute';
  }

  Color remindTimerToColor(Duration diff) {
    if (diff.inSeconds < 3600) {
      return const Color(0xffef3345).withOpacity(0.8);
    } else if (diff.inSeconds < 21600) {
      return const Color(0xffefef22).withOpacity(0.8);
    } else if (diff.inSeconds < 86400) {
      // return Color(0xff22ef22).withOpacity(0.8);
      return const Color(0xff66e466).withOpacity(0.6);
    } else {
      return const Color(0xff66e4ee).withOpacity(0.6);
    }
  }

  Widget infoHeader(BuildContext context, BoardList list) {
    return Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 150,
        margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0x16000000)),
            borderRadius: BorderRadius.circular(10),
            image: const DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    'https://trello-backgrounds.s3.amazonaws.com/SharedBackground/original/d03e6f84a6bbe127d7cb84e03b64cb89/photo-1582520632092-410a5f4baa95'))),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: const Color.fromARGB(40, 255, 255, 255),
                    child: const Text("TEST TEXT\n1000",
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center)))));
  }
}
