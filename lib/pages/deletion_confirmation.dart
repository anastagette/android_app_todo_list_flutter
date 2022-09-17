import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';

class DeletionConfirmation extends StatefulWidget {

  final int? uid;
  final int notificationId;
  const DeletionConfirmation(
    this.uid, this.notificationId, {Key? key}
  ) : super(key: key);

  @override
  State<DeletionConfirmation> createState() => _DeletionConfirmation();
}

class _DeletionConfirmation extends State<DeletionConfirmation> {

  @override
  Widget build(BuildContext context) {

    return SimpleDialog(
      title: const Text( "The to-do will be deleted.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.black,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 30.0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            // A cancel button
            Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black
                      ),
                      color: Colors.black,
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
                    ),),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.lime
                    ),
                  ),
                ),
              ],
            ),

            // A delete button
            Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black
                      ),
                      color: Colors.black,
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
                    ),),

                  onPressed: () async {
                    await DatabaseService.instance
                      .deleteTask(widget.uid);
                    NotificationService.removeNotification(
                      id: widget.notificationId);
                    if (!mounted) return;
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },

                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.lime
                    ),
                  ),
                ),
              ],
            ),]
        )],
    );
  }
}