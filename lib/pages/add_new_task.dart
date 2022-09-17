import 'package:flutter/material.dart';
import '../services/database_service.dart';
import 'package:intl/intl.dart';
import '../pages/pick_date.dart';
import '../pages/pick_time.dart';
import '../services/notification_service.dart';
import 'dart:math';
import '../models/task.dart';

class AddNewTask extends StatefulWidget {

  const AddNewTask({Key? key}) : super(key: key);

  @override
  State<AddNewTask> createState() => _AddNewTask();
}

class _AddNewTask extends State<AddNewTask> {

  TextEditingController taskTitleController = TextEditingController();
  TextEditingController taskRemarksController = TextEditingController();
  int notificationId = Random().nextInt(1000000);
  bool notificationEnabled = false;
  DateTime notificationDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {

    final hours = notificationDateTime.hour.toString().padLeft(2, '0');
    final minutes = notificationDateTime.minute.toString().padLeft(2, '0');

    return SimpleDialog(

      // A task title
      title: TextFormField(
        decoration: const InputDecoration(
          hintText: 'To-do'
        ),
        controller: taskTitleController,
        style: const TextStyle(
          fontWeight: FontWeight. bold,
          fontSize: 16.0,
          color: Colors.black
        ),
        autofocus: true,
        showCursor: true,
        cursorHeight: 20.0,
        cursorRadius: const Radius.circular(20.0)
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
      backgroundColor: Colors.amber[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),

      children: [

        // Task remarks
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Remarks'
          ),
          controller: taskRemarksController,
          style: const TextStyle(fontSize: 16.0, color: Colors.black),
          cursorHeight: 20.0,
          cursorRadius: const Radius.circular(20.0)
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child:Row(
            children: [

              // A button to enable or disable notification
              Expanded(
                flex: 1,
                child: RawMaterialButton(
                  shape: const CircleBorder(),

                  onPressed: () {
                    if (!notificationEnabled) {
                      setState(() => notificationEnabled = true);
                      timePicker();
                      datePicker();
                    }
                    else {
                      setState(() => notificationEnabled = false);
                    }},

                  child: Container(
                    height: 37.0,
                    width: 37.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle
                    ),
                    child: notificationEnabled
                      ? const Icon(
                      Icons.notification_add,
                      color: Colors.black
                      )
                      : const Icon(
                      Icons.notification_add_outlined,
                      color: Colors.black
                    ),
                  ),
                )
              ),

              // A button to set notification date
              Expanded(
                flex: 2,
                child: TextButton(
                  style: TextButton.styleFrom(
                  shape: const CircleBorder(),
                  textStyle: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black
                  ),),

                  onPressed: () async {
                    if(notificationEnabled) {
                      datePicker();
                    } else {null;}},

                  child: Text(
                    '${notificationDateTime.day}'
                      '/${notificationDateTime.month}'
                      '/${notificationDateTime.year}',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: notificationEnabled
                        ? Colors.black
                        : Colors.grey[700]
                    )
                  ),
                )
              ),

              // A button to set notification time
              Expanded(
                flex: 1,
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black
                    ),),

                  onPressed: () async {
                    if(notificationEnabled) {
                      timePicker();
                    } else {null;}
                  },

                  child: Text(
                    '$hours:$minutes',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: notificationEnabled
                        ? Colors.black
                        : Colors.grey[700]
                    ),
                  )
                )
              )]
          )
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                // A cancel button
                Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme
                              .of(context)
                              .primaryColor
                          ),
                          color: Theme
                            .of(context)
                            .primaryColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20.0)
                          )
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        shape: const CircleBorder(),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0
                        ),),

                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black
                        ),
                      ),

                    ),
                  ],
                ),

                // A save button
                Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme
                              .of(context)
                              .primaryColor
                          ),
                          color: Theme
                            .of(context)
                            .primaryColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20.0)
                          )
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        shape: const CircleBorder(),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        )),

                      onPressed: () async {
                        if (taskTitleController.text.isNotEmpty) {
                          await DatabaseService.instance
                            .createNewTask(
                            Task(
                              title: taskTitleController.text.trim(),
                              remarks: taskRemarksController.text.trim(),
                              notificationId: notificationId,
                              notificationEnabled: notificationEnabled,
                              notificationDate: DateFormat("dd/MM/yyyy")
                                .format(notificationDateTime),
                              notificationTime: DateFormat("HH:mm")
                                .format(notificationDateTime)));

                          if(notificationEnabled){
                          NotificationService.addNotification(
                            id: notificationId,
                            title: taskTitleController.text.trim(),
                            body: taskRemarksController.text.trim(),
                            scheduledDateTime: notificationDateTime
                          );}

                          if (!mounted) return;
                          Navigator.pop(context);
                        }
                      },

                      child: const Text(
                        'Save',
                        style: TextStyle(
                            color: Colors.black
                        ),
                      ),
                    ),
                  ],
                ),]
            )
          )],
    );
  }

  void datePicker() async {
    final date = await pickDate(context, notificationDateTime);
    if (date == null) return;
    setState(() => notificationDateTime = date);
  }

  void timePicker() async {
    final time = await pickTime(context, notificationDateTime);
    if (time == null) return;

    final newNotificationDateTime = DateTime(
        notificationDateTime.year,
        notificationDateTime.month,
        notificationDateTime.day,
        time.hour,
        time.minute
    );

    setState(() =>
    notificationDateTime = newNotificationDateTime);
  }
}