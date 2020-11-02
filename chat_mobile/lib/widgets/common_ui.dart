import 'package:chat_mobile/screens/account_screen.dart';
import 'package:chat_mobile/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:chat_mobile/helpers/global_consts.dart' as consts;

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.exit_to_app),
        tooltip: 'Logout',
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if(prefs.containsKey(consts.IS_LOGGED)) {
            await prefs.setBool(consts.IS_LOGGED, false);
          }
          Navigator.of(context).pushNamedAndRemoveUntil(LoginPage.routeName, (route) => false);
        });
  }
}

class AccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.person_outline),
        tooltip: 'Account',
        onPressed: () {
          Navigator.of(context).pushNamed(AccountScreen.routeName);
        });
  }
}
