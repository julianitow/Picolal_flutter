import 'dart:async';

import 'package:flutter/material.dart';
import 'package:picolal/ApiServices.dart';
import 'package:picolal/Rule.dart';
import 'package:picolal/RuleCard.dart';
import 'package:picolal/Database_helper.dart';

class FavoritesView extends StatefulWidget{
  @override
  _FavoritesViewState createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {

  List<Rule> rules = [];

  static Future<List<Rule>> _query() async {
    List<Rule> rules = List<Rule>();
    final DatabaseHelper db = DatabaseHelper.instance;
    final allRows = await db.queryAllRows();
    allRows.forEach((row) {
      Rule rule = new Rule(0, row["name"], row["content"], row["drinks"]);
      rules.add(rule);
    });
    return rules;
  }

  void callback(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Mes règles favorites', style: TextStyle(color: Colors.orange, fontSize: 35, fontWeight: FontWeight.bold)),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 40),
              child: Column(
                children: <Widget>[
                  FutureBuilder(
                    future: _query(),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        this.rules = snapshot.data;
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: ListView.builder(
                            itemCount: this.rules.length,
                            itemBuilder: (context, index){
                              return RuleCard(rule: this.rules[index], callback: this.callback);
                            },
                          ),
                        );
                      } else {
                        return Text("NO DATA");
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}