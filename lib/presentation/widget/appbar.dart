import 'package:flutter/material.dart';
import 'package:saatmenumobileapp/helper/utils/colors.dart';
import 'package:saatmenumobileapp/helper/utils/fonts.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButtonVisible;

  const AppBarWidget({
    super.key,
    required this.title,
    required this.isBackButtonVisible,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: isBackButtonVisible
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : null,
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      title: fontxlbold(
        title,
        color: Colors.black,
      ),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(70);
}
