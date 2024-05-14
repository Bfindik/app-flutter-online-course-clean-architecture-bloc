import 'package:flutter/material.dart';
import 'package:online_course/core/services/database_helper.dart';
import 'package:online_course/src/Components/button.dart';
import 'package:online_course/src/Components/colors.dart';
import 'package:online_course/src/Components/textfield.dart';
import 'package:online_course/src/root_app.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final usrName = TextEditingController();
  final password = TextEditingController();

  bool isChecked = false;
  bool isLoginTrue = false;

  final db = DatabaseHelper.instance;
  final isAdmin = true;

  login() async {
    var res = await db.authenticateAdmin(usrName.text, password.text);
    if (res) {
      // Doğru giriş yapıldığında admin paneline yönlendir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RootApp(isAdmin: isAdmin,), 
        ),
      );
    } else {
      // Giriş başarısız olduysa hata mesajını göster
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
                const Text(
                  "ADMİN GİRİŞİ",
                  style: TextStyle(color: primaryColor, fontSize: 40),
                ),
                InputField(
                  hint: "Kullanıcı Adı",
                  icon: Icons.account_circle,
                  controller: usrName,
                ),
                InputField(
                  hint: "Şifre",
                  icon: Icons.lock,
                  controller: password,
                  passwordInvisible: true,
                ),
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
                Button(
                  label: "Giriş Yap",
                  press: () {
                    login();
                  },
                ),
                // Giriş hatalıysa gösterilecek hata mesajı
                isLoginTrue
                    ? Text(
                        "Kullanıcı adı veya şifre hatalı",
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
