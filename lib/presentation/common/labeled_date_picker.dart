import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LabeledDatePicker extends StatelessWidget {
  final Function(DateTime?) onDatePickerChange;
  final DateTime? value;
  late final DateTime firstDate_;
  LabeledDatePicker(
      {required this.onDatePickerChange, this.value, DateTime? firstDate, super.key})
      {
        if (firstDate != null) {
          firstDate_ = firstDate_;
        } else {
          firstDate_ = DateTime(2000);
        }
      }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () {
              showDatePicker(
                      context: context,
                      firstDate: firstDate_,
                      lastDate: DateTime(DateTime.now().year + 30))
                  .then((value) => onDatePickerChange(value));
            },
            icon: const Icon(Icons.calendar_month)),
        Text(value != null
            ? DateFormat("dd/MM/yyyy").format(value!)
            : "--/--/--"),
      ],
    );
  }
}
