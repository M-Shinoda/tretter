import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tretter/models/board.dart';

import '../api.dart';
import '../models/lists_view.dart';

class BoardsView extends HookWidget {
  const BoardsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final boards = useState<List<Board>>([]);
    final fetchBoards =
        useMemoized(() async => await dio.get('members/me/boards'), []);
    // await dio.get('boards/5e54b9bfb916087f5c3f2ff8/lists'), []);
    final fetchBoardsResponse = useFuture(fetchBoards);

    useEffect(() {
      if (fetchBoardsResponse.hasData) {
        final resBoardsData =
            (fetchBoardsResponse.data!.data as List<dynamic>).toList();
        for (var board in resBoardsData) {
          final b = Board.fromJson(board);
          boards.value.add(b);
        }
      }
      return;
    }, [fetchBoardsResponse.data]);

    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.cyan[50],
            body: Container(
                padding: const EdgeInsets.only(top: 100),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    ...boards.value.map((board) => listItem(context, board))
                  ],
                )))));
  }

  Widget listItem(BuildContext context, Board board) {
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
                      builder: (context) => Container(
                            color: Colors.white,
                            child: const ListsView(),
                          )));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(board.name),
                Text(board.desc),
                Text(board.dateLastActivity),
                Text(board.dateLastView)
              ],
            )));
  }
}
