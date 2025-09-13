import 'package:flutter/material.dart';
import 'package:saatmenumobileapp/helper/utils/colors.dart';
import 'package:saatmenumobileapp/helper/utils/fonts.dart';
import 'package:saatmenumobileapp/presentation/page/home.dart';
import 'package:saatmenumobileapp/presentation/widget/appbar.dart';

class ServedPage extends StatefulWidget {
  const ServedPage({super.key});

  @override
  State<ServedPage> createState() => _ServedPageState();
}

class _ServedPageState extends State<ServedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBarWidget(
        title: 'Served',
        isBackButtonVisible: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            fontlgbold(
              'Served Orders',
              color: Colors.black,
            ),
            SizedBox(height: 20),
            ...List.generate(
              10,
              (index) => Column(
                children: [
                  orderingBox('Table 1', 'Order #123', '12:00 PM', '2', context),
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
