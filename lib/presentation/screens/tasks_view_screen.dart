import 'package:flutter/material.dart';
import 'package:followupapp/models/area.dart';
import 'package:followupapp/models/filter_state.dart';
import 'package:followupapp/models/person.dart';
import 'package:followupapp/models/task.dart';
import 'package:followupapp/presentation/common/labeled_date_picker.dart';
import 'package:followupapp/presentation/common/task_indicator_widget.dart';
import 'package:followupapp/presentation/common/task_summary_widget.dart';
import 'package:followupapp/presentation/overlays/filter_tab.dart';
import 'package:followupapp/presentation/screens/task_create_or_edit.dart';
import 'package:followupapp/service/get_areas.dart';
import 'package:followupapp/service/get_people.dart';
import 'package:followupapp/service/get_task_states.dart';
import 'package:followupapp/service/get_tasks.dart';

class TaskViewScreen extends StatefulWidget {
  const TaskViewScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return TasksViewScreenState();
  }
}

class TasksViewScreenState extends State<TaskViewScreen> {
  List<Task> tasks = [];
  List<dynamic> tempList = []; // temporary list for filters
  FilterState filters = FilterState();

  @override
  void initState() {
    super.initState();
    getTasks(filters).then((value) => setState(() => tasks = value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Tareas", style: TextStyle(color: Colors.white)),
        ),
      ),
      body: Column(
        children: [
          const Text("Filters:"),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 30,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                DrawerFilterChip(
                  title: "Areas",
                  active: filters.filterAreas,
                  // filter: filters,
                  bodyBuilder: (context, setStateL) {
                    // this is a utility function that allows us to use
                    // just one setState.
                    void setStateA(void Function() a) {
                      setStateL(() => {});
                      setState(a);
                    }
                    // here we can write our code using setStateA as we would
                    // setState.

                    return ListView(
                      children: [
                        for (Area a in tempList)
                          Center(
                            child: Row(
                              children: [
                                Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      a.areaName,
                                      style: const TextStyle(fontSize: 16),
                                    )),
                                const Spacer(),
                                Checkbox(
                                    // dart sets have a bug in which they will have
                                    // two objects with the same hash
                                    value: filters.allowedAreas.any((element) =>
                                        element.areaName == a.areaName),
                                    onChanged: (v) {
                                      if (filters.allowedAreas.any((element) =>
                                          element.areaName == a.areaName)) {
                                        filters.allowedAreas.removeWhere(
                                            (element) =>
                                                element.areaName == a.areaName);
                                      } else {
                                        filters.allowedAreas.add(a);
                                      }
                                      setStateA(() {});
                                    }),
                                const SizedBox(width: 50)
                              ],
                            ),
                          )
                      ],
                    );
                  },
                  onClose: () {
                    setState(() => {});
                    getTasks(filters)
                        .then((value) => setState(() => tasks = value));
                  },
                  onToggle: (v) => setState(() => filters.filterAreas = v),
                  onBottomSheetOpen: () async {
                    tempList = await getAreas();
                  },
                ),
                DrawerFilterChip(
                  title: "Personas",
                  active: filters.filterPeople,
                  // filter: filters,
                  bodyBuilder: (context, setStateL) {
                    // this is a utility function that allows us to use
                    // just one setState.
                    void setStateA(void Function() a) {
                      setStateL(() => {});
                      setState(a);
                    }
                    // here we can write our code using setStateA as we would
                    // setState.

                    return ListView(
                      children: [
                        for (Person a in tempList)
                          Center(
                            child: Row(
                              children: [
                                Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      a.personName,
                                      style: const TextStyle(fontSize: 16),
                                    )),
                                const Spacer(),
                                Checkbox(
                                    // dart sets have a bug in which they will have
                                    // two objects with the same hash
                                    value: filters.allowedPeople.any(
                                        (element) =>
                                            element.personName == a.personName),
                                    onChanged: (v) {
                                      if (filters.allowedPeople.any((element) =>
                                          element.personName == a.personName)) {
                                        filters.allowedPeople.removeWhere(
                                            (element) =>
                                                element.personName ==
                                                a.personName);
                                      } else {
                                        filters.allowedPeople.add(a);
                                      }
                                      setStateA(() {});
                                    }),
                                const SizedBox(width: 50)
                              ],
                            ),
                          )
                      ],
                    );
                  },
                  onClose: () {
                    setState(() => {});
                    getTasks(filters)
                        .then((value) => setState(() => tasks = value));
                  },
                  onToggle: (v) => setState(() => filters.filterPeople = v),
                  onBottomSheetOpen: () async {
                    tempList = await getPeople();
                  },
                ),
                DrawerFilterChip(
                  title: "Estado de la Tarea",
                  active: filters.filterTaskStates,
                  // filter: filters,
                  bodyBuilder: (context, setStateL) {
                    // this is a utility function that allows us to use
                    // just one setState.
                    void setStateA(void Function() a) {
                      setStateL(() => {});
                      setState(a);
                    }
                    // here we can write our code using setStateA as we would
                    // setState.

                    return ListView(
                      children: [
                        for (TaskState a in tempList)
                          Center(
                            child: Row(
                              children: [
                                Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: TaskStateIndicatorWidget(a)),
                                const Spacer(),
                                Checkbox(
                                    value:
                                        filters.allowedTaskStates.contains(a),
                                    onChanged: (v) {
                                      if (filters.allowedTaskStates
                                          .contains(a)) {
                                        filters.allowedTaskStates.remove(a);
                                      } else {
                                        filters.allowedTaskStates.add(a);
                                      }
                                      setStateA(() {});
                                    }),
                                const SizedBox(width: 50)
                              ],
                            ),
                          )
                      ],
                    );
                  },
                  onClose: () {
                    setState(() => {});
                    getTasks(filters)
                        .then((value) => setState(() => tasks = value));
                  },
                  onToggle: (v) => setState(() => filters.filterTaskStates = v),
                  onBottomSheetOpen: () async {
                    tempList = await getTaskStates();
                  },
                ),
                DrawerFilterChip(
                  title: "Siguiente Fecha",
                  active: filters.filterNextMilestone,
                  // filter: filters,
                  bodyBuilder: (context, setStateL) {
                    // this is a utility function that allows us to use
                    // just one setState.
                    void setStateA(void Function() a) {
                      setStateL(() => {});
                      setState(a);
                    }
                    // here we can write our code using setStateA as we would
                    // setState.

                    return Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Desde: ",
                                style: TextStyle(fontSize: 16)),
                            LabeledDatePicker(
                                value: filters.minNextMilestone,
                                onDatePickerChange: (v) => setStateA(
                                    () => filters.minNextMilestone = v))
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Hasta: ",
                                style: TextStyle(fontSize: 16)),
                            LabeledDatePicker(
                                value: filters.maxNextMilestone,
                                onDatePickerChange: (v) => setStateA(
                                    () => filters.maxNextMilestone = v))
                          ]),
                    ]);
                  },
                  onClose: () {
                    setState(() => {});
                    getTasks(filters)
                        .then((value) => setState(() => tasks = value));
                  },
                  onToggle: (v) =>
                      {setState(() => filters.filterNextMilestone = v)},
                  onBottomSheetOpen: () {},
                ),
                DrawerFilterChip(
                  title: "Fecha de Fin",
                  active: filters.filterEnd,
                  // filter: filters,
                  bodyBuilder: (context, setStateL) {
                    // this is a utility function that allows us to use
                    // just one setState.
                    void setStateA(void Function() a) {
                      setStateL(() => {});
                      setState(a);
                    }
                    // here we can write our code using setStateA as we would
                    // setState.

                    return Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Desde: ",
                                style: TextStyle(fontSize: 16)),
                            LabeledDatePicker(
                                value: filters.minEnd,
                                onDatePickerChange: (v) =>
                                    setStateA(() => filters.minEnd = v))
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Hasta: ",
                                style: TextStyle(fontSize: 16)),
                            LabeledDatePicker(
                                value: filters.maxEnd,
                                onDatePickerChange: (v) =>
                                    setStateA(() => filters.maxEnd = v))
                          ]),
                    ]);
                  },
                  onClose: () {
                    setState(() => {});
                    getTasks(filters)
                        .then((value) => setState(() => tasks = value));
                  },
                  onToggle: (v) => {setState(() => filters.filterEnd = v)},
                  onBottomSheetOpen: () {},
                ),
              ],
            ),
          ), // filters
          const Divider(
            indent: 10,
            endIndent: 10,
          ),
          Expanded(
            child: Column(children: [
              Expanded(
                child: ListView(
                  children: [
                    for (Task t in tasks)
                      TaskSummaryWidget(
                        t,
                        onNavigatorReturnFromDetails: () => getTasks(filters)
                            .then((value) => setState(() => tasks = value)),
                        onNavigatorReturnFromLog: () => getTasks(filters)
                            .then((value) => setState(() => tasks = value)),
                      )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(10),
                child: IconButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.green)),
                  onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TaskCreateOrEdit()))
                        .then((value) => getTasks(filters)
                            .then((v) => setState(() => tasks = v)));
                  },
                  icon: const Icon(Icons.add),
                ),
              ),
            ]),
          ), // tasks
        ],
      ),
    );
  }
}
