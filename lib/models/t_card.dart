import 'label.dart';

class TCard {
  final String id;
  final String name;
  final num position;
  final List<Label> labels;

  TCard(this.id, this.name, this.position, this.labels);

  TCard.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        position = json['pos'],
        labels = (json['labels'] as List<dynamic>)
            .map((e) => Label.fromJson(e as Map<String, dynamic>))
            .toList();
}
