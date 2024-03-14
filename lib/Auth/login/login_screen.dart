
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/Auth/custom_text_from_field.dart';
import 'package:todo/Auth/register/register_screen.dart';
import 'package:todo/dialog_utils.dart';
import 'package:todo/firebase_utils.dart';
import 'package:todo/home/home_screen.dart';
import 'package:todo/my_theme.dart';
import 'package:todo/providers/app_confing_provider.dart';
import 'package:todo/providers/auth.provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'LoginScreen_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
              AppLocalizations.of(context)!.task_list,
                style: TextStyle(color: MyTheme.whiteColor),
              ),
          ),
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
                          Text(
                              AppLocalizations.of(context)!.welcome,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 20),
                          CustomFromField(
                            label:   AppLocalizations.of(context)!.email,
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            validator: (text) {
                              if (text == null || text.trim().isEmpty) {
                                return   AppLocalizations.of(context)!.please_email;
                              }
                              bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(emailController.text);
                              if (!emailValid) {
                                return  AppLocalizations.of(context)!.valid_email;
                              }
                              return null;
                            }, labelColor:provider.isDarkMode()?
                          MyTheme.whiteColor:
                          MyTheme.blackColor,
                          ),
                          CustomFromField(
                            label:   AppLocalizations.of(context)!.password,
                            keyboardType: TextInputType.number,
                            controller: passwordController,
                            validator: (text) {
                              if (text == null || text.trim().isEmpty) {
                                return  AppLocalizations.of(context)!.please_password;
                              }
                              if (text.length < 6) {
                                return  AppLocalizations.of(context)!.char_password;
                              }
                              return null;
                            },
                            obscureText: true,
                            labelColor:provider.isDarkMode()?
                            MyTheme.whiteColor:
                            MyTheme.blackColor,

                          ),
                        ],
                      ),
                    )),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(MyTheme.primaryLight),
                  ),
                  onPressed: () {
                    login();
                  },
                  child: Text(
                     AppLocalizations.of(context)!.login,
                    style: TextStyle(color: MyTheme.whiteColor),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(RegisterScreen.routeName);
                    },
                    child: Text(
                  AppLocalizations.of(context)!.or_create,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.w700,color: MyTheme.primaryLight),
                    )),
              ],
            ),
          ),
        )
      ],
    );
  }

  void login() async{
    if (_formKey.currentState?.validate() == true) {
      try {
        DialogUtils.showLoading(context: context, message: "Loading ....");

        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text
        );
     var user= await  FirebaseUtils.readUserFromFireStore(credential.user?.uid??"");
         if(user==null){
           return;
         }
        var  authProvider= Provider.of<AuthProviders>(context,listen: false);
        authProvider.updateUser(user);
        DialogUtils.showMessage(context: context, message: "Login successfully",
            title: "success",
             posActionNamed: "ok",
             posAction: (){
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
             });
        print("Login successfully ");
        print(credential.user?.uid);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-credential') {
          DialogUtils.showMessage(context: context, message: "The supplied auth credential is incorrect, malformed or has expired.",
              title: "Error",
              posActionNamed: "ok",
              posAction: (){
                Navigator.pop(context);
              });

          print('No user found for that email.');

        }
      }catch(e){
        print(e.toString());
      }
    }
  }
}
