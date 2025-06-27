import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniture_shop_wijaya/presentation/screens/login_page/login.dart';
import 'package:furniture_shop_wijaya/presentation/screens/main_dashboard/main_dashboard.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const MainDashboard();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
