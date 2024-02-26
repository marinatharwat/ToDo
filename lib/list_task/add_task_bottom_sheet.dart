import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/firebase_utils.dart';
import 'package:todo/model/task.dart';
import 'package:todo/my_theme.dart';
import 'package:todo/providers/app_confing_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({Key? key}) : super(key: key);

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  var selectedDate = DateTime.now();
  var fromKey = GlobalKey<FormState>();
  String title = '';
  String description = '';

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);

    return Padding(
      padding:  const EdgeInsets.all(8.0),
      child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: 
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppLocalizations.of(context)!.add_new_task,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Form(
                    key: fromKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              onChanged: (text) {
                                title = text;
                              },
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return AppLocalizations.of(context)?.please_title;
                                }
                                return null;
                              },
                              decoration:  InputDecoration(
                                hintText: AppLocalizations.of(context)?.enter_task_title,
                                hintStyle:  TextStyle(fontSize: 16,color:provider.isDarkMode()?
                                MyTheme.whiteColor:
                                MyTheme.blackColor, ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              onChanged: (text) {
                                description = text;
                              },
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return AppLocalizations.of(context)?.please_description;
                                }
                                return null;
                              },
                              decoration:  InputDecoration(
                                hintText: AppLocalizations.of(context)?.enter_task_description,
                                hintStyle:  TextStyle(fontSize: 16,color:provider.isDarkMode()?
                                MyTheme.whiteColor:
                                MyTheme.blackColor, ),
                              ),
                              maxLines: 4,
                            ),
                          ),
                          Text(
                              AppLocalizations.of(context)!.select_date,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                showCalender();
                              },
                              child: Text(
                                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: FloatingActionButton(
                                onPressed: () {
                                  addTask();
                                },
                                backgroundColor: MyTheme.primaryLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  side: const BorderSide(
                                      color: Colors.white, width: 4),
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: MyTheme.whiteColor,
                                  size: 40,
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void showCalender() async {
    var chosenDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            primaryColor: MyTheme.primaryLight,
            hintColor: MyTheme.primaryLight,
            colorScheme: const ColorScheme.light(primary: MyTheme.primaryLight),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
      // locale:Provider.appLanguage;
    );

    if (chosenDate != null) {
      selectedDate = chosenDate;
      setState(() {});
    }
  }

  void addTask() {
    if (fromKey.currentState?.validate() == true) {
      Task task= Task(title: title, description: description, dateTime: selectedDate);
      FirebaseUtils.addTaskToFirestore(task).timeout(const Duration(milliseconds:500 ),
      onTimeout:() {
        print('task add successfully ');
        Navigator.pop(context);
      }
      );
    }
  }
}
