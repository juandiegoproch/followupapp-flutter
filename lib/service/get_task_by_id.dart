import 'package:followupapp/models/task.dart';
import 'package:followupapp/service/database.dart';

Future<Task> getTaskById(int taskId) async
/// Takes task id, returns details for corresponding task.
{
  await whenDBUp();
  String query = """
  SELECT 
    taskId,
      area,
      person,
      program,
      deliverable,
      taskState,
      CASE 
          WHEN strftime('%s',nextMDate) - strftime('%s','now') > 0 AND 
          ABS(strftime('%s',nextMDate) - strftime('%s','now')) < 259200 -- 3 days in sec
          AND nextIsFinal = 0
              THEN 'upcomingRevision'
          WHEN strftime('%s',nextMDate) - strftime('%s','now') > 0 AND 
          ABS(strftime('%s',nextMDate) - strftime('%s','now')) < 259200 -- 3 days in sec
          AND nextIsFinal = 1
              THEN 'upcomingFinal'
          WHEN nextIsFinal = 1 AND strftime('%s',nextMDate) - strftime('%s','now') < 0
              THEN 'lateFinal'
          ELSE 'nothing'
      END as nextTState,
      nextMId,
      nextSatisfied,
      nextIsFinal,
      nextMDate,
      endMID,
      endSatisfied,
      endIsFinal,
      endMDate,
      'nothing' AS endTState --TODO
  FROM 
  (SELECT 
    taskId,
    area,
    person,
    program,
    deliverable,
    taskState
  FROM Tasks
  WHERE taskId = ?
  )
  LEFT OUTER JOIN
  (SELECT 
    mId AS nextMId,
    satisfied AS nextSatisfied,
      isFinal AS nextIsFinal,
      mDate AS nextMDate
  FROM Milestones
  WHERE taskId = ?
  ORDER BY strftime('%s', mdate) - strftime('%s', 'now') < 0, 
    ABS(strftime('%s', mdate) - strftime('%s', 'now'))
  LIMIT 1)
  LEFT OUTER JOIN
  (SELECT 
    mId AS endMId,
    satisfied AS endSatisfied,
      isFinal AS endIsFinal,
      mDate AS endMDate
  FROM Milestones
  WHERE taskId = ? AND isFinal = 1
  LIMIT 1);
  """;
  dynamic response = await db?.rawQuery(query,[taskId,taskId,taskId]);
  return Task.fromDetailedMap(response[0]);
}