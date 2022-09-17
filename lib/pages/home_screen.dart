import 'package:flutter/material.dart';
import '../pages/deletion_confirmation.dart';
import '../pages/add_new_task.dart';
import '../pages/read_and_edit_task.dart';
import '../models/task.dart';
import '../services/database_service.dart';
import '../pages/loading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State <HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 75,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20.0)
              )
            ),
            centerTitle: true,
            title: const Text("To-do List"),
        ),
          body: Padding(
            padding: const EdgeInsets.only(top: 35.0),
            child: FutureBuilder<List<Task>>(
              future: DatabaseService.instance.getTasks(),
              builder: (BuildContext context,
                AsyncSnapshot<List<Task>> snapshot) {
              if (snapshot.hasError) {
                return Directionality(
                  textDirection: TextDirection.ltr,
                  child: MediaQuery(
                    data: const MediaQueryData(),
                    child: Scaffold(
                      body: Center(
                        child: Text(
                        snapshot.error.toString(),
                        textDirection: TextDirection.ltr
                      )),
                    )
                  )
                );
              }

              if (!snapshot.hasData) {
              return const Loading();
              }

              List<Task> tasks = snapshot.data!;
              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (BuildContext context, int index) {

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 11.0,
                      horizontal: 10.0
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor
                      ),
                      color: Theme.of(context).primaryColor,
                      borderRadius:
                        const BorderRadius.all(Radius.circular(20.0))
                    ),
                    child: Slidable(
                      key: Key(tasks[index].title),

                      // Delete button under a slidable card
                      startActionPane: ActionPane(
                        motion: const BehindMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              await showDialog(context: context,
                                builder: (context) =>
                                  DeletionConfirmation(
                                    tasks[index].uid as int,
                                    tasks[index].notificationId as int
                                  ));
                              setState(() {
                                DatabaseService.instance.getTasks();
                              });
                            },
                            icon: Icons.delete,
                            backgroundColor: Theme.of(context).primaryColor,
                            borderRadius: const BorderRadius.all(
                                Radius.circular(20.0)
                            ),
                          )]
                      ),

                      // A slidable card
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)
                        ),
                        color: Colors.amber[50],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: ListTile(
                            title: Text(
                              tasks[index].title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.black
                              )),
                            subtitle: Text(
                              (tasks[index].remarks).toString(),
                              style: const TextStyle(
                                fontSize: 16.0
                              )),
                            onTap: () async {
                              await showDialog(context: context,
                                builder: (BuildContext context){
                                  return ReadEditTask(
                                    tasks[index].uid as int,
                                    tasks[index].title,
                                    tasks[index].remarks,
                                    tasks[index].notificationId as int,
                                    tasks[index].notificationEnabled,
                                    tasks[index].notificationDate,
                                    tasks[index].notificationTime
                                  );},);
                                setState(() {
                                  DatabaseService.instance.getTasks();
                                });
                              },

                            // A check button
                            leading: RawMaterialButton(
                              constraints: const BoxConstraints(minWidth: 40.0),
                              shape: const CircleBorder(),
                              onPressed: () {
                                if (!tasks[index].isDone) {
                                  DatabaseService.instance.
                                    taskIsDone(tasks[index].uid);
                                }
                                else{
                                  DatabaseService.instance
                                    .taskIsNotDone(tasks[index].uid);
                                }
                                setState(() {
                                  DatabaseService.instance.getTasks();
                                });
                              },
                              child: Container(
                                height: 37.0,
                                width: 37.0,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle
                                ),
                                child: tasks[index].isDone
                                  ? const Icon(
                                    Icons.check,
                                    color: Colors.black
                                  )
                                  : null,
                              )
                            ),

                            // Notification date and time
                            trailing: tasks[index].notificationEnabled
                              ? Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.notifications,
                                    color: Colors.black,
                                    size: 14.0
                                  ),
                                  Text(
                                    (tasks[index].notificationDate)
                                      .toString(),
                                    style: const TextStyle(
                                      fontSize: 11.0,
                                    )
                                  ),
                                  Text(
                                    (tasks[index].notificationTime)
                                      .toString(),
                                    style: const TextStyle(
                                      fontSize: 11.0,
                                    )
                                  )]
                              )
                              : null,
                          )
                        ),
                      ),
                    )
                  );
                });
              }
            )
          ),

          // A button to create new task
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 36.0),
            child: Container(
              height: 65.0,
              width: 65.0,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2.5
                ),
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: FloatingActionButton(
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 30.0
                ),

                onPressed: () async {
                  await showDialog(context: context,
                    builder: (BuildContext context){
                      return const AddNewTask();
                      },);
                  setState(() {
                    DatabaseService.instance.getTasks();
                  });
                }

              )
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
        );
      // }
    // );
  }
}
