import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OpenDrawerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: FaIcon(FontAwesomeIcons.alignLeft),
      onPressed: ()=>Scaffold.of(context).openDrawer(),
    );
  }
}