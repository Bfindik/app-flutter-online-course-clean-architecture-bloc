import 'package:flutter/material.dart';
import 'package:online_course/src/Components/button.dart';
import 'package:online_course/src/Components/colors.dart';
import 'package:online_course/src/JSON/users.dart';
import 'package:online_course/src/Views/login.dart';

class Profile extends StatelessWidget {
  final Users? profile;
  const Profile({Key? key, this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 45.0, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 77,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/no_user.jpg"),
                    radius: 75,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  profile!.fullName ?? "",
                  style: const TextStyle(fontSize: 28, color: primaryColor),
                ),
                Text(
                  profile!.email ?? "",
                  style: const TextStyle(fontSize: 17, color: Colors.grey),
                ),
                Button(
                  label: "Çıkış Yap",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person, size: 30),
                  subtitle: const Text("Ad Soyad"),
                  title: Text(profile!.fullName ?? ""),
                ),
                ListTile(
                  leading: const Icon(Icons.email, size: 30),
                  subtitle: const Text("Email"),
                  title: Text(profile!.email ?? ""),
                ),
                ListTile(
                  leading: const Icon(Icons.phone, size: 30),
                  subtitle: const Text("Telefon Numarası"),
                  title: Text(profile!.phoneNumber ?? ""),
                ),
                ListTile(
                  leading: const Icon(Icons.location_on, size: 30),
                  subtitle: const Text("Adres"),
                  title: Text(profile!.address ?? ""),
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle, size: 30),
                  subtitle: const Text("Kullanıcı Adı"),
                  title: Text(profile!.usrName),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
