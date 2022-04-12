class Board {
  final String id;
  final String name;
  final String desc;
  final String url;
  // final Prefs prefs; ToDo:
  final String dateLastActivity;
  final String dateLastView;

  Board(this.id, this.name, this.desc, this.url, this.dateLastActivity,
      this.dateLastView);

  Board.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        desc = json['desc'],
        url = json['url'],
        dateLastActivity = json['dateLastActivity'],
        dateLastView = json['dateLastView'];
}
