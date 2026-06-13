import 'package:flutter/material.dart';

class HeaderTextAuthWidget extends StatelessWidget {
  const HeaderTextAuthWidget({super.key, required this.txt});
  final String txt;
  @override
  Widget build(BuildContext context) {
    return Text(txt, style: Theme.of(context).textTheme.displayMedium);
  }
}
