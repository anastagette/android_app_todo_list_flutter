import 'package:flutter/material.dart';

Future<TimeOfDay?> pickTime(context, notificationDateTime) =>
  showTimePicker(
    context: context,
    initialTime: TimeOfDay(
      hour: notificationDateTime.hour,
      minute: notificationDateTime.minute));