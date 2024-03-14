import 'package:flutter/material.dart';

class MyTheme {

  static Color blackColor =  const Color(0xff383838);
  static   const Color primaryLight =   Color(0xff5D9CEC);
  static Color greenColor =  const Color(0xff61E757);
  static Color whiteColor =  const Color(0xffffffff);
  static Color primaryDark =  const Color(0xff060E1E);
  static Color blackPrimaryDark =  const Color(0xff141922);
  static Color redDark =  const Color(0xffEC4B4B);
  static Color lightGreen =  const Color(0xffDFECDB);


  static ThemeData lightMode = ThemeData(
      canvasColor: primaryLight,
      scaffoldBackgroundColor: MyTheme.lightGreen,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: whiteColor,
          selectedItemColor: primaryLight,
          showUnselectedLabels: true),

      appBarTheme:  const AppBarTheme(
        color: MyTheme.primaryLight,
        elevation: 0,
        centerTitle: true,
        iconTheme:IconThemeData(color: primaryLight)
      ),
      bottomSheetTheme:  BottomSheetThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
              topRight: Radius.circular(15)
          ),
          side: BorderSide(
            color: MyTheme.whiteColor
          )
        )
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.white),

        titleMedium:TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.black),
        titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: Colors.black),

      ));


  static ThemeData darkMode = ThemeData(
      canvasColor: primaryDark,
      scaffoldBackgroundColor: Colors.transparent,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: primaryDark,
          selectedItemColor: primaryLight,
          unselectedLabelStyle: TextStyle(color: whiteColor),
          selectedLabelStyle:  TextStyle(color: whiteColor),
          unselectedIconTheme: IconThemeData(color: whiteColor),
         unselectedItemColor: Colors.white,
          showUnselectedLabels: true
      ),
      appBarTheme:  const AppBarTheme(
          color:primaryLight,
          elevation: 0,
          centerTitle: true,
          iconTheme:IconThemeData(color: MyTheme.primaryLight)
      ),
      bottomSheetTheme:  BottomSheetThemeData(
          backgroundColor: MyTheme.primaryDark,
          shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15)
              ),
              side: BorderSide(
                  color: MyTheme.whiteColor
              )
          )
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.white),
        titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.white),
        titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: Colors.white),

      ));

}
