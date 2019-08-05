import 'package:flutter/material.dart';
import 'package:terminal_sismos_app/utils/DemoLocalizations.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:terminal_sismos_app/db/models.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
  ProgressDialog progressDialog;
  Alert alertFail;



  @override
  void initState() {
    super.initState();
    alertFail= Alert(context: context,
      title: "Error on Form Update",
      desc: "There was an error while updating the form. It's mandatory to update the form"
          "in order to add new important fields. Do you want to retry?",
      buttons: [
        DialogButton(
          child: Text(
            "Retry",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: (){
            Navigator.pop(context);
            updateFicha().then((value){
              //Just querying database data for testing
              printDatabase();
              progressDialog.hide();
            }).catchError((e){
              print("$e");
              if(progressDialog.isShowing())
                progressDialog.hide();

              alertFail.show();
            });
            progressDialog.show();
          },
          color: Color.fromARGB(255, 48, 127, 226),
        ),
        DialogButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: Color.fromARGB(255, 255, 51, 51)),
      ],);

    updateFicha().then((value){
      //Just querying database data for testing
      printDatabase();
      if(progressDialog.isShowing())
        progressDialog.hide();
    },onError: (error){
      if(progressDialog.isShowing())
        progressDialog.hide();

      alertFail.show();
    }).catchError((e){
      print("$e");
      if(progressDialog.isShowing())
        progressDialog.hide();

      alertFail.show();
    });

    WidgetsBinding.instance.addPostFrameCallback((_){
      progressDialog=new ProgressDialog(context, ProgressDialogType.Normal);
      progressDialog.setMessage("Updating Form fields");
      progressDialog.show();

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


  Future<String> fetchFichaUpdate() async {
    final response = await http.get("https://sivswebapp.azurewebsites.net/api/actualizarfichatelefono");
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      return response.body;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to connect to server');
    }
  }


  Future<void> updateFicha() async{
    String json_string;
    try {
      json_string = await fetchFichaUpdate();

      List<dynamic> list = json.decode(json_string);
      print("PARSING INFO: $list");
      list.forEach((obj) async {
        //print("sec: $obj ");
        Seccion s = Seccion.fromMap(obj);
        int value = await s.save();
        if (value <= 0){
          throw Exception("Failed to parse object \'Seccion\' and save data in database");
        }

        List<dynamic> json_variables = obj['variable'];
        json_variables.forEach((obj_variable) async {
          //print("sec_id: ${obj_variable['seccion']}");
          Variable variable = Variable.fromMap(obj_variable);
          int value_v = await variable.save();
          if (value_v <= 0) {
            throw Exception(
                "Failed to parse object \'Variable\' and save data in database");
          }

          List<dynamic> json_items = obj_variable['itemVariable'];
          json_items.forEach((obj_item) async {
            Itemvariable item = Itemvariable.fromMap(obj_item);
            int value_i = await item.save();
            if (value_i <= 0) {
              throw Exception(
                  "Failed to parse object \'ItemVariable\' and save data in database");
            }
            List<dynamic> json_options = obj_item['opcion'];
            json_options.forEach((obj_option) async {
              Opcion op = Opcion.fromMap(obj_option);
              int value_op = await op.save();
              if (value_op <= 0) {
                throw Exception(
                    "Failed to parse object \'Opcion\' and save data in database");
              }
            });
          });
        });
      });
    }catch(e){
      print("EXCEPTION LAUNCHED!!!!!!!!!! $e");
      rethrow;
    }
  }

  void printDatabase(){
    /*Seccion().select().toList((secciones){
      secciones.forEach((seccion) async{
        print("Seccion: ${seccion.toMap()}");
        await seccion.getVariables((variableList){
          print("Variable List: $variableList of ${seccion.nombre}");
          variableList.forEach((variable){
            print("Variable: ${variable.toMap()} from seccion ${seccion.nombre}");
            variable.getItemvariables((itemvariableList){
              print("ItemVariable List: $itemvariableList of ${variable.nombre}");
              itemvariableList.forEach((item){
                print("Item: ${item.toMap()} from variable ${variable.nombre}");
                item.getOpcions((opcionList){
                  print("Option List: $opcionList of ${item.nombre}");
                  opcionList.forEach((opcion){
                    print("Opcion: ${opcion.toMap()} from item ${item.nombre}");
                  });
                });
              });
            });
          });
        });
      });
    });*/
    Vivienda().select().toList((viviendaList){
      viviendaList.forEach((v){
        v.getFichas((fichaList){
          fichaList.forEach((ficha){
            ficha.getAnexos((anexoList){
              ficha.getRespuestas((respuestaList){
                print("${v.toMap()}");
                print("${ficha.toMap()}");
                for(Anexo a in anexoList)
                  print("${a.toMap()}");
                for(Respuesta r in respuestaList) {
                  r.getRespuestatextos((respuestatextoList){
                    r.getRespuestaopcionsimples((respuestaopcionsimpleList){
                      r.getRespuestaopcionmultiples((respuestaopcionmultipleList){
                        print(" ANSWER: ${r.toMap()}");
                        print("Text: ${respuestatextoList.isNotEmpty ? respuestatextoList.first.toMap() : ""}");
                        print("Simple:${respuestaopcionsimpleList.isNotEmpty ? respuestaopcionsimpleList.first.toMap() : ""}");
                        print("Mult: ${respuestaopcionmultipleList.isNotEmpty ? respuestaopcionmultipleList.first.toMap(): ""}");
                      });
                    });
                  });
                }
              });
            });
          });
        });
      });
    });

    Ficha().select().recover();
  }
}
