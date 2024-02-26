import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo/my_theme.dart';

import '../providers/app_confing_provider.dart';


class BottomLanguageSheet extends StatefulWidget {
  const BottomLanguageSheet({Key? key}) : super(key: key);

  @override
  State<BottomLanguageSheet> createState() => _BottomLanguageSheetState();
}

class _BottomLanguageSheetState extends State<BottomLanguageSheet> {
  @override
  Widget build(BuildContext context) {
    var provider= Provider.of<AppConfigProvider>(context);

    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color:
          provider.isDarkMode()
              ? MyTheme.primaryDark
              : MyTheme.whiteColor,

          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: (){
                  provider.ChangeLanguage("en");
                },
                child:provider.appLanguage == 'en'?
                getSelectedItemWidget(AppLocalizations.of(context)!.english):
                getUnSelectedItemWidget(AppLocalizations.of(context)!.english)
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: (){
                  provider.ChangeLanguage("ar");

                },

                child:provider.appLanguage == 'ar'?
              getSelectedItemWidget(AppLocalizations.of(context)!.arabic):
              getUnSelectedItemWidget(AppLocalizations.of(context)!.arabic)
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget getSelectedItemWidget(String text){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
            text,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color:MyTheme.primaryLight,
                fontWeight: FontWeight.bold
            )
        ),
        const Icon(
          Icons.check,
          size: 40,
          color: MyTheme.primaryLight,
        )
      ],
    );
  }
  Widget getUnSelectedItemWidget(String text){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text ,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

}
