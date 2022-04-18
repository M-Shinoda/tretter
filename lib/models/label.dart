class Label {
  final String id;
  final String name;
  final String color;

  Label(this.id, this.name, this.color);

  Label.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        color = json['color'];
}
