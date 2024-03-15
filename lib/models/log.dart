class LogEntry {
  late int id;
  late DateTime createdAt;
  late String logValue;
  LogEntry(this.id, this.createdAt, this.logValue);

  LogEntry.fromMap(Map<String, String> map) {
    id = 1;
    createdAt = DateTime.now();
    logValue = "";
  }

  LogEntry.defaultPlaceholder(int? id, DateTime? created, String? value) {
    id = 1;
    createdAt = DateTime.now();
    logValue = "";
  }
}
