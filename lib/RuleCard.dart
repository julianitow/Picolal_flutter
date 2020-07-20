import 'dart:async';

import 'package:flutter/material.dart';
import 'package:picolal/FavoritesView.dart';
import 'package:picolal/Rule.dart';
import 'package:picolal/Database_helper.dart';

class RuleCard extends StatefulWidget {
  Rule rule;
  Function callback;
  RuleCard({Key key, this.rule, this.callback }) : super(key: key);

  @override
  _RuleCardState createState() => _RuleCardState();
}

class _RuleCardState extends State<RuleCard> {
  DatabaseHelper db;

  void _delete() async {
    final name = this.widget.rule.name;
    final rowsDeleted = await db.deleteFromName(name);
    print('deleted $rowsDeleted row(s): row $name');
  }

  @override
  void initState() {
    super.initState();
    this.db = DatabaseHelper.instance;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        print("click")
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(3),
          color: Colors.lightBlue
        ),
        margin: EdgeInsets.only(top: 10, left: 40, right: 40),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Text(
                    widget.rule.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Text(widget.rule.content,
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                Container(
                  padding: EdgeInsets.only(bottom: 10, left: 10),
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 50,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: GestureDetector(
                          onTap: () {
                            this._delete();
                            widget.callback();
                          },
                          child: Container(
                            child: Icon(Icons.delete_outline, color: Colors.red,),
                          ),
                        )
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              widget.rule.drinks.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 5),
                                width: 18,
                                child: Image.asset("assets/drink_bg.png")
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
