import 'package:flutter/material.dart';
import 'package:online_course/core/services/database_helper.dart';
import 'package:online_course/src/Components/button.dart';
import 'package:online_course/src/Components/colors.dart';
import 'package:online_course/src/Components/textfield.dart';
import 'package:online_course/src/JSON/users.dart';
import 'package:online_course/src/Views/profile.dart';
import 'package:online_course/src/Views/signup.dart';
import 'package:online_course/src/root_app.dart';
import 'package:online_course/src/theme/app_color.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Our controllers
  //Controller is used to take the value from user and pass it to database
  final usrName = TextEditingController();
  final password = TextEditingController();

  bool isChecked = false;
  bool isLoginTrue = false;

  final db = DatabaseHelper.instance;
  //Login Method
  //We will take the value of text fields using controllers in order to verify whether details are correct or not
  login() async {
    Users? usrDetails = await db.getUser(usrName.text);
    var res = await db
        .authenticate(Users(usrName: usrName.text, password: password.text));
    if (res == true) {
      //If result is correct then go to profile or home
      if (!mounted) return;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RootApp(profile: usrDetails)));
    } else {
      //Otherwise show the error message
      setState(() {
        isLoginTrue = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Because we don't have account, we must create one to authenticate
                //lets go to sign up

                const Text(
                  "GİRİŞ YAP",
                  style: TextStyle(color: primaryColor, fontSize: 40),
                ),
                Image.asset("assets/background.jpg"),
                InputField(
                    hint: "Kullanıcı Adı",
                    icon: Icons.account_circle,
                    controller: usrName),
                InputField(
                    hint: "Şifre",
                    icon: Icons.lock,
                    controller: password,
                    passwordInvisible: true),

                ListTile(
                  horizontalTitleGap: 2,
                  title: const Text("Beni Hatırla"),
                  leading: Checkbox(
                    activeColor: primaryColor,
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = !isChecked;
                      });
                    },
                  ),
                ),

                //Our login button
                Button(
                    label: "Giriş Yap",
                    press: () {
                      login();
                    }),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Hesabın var mı?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupScreen()));
                        },
                        child: const Text(
                          "Kayıt Ol",
                          selectionColor: AppColor.primary,
                        ))
                  ],
                ),

                // Access denied message in case when your username and password is incorrect
                //By default we must hide it
                //When login is not true then display the message
                isLoginTrue
                    ? Text(
                        "Username or password is incorrect",
                        style: TextStyle(color: Colors.red.shade900),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
