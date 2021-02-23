import 'package:flutter/material.dart';
import 'package:kilofarms/ProductScreens/product_listing.dart';
import 'package:provider/provider.dart';


class CardDesign extends StatelessWidget {

  final index;

  CardDesign({this.index});
  @override
  Widget build(BuildContext context) {
    final double height=MediaQuery.of(context).size.height;
    final double width=MediaQuery.of(context).size.width;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            Provider.of<Data>(context,listen: false).productNames[index],
            style: TextStyle(
              color: Colors.black,
              fontFamily: "WorkSans",
              fontWeight: FontWeight.bold,
              fontSize: height/50,
            ),
          ),
          SizedBox(
            height: height/50,
          ),
          Text(
            Provider.of<Data>(context,listen: false).productIDs[index],
            style: TextStyle(
              color: Colors.black,
              fontFamily: "WorkSans",
              fontWeight: FontWeight.bold,
              fontSize: height/50,
            ),
          ),
        ],
      ),
    );
  }
}