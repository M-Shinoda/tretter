import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api.dart';
import '../board_list.dart';
import 'list_card_view.dart';

class ListsView extends HookWidget {
  const ListsView({required this.boardId, Key? key}) : super(key: key);
  final String boardId;
  @override
  Widget build(BuildContext context) {
    final boardLists = useState<List<BoardList>>([]);
    final fetchboardLists =
        useMemoized(() async => await dio.get('boards/$boardId/lists'), []);
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CardsView(
                            list: boardList,
                          )));
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
