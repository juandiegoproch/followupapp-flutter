import 'package:followupapp/models/log.dart';
import 'package:followupapp/service/database.dart';

Future<LogEntry> getLogEntryByTaskIdAndLogId(int taskId, int logId) async {
  await whenDBUp();
  dynamic a = await db?.query('Logs',where:'taskId = ? AND lId = ?', whereArgs: [taskId,logId]);
  return LogEntry.fromMap(a[0]);
}
