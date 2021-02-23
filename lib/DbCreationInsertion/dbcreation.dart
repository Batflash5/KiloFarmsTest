import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbCreation extends StatelessWidget {

  Future<void> dbCreation(context)async{
    bool newDBCreated=false;
    WidgetsFlutterBinding.ensureInitialized();
    await openDatabase(
      join(await getDatabasesPath(), 'sku_database.db'),
      onCreate: (db, version) {
        print('Creates new database');
        newDBCreated=true;
        return db.execute(
          "CREATE TABLE sku(skuID TEXT PRIMARY KEY, skuName TEXT)",
        );
      },
      version: 1,
    );
    if(newDBCreated){
      insertInDB(context);
    }
    else{
      Navigator.pushReplacementNamed(context, '/productListing');
    }
  }
  Future<void> insertInDB(context)async{
    print('Inserting in newDB');
    var db = await openDatabase('sku_database.db');
    var dbData;
    var response = await http.get("https://6j57eve9a1.execute-api.us-east-1.amazonaws.com/staging/vegetable?item=all&userId=1");
    var data=jsonDecode(response.body);
    for (var product in data['data'] ){
      dbData={
        'skuID': product['skuId'],
        'skuName':product['skuName'],
      };
      await db.insert(
        'sku',
        dbData,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    Navigator.pushReplacementNamed(context, '/productListing');
  }

  @override
  Widget build(BuildContext context) {
    dbCreation(context);
    return SpinKitCubeGrid(
      color: Color(0xFFD71B54),
      size: 100,
    );
  }
}
