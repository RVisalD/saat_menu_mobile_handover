import 'package:flutter/material.dart';
import 'package:saatmenumobileapp/helper/utils/colors.dart';
import 'package:saatmenumobileapp/helper/utils/fonts.dart';
import 'package:saatmenumobileapp/presentation/widget/appbar.dart';

class TableCheckOutPage extends StatefulWidget {
  const TableCheckOutPage({super.key});

  @override
  State<TableCheckOutPage> createState() => _TableCheckOutPageState();
}

class _TableCheckOutPageState extends State<TableCheckOutPage> {
  final orders = [
    {'order': 'Order #103214', 'amount': '\$ 14.00'},
    {'order': 'Order #103215', 'amount': '\$ 14.70'}
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBarWidget(title: 'Table 1', isBackButtonVisible: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Center(
                    child: fontmd('Table 1', color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: fontxlbold('\$ 28.70'),
                  ),
                  Divider(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: fontsm('Date: Mon 10 Feb, 2025', color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  ...List.generate(
                    orders.length,
                    (index) {
                      return Column(
                        children: [
                          rowTextContainer(
                            orders[index]['order']!,
                            orders[index]['amount']!,
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
                  rowTextContainer('Sub Total', '\$ 28.70'),
                  const SizedBox(height: 10),
                  rowTextContainer('Tax (0%)', '0%'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            fontmdbold(
              'Select Payment Method',
              color: Colors.grey,
            ),
            const SizedBox(height: 10),
            paymentMethod(
              context,
              'assets/images/khqr.png',
              'ABA KHQR',
              'Scan to pay with any banking app',
              'served',
            ),
            const SizedBox(height: 10),
            paymentMethod(
              context,
              'assets/images/pay_cash.png',
              'Pay by Cash',
              'Customer would like to pay cash',
              'served',
            ),
          ],
        ),
      ),
    );
  }
}

Widget rowTextContainer(String text1, String text2) {
  return Row(
    children: [
      fontmd(
        text1,
        color: Colors.grey,
      ),
      Spacer(),
      fontmdbold(
        text2,
        color: Colors.black,
      ),
    ],
  );
}

Widget paymentMethod(BuildContext context, String image, String title,
    String subtitle, String route) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, route);
    },
    child: Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              image,
              width: 50,
              height: 50,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              fontmdbold(
                title,
                color: Colors.black,
              ),
              fontsm(
                subtitle,
                color: Colors.grey,
              ),
            ],
          ),
          Spacer(),
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0XFFFF2F3F7),
            ),
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0XFFF535362),
              size: 15,
            ),
          ),
        ],
      ),
    ),
  );
}
