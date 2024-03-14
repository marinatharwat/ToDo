import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/dialog_utils.dart';
import 'package:todo/firebase_utils.dart';
import 'package:todo/my_theme.dart';
import 'package:todo/providers/app_confing_provider.dart';
import 'package:todo/model/task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/setting/dialogs.dart';


class UpdateTaskScreen extends StatefulWidget {
  static const String  routeName='updateNote';
  final Task task;

  UpdateTaskScreen({Key? key, required this.task}) : super(key: key);


  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  Task? task;
  late AppConfigProvider provider;
  @override
  Widget build(BuildContext context) {
    if (task == null) {
      task = ModalRoute.of(context)?.settings.arguments as Task;
      title.text = task!.title!;
      description.text = task!.description!;
      selectedDate = DateTime.fromMillisecondsSinceEpoch(
          task!.dateTime?.millisecondsSinceEpoch ?? 0);
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewInsets.top + 100,
              left: 45,
              right: 45,
              bottom: MediaQuery.of(context).viewInsets.bottom + 50),
          decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.onBackground),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Update Task',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  onChanged: (text) {
                    title = title;
                  },
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return AppLocalizations.of(context)?.please_title;
                    }
                    return null;
                  },
                  style: TextStyle(
                    color: provider.isDarkMode() ? Colors.white : Colors.black, // Set text color based on dark mode
                  ),
                  decoration:  InputDecoration(
                    hintText: AppLocalizations.of(context)?.enter_task_title,

                    hintStyle:  TextStyle(fontSize: 16,color:provider.isDarkMode()?
                    MyTheme.whiteColor:
                    MyTheme.blackColor, ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  onChanged: (text) {
                    description = description;
                  },
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return AppLocalizations.of(context)?.please_description;
                    }
                    return null;
                  },
                  style: TextStyle(
                    color: provider.isDarkMode() ? Colors.white : Colors.black, // Set text color based on dark mode
                  ),
                  decoration:  InputDecoration(
                    hintText: AppLocalizations.of(context)?.enter_task_description,
                    hintStyle:  TextStyle(fontSize: 16,color:provider.isDarkMode()?
                    MyTheme.whiteColor:
                    MyTheme.blackColor, ),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(
                  height: 25,
                ),
                InkWell(
                  onTap: () {
                    showTaskDate();
                  },
                  child: Text(
                    'Select date',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                SizedBox(
                  height: showDateError ? 0 : 15,
                ),
                Visibility(
                  visible: showDateError,
                  child: Text(
                    'please enter date',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      fontFamily: '',
                    ),
                  ),
                ),
                Text(
                  selectedDate == null
                      ? ''
                      : '${selectedDate?.day} / ${selectedDate?.month} / ${selectedDate?.year}',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: TextButton(
                    onPressed: () async {
                      var authProvider =
                      Provider.of<AuthProvider>(context, listen: false);
                      var finalDate = Timestamp.fromMillisecondsSinceEpoch(
                          selectedDate?.millisecondsSinceEpoch ?? 0);
                      if (description.text == task!.description &&
                          title.text == task!.title &&
                          finalDate == task!.dateTime) {
                        print('no changes');
                        return;
                      }
                      task!.title = title.text;
                      task!.description = description.text;
                      // task!.dateTime = finalDate;
                      try {
                        DialogUtils.showMessage(
                            context:context, message: 'Add Task... ');
                        await FirebaseUtils.updateTask(authProvider.providerId,
                            task!.id, task!.toFirestore());
                        Dialogs.closeMessageDialog(context);
                        Dialogs.showMessageDialog(
                          context,
                          'Task added successfully',
                          isClosed: false,
                          positiveActionText: 'Ok',
                          positiveAction: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.check_circle_sharp,
                            color: Colors.green,
                            size: 30,
                          ),
                        );
                      } catch (e) {
                        Dialogs.closeMessageDialog(context);
                        Dialogs.showMessageDialog(
                            context, 'some thing went wrong',
                            icon: Icon(
                              Icons.error,
                              color: Colors.red,
                            ));
                      }
                    },
                    child: Text(
                      'Ubdate Task',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  DateTime? selectedDate;

  bool showDateError = false;

  void showTaskDate() async {
    var date = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(
          Duration(days: 365),
        ));
    selectedDate = date;
    setState(() {
      selectedDate = date;
      if (selectedDate != null) {
        showDateError = false;
      }
    });
  }

  bool validation() {
    if (formKey.currentState!.validate() && selectedDate != null) {
      return true;
    }
    setState(() {
      if (selectedDate == null) {
        showDateError = true;
      }
    });
    return false;
  }
}
