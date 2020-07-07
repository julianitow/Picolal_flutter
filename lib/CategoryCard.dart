import 'package:flutter/material.dart';
import 'package:picolal/ApiServices.dart';
import 'package:picolal/Category.dart';
import 'package:picolal/DrunkView.dart';
import 'package:picolal/Rule.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final List<String> players;

  const CategoryCard({Key key, this.category, this.players}) : super(key: key);

  void _goToDrunkView(BuildContext context) {
    ApiServices.getRulesByCat(this.category).then((rules) {
      print(rules.toString());
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => DrunkView(this.category, this.players, rules),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => { _goToDrunkView(context) },
      child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(3),
              color: Colors.grey),
          margin: EdgeInsets.only(top: 10, left: 40, right: 40),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text('${category.name}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center
                      )
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 30),
                    child: Text('${category.description}',
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.center),
                  )
                ],
              )
            ],
          )),
    );
  }
}
