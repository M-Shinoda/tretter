import 'package:flutter/material.dart';

import 'label.dart';

class TCard {
  final String id;
  final String name;
  final num position;
  final List<Label> labels;
  final String? dueDate;
  final bool dueComplete;
  final String? dueString;
  final Color? remindColor;

  const TCard(this.id, this.name, this.position, this.labels, this.dueDate,
      this.dueComplete,
      {this.dueString, this.remindColor});

  TCard.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        position = json['pos'],
        dueDate = json['due'],
        dueComplete = json['dueComplete'],
        labels = (json['labels'] as List<dynamic>)
            .map((e) => Label.fromJson(e as Map<String, dynamic>))
            .toList(),
        dueString = null,
        remindColor = null;

  TCard copyWith(
      {String? id,
      String? name,
      num? position,
      List<Label>? labels,
      String? dueDate,
      bool? dueComplete,
      String? dueString,
      Color? remindColor}) {
    return TCard(
        id ??= this.id,
        name ??= this.name,
        position ??= this.position,
        labels ??= this.labels,
        dueDate ??= this.dueDate,
        dueComplete ??= this.dueComplete,
        dueString: dueString ??= this.dueString,
        remindColor: remindColor ??= this.remindColor);
  }
}
