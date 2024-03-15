import 'package:followupapp/models/log.dart';
import 'package:followupapp/service/database.dart';

Future<void> updateLogEntry(int taskId,int logEntryId, LogEntry newValue) async
/// Takes a task id and log entry id to identify log entry to update, replaces with newValue. Returns future for error.
{
  await whenDBUp();

  db!.update('Logs', {
    'value': newValue.logValue
  }, where:'lId = ? AND taskId = ?', whereArgs: [logEntryId,taskId]);

  return;
}