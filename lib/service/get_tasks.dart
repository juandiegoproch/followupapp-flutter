import 'package:followupapp/models/area.dart';
import 'package:followupapp/models/person.dart';
import 'package:followupapp/models/task.dart';
import 'package:followupapp/models/filter_state.dart';
import 'package:followupapp/service/database.dart';

Future<List<Task>> getTasks(FilterState filters) async {
  // Wait for the database to be up
  await whenDBUp();

  (String, List<dynamic>) record = toSqlWhere(filters);
  // TODO: use something decent like an ORM for this
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
  dynamic response = await db?.rawQuery(query, record.$2);
  return [for (Map<String, dynamic> i in response) Task.fromDetailedMap(i)];
}

/// utility stuff to make a filter object into a ("WHERE",ARGS) object

(String, List<dynamic>) toSqlWhere(FilterState f) {
  String where = "";
  List<dynamic> whereArgs = [];
  bool hasPrev = false;

  if (f.filterPeople) {
    // for consistency:
    // ignore: dead_code
    if (hasPrev) where += " AND ";

    dynamic ppl = peopleToSqlWhere(f);
    where += ppl.$1;
    whereArgs.addAll(ppl.$2);

    hasPrev = true;
  }

  if (f.filterAreas) {
    if (hasPrev) where += " AND ";

    dynamic areas = areasToSqlWhere(f);
    where += areas.$1;
    whereArgs.addAll(areas.$2);

    hasPrev = true;
  }

  if (f.filterTaskStates) {
    if (hasPrev) where += " AND ";

    dynamic tstates = taskStatesToSqlWhere(f);
    where += tstates.$1;
    whereArgs.addAll(tstates.$2);

    hasPrev = true;
  }

  if (f.filterNextMilestone) {
    if (hasPrev) where += " AND ";

    dynamic nmilestone = nextToSqlWhere(f); // must return ('true',[]) if
    /* no date is given */
    where += nmilestone.$1;
    whereArgs.addAll(nmilestone.$2);

    hasPrev = true;
  }

  if (f.filterEnd) {
    if (hasPrev) where += " AND ";

    dynamic end = endToSqlWhere(f); // must return ('true',[]) if
    /* no date is given */
    where += end.$1;
    whereArgs.addAll(end.$2);

    hasPrev = true;
  }

  if (hasPrev) where = "WHERE $where";

  return (where, whereArgs);
}

(String, List<dynamic>) peopleToSqlWhere(FilterState f) {
  String where = "person IN (";
  List<dynamic> whereargs = [];

  for (Person i in f.allowedPeople) {
    where += " ?,";
    whereargs.add(i.personName);
  }
  where = where.substring(0, where.length - 1);
  where += ')';
  return (where, whereargs);
}

(String, List<dynamic>) areasToSqlWhere(FilterState f) {
  String where = "area IN (";
  List<dynamic> whereargs = [];

  for (Area i in f.allowedAreas) {
    where += " ?,";
    whereargs.add(i.areaName);
  }
  where = where.substring(0, where.length - 1);
  where += ')';
  return (where, whereargs);
}

(String, List<dynamic>) taskStatesToSqlWhere(FilterState f) {
  String where = "taskState IN (";
  List<dynamic> whereargs = [];

  for (TaskState i in f.allowedTaskStates) {
    where += " ?,";
    whereargs.add(i.name);
  }
  where = where.substring(0, where.length - 1);
  where += ')';
  return (where, whereargs);
}

(String, List<dynamic>) nextToSqlWhere(FilterState f) {
  String where = "";
  List<dynamic> whereargs = [];

  if (f.maxNextMilestone == null && f.minNextMilestone == null) {
    return ("true", []);
  }

  bool hasprev = false;
  if (f.maxNextMilestone != null) {
    // if (hasprev) where += ' AND ';
    where += "strftime('%s',nextMDate) <= strftime('%s',?)";
    whereargs.add(f.maxNextMilestone!.toUtc().toIso8601String());

    hasprev = true;
  }

  if (f.minNextMilestone != null) {
    if (hasprev) where += ' AND ';
    where += "strftime('%s',nextMDate) >= strftime('%s',?)";
    whereargs.add(f.minNextMilestone!.toUtc().toIso8601String());

    hasprev = true;
  }

  return (where, whereargs);
}

(String, List<dynamic>) endToSqlWhere(FilterState f) {
  String where = "";
  List<dynamic> whereargs = [];

  if (f.maxEnd == null && f.minEnd == null) {
    return ("true", []);
  }

  bool hasprev = false;
  if (f.maxEnd != null) {
    // if (hasprev) where += ' AND ';
    where += "strftime('%s',endMDate) <= strftime('%s',?)";
    whereargs.add(f.maxEnd!.toUtc().toIso8601String());

    hasprev = true;
  }

  if (f.minEnd != null) {
    if (hasprev) where += ' AND ';
    where += "strftime('%s',endMDate) >= strftime('%s',?)";
    whereargs.add(f.minEnd!.toUtc().toIso8601String());

    hasprev = true;
  }

  return (where, whereargs);
}
