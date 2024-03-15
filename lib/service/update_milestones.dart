import 'package:followupapp/models/milestone.dart';
import 'package:followupapp/service/database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> updateTaskMilestonesById(int taskId,List<Milestone> milestones) async
/// Replaces all milestones for task with id taskId, with milestones. Returns future for error.
{
  await whenDBUp();
  db!.transaction((txn) async {
    // get rid of the old milestones except the end
    txn.delete('Milestones',where: 'taskId = ? AND isFinal <= 0',whereArgs: [taskId]);

    // insert the milestones atomically
    Batch b = txn.batch();
    for (Milestone m in milestones)
    {
      m.tId = taskId; // make sure the taskId is OK
      Map<String,Object?> mMap = m.toMap();
      mMap.remove('mId'); // db determines this
      mMap.remove('status'); //this is a computed property
      b.insert('Milestones',mMap);
    }
    b.commit();
    return 1;
  });
  return;
}