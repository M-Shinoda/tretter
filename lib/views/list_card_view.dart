import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api.dart';
import '../models/t_card.dart';

class CardsView extends HookWidget {
  const CardsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final listCards = useState<List<TCard>>([]);
    final fetchListCards = useMemoized(
        () async => await dio.get('list/5e54bf0b8fdd8e6b3cda51cb/cards'), []);
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
                    : "")
              ],
            )));
  }
}
