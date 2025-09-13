import 'package:flutter/material.dart';
import 'package:saatmenumobileapp/helper/utils/colors.dart';
import 'package:saatmenumobileapp/helper/utils/fonts.dart';
import 'package:saatmenumobileapp/presentation/page/home.dart';
import 'package:saatmenumobileapp/presentation/widget/appbar.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBarWidget(title: 'Order Detail', isBackButtonVisible: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      fontmdbold('Table 1'),
                      fontmd('Order #103214'),
                      fontxsbold('Order Time: 10:15 AM'),
                    ],
                  ),
                  const Spacer(),
                  statusBox('0')
                ],
              ),
            ),
            const SizedBox(height: 20),
            ...List.generate(
              10,
              (index) => Column(
                children: [
                  Divider(
                    color: Colors.grey[400],
                    height: 1,
                  ),
                  // orderingDetail(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: orderGrandTotalBox(),
    );
  }
}

Widget orderGrandTotalBox() {
  return Container(
    height: 110,
    decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: Colors.grey,
        )),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        fontmdbold('Grand Total: \$53.70'),
        const Spacer(),
        Column(
          children: [
            fontmdbold('Payment: Paid with ABA'),
            const SizedBox(height: 10),
            Row(
              children: [
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: green,
                      ),
                    ),
                    child: Center(
                      child: fontmdbold('Decline'),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: green,
                    ),
                    child: Center(
                      child: fontmdbold('Accept', color: white),
                    ),
                  ),
                )
              ],
            )
          ],
        )
      ],
    ),
  );
}
