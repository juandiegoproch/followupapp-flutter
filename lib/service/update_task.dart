import 'package:flutter/material.dart';
import 'package:followupapp/models/task.dart';
import 'package:followupapp/service/database.dart';

Future<void> updateTask(int taskId, Task newValue) async
/// Replaces task with taskId with newValue. Returns future for errors.
{
  debugPrint(newValue.toMap().toString());
  await whenDBUp();
  db!.transaction((txn) async
  {
    txn.update('Tasks', newValue.toSimpleMap(), where: 'taskId = ?', whereArgs: [taskId]);
    // If the task has no end, drop all ends that may have existed
    txn.delete('Milestones',where: 'taskId=? AND isFinal = 1', whereArgs: [taskId]);
    if (newValue.end != null)
    { // if the task has an end, reinsert it
      Map<String,Object?> m = newValue.end!.toMap();
      m.remove('mId');
      m.remove('status');
      m['taskId'] = taskId; // make sure of this
      txn.insert('Milestones',m);
    }

    return 1;
  });
}