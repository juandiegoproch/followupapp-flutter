import 'package:followupapp/models/task.dart';
import 'package:followupapp/service/database.dart';

Future<int> createTask(Task newValue) async

/// Takes a Task object and stores it in the database. Returns int task id future.
{
  await whenDBUp();
  int id = 0;
  db!.transaction((txn) async {
    Map<String, Object?> taskmap = newValue.toSimpleMap();
    taskmap
        .remove('taskId'); // when a task is created there is no ID to speak of
    int id = await txn.insert('Tasks', taskmap);
    if (newValue.end != null) {
      Map<String, Object?> endMap = newValue.end!.toMap();
      endMap['taskId'] = id;
      endMap.remove('mId');
      endMap.remove('status'); // this is a computed property
      txn.insert('Milestones', endMap);
    }
    return id;
  });
  return id;
}
