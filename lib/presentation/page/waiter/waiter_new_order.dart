import 'package:flutter/material.dart';
import 'package:saatmenumobileapp/helper/utils/colors.dart';
import 'package:saatmenumobileapp/helper/utils/fonts.dart';

class WaiterNewOrderPage extends StatefulWidget {
  const WaiterNewOrderPage({super.key});

  @override
  State<WaiterNewOrderPage> createState() =>
      WaiterNewOrderPageState();
}

class WaiterNewOrderPageState extends State<WaiterNewOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: fontlgbold('New Orders'),
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
