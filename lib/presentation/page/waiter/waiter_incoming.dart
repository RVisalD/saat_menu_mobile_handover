import 'package:flutter/material.dart';
import 'package:saatmenumobileapp/helper/utils/colors.dart';
import 'package:saatmenumobileapp/helper/utils/fonts.dart';

class WaiterIncomingOrderPage extends StatefulWidget {
  const WaiterIncomingOrderPage({super.key});

  @override
  State<WaiterIncomingOrderPage> createState() =>
      WaiterIncomingOrderStatePage();
}

class WaiterIncomingOrderStatePage extends State<WaiterIncomingOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: fontlgbold('Ready to Served'),
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
      bottomNavigationBar: Container(
        height: 110,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: Colors.transparent,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width - 45,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Color(0xfff229116),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: fontsm('Served', color: white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
