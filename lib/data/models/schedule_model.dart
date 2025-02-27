import 'dart:convert';

import 'package:rtu_mirea_app/data/models/lesson_model.dart';
import 'package:rtu_mirea_app/domain/entities/schedule.dart';

class ScheduleModel extends Schedule {
  ScheduleModel({required this.group, required this.schedule})
      : super(group: group, schedule: schedule);

  final String group;
  final Map<String, ScheduleWeekdayValueModel> schedule;

  factory ScheduleModel.fromRawJson(String str) =>
      ScheduleModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
        group: json["group"],
        schedule: Map.from(json["schedule"]).map((k, v) =>
            MapEntry<String, ScheduleWeekdayValueModel>(
                k, ScheduleWeekdayValueModel.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "group": group,
        "schedule": Map.from(schedule)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class ScheduleWeekdayValueModel extends ScheduleWeekdayValue {
  ScheduleWeekdayValueModel({required this.lessons}) : super(lessons: lessons);

  final List<List<LessonModel>> lessons;

  factory ScheduleWeekdayValueModel.fromRawJson(String str) =>
      ScheduleWeekdayValueModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScheduleWeekdayValueModel.fromJson(Map<String, dynamic> json) =>
      ScheduleWeekdayValueModel(
        lessons: List<List<LessonModel>>.from(json["lessons"].map((x) =>
            List<LessonModel>.from(x.map((x) => LessonModel.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "lessons": List<dynamic>.from(
            lessons.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
      };
}
