import 'package:flutter/material.dart';
import 'package:followupapp/models/filter_state.dart';
import 'package:followupapp/models/task.dart';
import 'package:followupapp/presentation/common/task_summary_widget.dart';
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
                  FilterChip(
                      label: const Text("a"),
                      onSelected: (v) => showModalBottomSheet(
                              context: context,
                              builder: (context) => StatefulBuilder(
                                      builder: (context, setStateL) {
                                    return SizedBox.expand(
                                        child: Column(
                                      children: [
                                        Row(children: [
                                          Expanded(
                                              child: Container(
                                                  clipBehavior: Clip.hardEdge,
                                                  height: 30,
                                                  color: Colors.green))
                                        ])
                                      ],
                                    ));
                                  })).then((value) {
                            // On modalBottomSheet return
                          }))
                ],
              )), // filters
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
