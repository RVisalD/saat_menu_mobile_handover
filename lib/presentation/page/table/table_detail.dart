import 'package:flutter/material.dart';
import 'package:saatmenumobileapp/helper/utils/colors.dart';
import 'package:saatmenumobileapp/presentation/page/home.dart';
import 'package:saatmenumobileapp/presentation/widget/appbar.dart';

class TableDetailPage extends StatefulWidget {
  const TableDetailPage({super.key});

  @override
  State<TableDetailPage> createState() => _TableDetailPageState();
}

class _TableDetailPageState extends State<TableDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBarWidget(
        title: 'Table 1',
        isBackButtonVisible: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ...List.generate(
              10,
              (index) => Column(
                children: [
                  orderingBox(
                    'Table 1',
                    'Order #103214',
                    '10:15 AM',
                    '1',
                    context,
                  ),
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
