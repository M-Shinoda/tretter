import 'label.dart';

class TCard {
  final String id;
  final String name;
  final num position;
  final List<Label> labels;
  final String? dueDate;
  final bool dueComplete;
  final String? dueString;

  const TCard(this.id, this.name, this.position, this.labels, this.dueDate,
      this.dueComplete,
      {this.dueString});

  TCard.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        position = json['pos'],
        dueDate = json['due'],
        dueComplete = json['dueComplete'],
        labels = (json['labels'] as List<dynamic>)
            .map((e) => Label.fromJson(e as Map<String, dynamic>))
            .toList(),
        dueString = null;

  TCard setDateTime(String dueString) {
    return TCard(id, name, position, labels, dueDate, dueComplete,
        dueString: dueString);
  }
}
