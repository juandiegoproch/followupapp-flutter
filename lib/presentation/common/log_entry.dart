import 'package:flutter/material.dart';
import 'package:followupapp/models/log.dart';
import 'package:intl/intl.dart';

class LogEntryWidget extends StatelessWidget {
  final LogEntry logEntry;
  final Function(int)? onEdit;
  final Function(int)? onDelete;
  const LogEntryWidget(
      {required this.logEntry, this.onEdit, this.onDelete, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 217, 217, 217)),
        child: Column(
          children: [
            Row(children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                      "• ${DateFormat.yMd().add_jm().format(logEntry.createdAt)}",
                      style: const TextStyle(fontStyle: FontStyle.italic))),
              const Spacer(),
              onEdit != null
                  ? IconButton(
                      // button for deleting the log
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.grey)),
                      onPressed: () => onEdit!(logEntry.id),
                      icon: const Icon(Icons.edit))
                  : Container(),
              const SizedBox(width: 5),
              onDelete != null
                  ? IconButton(
                      // button for deleting the log
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.red)),
                      onPressed: () => onDelete!(logEntry.id),
                      icon: const Icon(Icons.delete))
                  : Container(),
              const SizedBox(width: 5),
            ]),
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      logEntry.logValue,
                      textScaler: const TextScaler.linear(1.5),
                    ))),
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                child: Divider())
          ],
        ));
  }
}
