import 'package:flutter/material.dart';
import 'package:saatmenumobileapp/helper/utils/colors.dart';
import 'package:saatmenumobileapp/helper/utils/fonts.dart';
import 'package:saatmenumobileapp/presentation/widget/appbar.dart';

class TablePage extends StatefulWidget {
  const TablePage({super.key});

  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  final dynamic tables = [
    /*
    * 0 = free
    * 1 = paid
    */
    {
      "table": "Table 1",
      "status": "0",
    },
    {
      "table": "Table 2",
      "status": "0",
    },
    {
      "table": "Table 3",
      "status": "0",
    },
    {
      "table": "Table 4",
      "status": "1",
    },
    {
      "table": "Table 5",
      "status": "0",
    },
    {
      "table": "Table 6",
      "status": "1",
    },
    {
      "table": "Table 7",
      "status": "1",
    },
    {
      "table": "Table 8",
      "status": "0",
    },
    {
      "table": "Table 9",
      "status": "1",
    },
    {
      "table": "Table 10",
      "status": "1",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar:
          AppBarWidget(title: 'Table 1', isBackButtonVisible: false),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.5,
                ),
                itemCount: tables.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, 'table_detail');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: tables[index]["status"] == "0"
                            ? Colors.green
                            : Colors.red,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.table_restaurant_outlined, color: Colors.white, size: 30,),
                            fontmdbold(
                              tables[index]["table"],
                              color: Colors.white,
                            ),
                            fontsmbold(
                              tables[index]["status"] == "0" ? 'Free' : 'Paid',
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
