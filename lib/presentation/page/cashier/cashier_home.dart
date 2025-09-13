import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:saatmenumobileapp/helper/preferences.dart';
import 'package:saatmenumobileapp/helper/utils/colors.dart';
import 'package:saatmenumobileapp/helper/utils/fonts.dart';
import 'package:saatmenumobileapp/models/auth.dart';
import 'package:saatmenumobileapp/presentation/widget/drawer.dart';

class CashierHomePage extends StatefulWidget {
  const CashierHomePage({super.key});

  @override
  State<CashierHomePage> createState() => _CashierHomePageState();
}

class _CashierHomePageState extends State<CashierHomePage> {
  dynamic userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  initializeData() async {
    try {
      Auth userDataString = await AppPreferences.getUserData();

      if (userDataString.staff != null) {
        if (userDataString is String) {
          userData = jsonDecode(userDataString.staff.toString());
        } else {
          userData = userDataString;
        }
      } else {
        userData = {};
      }
    } catch (e) {
      userData = {};
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  int indexSelected = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: fontlgbold(
            userData != null && userData['restaurantUsername'] != null
                ? '${userData['restaurantUsername']} Cashier Side'
                : 'Cashier Side'),
        backgroundColor: backgroundColor,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: DrawerWidget(
        userType: 2,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        indexSelected = 0;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: primaryColor,
                        ),
                        color: indexSelected == 0 ? primaryColor : white,
                      ),
                      child: Center(
                        child: fontsm('Pending',
                            color: indexSelected == 0 ? white : primaryColor),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        indexSelected = 2;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0XFFF229116),
                        ),
                        color: indexSelected == 2 ? Color(0xFFF229116) : white,
                      ),
                      child: Center(
                        child: fontsm(
                          'Paid Orders',
                          color: indexSelected == 2
                              ? white
                              : Color(
                                  0xFFF229116,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...List.generate(5, (index) {
              return Column(
                children: [
                  // kitchenOrderingDetailWidget(
                  //     context,
                  //     indexSelected,
                  //     {},
                  //     indexSelected == 2 ? true : false,
                  //     indexSelected == 0
                  //         ? 'cashier_pending_payment'
                  //         : 'cashier_pending_payment',
                  //     2),
                  // const SizedBox(height: 10),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
