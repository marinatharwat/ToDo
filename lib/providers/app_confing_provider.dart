import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase_utils.dart';
import '../model/task.dart';

class AppConfigProvider extends ChangeNotifier {
  String appLanguage = 'en';
  List<Task> tasksList = [];
  DateTime selectDate = DateTime.now();
  ThemeMode appTheme = ThemeMode.light;

  Future<void> ChangeLanguage(String newLanguage) async {
    if (appLanguage == newLanguage) {
      return;
    } else {
      appLanguage = newLanguage;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('Language', appLanguage );

      notifyListeners();
    }
  }

  Future<void> ChangeTheme(ThemeMode newMode) async {
    if (appTheme == newMode) {
      return;
    } else {
      appTheme = newMode;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDark', appTheme == ThemeMode.light ? false : true);

      notifyListeners();
    }
  }

  bool isDarkMode() {
    return appTheme == ThemeMode.dark;
  }

  getAllTasksFromFireStore( String uId) async {
    QuerySnapshot<Task> querySnapshot = await FirebaseUtils.getTasksCollection(uId).get();
    tasksList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();

      tasksList=  tasksList.where((task) {
      if (selectDate.day == task.dateTime.day &&
          selectDate.month == task.dateTime.month &&
          selectDate.year == task.dateTime.year) {
        return true;
      }

      return false;
    }).toList();
    tasksList.sort((Task task1, Task task2){
      return
       task1.dateTime.compareTo(task2.dateTime);
    });
    notifyListeners();
  }

  void changeSelectDate(DateTime newSelectDate,String uId){
    selectDate= newSelectDate;
    getAllTasksFromFireStore(uId);
  }


}
