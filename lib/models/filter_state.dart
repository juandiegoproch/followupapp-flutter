import 'package:followupapp/models/area.dart';
import 'package:followupapp/models/person.dart';
import 'package:followupapp/models/task.dart';

// this is a structure to keep tabs on the state of the filters that the user
// has set. It exists merely as a convenient package and has no other function.

class FilterState {
  bool filterPeople = false;
  Set<Person> allowedPeople = {};

  bool filterAreas = false;
  Set<Area> allowedAreas = {};

  bool filterTaskStates = false;
  Set<TaskState> allowedTaskStates = {};

  bool filterNextMilestone = false;
  DateTime? minNextMilestone = DateTime.now();
  DateTime? maxNextMilestone;

  bool filterEnd = true;
  DateTime? minEnd;
  DateTime? maxEnd;

  FilterState();
}
