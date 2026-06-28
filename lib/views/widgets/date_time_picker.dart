import 'package:flutter/material.dart';
import 'snack_bar_helper.dart';

Future<void> selectDateAndTime(BuildContext context, DateTime selectedDateTime, Function(DateTime) onDateTimeChanged) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: selectedDateTime,
    firstDate: DateTime(2000),
    lastDate: DateTime.now(),
  );

  if (pickedDate != null) {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
    );

    if (pickedTime != null) {
      final DateTime combinedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      if (combinedDateTime.isAfter(DateTime.now())) {
        showSnackBar(context, "Future dates and times are not allowed.");
      } else {
        onDateTimeChanged(combinedDateTime);
      }
    }
  }
}
