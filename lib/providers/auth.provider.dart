import 'package:flutter/material.dart';
import 'package:todo/model/my_user.dart';
class  AuthProviders extends ChangeNotifier{
  MyUser? currentUser;
  void updateUser(MyUser? newUser){
    currentUser=newUser;
    notifyListeners();
  }
}