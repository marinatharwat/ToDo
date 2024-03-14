import 'package:flutter/material.dart';
 class DialogUtils{


  static void showLoading({required BuildContext context,
    required String message}){
    showDialog(
        context: context,
        builder: (context){

          return  AlertDialog(
            content: Row(children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 10,),
              Text(message),
            ],),
          );
        });
  }

  static void showMessage({required BuildContext context,
    required String message,
     String? title,
    String? posActionNamed,
    Function? posAction,
    String? negActionNamed,
    Function?  negAction,
  })

  {
    List<Widget> actions =[];
   if(posActionNamed != null){
     actions.add(TextButton(onPressed: (){

       Navigator.pop(context);
       if(posAction!= null){
         posAction.call();
       }
     },

         child: Text(posActionNamed)));
   }
    if(negActionNamed != null){
      actions.add(TextButton(onPressed: (){

        Navigator.pop(context);
        if(negAction!= null){
          negAction.call();
        }
      },

          child: Text(negActionNamed)));
    }
    showDialog(
        context: context,
        builder: (context){

          return  AlertDialog(
            content:
            Text(message,style: const TextStyle(fontSize: 18),),
            title: Text(title??'',style: Theme.of(context).textTheme.titleSmall,),
            actions: actions,
          );
        });
  }

 }