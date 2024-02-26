import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/list_task/task_list_item.dart';
import 'package:todo/model/task.dart';
import 'package:todo/my_theme.dart';
import 'package:todo/providers/app_confing_provider.dart';
class ListTaskScreen extends StatefulWidget {
  const ListTaskScreen({super.key});

  @override
  State<ListTaskScreen> createState() => _ListTaskScreenState();
}

class _ListTaskScreenState extends State<ListTaskScreen> {
  List <Task> tasksList=[];
  DateTime selectDate=DateTime.now();


  @override
  Widget build(BuildContext context) {
    var provider= Provider.of<AppConfigProvider>(context);


    provider. getAllTasksFromFireStore();


    return Container(
      child: Column(
        children: [
          EasyDateTimeLine(
            initialDate:provider.selectDate,
            onDateChange: (selectedDate) {
              provider.changeSelectDate(selectedDate);
            },
            headerProps: const EasyHeaderProps(
              monthPickerType: MonthPickerType.switcher,
              dateFormatter: DateFormatter.fullDateDMY(),
            ),

            dayProps: EasyDayProps(
              borderColor:
              provider.isDarkMode()?
            MyTheme.primaryLight:
            MyTheme.whiteColor,
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
            child: ListView.builder(
              itemBuilder:(context,index){
                return    ItemTask(task:provider.tasksList[index]);
              },
              itemCount: provider.tasksList.length,

            ),
          )

        ],
      ),
    );
  }
}