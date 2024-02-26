import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/model/task.dart';
import 'package:todo/my_theme.dart';
import 'package:todo/providers/app_confing_provider.dart';

class ItemTask extends StatelessWidget {
  Task task;
 ItemTask({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return
      Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(borderRadius:BorderRadius.circular(15),
      color:  provider.isDarkMode()?
        MyTheme.primaryDark:
        MyTheme.whiteColor,

      ),
      child:
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              height: MediaQuery.of(context).size.height/13,
                width: 4,
                decoration: BoxDecoration(borderRadius:BorderRadius.circular(30),
                  color: MyTheme.primaryLight,
                ),

             ),
          ),

         Expanded(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
             Text( task.title,
                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
               color: MyTheme.primaryLight,
             )

             ),
               Text( task.description,
                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
                     color: MyTheme.blackColor,
                   )

               ),

           
           
           ],),
         ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 40,
            width: 70,
            decoration: BoxDecoration(borderRadius:BorderRadius.circular(15),
              color: MyTheme.primaryLight,
            ),
           child: const Icon(Icons.check,size: 30,color: Colors.white,),
          ),
        ),
      ],),
    );
  }
}
