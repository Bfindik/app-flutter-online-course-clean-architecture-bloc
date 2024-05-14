import 'package:flutter/material.dart';
import 'package:online_course/core/services/database_helper.dart';
import 'package:online_course/src/Components/button.dart';
import 'package:online_course/src/Components/colors.dart';
import 'package:online_course/src/Components/textfield.dart';
import 'package:online_course/src/JSON/users.dart';
import 'package:online_course/src/Views/login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final usrNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController(); // New controller for address
  final db = DatabaseHelper.instance;

  signUp() async {
    var res = await db.createUser(Users(
      fullName: fullNameController.text,
      email: emailController.text,
      usrName: usrNameController.text,
      password: passwordController.text,
      phoneNumber: phoneNumberController.text,
      address: addressController.text, // Include the address
    ));
    if (res > 0) {
      if (!mounted) return;
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Yeni Hesap Oluştur",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 55,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                InputField(
                  hint: "Full İsim",
                  icon: Icons.person,
                  controller: fullNameController,
                ),
                InputField(
                  hint: "Email",
                  icon: Icons.email,
                  controller: emailController,
                ),
                InputField(
                  hint: "Telefon Numarası",
                  icon: Icons.phone,
                  controller: phoneNumberController,
                ),
                InputField(
                  hint: "Adres",
                  icon: Icons.location_on,
                  controller: addressController,
                ),
                InputField(
                  hint: "Kullanıcı Adı",
                  icon: Icons.account_circle,
                  controller: usrNameController,
                ),
                InputField(
                  hint: "Şifre",
                  icon: Icons.lock,
                  controller: passwordController,
                  passwordInvisible: true,
                ),
                InputField(
                  hint: "Tekrar Şifre",
                  icon: Icons.lock,
                  controller: confirmPasswordController,
                  passwordInvisible: true,
                ),
                const SizedBox(height: 10),
                Button(
                  label: "Kayıt Ol",
                  press: () {
                    signUp();
                  },
                ),
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
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text("Giriş Yap"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
