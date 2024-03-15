import "package:followupapp/models/milestone.dart";
import "package:followupapp/service/database.dart";

Future<List<Milestone>> getMilestonesForTaskById(int id) async
/// Takes int task id. Returns future for all corresponding milestones ordered by date.
{
  await whenDBUp();
  dynamic a = await db?.rawQuery(
    """
    SELECT 
      taskId,
      mId,
      satisfied,
      isFinal,
      mDate,
        CASE 
            WHEN strftime('%s',mDate) - strftime('%s','now') > 0 AND 
            ABS(strftime('%s',mDate) - strftime('%s','now')) < 259200 -- 3 days in sec
            AND isFinal = 0
                THEN 'upcomingRevision'
            WHEN strftime('%s',mDate) - strftime('%s','now') > 0 AND 
            ABS(strftime('%s',mDate) - strftime('%s','now')) < 259200 -- 3 days in sec
            AND isFinal = 1
                THEN 'upcomingFinal'
            WHEN isFinal = 1 AND strftime('%s',mDate) - strftime('%s','now') < 0
                THEN 'lateFinal'
            ELSE 'nothing'
        END AS status
    FROM Milestones
    WHERE taskId = ? AND isFinal <= 0; -- begin/end work differently!
    """,
    [id]
  );
  return [for (Map<String,Object?> x in a) Milestone.fromMap(x)];
}