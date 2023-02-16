import 'package:flutter/material.dart';
import 'package:imin/admin/admin_dashb.dart';
import 'package:imin/user/user_dashb.dart';
import 'package:imin/screens/login_page.dart';
import 'package:imin/main.dart';
import 'package:imin/services/auth_service.dart';
import 'package:imin/screens/loading_screen.dart';
import 'package:imin/screens/start_page.dart';
import 'package:provider/provider.dart';
import 'package:imin/models/user_model.dart';
import 'package:imin/models/globals.dart' as globals;

// ignore: must_be_immutable, use_key_in_widget_constructors
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;

          if (user != null) {
            globals.userID = user.uid;
          }
          if (user?.username != null) {
            globals.userName = user!.username.toString();
          }

          return FutureBuilder<bool?>(
            future: checkFirstSeen(),
            builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == false) {
                  return const StartPage();
                }
                return user == null
                    ? const LoginPage()
                    : user.uid == 'fTwZx3ru9AVvMOFHlUDu0bKIDgs2'
                        ? const AdminDashboard()
                        : const UserDashboard();
              } else {
                return const LoadingScreen();
              }
            },
          );
        } else {
          return const LoadingScreen();
        }
      },
    );
  }

  Future<bool> checkFirstSeen() async {
    bool _seen = (spInstance.getBool('seen') ?? false);

    if (_seen) {
      return true;
    } else {
      await spInstance.setBool('seen', true);
      return false;
    }
  }
}
