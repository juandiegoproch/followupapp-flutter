import 'package:followupapp/models/task.dart';
import 'package:followupapp/models/filter_state.dart';
import 'package:followupapp/service/database.dart';

Future<List<Task>> getTasks(FilterState filters) async {
  // Wait for the database to be up
  await whenDBUp();

  (String, List<dynamic>) record = filters.toSqlWhere();

  String query = """
    -- Returns each task with next milesone and end milestone concatenated in order
    -- next milestone is first ordered by following criteria: mDate is in future, abs(date-today)
    -- task order is next
    SELECT 
        taskId,
        area,
        person,
        program,
        deliverable,
        taskState,
        nextMId,
        nextSatisfied,
        nextIsFinal,
        nextMDate,
        nextTState,
        endMId,
        endSatisfied,
        endIsFinal,
        endMDate,
        endTState
    FROM(
      SELECT 
        taskId,
        area,
        person,
        program,
        deliverable,
        taskState,
        nextMId,
        nextSatisfied,
        nextIsFinal,
        nextMDate,
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
        endMId,
        endSatisfied,
        endIsFinal,
        endMDate,
        CASE  
        	WHEN strftime('%s',endMDate) - strftime('%s','now') > 0 AND 
             ABS(strftime('%s',endMDate) - strftime('%s','now')) < 259200 -- within 3d in future
             	THEN 'upcomingFinal'
        	WHEN strftime('%s',endMDate) - strftime('%s','now') < 0
             	THEN 'lateFinal'
            ELSE 'nothing'
        END AS endTState
    FROM 
      (SELECT
          MIN(_orderc) as _orderc,
          Tasks.taskId,
          area,
          person,
          program,
          deliverable,
          taskState,
          nextMId,
          nextSatisfied,
          nextIsFinal,
          nextMDate,
          endMId,
          endSatisfied,
          endIsFinal,
          endMDate 
      FROM
          Tasks 
      LEFT OUTER JOIN ( -- Outer join keeps all tasks and fills nulls where appropiate
          SELECT -- Next important task. use row number for complex ordering criteria.
              ROW_NUMBER() OVER (ORDER BY strftime('%s', mdate) - strftime('%s', 'now') < 0, ABS(strftime('%s', mdate) - strftime('%s', 'now'))) AS _orderc,
              taskId,
              mId AS nextMId,
              satisfied AS nextSatisfied,
              isFinal AS nextIsFinal,
              mDate AS nextMDate
          FROM
              Milestones
      ) AS nextq ON Tasks.taskId = nextq.taskId
      LEFT OUTER JOIN (
          SELECT -- End dates for tasks. Asumes 1 or 0 end dates, undefined behaviour elsewise.
              taskId,
              mId as endMId,
              satisfied AS endSatisfied,
              isFinal AS endIsFinal,
              mdate AS endMDate
          FROM
              Milestones
          WHERE
              isfinal = 1
      ) AS endq ON Tasks.taskId = endq.taskId
      GROUP BY
          Tasks.taskId
      ORDER BY
          taskState = 'finalized', -- Push finalized tasks down as much as posible
          _orderc IS NULL, -- push tasks without milestones under those that have
          _orderc -- keep order from above
        ) as result)
      ${record.$1};
  """;


  dynamic response = await db?.rawQuery(query,record.$2);
  return [for (Map<String,dynamic> i in response) Task.fromDetailedMap(i)];
}

// returns list of tasks filtered and ordered as convinient by filterState. Null if error.

/*Future<(Milestone,MilestoneStatus)> getTaskNextMilestone(int taskId) async
{
  return (Milestone.defaultPlaceholder(),MilestoneStatus.lateFinal);
}
*/