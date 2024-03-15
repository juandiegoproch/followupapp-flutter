import "package:followupapp/models/log.dart";
import "package:followupapp/service/database.dart";

Future<List<LogEntry>> getLogsForTaskById(int tId) async {
  await whenDBUp();

  List<dynamic> response =
      await db!.query("Logs", where: "taskId = ?", whereArgs: [tId]);
  return [for (dynamic r in response) LogEntry.fromMap(r)];
}
