import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kilofarms/DbCreationInsertion/dbcreation.dart';
import 'package:kilofarms/ProductScreens/product_listing.dart';
import 'package:kilofarms/ProductScreens/product_page.dart';
import 'package:kilofarms/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences=await SharedPreferences.getInstance();
  String username= preferences.getString('username');
  runApp(MyApp(username:username));
}

class MyApp extends StatelessWidget {
  final String username;
  MyApp({this.username});
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/login':(context)=>LoginPage(),
        '/create':(context)=>DbCreation(),
        '/productListing':(context)=>ListData(),
        '/productPage':(context)=>ProductPage(),
      },
      home: username==null?LoginPage():DbCreation(),//DbCreation()
    );
  }
}