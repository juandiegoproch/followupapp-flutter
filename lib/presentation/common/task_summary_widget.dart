import 'package:flutter/material.dart';
import 'package:followupapp/models/milestone.dart';
import 'package:followupapp/models/task.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:followupapp/presentation/screens/log_add_or_edit.dart';
import 'package:followupapp/presentation/screens/task_detail_screen.dart';
import 'package:followupapp/presentation/common/task_indicator_widget.dart';

class TaskSummaryWidget extends StatelessWidget {
  final Task task;
  late final String taskIconPath;
  late final void Function()? onNavigatorReturnFromDetails, onNavigatorReturnFromLog;
  TaskSummaryWidget(Task task_, {this.onNavigatorReturnFromDetails, this.onNavigatorReturnFromLog, super.key})
      : task = task_ {
    switch (task.nextMilestone?.status) {
      case null:
      case MilestoneStatus.nothing:
        taskIconPath = "assets/nothing.svg";
        break;
      case MilestoneStatus.lateFinal:
        taskIconPath = "assets/LateFinal.svg";
        break;
      case MilestoneStatus.upcomingFinal:
        taskIconPath = "assets/ImminentFinal.svg";
        break;
      case MilestoneStatus.lateRevision:
        taskIconPath = "assets/LateRevision.svg";
        break;
      case MilestoneStatus.upcomingRevision:
        taskIconPath = "assets/ImminentRevision.svg";
        break;
    }
  }

  @override
  build(context) {
    assert(debugCheckHasMaterial(context));
    return Card(
        margin: const EdgeInsets.all(5),
        child: Container(
            padding: const EdgeInsets.only(left: 5),
            child: InkResponse(
                onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TaskDetailScreen(taskId: task.id))).then((a) {
                        if (onNavigatorReturnFromDetails != null) onNavigatorReturnFromDetails!();
                      })
                    },
                child: Column(children: [
                  Row(children: [
                    Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(task.deliverable),
                            const Divider(
                              color: Color.fromARGB(255, 37, 37, 37),
                              height: 1,
                            ),
                            Text(task.person.personName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300)),
                          ],
                        )),
                    Container(
                        padding: const EdgeInsets.only(left: 5),
                        child: IconButton(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            onPressed: () => {Navigator.push(context,MaterialPageRoute(builder: (context) => LogAddOrEdit(taskId: task.id))).then((value){ if (onNavigatorReturnFromLog != null) onNavigatorReturnFromLog!();})},
                            icon: const Icon(Icons.add))),
                  ]),
                  Row(children: [
                    Text(task.nextMilestone == null?"":
                        "${task.nextMilestone?.time.day.toString()}/${task.nextMilestone?.time.month.toString()}/${task.nextMilestone?.time.year.toString()}"),
                    const Spacer(),
                    Container(
                        padding: const EdgeInsets.only(right: 20, bottom: 5),
                        child: SvgPicture.asset(taskIconPath,
                            width: 50, height: 25)),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: TaskStateIndicatorWidget(task.taskState))
                  ]),
                ]))));
  }
}
