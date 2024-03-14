import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/Auth/custom_text_from_field.dart';
import 'package:todo/dialog_utils.dart';
import 'package:todo/firebase_utils.dart';
import 'package:todo/home/home_screen.dart';
import 'package:todo/model/my_user.dart';
import 'package:todo/my_theme.dart';
import 'package:todo/providers/app_confing_provider.dart';
import 'package:todo/providers/auth.provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'RegisterScreen_screen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AppConfigProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppConfigProvider>(context);

    return Stack(
      children: [
        Container(
          color:provider.isDarkMode()?
          MyTheme.primaryDark:
          MyTheme.lightGreen,
          child: Image.asset(
            'assets/images/main_background.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
              AppLocalizations.of(context)!.create_account,
                style: TextStyle(color: MyTheme.whiteColor),
              ),
              leading:
              Icon(
                Icons.arrow_back,
                color: MyTheme.whiteColor,
                size: 30,
              )),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                    key: _formKey,
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 200),
                      CustomFromField(
                        label:  AppLocalizations.of(context)!.user_name,
                        controller: nameController,
                        validator: (text) {
                          if(text==null ||text.trim().isEmpty){
                            return  AppLocalizations.of(context)!.please_enter_userName;
                          }
                          return null;
                        },
                        labelColor:provider.isDarkMode()?
                      MyTheme.whiteColor:
                      MyTheme.blackColor,

                      ),
                      CustomFromField(
                        label:  AppLocalizations.of(context)!.email,
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        validator: (text) {
                          if(text==null ||text.trim().isEmpty){
                            return  AppLocalizations.of(context)!.please_email;
                          }
                          bool emailValid =
                          RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(emailController.text);
                          if(!emailValid){
                            return  AppLocalizations.of(context)!.valid_email;
                          }
                          return null;
                        },
                        labelColor:provider.isDarkMode()?
                        MyTheme.whiteColor:
                        MyTheme.blackColor,

                      ),
                      CustomFromField(
                        label:  AppLocalizations.of(context)!.password,
                        keyboardType: TextInputType.number,
                        controller: passwordController,
                        validator: (text) {
                          if(text==null ||text.trim().isEmpty){
                            return  AppLocalizations.of(context)!.please_password;
                          }
                          if(text.length <6){
                            return  AppLocalizations.of(context)!.char_password;
                          }
                          return null;
                        },
                        labelColor:provider.isDarkMode()?
                        MyTheme.whiteColor:
                        MyTheme.blackColor,

                        obscureText: true,
                      ),
                      CustomFromField(
                        label:  AppLocalizations.of(context)!.confirm_password,
                        keyboardType: TextInputType.number,
                        controller: confirmPasswordController,
                        validator: (text) {
                          if(text==null ||text.trim().isEmpty){
                            return  AppLocalizations.of(context)!.please_confirm_password;
                          }
                          if( text!=passwordController.text){
                            return  AppLocalizations.of(context)!.dont_match;
                          }

                          return null;
                        },
                        labelColor:provider.isDarkMode()?
                        MyTheme.whiteColor:
                        MyTheme.blackColor,

                        obscureText: true,
                      ),
                    ],
                  ),
                )),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(MyTheme.primaryLight),
                  ),
                  onPressed: () {
                    register();
                  },
                  child:  Text(
                    AppLocalizations.of(context)!.create_account,
                    style: TextStyle(color: MyTheme.whiteColor),
                  ),
                ),

              ],
            ),
          ),
        )
      ],
    );
  }
  void register() async {
    if (_formKey.currentState?.validate() == true) {
      try {
        DialogUtils.showLoading(context: context, message: "Loading ....");
        final credential =
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

         MyUser myUser= MyUser(
             id: credential.user?.uid ??'',
            name: nameController.text,
            email: emailController.text);
        var  authProvider= Provider.of<AuthProviders>(context,listen: false);
        authProvider.updateUser(myUser);

      await  FirebaseUtils.addUserForFirestore(myUser);
        Navigator.of(context, rootNavigator: true).pop();

        DialogUtils.showMessage(context: context, message: "Register successfully", title: "success", posActionNamed: 'ok',
            posAction: (){
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        });




      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Timer(const Duration(seconds: 2), () {
            Navigator.of(context, rootNavigator: true).pop();
          });
          DialogUtils.showMessage(context: context, message: "The password provided is too weak",title: "Error");
        } else if (e.code == 'email-already-in-use') {
          Timer(const Duration(seconds: 2), () {
            Navigator.of(context, rootNavigator: true).pop();
          });
          DialogUtils.showMessage(context: context, message: "The account already exists for that email",title: "Error");
        }
      } catch (e) {
        Timer(const Duration(seconds: 2), () {
          Navigator.of(context, rootNavigator: true).pop();
        });
        DialogUtils.showMessage(context: context, message: '${e.toString()}');
        print(e);
      }
    }
  }}