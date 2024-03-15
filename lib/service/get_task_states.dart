
import 'package:followupapp/models/task.dart';

Future<List<TaskState>> getTaskStates() async
// returns a list of all valid task states
{
  return TaskState.values;
}