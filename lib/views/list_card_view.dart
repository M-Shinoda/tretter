import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api.dart';
import '../models/t_card.dart';

class CardsView extends HookWidget {
  const CardsView({required this.listId, Key? key}) : super(key: key);
  final String listId;
  @override
  Widget build(BuildContext context) {
    final listCards = useState<List<TCard>>([]);
    final fetchListCards =
        useMemoized(() async => await dio.get('list/$listId/cards'), []);
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
        for (var card in listCards.value) {
          if (card.dueDate == null) return;
          final diff = DateTime.parse(card.dueDate!).difference(DateTime.now());
          final index = listCards.value.indexOf(card);
          List<TCard> temp = listCards.value;
          temp[index] = card.setDateTime(timerTextFormat(diff));
          listCards.value = [...temp];
        }
      });
      return () {
        timer.cancel();
      };
    }, const []);

    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.cyan[50],
            body: Container(
                padding: const EdgeInsets.only(top: 100),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    ...listCards.value
                        .map((listCard) => listItem(context, listCard))
                  ],
                )))));
  }

  Widget listItem(BuildContext context, TCard boardList) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
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
                Text(boardList.name),
                Text(boardList.id),
                Text(boardList.position.toString()),
                Text(boardList.labels.isNotEmpty
                    ? boardList.labels.first.id
                    : ""),
                if (boardList.dueString != null) Text(boardList.dueString!)
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
      hour = due.toString();
    }
    if ((due.inMinutes - due.inHours * 60) < 10) {
      minute = '0' + ((due.inMinutes - due.inHours * 60)).toString();
    } else {
      minute = (due.inMinutes - due.inHours * 60).toString();
    }
    return '$hour:$minute';
  }
}
