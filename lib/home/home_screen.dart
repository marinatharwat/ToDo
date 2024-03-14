import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/Auth/login/login_screen.dart';
import 'package:todo/list_task/add_task_bottom_sheet.dart';
import 'package:todo/my_theme.dart';
import 'package:todo/providers/app_confing_provider.dart';
import 'package:todo/providers/auth.provider.dart';
import 'package:todo/setting/setting_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../list_task/list_task_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String  routeName='Home_Screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    var  authProvider= Provider.of<AuthProviders>(context,listen: false);

    return Scaffold(
      appBar: AppBar(
       toolbarHeight: MediaQuery.of(context).size.height/5,
        title:  Text('${AppLocalizations.of(context)?.to_do_list} ${authProvider.currentUser!.name!}',

    style: Theme.of(context).textTheme.titleLarge,),
        actions: [
          IconButton(onPressed:(){
            authProvider.currentUser =null;
            provider.tasksList=[];
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          },

              icon: const Icon(Icons.logout_outlined,color: Colors.white,))
        ],
        centerTitle: false,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context)
            .copyWith(canvasColor: Theme.of(context).canvasColor),
        child:
        BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            selectedIndex = index;
            setState(() {});
          },
          items:  [
            BottomNavigationBarItem(
                icon: const Icon(Icons.list_outlined,size: 40,),
                label:AppLocalizations.of(context)!.task_list),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings,size: 35,),
              label: AppLocalizations.of(context)!.setting,
            )


          ],
        ),

      ),
      floatingActionButton:
      FloatingActionButton(
        onPressed: () {
          showAddBottomSheet();
        },
        backgroundColor: MyTheme.primaryLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
          side: const BorderSide(color: Colors.white, width: 4),
        ),
        child: Icon(
          Icons.add,
          color: MyTheme.whiteColor,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: tabs[selectedIndex],
    );
  }

  List<Widget> tabs = [
   const ListTaskScreen(),
  const SettingScreen(),
  ];

  void showAddBottomSheet() {
    showModalBottomSheet(context: context, builder: (context)=>const AddTaskBottomSheet());
  }
}
