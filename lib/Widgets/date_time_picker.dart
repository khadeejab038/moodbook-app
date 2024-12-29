import 'package:flutter/material.dart';

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Future dates and times are not allowed."),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        onDateTimeChanged(combinedDateTime);
      }
    }
  }
}
