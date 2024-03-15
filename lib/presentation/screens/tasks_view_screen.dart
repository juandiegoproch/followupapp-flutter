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
    // TODO: implement initState
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
          SizedBox(
              height: 30,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  FilterChip(label: const Text("a"), onSelected: (v) => {})
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
