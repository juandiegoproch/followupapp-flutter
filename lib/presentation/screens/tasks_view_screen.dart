import 'package:flutter/material.dart';
import 'package:followupapp/models/area.dart';
import 'package:followupapp/models/filter_state.dart';
import 'package:followupapp/models/person.dart';
import 'package:followupapp/models/task.dart';
import 'package:followupapp/presentation/common/task_summary_widget.dart';
import 'package:followupapp/presentation/overlays/filter_tab.dart';
import 'package:followupapp/service/get_areas.dart';
import 'package:followupapp/service/get_people.dart';
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
        body: Column(children: [
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
                  filter: filters,
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
                          Row(children: [
                            Text(a.areaName),
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
                                })
                          ])
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
                  filter: filters,
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
                          Row(children: [
                            Text(a.personName),
                            Checkbox(
                                // dart sets have a bug in which they will have
                                // two objects with the same hash
                                value: filters.allowedPeople.any((element) =>
                                    element.personName == a.personName),
                                onChanged: (v) {
                                  if (filters.allowedAreas.any((element) =>
                                      element.areaName == a.personName)) {
                                    filters.allowedAreas.removeWhere(
                                        (element) =>
                                            element.areaName == a.personName);
                                  } else {
                                    filters.allowedPeople.add(a);
                                  }
                                  setStateA(() {});
                                })
                          ])
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
              ],
            ),
          ), // filters
          const Divider(
            indent: 10,
            endIndent: 10,
          ),
          Expanded(
              child: ListView(children: [
            for (Task t in tasks)
              TaskSummaryWidget(
                t,
                onNavigatorReturnFromDetails: () => getTasks(filters)
                    .then((value) => setState(() => tasks = value)),
                onNavigatorReturnFromLog: () => getTasks(filters)
                    .then((value) => setState(() => tasks = value)),
              )
          ])), // tasks
        ]));
  }
}
