import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo/firebase_utils.dart';
import 'package:todo/model/task.dart';
import 'package:todo/my_theme.dart';
import 'package:todo/providers/auth.provider.dart';
import '../providers/app_confing_provider.dart';
import 'edit_task.dart';
class ItemTask extends StatefulWidget {
   final Task task;

  const ItemTask({Key? key, required this.task, }) : super(key: key);
  @override
  State<ItemTask> createState() => _ItemTaskState();
}
CrossFadeState crossFadeState = CrossFadeState.showFirst;
Color titleColor = const Color(0xFF82B1FF);
bool isDone = false;
class _ItemTaskState extends State<ItemTask> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);

    var dateOfTask = DateTime.fromMillisecondsSinceEpoch(
        widget.task.dateTime.millisecondsSinceEpoch);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 150,
        child: Slidable(
          startActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (sliderContext) {
                  var authProvider = Provider.of<AuthProviders>(context, listen: false);
                  FirebaseUtils.deleteTask(
                      authProvider.currentUser?.id,
                      widget.task.id
                  ).then((_) {
                    setState(() {
                    });
                  }).catchError((error) {
                    print('Error deleting task: $error');
                  });
                },
                icon: Icons.delete,
                backgroundColor: Colors.red,
                label: 'delete',
                borderRadius: BorderRadius.circular(15),
              ),
            ],
          ),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                foregroundColor: Colors.white,
                onPressed: (slidableContext) {
                  Navigator.pushNamed(context, UpdateNoteScreen.routeName,
                      arguments: widget.task);
                },
                icon: Icons.edit,
                backgroundColor: const Color(0xFF0daec7),
                label: 'Edit',
                borderRadius: BorderRadius.circular(15),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: 352,
              height: 110,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: provider.isDarkMode() ? MyTheme.blackPrimaryDark : MyTheme.whiteColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color:   MyTheme.primaryLight,
                        borderRadius: BorderRadius.circular(10)),
                    width: 4,
                    height: double.infinity,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.task.title,
                          style: const TextStyle(color:MyTheme.primaryLight),
                          overflow: TextOverflow.ellipsis,
                        ),

                        Text(
                          widget.task.description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: 13,color:provider.isDarkMode() ? MyTheme.whiteColor : MyTheme.blackColor, ),
                        ),

                        Row(
                          children: [
                            Text(
                              '${dateOfTask.day} / ${dateOfTask.month} / ${dateOfTask.year}',
                              style: Theme.of(context).textTheme.bodySmall ?.copyWith(color:provider.isDarkMode() ? MyTheme.whiteColor : MyTheme.blackColor,
                            )),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
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
      ),
    );
  }
  void _updateTaskStatus() async {
    CrossFadeState crossFadeState = CrossFadeState.showFirst;

    var authProvider = Provider.of<AuthProviders>(context, listen: false);
    if (authProvider.currentUser != null) {
      var userId = authProvider.currentUser!.id;
      try {
        await FirebaseUtils.updateTask(userId, widget.task.id, {'isdone': isDone});
        setState(() {
          crossFadeState = CrossFadeState.showSecond;
        });
      } catch (error) {
        print('Error updating task status: $error');
      }
    }
  }
}
