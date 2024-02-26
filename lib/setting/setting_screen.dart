import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo/my_theme.dart';

import '../providers/app_confing_provider.dart';
import 'bottom_Theme_sheet.dart';
import 'bottom_language_sheet.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var provider= Provider.of<AppConfigProvider>(context);

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30,),
            Text(
              AppLocalizations.of(context)!.language,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                ShowLanguageBottomSheet();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: MyTheme.primaryLight,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        provider.appLanguage == 'en'
                            ? AppLocalizations.of(context)!.english
                            : AppLocalizations.of(context)!.arabic,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        size: 40,
                      )
                    ],
                  ),

                ),
              ),
            ),
            const SizedBox(height: 30,),
            Text(
              AppLocalizations.of(context)!.theme,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                ShowThemeBottomSheet();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: MyTheme.primaryLight,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        provider.isDarkMode()
                            ? AppLocalizations.of(context)!.dark
                            : AppLocalizations.of(context)!.light,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        size: 40,
                      )
                    ],
                  ),

                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  void ShowLanguageBottomSheet(){
    showModalBottomSheet(context: context, builder: (context)=>const BottomLanguageSheet());
  }
  void ShowThemeBottomSheet(){
    showModalBottomSheet(context: context, builder: (context)=>const BottomThemeSheet());
  }
}
