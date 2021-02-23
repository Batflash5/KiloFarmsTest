import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kilofarms/ProductScreens/product_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'carddesign.dart';
import 'opendrawerbutton.dart';


class ListData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Data>(
      create: (context)=>Data(),
      child: SafeArea(
        child: Scaffold(
          body: Listing(),
        ),
      ),
    );
  }
}

class Listing extends StatefulWidget {
  @override
  _ListingState createState() => _ListingState();
}

class _ListingState extends State<Listing> {
  Future<void> fetchProducts(context)async{
    bool connectivity=await checkConnection();
    if(!connectivity){
      var db = await openDatabase('sku_database.db');
      final List<Map<String, dynamic>> maps = await db.query('sku');
      for(var map in maps){
        Provider.of<Data>(context,listen: false).changeData(pName:map['skuName'],pID:map['skuID']);
      }
      Provider.of<Data>(context,listen: false).changeFetched();
      print(maps);
    }
    else{
      var response = await http.get("https://6j57eve9a1.execute-api.us-east-1.amazonaws.com/staging/vegetable?item=all&userId=1");
      var data=jsonDecode(response.body);

      for(var product in data['data']){
        Provider.of<Data>(context,listen: false).changeData(pName:product['skuName'],pID:product['skuId']);
      }
      print(data);

      Provider.of<Data>(context,listen: false).changeFetched();
    }
  }

  Future<bool> checkConnection() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult==ConnectivityResult.none){
      return false;
    }
    else{
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts(context);
  }

  double height=0;
  double width=0;
  bool isProductPage=false;

  @override
  Widget build(BuildContext context) {
    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.width;

    return Provider.of<Data>(context).fetched?Scaffold(
      backgroundColor: isProductPage?Colors.black:Color(0xFF3AAFA9),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        child: ListView(
          children: [
            Image(
              image: AssetImage("images/agriculture.jpg"),
            ),
            SizedBox(
              height: height/30,
            ),
            ListTile(
              onTap: (){
                setState(() {
                  isProductPage=true;
                });
                Navigator.pop(context);
              },
              leading: Icon(
                  Icons.add
              ),
              title: Text(
                "Add a Product",
                style: TextStyle(
                  fontFamily: "WorkSans",
                ),
              ),
            ),
            ListTile(
              onTap: (){
                setState(() {
                  isProductPage=false;
                  Provider.of<Data>(context,listen: false).productIDs=[];
                  Provider.of<Data>(context,listen: false).productNames=[];
                  Provider.of<Data>(context,listen: false).fetched=false;
                  fetchProducts(context);
                });
                Navigator.pop(context);
              },
              leading: Icon(
                  Icons.view_list_outlined
              ),
              title: Text(
                "View Products",
                style: TextStyle(
                  fontFamily: "WorkSans",
                ),
              ),
            ),
            ListTile(
              onTap: ()async{
                SharedPreferences preferences=await SharedPreferences.getInstance();
                preferences.remove('username');
                Navigator.pushReplacementNamed(context, '/login');
              },
              leading: Icon(
                  Icons.logout
              ),
              title: Text(
                "Log Out",
                style: TextStyle(
                  fontFamily: "WorkSans",
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading:OpenDrawerButton(),
        title: Text(
          isProductPage?'NEW PRODUCT':'PRODUCTS',
          style: TextStyle(
            fontFamily: "WorkSans",
          ),
        ),
        centerTitle: true,
      ),
      body: isProductPage?ProductPage():Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/orangeBackground.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: ProductListBuilder(),
      ),
    ):Center(
      child: SpinKitCubeGrid(
        color: Color(0xFFD71B54),
        size: 100,
      ),
    );
  }
}

class ProductListBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double height=MediaQuery.of(context).size.height;
    final double width=MediaQuery.of(context).size.width;
    return Container(
      child: ListView.builder(
        itemBuilder: (context,index){
          return Container(
            padding: EdgeInsets.fromLTRB(5,height/4,0,height/4),
            height: height/2.3,
            width: width/1.3,
            child: Card(
                child: CardDesign(index:index),
              elevation: 20,
            ),
          );
        },
        itemCount: Provider.of<Data>(context,listen: false).productIDs.length,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

class Data extends ChangeNotifier{

  List<String> productNames=[];
  List<String> productIDs=[];
  bool fetched=false;

  void changeData({String pName,String pID}){
    productNames.add(pName);
    productIDs.add(pID);
    notifyListeners();
  }

  void changeFetched(){
    fetched=true;
    notifyListeners();
  }

}