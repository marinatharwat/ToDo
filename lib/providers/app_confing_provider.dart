import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../firebase_utils.dart';
import '../model/task.dart';

class AppConfigProvider extends ChangeNotifier {
  String appLanguage = 'en';
  List<Task> tasksList = [];
  DateTime selectDate = DateTime.now();

  ThemeMode appTheme = ThemeMode.light;

  void ChangeLanguage(String newLanguage) {
    if (appLanguage == newLanguage) {
      return;
    } else {
      appLanguage = newLanguage;
      notifyListeners();
    }
  }

  void ChangeTheme(ThemeMode newMode) {
    if (appTheme == newMode) {
      return;
    } else {
      appTheme = newMode;
      notifyListeners();
    }
  }

  bool isDarkMode() {
    return appTheme == ThemeMode.dark;
  }

  getAllTasksFromFireStore() async {
    QuerySnapshot<Task> querySnapshot = await FirebaseUtils.getTasksCollection().get();
    tasksList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();

    tasksList.where((task) {
      if (selectDate.day == task.dateTime.day &&
          selectDate.month == task.dateTime.month &&
          selectDate.year == task.dateTime.year) {
        return true;
      }

      return false;
    }).toList();
    notifyListeners();
  }
  void changeSelectDate(DateTime newSelect){
    selectDate= newSelect;
    notifyListeners();
  }
}
