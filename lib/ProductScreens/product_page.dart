import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sqflite/sqflite.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Color(0xFF3AAFA9),
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: AnimatedContainer(
          padding: EdgeInsets.symmetric(horizontal: width/10,vertical: height/10),
          curve: Curves.fastLinearToSlowEaseIn,
          duration: Duration(
            milliseconds: 1000
          ),
          child: ProductForm(),
        ),
      ),
    );
  }
}

class ProductForm extends StatefulWidget {
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {

  @override
  void initState() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          print(visible);
          columnAlignment= visible ? MainAxisAlignment.start: MainAxisAlignment.center;
        });
      },
    );
    super.initState();
  }

  Future<void> insertingIntoDatabase(String skuName)async{
    var response = await http.get("https://6j57eve9a1.execute-api.us-east-1.amazonaws.com/staging/vegetable?item=all&userId=1");
    var data=jsonDecode(response.body);
    String skuID;
    for(var product in data['data']){
      if(product['skuName']==skuName){
        skuID=product['skuId'];
        break;
      }
    }
    var dbData={
      'skuID': skuID,
      'skuName':skuName,
    };
    var db = await openDatabase('sku_database.db');
    await db.insert(
      'sku',
      dbData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  String _skuUnit="KG";
  String _skuCategory="Vegetables";
  String _skuName="";
  String _postURL="https://cc2pruxs38.execute-api.us-east-1.amazonaws.com/staging/vegetables";
  MainAxisAlignment columnAlignment=MainAxisAlignment.center;

  final _userID="1";
  final _skuNameController=TextEditingController();

  @override
  Widget build(BuildContext context) {

    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    final alphaNumericText = RegExp(r'^[a-zA-Z0-9]+$');

    return Column(
      mainAxisAlignment: columnAlignment,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.centerLeft,
            height: 90,
            child: TextField(
              controller: _skuNameController,
              keyboardType: TextInputType.text,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      color: Colors.black
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      color: Colors.black
                  ),
                ),
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  FontAwesomeIcons.ghost,
                  color: Colors.black,
                ),
                hintText: 'SKU Name',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ),
        Expanded(
          child: InputDecorator(
            decoration: InputDecoration(
                labelText: 'Unit',
                border: OutlineInputBorder()
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                icon:Icon(
                  Icons.arrow_drop_down_circle_outlined,
                ),
                isExpanded: true,
                value: _skuUnit,
                onChanged: (newUnit){
                  setState(() {
                    _skuUnit=newUnit;
                    print(_skuUnit);
                  });
                },
                items: [
                  DropdownMenuItem(child:Text('KG'),value: "KG",),
                  DropdownMenuItem(child:Text('Piece'),value: "Piece",),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                icon:Icon(
                    Icons.arrow_drop_down_circle_outlined
                ),
                value: _skuCategory,
                onChanged: (newCategory){
                  setState(() {
                    _skuCategory=newCategory;
                    print(_skuCategory);
                  });
                },
                items: [
                  DropdownMenuItem(child:Text('Vegetables'),value: "Vegetables",),
                  DropdownMenuItem(child:Text('Fruits'),value: "Fruits",),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          child: RaisedButton(
            elevation: 5.0,
            onPressed: ()async{
              FocusScope.of(context).requestFocus(new FocusNode());
              setState(() {
                _skuName=_skuNameController.text;
                print(_skuName);
              });
              if((_skuName!='') && (alphaNumericText.hasMatch(_skuName) != false) && (_skuName.isEmpty!=true)) {
                var response= await http.post(
                  _postURL,
                  body: jsonEncode(<String, String>{
                    "skuName": _skuName,
                    "user_id": _userID,
                    "skuUnit": _skuUnit,
                    "skuCategory": _skuCategory
                  }),
                );
                if(response.statusCode==200){
                  _skuNameController.clear();
                  print("Submitted");
                  await insertingIntoDatabase(_skuName);
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('New Product added successfully'))
                  );
                }
                else{
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to send data to the server'))
                  );
                  throw Exception("Failed to send data to the server");
                }
              }
              else{
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Please Enter a Unit'))
                );
              }
            },
            padding: EdgeInsets.all(15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Colors.white,
            child: Text(
              'SUBMIT',
              style: TextStyle(
                color: Color(0xFF527DAA),
                letterSpacing: 1.5,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        )
      ],
    );
  }
}
