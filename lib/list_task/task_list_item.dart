import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo/dialog_utils.dart';
import 'package:todo/firebase_utils.dart';
import 'package:todo/model/task.dart';
import 'package:todo/my_theme.dart';
import 'package:todo/providers/app_confing_provider.dart';
import 'package:todo/providers/auth.provider.dart';
import 'package:todo/providers/auth.provider.dart';
import 'package:todo/providers/auth.provider.dart';
import 'package:todo/providers/auth.provider.dart';
import 'package:todo/setting/dialogs.dart';

import 'edit_task.dart';
class ItemTask extends StatefulWidget {
  late final Task task;
  ItemTask? show;
  ItemTask({Key? key, required this.task,this.show}) : super(key: key);

  @override
  State<ItemTask> createState() => _ItemTaskState();
}

class _ItemTaskState extends State<ItemTask> {
  bool isDone = false;



  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    var authProvider = Provider.of<AuthProviders>(context, listen: false);
    CrossFadeState crossFadeState = CrossFadeState.showFirst;

    return  InkWell(
      onTap: () {
        // widget.show?.call(widget.task?.title, widget.task?.description);
      },
      child: Container(
        margin:  EdgeInsets.all(10),
        child: Slidable(
          key: UniqueKey(),
          startActionPane: ActionPane(
            extentRatio: 0.25,
            motion:  DrawerMotion(),
            dismissible: DismissiblePane(onDismissed: () {}),
            children: [
              SlidableAction(
                onPressed: (sliderContext) {
                  var authProvider = Provider.of<AuthProviders>(context, listen: false);
                  Dialogs.showMessageDialog(
                      context, 'task delete',
                      icon: Icon(
                        Icons.warning,
                        color: Colors.yellow[800],
                      ),
                      positiveActionText: '.yes',
                      positiveAction: () {
                        FirebaseUtils.deleteTask(
                            authProvider.currentUser?.id, widget.task.id);
                      },
                      negativeActionText: 'no',
                      negativeAction: () {
                        Navigator.pop(context);
                      }
                  );
                },



                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.zero,
                  topLeft: Radius.circular(15),
                  topRight: Radius.zero,
                ),
                backgroundColor: MyTheme.redDark,
                foregroundColor: MyTheme.whiteColor,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: provider.isDarkMode()
                  ? MyTheme.primaryDark
                  : MyTheme.whiteColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 13,
                    width: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: MyTheme.primaryLight,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.task.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                            color: MyTheme.primaryLight,
                          )),
                      Text(widget.task.description,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                            color: provider.isDarkMode()
                                ? MyTheme.whiteColor
                                : MyTheme.blackColor,
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isDone = !isDone;
                      });
                      _updateTaskStatus();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: isDone ? MyTheme.greenColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isDone,
                            activeColor: MyTheme.primaryLight,
                            onChanged: (value) {
                              setState(() {
                                isDone = value ?? false;
                              });
                              _updateTaskStatus();
                            },
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            widget.task.title,
                            style: TextStyle(
                              color: isDone
                                  ? provider.isDarkMode()
                                  ? MyTheme.blackColor
                                  : MyTheme.whiteColor
                                  : provider.isDarkMode()
                                  ? MyTheme.whiteColor
                                  : MyTheme.blackColor,
                              decoration: isDone ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _updateTaskStatus() async {
    CrossFadeState crossFadeState = CrossFadeState.showFirst;

    var authProvider = Provider.of<AuthProviders>(context, listen: false);
    if (authProvider != null && authProvider.currentUser != null) {
      var userId = authProvider.currentUser!.id;
      try {
        await FirebaseUtils.updateTask(userId, widget.task?.id, {'isdone': isDone});
        setState(() {
          crossFadeState = CrossFadeState.showSecond;
        });
      } catch (error) {
        print('Error updating task status: $error');
      }
    }
  }
}