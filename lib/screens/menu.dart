import 'package:flutter/material.dart';
import 'package:terminal_sismos_app/utils/DemoLocalizations.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:terminal_sismos_app/db/models.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }


  @override
  void initState() {
    super.initState();
    Seccion().select().delete();
    fetchFichaUpdate().then((String res){
      print(res.runtimeType);
      List<dynamic> list= json.decode(res);
      print("PARSING INFO: $list");
      List<Seccion> secciones= new List<Seccion>();
      list.forEach((obj){
        print("sec: $obj ");
        Seccion s= Seccion.fromMap(obj);
        s.save().then((value){
          print("saved: $value");
          print("content of variable: ${obj['variable']}");
          List<dynamic> json_variables= obj['variable'];
          json_variables.forEach((obj_variable){
            print("sec_id: ${obj_variable['seccion']}");
            Variable v= Variable.fromMap(obj_variable);
            v.save();
          });
        });
        /*if(obj['variable']){
          print("content of variable: ${obj['variable']}");
          List<dynamic> json_variables= obj['variable'];
          list.forEach((obj_variable){
            Variable v= Variable.fromMap(obj_variable);

            v.save();
          });
        }*/
      });

      Seccion().select().toList((secciones){
        secciones.forEach((seccion){
          print("Seccion: ${seccion.toMap()}");
          seccion.getVariables((variableList){
            print("Variable List: $variableList}");
            variableList.forEach((variable) => print("Variable: ${variable.toMap()}"));
          });
        });
      });

      //list.map((obj) => Seccion.fromMap(obj)).toList();
      /*secciones.forEach((seccion){
        print(seccion.toMap());
        seccion.getVariables((variableList){
          variableList.forEach((variable) => print(variable.toMap()));
        });
      });*/
    });
  }

  @override
  Widget build(BuildContext context) {
    Size devicesize= MediaQuery.of(context).size;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(''),
      ),
      body:
      new Container(
        /*\]]\\mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,*/
          padding: const EdgeInsets.all(10.0),
          child:
          Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      //FICHAS
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 10.0),
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                child: Image.asset("assets/images/ficha.png"),
                                onTap: ()=>Navigator.of(context).pushNamed('/fichas'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:10.0),
                                child: new Text(
                                  DemoLocalizations.of(context).localizedValues['ficha'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: 'Arvo',color: Color.fromARGB(255, 48, 127, 226),fontSize: 18),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      //SINCRONIZACION
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 10.0),
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                child: Image.asset("assets/images/sync.png"),
                                onTap: ()=>Navigator.of(context).pushNamed('/sincro'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:10.0),
                                child: new Text(
                                  DemoLocalizations.of(context).localizedValues['sincro'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: 'Arvo',color: Color.fromARGB(255, 48, 127, 226),fontSize: 18),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ]
                ),
              ),
              Expanded(
                flex: 3,
                child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      //INFORMACION
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 10.0),
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                  child: Image.asset("assets/images/info.png"),
                                  onTap: ()=>Navigator.of(context).pushNamed('/info'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:10.0),
                                child: new Text(
                                  DemoLocalizations.of(context).localizedValues['info'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: 'Arvo',color: Color.fromARGB(255, 48, 127, 226),fontSize: 18),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(),
                      )
                    ]
                ),
              ),
            ],
          )

      ),

    );
  }
}

Future<String> fetchFichaUpdate() async {
  final response = await http.get("https://sivswebapp.azurewebsites.net/api/actualizarfichatelefono");

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return response.body;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}
