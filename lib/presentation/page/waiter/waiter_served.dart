import 'package:flutter/material.dart';
import 'package:saatmenumobileapp/helper/utils/colors.dart';
import 'package:saatmenumobileapp/helper/utils/fonts.dart';

class WaiterServedOrderPage extends StatefulWidget {
  const WaiterServedOrderPage({super.key});

  @override
  State<WaiterServedOrderPage> createState() =>
      WaiterServedOrderPageState();
}

class WaiterServedOrderPageState extends State<WaiterServedOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: fontlgbold('Served Orders'),
        backgroundColor: backgroundColor,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            fontmd('Order #01614694', color: Colors.black),
                            fontsm('12:34', color: Colors.black),
                          ],
                        ),
                        fontmdbold('Table 1', color: Colors.black),
                      ],
                    ),
                  ),
                  ...List.generate(
                    10,
                    (index) => Column(
                      children: [
                        // orderingDetail(),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
