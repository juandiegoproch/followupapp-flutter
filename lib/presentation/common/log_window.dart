import 'package:flutter/material.dart';
import 'package:followupapp/models/log.dart';
import 'package:followupapp/presentation/common/log_entry.dart';

class LogsWindow extends StatelessWidget {
  final List<LogEntry> log;
  final int? highlighted;
  final Function(int)? onEdit;
  final Function(int)? onDelete;
  const LogsWindow(
      {required this.log,
      this.highlighted,
      this.onEdit,
      this.onDelete,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color.fromARGB(255, 243, 243, 243),
        padding: const EdgeInsets.all(5),
        child: ListView(
          children: [
            for (LogEntry l in log)
              Container(
                  decoration: highlighted == l.id
                      ? BoxDecoration(border: Border.all())
                      : null,
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: LogEntryWidget(
                    logEntry: l,
                    onEdit: onEdit,
                    onDelete: onDelete,
                  ))
          ],
        ));
  }
}
