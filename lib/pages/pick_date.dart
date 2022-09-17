import 'package:flutter/material.dart';

Future<DateTime?> pickDate(context, notificationDateTime) =>
  showDatePicker(
    context: context,
    initialDate: notificationDateTime,
    firstDate: DateTime(2022),
    lastDate: DateTime(2100));