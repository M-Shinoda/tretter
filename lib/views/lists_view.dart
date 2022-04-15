import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api.dart';

class BoardList {
  final String id;
  final String name;
  final bool closed;
  final double position;

  BoardList(this.id, this.name, this.closed, this.position);

  BoardList.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        closed = json['closed'],
        position = json['pos'];
}

class ListsView extends HookWidget {
  const ListsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final boardLists = useState<List<BoardList>>([]);
    final fetchboardLists = useMemoized(
        () async => await dio.get('boards/5e54b9bfb916087f5c3f2ff8/lists'), []);
    final fetchBoardlistResponse = useFuture(fetchboardLists);

    useEffect(() {
      if (fetchBoardlistResponse.hasData) {
        final resBoardListData =
            (fetchBoardlistResponse.data!.data as List<dynamic>).toList();
        for (var boardList in resBoardListData) {
          final bl = BoardList.fromJson(boardList);
          boardLists.value.add(bl);
        }
      }
      return;
    }, [fetchBoardlistResponse.data]);

    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.cyan[50],
            body: Container(
                padding: const EdgeInsets.only(top: 100),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    ...boardLists.value
                        .map((boardList) => listItem(context, boardList))
                  ],
                )))));
  }

  Widget listItem(BuildContext context, BoardList boardList) {
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
                Text(boardList.closed.toString()),
                Text(boardList.position.toString())
              ],
            )));
  }
}
