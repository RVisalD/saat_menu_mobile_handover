import 'package:flutter/material.dart';
import 'package:saatmenumobileapp/helper/utils/colors.dart';
import 'package:saatmenumobileapp/helper/utils/fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Image.asset(
                'assets/images/pfp.png',
                width: 50,
                height: 50,
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  fontxl('Welcome', color: black),
                  fontxlbold('John Doe!', color: black),
                ],
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, 'served');
                },
                child: const Icon(
                  Icons.notifications,
                  color: black,
                  size: 30,
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                fontmdbold(
                  'Order Management',
                  color: black,
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, 'served');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: green,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(
                            0,
                            3,
                          ),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/served-icon.png',
                          width: 20,
                          height: 20,
                        ),
                        fontmdbold(
                          'Served',
                          color: white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...List.generate(
              20,
              (index) => Column(
                children: [
                  orderingBox('Table 1', 'Order #123', '12:00 PM', '1', context),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget statusBox(String status) {
  /*
   * 0 = new order
   * 1 = preparing
   * 2 = served
   * 3 = rejected
   * 4 = cancelled
   */
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 5,
    ),
    decoration: BoxDecoration(
      color: status == '0'
          ? blue
          : status == '1'
              ? primaryColor
              : green,
      borderRadius: BorderRadius.circular(5),
      border: Border.all(
        color: status == '0'
            ? Color(0XFFFD8D100)
            : status == '1'
                ? Color(0XFFF5F6ABF)
                : Color(0XFFF229116),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 7,
          offset: Offset(
            0,
            3,
          ),
        ),
      ],
    ),
    child: Column(
      children: [
        if (status == '0')
          fontmdbold(
            'New Order',
            color: black,
          ),
        if (status == '1' || status == '2')
          fontmdbold(
            status == '1' ? 'Preparing' : 'Served',
            color: white,
          ),
      ],
    ),
  );
}

Widget orderingBox(
    String table, String orderNumber, String orderTime, String status, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, 'order_detail');
    },
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(
              0,
              3,
            ),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              fontmdbold(table),
              fontmd(orderNumber),
              fontxsbold('Order Time: $orderTime'),
            ],
          ),
          Spacer(),
          statusBox(status),
          const SizedBox(width: 10),
          Icon(
            Icons.play_arrow_rounded,
            color: Colors.grey.withOpacity(0.6),
            size: 30,
          ),
        ],
      ),
    ),
  );
}
