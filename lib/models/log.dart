class LogEntry {
  late int tId;
  late int id;
  late DateTime createdAt;
  late String logValue;

  LogEntry.fromMap(Map<String, dynamic> map) {
    tId = map['taskId'];
    id = map['lId'];
    createdAt = DateTime.parse(map['lastModified']);
    logValue = map['value'];
  }

  LogEntry.defaultPlaceholder(int? id, DateTime? created, String? value) {
    id = id ?? 1;
    tId = 0; // HACK placeholder value
    createdAt = created ?? DateTime.now();
    logValue = value ?? "";
  }
}
