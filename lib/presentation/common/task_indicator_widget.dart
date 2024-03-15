import 'package:flutter/material.dart';
import 'package:followupapp/models/task.dart';

class TaskStateIndicatorWidget extends StatelessWidget {
  late final Color bgColor;
  late final Color textColor;
  late final String text;
  TaskStateIndicatorWidget(TaskState st, {super.key}) {
    switch (st) {
      case TaskState.uninitiated:
        bgColor = Colors.yellow;
        textColor = Colors.black;
        text = "No Iniciado";
      case TaskState.ongoing:
        bgColor = Colors.green;
        textColor = Colors.black;
        text = "En Ejecucion";
      case TaskState.finalized:
        bgColor = Colors.black;
        textColor = Colors.white;
        text = "Finalizado";
      case TaskState.continuous:
        bgColor = Colors.purple;
        textColor = Colors.white;
        text = "Continuo";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 3, right: 2, top: 1, bottom: 1),
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.all(Radius.circular(3))),
        child: Text(text, style: TextStyle(color: textColor)));
  }
}