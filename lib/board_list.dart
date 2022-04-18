class BoardList {
  final String id;
  final String name;
  final bool closed;
  final num position;

  BoardList(this.id, this.name, this.closed, this.position);

  BoardList.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        closed = json['closed'],
        position = json['pos'];
}
