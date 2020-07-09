import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picolal/ApiServices.dart';
import 'package:picolal/Category.dart';
import 'package:picolal/Rule.dart';
import 'package:picolal/Home.dart';
import 'dart:math';
import 'package:picolal/Database_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DrunkView extends StatefulWidget {
  final Category category;
  final List<String> players;
  final List<Rule> rules;

  DrunkView(this.category, this.players, this.rules);

  @override
  _DrunkViewState createState() => _DrunkViewState(this.players);
}

class _DrunkViewState extends State<DrunkView> {

  int currentIndex;
  String currentPlayer;
  List<String> players;
  _DrunkViewState(this.players);
  final DatabaseHelper db = DatabaseHelper.instance;

  //When leaving reput the screen in portrait mode
  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  //Rotate landscape screen
  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    this._delete();
  }

  void initRules(List<Rule> rules){
    Random random = new Random();
    int randomNumber = random.nextInt(rules.length);
    int randomNumber2 = random.nextInt(this.players.length);

    this.currentPlayer = this.players[randomNumber2];
    this.currentIndex = randomNumber;
    print("init rules : " + widget.rules.toString());
  }

  int randomInt(){
    Random random = new Random();
    return random.nextInt(widget.rules.length);
  }

  void refreshRule(){
    if(widget.rules.length > 1){
      widget.rules.removeAt(this.currentIndex);
      this.currentIndex = randomInt();
      setState(() {

      });
    } else {
      print("NO MORE RULES");
      this._goToHomeView(context);
    }
  }

  void _goToHomeView(BuildContext context){
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => MyHomePage(),
        ),
      );
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await db.queryRowCount();
    for(int i = 1 ; i <= id ; i++){
      final rowsDeleted = await db.delete(i);
      print('deleted $rowsDeleted row(s): row $i');
    }
  }

  void insertDb(Rule rule) async{
    bool exists = false;
    Color color = Colors.green;
    String toastmsg = rule.name + " added to favorites";
    final allRows = await db.queryAllRows();
    allRows.forEach((row) => {
      if(row["name"] == rule.name){
        exists = true
      }
    });
    // row to insert
    if(!exists){
      Map<String, dynamic> row = {
        DatabaseHelper.columnName : rule.name,
        DatabaseHelper.columnContent : rule.content,
        DatabaseHelper.columnDrinks : rule.drinks
      };
      final id = await this.db.insert(row);
      print('inserted row id: $id');
    } else {
      color =Colors.orange;
      toastmsg = rule.name + " already added to favorites";
    }

    Fluttertoast.showToast(
        msg: toastmsg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  @override
  Widget build(BuildContext context) {
    initRules(widget.rules);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color.fromRGBO(52, 73, 94, 1.0),
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: <Widget>[
                        Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  width: 70,
                                  height: 70,
                                  child: GestureDetector(
                                    onTap: () => {
                                      this._goToHomeView(context)
                                    },
                                    child: Container(
                                      //color: Colors.orange,
                                        child: Image.asset('assets/quit_button.png')
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    "${widget.rules[this.currentIndex].name}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 50,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    width: 70,
                                    height: 70,
                                    child: GestureDetector(
                                      onTap: () => {
                                        this.refreshRule()
                                      },
                                      child: Container(
                                        child: Image.asset("assets/next_arrow.png"),
                                      ),
                                    )
                                )
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height*0.2,
                              alignment: Alignment.center,
                              child: Text(
                                '${this.currentPlayer}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.3,
                              alignment: Alignment.center,
                              child: Text(
                                '${widget.rules[this.currentIndex].content}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: MediaQuery.of(context).size.height*0.25,
                                alignment: Alignment.bottomLeft, padding: EdgeInsets.only(left: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () => {
                                        this.insertDb(widget.rules[this.currentIndex])
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            width: 70,
                                            height: 70,
                                            alignment: Alignment.bottomLeft,
                                            child: Icon(Icons.star_border, size: 70, color: Colors.yellow,),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              width: 70,
                                              height: 70,
                                              alignment: Alignment.bottomRight,
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    child: Image.asset("assets/drink_bg.png"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(right: 10),
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    '${widget.rules[this.currentIndex].drinks.toString()}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 35,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                )
                            )
                          ],
                        )
                      ],
                    )
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}