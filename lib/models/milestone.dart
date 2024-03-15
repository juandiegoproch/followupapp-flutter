enum MilestoneStatus {
  lateFinal,
  upcomingFinal,
  lateRevision,
  upcomingRevision,
  nothing
}

class Milestone {
  late DateTime time;
  late int tId;
  late int mId;
  late bool isFinal;
  late MilestoneStatus status;

  Milestone.defaultPlaceholder() {
    mId = 0;
    tId = 0;
    isFinal = false;
    status = MilestoneStatus.nothing;
    time = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day); // PLACEHOLDER
  }

  Milestone({
    required this.mId,
    required this.tId,
    required this.isFinal,
    required this.status,
    required this.time
  });

  Map<String, Object?> toMap() {
    return {
      "mId": mId,
      "taskId": tId,
      "isFinal": isFinal? 1:0,
      "status": status.name,
      "mDate": time.toUtc().toIso8601String()
    };
  }

  Milestone.fromMap(Map<String, Object?> map) {
    mId = map["mId"] as int;
    tId = map["taskId"] as int;
    isFinal = map["isFinal"] is bool
        ? map["isFinal"] as bool
        : (map["isFinal"] as int > 0);
    time = DateTime.parse(map["mDate"] as String);
    status = switch (map['status'] as String) {
      "lateFinal" => MilestoneStatus.lateFinal,
      "lateRevision" => MilestoneStatus.lateRevision,
      "nothing" => MilestoneStatus.nothing,
      "upcomingFinal" => MilestoneStatus.upcomingFinal,
      "upcomingRevision" => MilestoneStatus.upcomingRevision,
      _ => throw FormatException("Invalid MilestoneStatus", map[status])
    };
  }
}
