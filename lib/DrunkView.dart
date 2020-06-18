import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picolal/ApiServices.dart';
import 'package:picolal/Category.dart';
import 'package:picolal/Rule.dart';
import 'dart:math';

class DrunkView extends StatefulWidget {
  final Category category;
  final List<String> players;

  DrunkView(this.category, this.players);

  @override
  _DrunkViewState createState() => _DrunkViewState();
}

class _DrunkViewState extends State<DrunkView> {

  List<Rule> rules = [];
  int currentIndex;

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
  }

  void initRules(List<Rule> rules){
    Random random = new Random();
    this.rules = rules;
    int randomNumber = random.nextInt(rules.length);

    this.currentIndex = randomNumber;
    print("init rules : " + this.rules.toString());
  }

  int randomInt(){
    Random random = new Random();
    return random.nextInt(this.rules.length);
  }

  void refreshRule(){
    this.rules.removeAt(this.currentIndex);
    this.currentIndex = randomInt();
    setState(() {
      rules.forEach((element) {print(element.name);});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color.fromRGBO(52, 73, 94, 1.0),
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder(
              future: ApiServices.getRulesByCat(widget.category),
              builder: (context, snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                    break;
                  case ConnectionState.done:
                    if(snapshot.hasError){
                      return Center(
                        child: Text("Une erreur est survenue"),
                      );
                    }
                    if(snapshot.hasData){
                      List<Rule> rules = snapshot.data;
                      if(rules.isEmpty){
                        return Center(
                          child: Text(
                              "Il n'y a pas de règles."
                          ),
                        );
                      } else {
                        initRules(rules);
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
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
                                          "${rules.elementAt(this.currentIndex).name}",
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
                                      padding: EdgeInsets.only(top: 10),
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
                                )
                              ],
                          ),
                        );
                      }
                    } else {
                      return Text("Aucune donnée");
                    }
                    break;
                  default:
                    return Center();
                    break;
                }
              },
            ),
          ),
        ),
      )
    );
  }
}