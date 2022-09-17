import 'package:flutter/material.dart';
import '../pages/deletion_confirmation.dart';
import '../pages/pick_date.dart';
import '../pages/pick_time.dart';
import '../services/database_service.dart';
import 'package:intl/intl.dart';
import '../services/notification_service.dart';

class ReadEditTask extends StatefulWidget {

  final int uid;
  final String taskTitle;
  final String taskRemarks;
  final int notificationId;
  bool notificationEnabled;
  String notificationDate;
  String notificationTime;


  ReadEditTask(
    this.uid, this.taskTitle, this.taskRemarks,
    this.notificationId, this.notificationEnabled, this.notificationDate,
    this.notificationTime, {Key? key}) : super(key: key);

  @override
  State<ReadEditTask> createState() => _ReadEditTask();
}

class _ReadEditTask extends State<ReadEditTask> {

  bool editModeDisabled = true;

  @override
  Widget build(BuildContext context) {

    TextEditingController taskTitleController = TextEditingController(
      text: widget.taskTitle);
    taskTitleController.selection = TextSelection.collapsed(
      offset: taskTitleController.text.length);

    TextEditingController taskRemarksController = TextEditingController(
      text: widget.taskRemarks);
    taskRemarksController.selection = TextSelection.collapsed(
      offset: taskRemarksController.text.length);

    return SimpleDialog(

      // Read or edit title
      title: Padding(
        padding: const EdgeInsets.only(top: 15.0),
    child: EditableText(
        readOnly: editModeDisabled,
        controller: taskTitleController,
        focusNode: FocusNode(),
        cursorColor: Theme
          .of(context)
          .primaryColor,
        backgroundCursorColor: Colors.black,
        style: const TextStyle(
          fontWeight: FontWeight. bold,
          fontSize: 16.0,
          color: Colors.black
        ),
        cursorHeight: 20.0,
        cursorRadius: const Radius.circular(20.0)
      )),

      contentPadding: const EdgeInsets.symmetric(
        vertical: 6.0,
        horizontal: 24.0
      ),
      backgroundColor: Colors.amber[50],
      shape: RoundedRectangleBorder(
        side: editModeDisabled
        ? BorderSide.none
        : const BorderSide(width: 2.0, color: Colors.black),
        borderRadius: BorderRadius.circular(20.0),
      ),

      children: [

        Divider(
          thickness: 1.0,
          color: editModeDisabled
          ? Colors.grey[600]
          : Colors.black,
        ),

        // Read or edit remarks
        Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 6.0),
          child: EditableText(
            readOnly: editModeDisabled,
            controller: taskRemarksController,
            focusNode: FocusNode(),
            cursorColor: Theme
              .of(context)
              .primaryColor,
            backgroundCursorColor: Colors.black,
            style: const TextStyle(fontSize: 16.0, color: Colors.black),
            cursorHeight: 20.0,
            cursorRadius: const Radius.circular(20.0)
          )
        ),

        Divider(
          thickness: 1.0,
          color: editModeDisabled
              ? Colors.grey[600]
              : Colors.black,
        ),

        // A button to enable or disable notification
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: [
            Expanded(
              flex: 1,
              child: RawMaterialButton(
                shape: const CircleBorder(),

                onPressed: () async {

                  if (!widget.notificationEnabled) {
                    setState(() => widget.notificationEnabled = true);
                    DatabaseService.instance
                      .updateNotificationEnabled(widget.uid, true);
                    NotificationService.addNotification(
                      id: widget.notificationId,
                      title: widget.taskTitle,
                      body: widget.taskRemarks,
                      scheduledDateTime: DateTime
                        .parse("${(widget.notificationDate)
                        .split('/').reversed.join()}"
                          " ${widget.notificationTime}")
                    );}

                  else {
                    setState(() => widget.notificationEnabled = false);
                    DatabaseService.instance
                      .updateNotificationEnabled(widget.uid, false);
                    NotificationService.removeNotification(
                      id: widget.notificationId);
                  }
                },
                child: Container(
                  height: 37.0,
                  width: 37.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle
                  ),
                  child: widget.notificationEnabled
                    ? const Icon(
                    Icons.notifications,
                    color: Colors.black
                    )
                    : const Icon(
                    Icons.notifications_outlined,
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
                  if(widget.notificationEnabled) {
                    final newDate = await pickDate(context, DateTime
                      .parse("${(widget.notificationDate)
                      .split('/').reversed.join()}"
                        " ${widget.notificationTime}"));

                    if (newDate == null) return;

                    setState(() => widget.notificationDate =
                      DateFormat("dd/MM/yyyy").format(newDate));
                    setState(() => widget.notificationTime =
                      DateFormat("HH:mm").format(newDate));
                    DatabaseService.instance
                      .updateNotificationDate(widget.uid,
                        widget.notificationDate);

                    NotificationService.updateNotification(
                      id: widget.notificationId,
                        title: widget.taskTitle,
                        body: widget.taskRemarks,
                        scheduledDateTime: DateTime
                          .parse("${(widget.notificationDate)
                          .split('/').reversed.join()}"
                            " ${widget.notificationTime}"));
                  } else {null;}
                },
                child: Text(
                  widget.notificationDate,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: widget.notificationEnabled
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
                  ),
                ),

                onPressed: () async {

                  if(widget.notificationEnabled) {
                    final time = await pickTime(context, DateTime
                      .parse("${(widget.notificationDate)
                      .split('/').reversed.join()}"
                        " ${widget.notificationTime}"));

                    if (time == null) return;

                    final hours = time.hour.toString().padLeft(2, '0');
                    final minutes = time.minute.toString().padLeft(2, '0');
                    setState(() => widget.notificationTime = "$hours:$minutes");

                    DatabaseService.instance
                      .updateNotificationTime(widget.uid,
                      widget.notificationTime);

                    NotificationService.updateNotification(
                      id: widget.notificationId,
                      title: widget.taskTitle,
                      body: widget.taskRemarks,
                      scheduledDateTime: DateTime
                        .parse("${(widget.notificationDate)
                        .split('/').reversed.join()}"
                          " ${widget.notificationTime}"));
                  } else {null;}
                },
                child: Text(
                  widget.notificationTime,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: widget.notificationEnabled
                      ? Colors.black
                      : Colors.grey[700]
                  ),
                )
              )
            )
          ])
        ),

        // A button to delete or cancel task editing
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: editModeDisabled
                              ? Theme.of(context).primaryColor
                              : Colors.black,
                          width: editModeDisabled ? 0.0 : 2.0
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
                    )),

                  // Delete task
                  onPressed: () {
                    editModeDisabled
                    ? showDialog(context: context,
                        builder: (context) =>
                          DeletionConfirmation(
                            widget.uid,
                            widget.notificationId
                          ))

                    // Cancel task editing
                    : setState(() => editModeDisabled = true);
                    },

                  child: editModeDisabled
                    ? const Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.black
                      )
                    )
                    : const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black
                      ),
                    )
                ),
              ],
            ),

            // A button to enable task editing or save a modified task
            Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: editModeDisabled
                        ? Theme.of(context).primaryColor
                        : Colors.black,
                        width: editModeDisabled ? 0.0 : 2.0
                      ),
                      color: Theme
                        .of(context)
                        .primaryColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20.0))
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16
                    )),

                  onPressed: () async{
                    // Enable task editing
                    if (editModeDisabled){
                      setState(() => editModeDisabled = false);
                    }

                    // Save a modified task
                    else{
                      if (taskTitleController.text.isNotEmpty) {
                        await DatabaseService.instance
                          .updateTask(widget.uid,
                          taskTitleController.text.trim(),
                          taskRemarksController.text.trim());

                        if (widget.notificationEnabled) {
                          NotificationService.updateNotification(
                              id: widget.notificationId,
                              title: taskTitleController.text.trim(),
                              body: taskRemarksController.text.trim(),
                              scheduledDateTime: DateTime
                                  .parse("${(widget.notificationDate)
                                  .split('/')
                                  .reversed
                                  .join()}"
                                  " ${widget.notificationTime}"));
                        }

                        if (!mounted) return;
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: editModeDisabled
                  ? const Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.black
                    )
                  )
                  : const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.black
                    )
                  )
                ),
              ],
            )]
          )
        )],
    );
  }
}