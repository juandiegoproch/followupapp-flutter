import 'package:followupapp/service/database.dart';

Future<void> removeLogEntry(int taskId,int logEntryId) async
/// Takes task id and log entry id to identify the log to delete. Returns future for error reporting.
{
  await whenDBUp();
  db!.delete('Logs',where:'lId = ? AND taskId = ?', whereArgs: [logEntryId,taskId]);
}