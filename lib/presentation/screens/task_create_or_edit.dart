import 'package:flutter/material.dart';
import 'package:followupapp/models/milestone.dart';
import 'package:followupapp/models/task.dart';
import 'package:followupapp/presentation/common/labeled_date_picker.dart';
import 'package:followupapp/presentation/common/task_indicator_widget.dart';
import 'package:followupapp/service/create_task.dart';
import 'package:followupapp/service/get_milestones_for_task.dart';
import 'package:followupapp/service/get_task_by_id.dart';
import 'package:followupapp/service/update_milestones.dart';
import 'package:followupapp/service/update_task.dart';
import 'package:intl/intl.dart';

class TaskCreateOrEdit extends StatefulWidget {
  final int? taskId;
  const TaskCreateOrEdit({this.taskId, super.key});
  @override
  State<TaskCreateOrEdit> createState() {
    return TaskCreateOrEditState();
  }
}

class TaskCreateOrEditState extends State<TaskCreateOrEdit> {
  static const double labelScaleFactor = 1.3;
  late Task taskToEdit;
  late List<Milestone> milestones;
  bool isCreate = false;
  bool fetchError = true;
  bool taskHasEnd = false;

  TextEditingController personaController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController programaController = TextEditingController();
  TextEditingController entregableController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Default values pre fetch:
    taskToEdit = Task();
    taskToEdit.end = Milestone.defaultPlaceholder();
    taskToEdit.end!.isFinal = true;
    taskToEdit.deliverable = "Not Fetched";
    milestones = [];

    // TODO: handle errors
    if (widget.taskId != null) { // if task is edit:
      getTaskById(widget.taskId!).then(
        (fetchedTask) {
          if (!mounted) return;
          setState(() {
            taskToEdit = fetchedTask;
            /* if the task has no end, give it one to 
              this is used to store the value of the end in case one is given
            the end is stored if taskHasEnd = true when user saves task */
            if (taskToEdit.end == null) 
            {
              taskToEdit.end = Milestone.defaultPlaceholder();
              taskToEdit.end!.isFinal = true;
              taskHasEnd = false;
            }                                                  
            else                                               
            {
              taskHasEnd = true;
            }
          });
          updateControllers();
        },
      );
      getMilestonesForTaskById(widget.taskId!).then((fetchedMilestones) {
        if (!mounted) return;
        setState(() {
          milestones = fetchedMilestones;
        });
      });
    } else {
      taskToEdit = Task();
      taskToEdit.end = Milestone.defaultPlaceholder();
      taskToEdit.end!.isFinal = true;
      milestones = [];
      isCreate = true;
    }
    updateControllers();
    personaController.addListener(() {
      taskToEdit.person.personName = personaController.text;
    });

    areaController.addListener(() {
      taskToEdit.area.areaName = areaController.text;
    });

    programaController.addListener(() {
      taskToEdit.program = programaController.text;
    });

    programaController.addListener(() {
      taskToEdit.deliverable = programaController.text;
    });
  }

  void updateControllers() {
    personaController.text = taskToEdit.person.personName;
    areaController.text = taskToEdit.area.areaName;
    programaController.text = taskToEdit.program;
    entregableController.text = taskToEdit.deliverable;
  }

  @override
  void dispose() {
    super.dispose();
    personaController.dispose();
    areaController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            isCreate ? "Crear Tarea" : "Editar Tarea",
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "Persona",
                      textScaler: TextScaler.linear(labelScaleFactor),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: TextField(controller: personaController))
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Area",
                      textScaler: TextScaler.linear(labelScaleFactor),
                    ),
                    const SizedBox(width: 20),
                    Expanded(child: TextField(controller: areaController)),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(
                  endIndent: 10,
                  indent: 10,
                ),
                Row(
                  children: [
                    const Text(
                      "Fecha de fin?",
                      textScaler: TextScaler.linear(labelScaleFactor),
                    ),
                    const Spacer(),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Switch(
                            value: taskHasEnd,
                            onChanged: (hasEnd) => setState(() {
                                  taskHasEnd = hasEnd;
                                  if (hasEnd) {
                                    taskToEdit.taskState =
                                        TaskState.uninitiated;
                                  } else {
                                    taskToEdit.taskState = TaskState.continuous;
                                  }
                                })))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: taskHasEnd
                          ? () {
                              showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2000),
                                      lastDate:
                                          DateTime(DateTime.now().year + 30))
                                  .then((value) {
                                if (value != null) {
                                  setState(() {
                                    taskToEdit.end!.time = value;
                                  });
                                }
                              });
                            }
                          : null,
                      icon: const Icon(Icons.calendar_month),
                    ),
                    Text(taskHasEnd
                        ? DateFormat("dd/MM/yyyy").format(taskToEdit.end!.time)
                        : "-/-/-"),
                  ],
                ),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Programa",
                      textScaler: TextScaler.linear(labelScaleFactor),
                      softWrap: true,
                    )),
                TextField(controller: programaController),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Entregable",
                      textScaler: TextScaler.linear(labelScaleFactor),
                    )),
                TextField(controller: entregableController),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text("Revisiones: ",
                        textScaler: TextScaler.linear(labelScaleFactor))),
                Center(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (int i = 0;
                        i < milestones.length;
                        i++) // add removal thingy
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LabeledDatePicker(
                                value: milestones[i].time,
                                onDatePickerChange: (DateTime? time) {
                                  setState(() {
                                    if (time != null) {
                                      milestones[i].time = time;
                                      milestones.sort(
                                          (Milestone a, Milestone b) => a
                                              .time
                                              .compareTo(b.time));
                                    }
                                  });
                                }),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: IconButton(
                                    onPressed: () =>
                                        setState(() => milestones.removeAt(i)),
                                    icon: const Icon(Icons.close)))
                          ])
                  ],
                )),
                Center(
                  child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(
                            () => milestones.add(Milestone.defaultPlaceholder()),
                          )),
                ),
                Row(children: [
                  const Text(
                    "Estado",
                    textScaler: TextScaler.linear(labelScaleFactor),
                  ),
                  TaskStateIndicatorWidget(taskToEdit.taskState)
                ]),
                Column(
                  children: [
                    ListTile(
                      title: const Text("No Iniciada"),
                      leading: Radio<TaskState>(
                          value: TaskState.uninitiated,
                          groupValue: taskToEdit.taskState,
                          onChanged: taskHasEnd
                              ? (val) =>
                                  setState(() => taskToEdit.taskState = val!)
                              : null),
                    ),
                    ListTile(
                      title: const Text("En Ejecucion"),
                      leading: Radio<TaskState>(
                          value: TaskState.ongoing,
                          groupValue: taskToEdit.taskState,
                          onChanged: taskHasEnd
                              ? (val) =>
                                  setState(() => taskToEdit.taskState = val!)
                              : null),
                    ),
                    ListTile(
                      title: const Text("Finalizada"),
                      leading: Radio<TaskState>(
                          value: TaskState.finalized,
                          groupValue: taskToEdit.taskState,
                          onChanged: taskHasEnd
                              ? (val) =>
                                  setState(() => taskToEdit.taskState = val!)
                              : null),
                    ),
                  ],
                ),
                Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white),
                    child: const Text("Guardar"),
                    onPressed: () async {
                      //TODO: Alert user on error

                      /*
                      This deltes the placeholder end date if the task is not suposed to have it.
                      We do this because we want to keep the value of the selected date for the
                      user if the "no end" switch is cycled.
                       */
                      if (!taskHasEnd) taskToEdit.end = null; 

                      if (isCreate) {
                        createTask(taskToEdit).then((newTaskId) {
                          // do this here to ensure consistency in db

                          updateTaskMilestonesById(newTaskId, milestones)
                              .then((a) => Navigator.pop(context));
                        });
                      } else {
                        updateTask(widget.taskId!, taskToEdit).then((value) {
                          updateTaskMilestonesById(widget.taskId!, milestones)
                              .then((a) => Navigator.pop(context));
                        });
                      }
                    },
                  ),
                )
              ],
            ))));
  }
}
