import 'package:followupapp/models/log.dart';
import 'package:followupapp/service/database.dart';

Future<void> createLogEntry(int taskId, LogEntry entry) async

/// Takes a task id and log entry id to identify log entry to update, replaces with newValue. Returns future for error.
{
  await whenDBUp();
  db!.insert('Logs', {
    'taskId': taskId,
    'lastModified': entry.createdAt.toUtc().toIso8601String(),
    'value': entry.logValue
  });
}
