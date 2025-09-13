import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:saatmenumobileapp/api/auth.dart';
import 'package:saatmenumobileapp/helper/preferences.dart';
import 'package:saatmenumobileapp/helper/utils/colors.dart';
import 'package:saatmenumobileapp/helper/utils/fonts.dart';
import 'package:saatmenumobileapp/models/auth.dart';

class DrawerWidget extends StatefulWidget {
  final int userType;
  const DrawerWidget({super.key, required this.userType});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  
  void _showLogoutDialog(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: fontlgbold('Logout'),
            content: fontmd('Are you sure you want to logout?'),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(),
                child: fontsm('Cancel'),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  _handleLogout();
                },
                isDestructiveAction: true,
                child: fontsm('Logout'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: fontlgbold('Logout', color: black),
            content: fontmd('Are you sure you want to logout?', color: black),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: fontsm('Cancel', color: Colors.grey),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _handleLogout();
                },
                child: fontsm('Logout', color: Colors.red),
              ),
            ],
          );
        },
      );
    }
  }

  Auth? userData;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    userData = await AppPreferences.getUserData();
    setState(() {});
  }

  void _handleLogout() async {
    await AuthService.logout();
    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: white,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
              children: <Widget>[
                // if(widget.userType == 0)
                Container(
                  color: white,
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                  child: fontlg(userData?.staff?.fullName ?? '', color: black),
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: fontmd('History', color: black),
                  onTap: () {
                    // Navigator.pushNamed(context, 'history');
                  },
                ),
              ],
            ),
          ),
          // Logout section at the bottom
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: fontmd('Logout', color: Colors.red),
              onTap: () => _showLogoutDialog(context),
            ),
          ),
        ],
      ),
    );
  }
}