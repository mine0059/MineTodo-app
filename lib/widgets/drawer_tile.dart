import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final Widget leading;
  final void Function()? onTap;
  const DrawerTile(
      {super.key,
      required this.title,
      required this.leading,
      this.trailing,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: ListTile(
        title: Text(
          title,
        ),
        leading: leading,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
