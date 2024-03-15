import 'package:followupapp/models/milestone.dart';
import 'package:followupapp/models/person.dart';
import 'package:followupapp/models/area.dart';

enum TaskState { uninitiated, ongoing, finalized, continuous }

class Task {
  late int id;
  late Area area;
  late Person person;
  late String program;
  late String deliverable;
  late TaskState taskState;
  late Milestone? end;
  late Milestone? nextMilestone;
  Task({
    this.id = 0,
    String areaName = "placeholder",
    String personName = "placeholder",
    this.program = "placeholder",
    this.deliverable = "placeholder",
    this.taskState = TaskState.continuous,
    this.end,
    this.nextMilestone,
  }) {
    area = Area(areaName);
    person = Person(personName);
  }
  Map<String, dynamic> toMap() {
    return {
      'taskId': id.toString(),
      'area': area.areaName,
      'person': person.personName,
      'program': program,
      'deliverable': deliverable,
      'taskState': taskState.name,
      'nextMilestone': nextMilestone?.toMap(),
      'end': end?.toMap()
    };
  }

  Map<String,Object?> toSimpleMap()
  {
    return {
      'taskId': id.toString(),
      'area': area.areaName,
      'person': person.personName,
      'program': program,
      'deliverable': deliverable,
      'taskState': taskState.name,
    };
  }

  Task.fromDetailedMap(Map<String, dynamic> map) {
    id = map["taskId"] as int;
    area = Area(map["area"] as String);
    person = Person(map["person"] as String);
    program = map["program"] as String;
    deliverable = map["deliverable"] as String;
    taskState = TaskState.values.byName(map["taskState"] as String);
    nextMilestone = map["nextMId"] == null
        ? null
        : Milestone(
            mId: map["nextMId"] as int,
            tId: map["taskId"] as int,
            isFinal: map["nextIsFinal"] as int > 0,
            status: MilestoneStatus.values.byName(map["nextTState"] as String),
            time: DateTime.parse(map["nextMDate"] as String));
    end = map["endMId"] == null
        ? null
        : Milestone(
            mId: map["endMId"] as int,
            tId: map["taskId"] as int,
            isFinal: map["endIsFinal"] as int > 0,
            status: MilestoneStatus.values.byName(map["endTState"] as String),
            time: DateTime.parse(map["endMDate"] as String));
  }
}
