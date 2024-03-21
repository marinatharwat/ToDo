import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/list_task/container_task.dart';
import 'package:todo/model/task.dart';
import 'package:todo/my_theme.dart';
import 'package:todo/providers/app_confing_provider.dart';
import 'package:todo/providers/auth.provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListTaskScreen extends StatefulWidget {
  const ListTaskScreen({super.key});

  @override
  State<ListTaskScreen> createState() => _ListTaskScreenState();
}

class _ListTaskScreenState extends State<ListTaskScreen> {
  List<Task> tasksList = [];
  DateTime selectDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    var userprovider = Provider.of<AuthProviders>(context);

    provider.getAllTasksFromFireStore(userprovider.currentUser!.id!);
    print("after  calling get all tasks");
    return Column(
      children: [
        EasyDateTimeLine(
          initialDate: provider.selectDate,
          locale: AppLocalizations.of(context)!.localeName,
          onDateChange: (date) {
            provider.changeSelectDate(date, userprovider.currentUser!.id ?? "");
          },
          headerProps: const EasyHeaderProps(
            monthPickerType: MonthPickerType.switcher,
            dateFormatter: DateFormatter.fullDateDMY(),
          ),
          dayProps: EasyDayProps(
            borderColor: provider.isDarkMode()
                ? MyTheme.primaryLight
                : MyTheme.whiteColor,
            dayStructure: DayStructure.dayStrDayNum,
            activeDayStyle: DayStyle(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    MyTheme.primaryLight,
                    MyTheme.primaryDark,
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: provider.tasksList.length,
              itemBuilder: (context, index) {
                return ItemTask(
                  task: provider.tasksList[index],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
