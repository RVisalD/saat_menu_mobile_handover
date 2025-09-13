import 'package:flutter/material.dart';
import 'package:saatmenumobileapp/helper/utils/colors.dart';
import 'package:saatmenumobileapp/helper/utils/fonts.dart';

class CashierPendingPaymentPage extends StatefulWidget {
  const CashierPendingPaymentPage({super.key});

  @override
  State<CashierPendingPaymentPage> createState() =>
      CashierPendingPaymentPageState();
}

class CashierPendingPaymentPageState extends State<CashierPendingPaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: fontlgbold('Pending Payment'),
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
                    5,
                    (index) => Column(
                      children: [
                        // orderingDetail(),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: SizedBox(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              fontmdbold('Sub Total', color: Colors.black),
                              fontmd('\$ 14.00', color: Colors.black),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              fontmd('Discount', color: Colors.black),
                              fontmd('\$ 4.00', color: Colors.black),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              fontmd('VAT 10%', color: Colors.black),
                              fontmd('\$ 1.4', color: Colors.black),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              fontmdbold('Grand Total: \$ 10.14', color: Colors.black),
                            ],
                          ),
                        ],
                      ),
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
                width: MediaQuery.of(context).size.width / 2 - 40,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  color: Color(0xfff1B5BA6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: fontsm('Pay by Cash', color: white),
                ),
              ),
            ),
            InkWell(
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width / 2 - 40,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  color: Color(0xfff1B5BA6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: fontsm('Pay with ABA', color: white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
