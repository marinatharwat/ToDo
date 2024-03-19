import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/Auth/custom_text_from_field.dart';
import 'package:todo/firebase_utils.dart';
import 'package:todo/model/task.dart';
import 'package:todo/my_theme.dart';
import 'package:todo/providers/app_confing_provider.dart';
import 'package:todo/providers/auth.provider.dart';
import 'package:todo/setting/dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdateNoteScreen extends StatefulWidget {
  static const String routeName = "updateNote";

  const UpdateNoteScreen({super.key});

  @override
  State<UpdateNoteScreen> createState() => _UpdateNoteScreenState();
}

class _UpdateNoteScreenState extends State<UpdateNoteScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  Task? task;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);

    if (task == null) {
      task = ModalRoute.of(context)?.settings.arguments as Task;
      title.text = task!.title;
      content.text = task!.description;
      selectedDate = DateTime.fromMillisecondsSinceEpoch(
          task!.dateTime.millisecondsSinceEpoch ?? 0);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Task',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color:  MyTheme.whiteColor
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor
      : provider.isDarkMode() ? MyTheme.blackPrimaryDark : MyTheme.lightGreen,
      body: SingleChildScrollView(

        child: Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewInsets.top + 200,
              left: 45,
              right: 45,
              ),
          decoration:
           BoxDecoration(color: provider.isDarkMode() ? MyTheme.blackPrimaryDark : MyTheme.lightGreen,),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                const SizedBox(
                  height: 15,
                ),
                CustomFromField(
                  label: AppLocalizations.of(context)!.enter_task_title,
                  controller: title,
                  validator: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return AppLocalizations.of(context)?.please_title;
                    } else {
                      return null;
                    }
                  },
                  labelColor:provider.isDarkMode()?
                  MyTheme.whiteColor:
                  MyTheme.blackColor,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomFromField(
                  label: AppLocalizations.of(context)!.enter_task_description,
                  controller: content,
                  validator: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return  AppLocalizations.of(context)?.please_description;
                    } else {
                      return null;
                    }
                  },
                  labelColor:provider.isDarkMode()?
                  MyTheme.whiteColor:
                  MyTheme.blackColor,
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
                    style: TextStyle(fontSize: 16,color:provider.isDarkMode()?
                    MyTheme.whiteColor:
                    MyTheme.blackColor, ),
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
                     color:provider.isDarkMode()?
                    MyTheme.whiteColor:
                    MyTheme.blackColor,
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
                      ?.copyWith(fontSize: 18,color:provider.isDarkMode()?
                  MyTheme.whiteColor:
                  MyTheme.blackColor, ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: const BoxDecoration(
                    color:MyTheme.primaryLight,
                  ),
                  child: TextButton(
                    onPressed: ()  {
                      var authProvider =
                      Provider.of<AuthProviders>(context, listen: false);
                      var finalDate = Timestamp.fromMillisecondsSinceEpoch(
                          selectedDate?.millisecondsSinceEpoch ?? 0);
                      if (content.text == task!.description &&
                          title.text == task!.title &&
                          finalDate == task!.dateTime) {
                        print('no changes');
                        return;
                      }
                      task!.title = title.text;
                      task!.description = content.text;
                      task!.dateTime = finalDate.toDate();
                      try {
                        Dialogs.showLoadingDialog(context, 'Add Task...',
                            isCanceled: false);
                         FirebaseUtils.updateTask(authProvider.currentUser?.id,
                            task!.id, task!.toFirestore());
                        Dialogs.closeMessageDialog(context);
                        Dialogs.showMessageDialog(
                          context,
                          'Task update successfully',
                          isClosed: false,
                          positiveActionText: 'Ok',
                          positiveAction: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.check_circle_sharp,
                            color: Colors.green,
                            size: 30,
                          ),
                        );
                      } catch (e) {
                        Dialogs.closeMessageDialog(context);
                        Dialogs.showMessageDialog(
                            context, 'some thing went wrong',
                            icon: const Icon(
                              Icons.error,
                              color: Colors.red,
                            ));
                      }
                    },
                    child: const Text(
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
          const Duration(days: 365),
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
