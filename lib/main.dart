import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/Auth/login/login_screen.dart';
import 'package:todo/Auth/register/register_screen.dart';
import 'package:todo/home/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo/model/task.dart';
import 'package:todo/providers/app_confing_provider.dart';
import 'package:todo/providers/auth.provider.dart';

import 'list_task/edit_task.dart';
import 'my_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await FirebaseFirestore.instance.disableNetwork();
  // FirebaseFirestore.instance.settings =
  //     const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  runApp(
      MultiProvider(providers:  [
      ChangeNotifierProvider(create: (context)=>AppConfigProvider()),
        ChangeNotifierProvider(create: (context)=>AuthProviders()),

      ],
          child:  MyApp()
      ));

}

class MyApp extends StatelessWidget {
late AppConfigProvider provider;
  @override
  Widget build(BuildContext context) {
     provider= Provider.of<AppConfigProvider>(context);
     initSharedPreferences();
    return MaterialApp(
    debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.routeName ,
        routes: {
          HomeScreen.routeName :(context) => const HomeScreen(),
          RegisterScreen.routeName:(context) => const RegisterScreen(),
          LoginScreen.routeName:(context) => const LoginScreen(),
          // UpdateTaskScreen.routeName: (context) => UpdateTaskScreen(),
        },
      theme: MyTheme.lightMode,
      locale: Locale(provider.appLanguage),
      themeMode: provider.appTheme,
      darkTheme: MyTheme.darkMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
Future<void> initSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();

  var language = prefs.getString("Language");
  if (language != null) {
    provider.ChangeLanguage(language);
  }

  var isDark = prefs.getBool("isDark");
  if (isDark == true) {
    provider.ChangeTheme(ThemeMode.dark);
  } else if (isDark == false) {
    provider.ChangeTheme(ThemeMode.light);
  }
}
}
