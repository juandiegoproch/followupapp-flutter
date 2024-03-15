import 'package:flutter/material.dart';
import 'package:followupapp/models/log.dart';
import 'package:followupapp/models/task.dart';
import 'package:followupapp/presentation/common/log_window.dart';
import 'package:followupapp/presentation/screens/task_create_or_edit.dart';
import 'package:followupapp/presentation/common/task_indicator_widget.dart';
import 'package:followupapp/service/get_logs_for_task.dart';
import 'package:followupapp/service/get_task_by_id.dart';

class TaskDetailScreen extends StatefulWidget {
  final int taskId;
  const TaskDetailScreen({required this.taskId, super.key});
  @override
  State<StatefulWidget> createState() {
    return TaskDetailScreenState();
  }
}

class TaskDetailScreenState extends State<TaskDetailScreen> {
  late Task task;
  late List<LogEntry> log;
  TaskDetailScreenState();

  void fetchTaskAndLog()
  {
    getTaskById(widget.taskId).then((retrievedTask) {
      getLogsForTaskById(widget.taskId).then((retrievedLog) {
                if (!mounted) return;
                setState((){
                  task = retrievedTask;
                  log = retrievedLog;
                });
      });
    });

  }

  @override
  void initState() {
    super.initState();
    task = Task();
    log = [];
    fetchTaskAndLog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Center(
                child: Text(
          "Detalles de la Tarea",
          style: TextStyle(color: Colors.white),
        ))),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: Column(
              children: [
                Row(children: [
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            children: [
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text("Estado:"),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: TaskStateIndicatorWidget(
                                          task.taskState))
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text("Persona:"),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        task.person.personName,
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline),
                                      ))
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text("Area:"),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 25),
                                      child: Text(
                                        task.area.areaName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w200,
                                            decoration:
                                                TextDecoration.underline),
                                      ))
                                ],
                              ),
                            ],
                          ))),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: IconButton(
                          onPressed: () => {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TaskCreateOrEdit(
                                                    taskId: task.id)))
                                    .then( (v) =>
                                      fetchTaskAndLog()
                                    ),
                              },
                          icon: const Icon(Icons.settings)))
                ]),
                const SizedBox(height: 20),
                const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text("Entregable")),
                Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.grey),
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8, bottom: 10, left: 5, right: 5),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(task.deliverable)))),
                const Divider(
                  indent: 10,
                  endIndent: 10,
                ),
                Expanded(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: LogsWindow(log: log),
                ))
              ],
            )),
          ],
        ));
  }
}
