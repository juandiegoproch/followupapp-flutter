import 'package:flutter/material.dart';
import 'package:followupapp/models/log.dart';
import 'package:followupapp/presentation/common/log_window.dart';
import 'package:followupapp/service/create_log_entry.dart';
import 'package:followupapp/service/get_log_entry.dart';
import 'package:followupapp/service/get_logs_for_task.dart';
import 'package:followupapp/service/remove_log_entry.dart';
import 'package:followupapp/service/update_log_entry.dart';

class LogAddOrEdit extends StatefulWidget {
  final int taskId;
  const LogAddOrEdit({required this.taskId, super.key});
  @override
  State<StatefulWidget> createState() {
    return LogAddOrEditState();
  }
}

class LogAddOrEditState extends State<LogAddOrEdit> {
  late List<LogEntry> log;
  int? currentlyEdited; // null when it is a new logEntry
  late TextEditingController textController;

  String tempText = "";
  bool tempIsHeldDown = false;

  @override
  void initState() {
    super.initState();
    log = [];
    textController = TextEditingController();
    getLogsForTaskById(widget.taskId).then((retrievedLog) {
      if (!mounted) return;
      setState(() {
        log = retrievedLog;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
          "Editar Bitacora",
          style: TextStyle(color: Colors.white),
        )),
        body: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Expanded(
                    child: LogsWindow(
                  highlighted: currentlyEdited,
                  log: log,
                  onDelete: (int toDeleteId) {
                    removeLogEntry(widget.taskId, toDeleteId).then((value) => {
                          getLogsForTaskById(widget.taskId).then((updatedLog) {
                            setState(() {
                              currentlyEdited =
                                  null; // in case we delete this log, dont leave dangling ids
                              log = updatedLog;
                            });
                          })
                        });
                  },
                  onEdit: (int toEditId) {
                    if (currentlyEdited == toEditId) {
                      setState(() => currentlyEdited = null);
                    } // unselect this
                    else {
                      setState(() => currentlyEdited = toEditId);
                      getLogEntryByTaskIdAndLogId(widget.taskId, toEditId).then(
                          (logEntry) =>
                              textController.text = logEntry.logValue);
                    }
                  },
                )),
                Row(children: [
                  Expanded(
                      child: TextField(
                    controller: textController,
                    maxLines: null,
                  )),
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white),
                      onPressed: () {
                        if (currentlyEdited == null) {
                          createLogEntry(
                                  widget.taskId,
                                  LogEntry.defaultPlaceholder(
                                      0, DateTime.now(), textController.text))
                              .then((v) => getLogsForTaskById(widget.taskId)
                                  .then((fetchedLogs) =>
                                      setState(() => log = fetchedLogs)));
                        } else {
                          updateLogEntry(
                                  widget.taskId,
                                  currentlyEdited!,
                                  LogEntry.defaultPlaceholder(
                                      0, DateTime.now(), textController.text))
                              .then((v) => getLogsForTaskById(widget.taskId)
                                  .then((fetchedLogs) =>
                                      setState(() => log = fetchedLogs)));
                        }
                        textController.text = ''; // clear out the buffer so user gets feedback
                        currentlyEdited =
                            null; // people usually dont want to edit what they just finished editing
                      },
                      child: const Text("Guardar"))
                ])
              ],
            )));
  }
}
/*
    return Scaffold(
        body: LogsWindow(
      log: log,
      onEdit: (a) {
        // do the edit thing. Should set the 

      },
      onDelete: (b){
        // do the delete thing
      },
    ));
    */