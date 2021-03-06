import 'package:flutter/material.dart';
import 'package:terminal_sismos_app/utils/DemoLocalizations.dart';

class MenuEncuestaPage extends StatefulWidget {
  MenuEncuestaPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MenuEncuestaPageState createState() => _MenuEncuestaPageState();
}

class _MenuEncuestaPageState extends State<MenuEncuestaPage> {
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
                      //REVISAR FICHA
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 10.0),
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                child: Image.asset("assets/images/rev_ficha.png"),
                                onTap: ()=>Navigator.of(context).pushNamed('/fichas/revisar_ficha'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:10.0),
                                child: new Text(
                                  DemoLocalizations.of(context).localizedValues['ver_ficha'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: 'Arvo',color: Color.fromARGB(255, 48, 127, 226),fontSize: 18),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      //NUEVA FICHA
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 10.0),
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                child: Image.asset("assets/images/nueva_ficha.png"),
                                onTap: ()=>Navigator.of(context).pushNamed('/fichas/nueva_ficha'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:10.0),
                                child: new Text(
                                  DemoLocalizations.of(context).localizedValues['nueva_ficha'],
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
                      //EDITAR FICHA
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 10.0),
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                child: Image.asset("assets/images/edit_ficha.png"),
                                onTap: ()=>Navigator.of(context).pushNamed('/fichas/editar_ficha'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:10.0),
                                child: new Text(
                                  DemoLocalizations.of(context).localizedValues['editar_ficha'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: 'Arvo',color: Color.fromARGB(255, 48, 127, 226),fontSize: 18),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      //ELIMINAR_FICHA
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 10.0),
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                child: Image.asset("assets/images/del_ficha.png"),
                                onTap: ()=>Navigator.of(context).pushNamed('/fichas/eliminar_ficha'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:10.0),
                                child: new Text(
                                  DemoLocalizations.of(context).localizedValues['eliminar_ficha'],
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
            ],
          )

      ),

    );
  }
}