import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:terminal_sismos_app/db/models.dart';
import 'package:terminal_sismos_app/utils/DemoLocalizations.dart';
import 'package:mime_type/mime_type.dart';

class SincronizacionPage extends StatefulWidget {
  @override
  _SincronizacionPageState createState() => _SincronizacionPageState();
}

class _SincronizacionPageState extends State<SincronizacionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      //resizeToAvoidBottomPadding: true,
        appBar: new AppBar(
          title:new Text(DemoLocalizations.of(context).localizedValues['sincro']),
        ),
        body: ListView(
          padding: EdgeInsets.all(15),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Container(
              child: Text(
                DemoLocalizations.of(context).localizedValues['sincro_mensaje'],
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Arvo',color: Color.fromARGB(255, 48, 127, 226),fontSize: 25),
              ),
              alignment: Alignment.center,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              child: IconButton(
                icon: Image.asset("assets/images/syncnow.png"),
                onPressed: ()=>_syncForm(),
                iconSize: MediaQuery.of(context).size.height * 0.25,
              ),

            ),
            Container(
              padding: EdgeInsets.only(top: 18),
              child: Text(
                DemoLocalizations.of(context).localizedValues['sincro_ahora'],
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Arvo',color: Color.fromARGB(255, 48, 127, 226),fontSize: 25),
              ),
              alignment: Alignment.center,
            ),
          ],
         )
    );;
  }

  Future _syncForm() async{
    Alert resultAlert;
    ProgressDialog waitingDialog=new ProgressDialog(this.context, ProgressDialogType.Normal);
    waitingDialog.setMessage("Syncing forms");
    waitingDialog.show();
    Map<Vivienda,String> results= Map<Vivienda,String>();
    List<Ficha> fichas= new List<Ficha>();

    bool hasGotFichasData=false;
    Ficha().select().estado.equals("Finalizada").toList((fichasList) {
      fichas= fichasList;
      hasGotFichasData= true;
    });

    //Future.delayed(Duration(seconds:1));
    //waitingDialog.update(message:"Syncing form {}");
    while(!hasGotFichasData) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    if(fichas.isEmpty){
        waitingDialog.hide();
        resultAlert= _buildAlertWidget("No Forms found", "There are no forms to sync",type: AlertType.info);
        resultAlert.show();
        return;
    }

    for(Ficha ficha in fichas){
        bool hasGotDataFicha=false;
        Vivienda vivienda;
        List<Respuesta> respuestas;
        List<Anexo> anexos;


        ficha.getVivienda((v){
            vivienda = v;
            print(vivienda);
            ficha.getRespuestas((listRespuestas){
              respuestas= listRespuestas;
              print(respuestas);
              ficha.getAnexos((anexoList){
                anexos= anexoList;
                print(anexos);
                hasGotDataFicha= true;
                return;
              });
            });
        });

        while(!hasGotDataFicha) {
          await Future.delayed(Duration(milliseconds: 100));
        }//await Future.delayed(Duration(seconds: 10));
        print("vivienda ${vivienda.toMap()}");
        print("respuestas ${respuestas.toString()}");
        print("anexos ${anexos.toString()}");

        Future.delayed(Duration(seconds:1));
        waitingDialog.update(message:"Syncing form ${vivienda.inspeccion_id}");

        String json =await _buildJson(ficha,vivienda,respuestas,anexos);
        if(json == null){
          results[vivienda]= "PARSING_ERROR";
          continue;
        }
        //debugPrint(json);

        String response= await _submitToServer(json, anexos);
        results[vivienda]= response;
        if(response == "OK"){
          //results[vivienda]= response;
          ficha.estado= "Enviada";
          ficha.save();
          //Map<String,dynamic> update= new Map<String,dynamic>();
          //update["estado"]= "ENVIADA";

        }

      }
      print("OUT OF FUNCTION");
      waitingDialog.hide();
      String message= "Process was completed with these results:\n\n";
      for(Vivienda v in results.keys){
        if(results[v] == "OK")
          message+= "Form ${v.inspeccion_id} has been submited to server.\n\n";
        else if(results[v] == "ERROR")
          message+= "Form ${v.inspeccion_id} has not been submited. Try again later.\n\n";
        else if(results[v] == "PARSING_ERROR")
          message+= "Form ${v.inspeccion_id} had an unexpected error. Please check your form.\n\n";
      }
      resultAlert= _buildAlertWidget("Sync process finished", message,type: AlertType.info);
      resultAlert.show();
    /*await Future.delayed(Duration(seconds: 5));
    if(waitingDialog.isShowing())
      waitingDialog.hide();
    resultAlert.show();*/
  }

  Future<String> _buildJson(Ficha ficha,Vivienda vivienda,List<Respuesta> respuestas,List<Anexo> anexos) async{
    //manipulacion de la ficha
    Map<String,dynamic> fichaMap= ficha.toMap();
    fichaMap.remove("id");
    fichaMap.remove("estado");
    fichaMap.remove("activo");
    fichaMap.remove("ViviendaId");
    fichaMap.remove("isDeleted");
    DateFormat dateFormatter = new DateFormat("dd-MM-yyyy");
    DateTime date= dateFormatter.parse(fichaMap["fecha_inspeccion"]);
    DateFormat jsonDateFormatter= new DateFormat("yyyy-MM-ddTHH:mm:ss");
    fichaMap["fecha_inspeccion"]= jsonDateFormatter.format(date);


    //manipulacion de la vivienda
    Map<String,dynamic> viviendaMap= vivienda.toMap();
    viviendaMap.remove("id");
    viviendaMap.remove("isDeleted");
    if(viviendaMap.containsKey("elevacion")){
      viviendaMap["elevacion"]= double.parse(viviendaMap["elevacion"].toStringAsFixed(2));
    }
    //print("vivienda map: $viviendaMap");
    fichaMap["Vivienda"]= viviendaMap;

    //manipulacion de los anexos
    List<Map<String,dynamic>> anexosMapList= new List<Map<String,dynamic>>();
    for(Anexo anexo in anexos){
      Map<String,dynamic> anexoMap= anexo.toMap();
      anexoMap.remove("id");
      anexoMap.remove("FichaId");
      anexoMap.remove("isDeleted");
      anexoMap["url_anexo"]= anexoMap["url_anexo"].split("/")[anexoMap["url_anexo"].split("/").length - 1];
      //print("anexo map: $anexoMap");
      anexosMapList.add(anexoMap);
    }
    //print(anexosMapList);
    fichaMap["Anexo"]= anexosMapList;

    //manipulacion de repuestas
    List<Map<String,dynamic>> respuestasMapList= new List<Map<String,dynamic>>();
    for(Respuesta respuesta in respuestas){
      Map<String,dynamic> respuestaMap= respuesta.toMap();
      respuestaMap.remove("id");
      respuestaMap.remove("activo");
      respuestaMap.remove("FichaId");
      respuestaMap.remove("isDeleted");
      respuestaMap["item_respuesta"]= respuestaMap.remove("ItemVariableId");

      bool gotItemData=false;
      Itemvariable item;
      respuesta.getItemvariable((itemvariable){
        item= itemvariable;
        gotItemData= true;
      });
      while(!gotItemData){
        await Future.delayed(Duration(milliseconds: 100));
      }
      if(item == null){
        return null;
      }

      if(item.tipo == "Texto"){
        bool gotRespData= false;
        Respuestatexto respt;
        respuesta.getRespuestatextos((resptextoList){
          if(resptextoList.isEmpty){
            gotRespData=true;
            return;
          }
          respt= resptextoList.first;
          gotRespData= true;
        });
        while(!gotRespData){
          await Future.delayed(Duration(milliseconds: 100));
        }

        if(respt == null){
          return null;
        }

        Map<String,dynamic> resptMap= respt.toMap();
        resptMap.remove("id");
        resptMap.remove("RespuestaId");
        resptMap.remove("isDeleted");

        respuestaMap["RespuestaTexto"]= [resptMap];
      }
      else if(item.tipo == "OpSimple"){
        bool gotRespData= false;
        Respuestaopcionsimple respos;

        respuesta.getRespuestaopcionsimples((respList){
          if(respList.isEmpty){
            gotRespData= true;
            return;
          }
          respos= respList.first;
          gotRespData= true;
        });
        while(!gotRespData){
          await Future.delayed(Duration(milliseconds: 100));
        }

        if(respos == null){
          return null;
        }

        Map<String,dynamic> resptMap= respos.toMap();
        resptMap.remove("id");
        resptMap.remove("RespuestaId");
        resptMap.remove("isDeleted");
        resptMap["opcion_respuestasimple"]= resptMap.remove("OpcionId");

        respuestaMap["RespuestaOpcionSimple"]= [resptMap];
      }
      else if(item.tipo == "OpMultiple"){
        bool gotRespData= false;
        Respuestaopcionmultiple respom;
        List<Opcionrespuesta> opciones;


        respuesta.getRespuestaopcionmultiples((respList){
          if(respList.isEmpty){
            gotRespData= true;
            return;
          }
          respom= respList.first;
          if(respom == null){
            gotRespData= true;
          }
          respom.getRespuestaopcionrespuestas((opcionList){
            opciones= opcionList;
            gotRespData= true;
          });
        });
        while(!gotRespData){
          await Future.delayed(Duration(milliseconds: 100));
        }

        if(respom == null || opciones == null){
          return null;
        }

        Map<String,dynamic> resptMap= respom.toMap();
        resptMap.remove("id");
        resptMap.remove("RespuestaId");
        resptMap.remove("isDeleted");

        List<Map<String,dynamic>> opresMapList= List<Map<String,dynamic>>();
        for(Opcionrespuesta opcion in opciones){
          Map<String,dynamic> opresMap= opcion.toMap();
          opresMap.remove("id");
          opresMap.remove("RespuestaOpcionMultipleId");
          opresMap.remove("isDeleted");
          opresMap["opcion_respuesta"]= opresMap.remove("OpcionId");
          opresMapList.add(opresMap);
        }

        resptMap["RespuestaOpcion"]= opresMapList;
        respuestaMap["RespuestaOpcionMultiple"]= [resptMap];
      }

      respuestasMapList.add(respuestaMap);
    }
    //print(respuestasMapList);
    fichaMap["Respuesta"]= respuestasMapList;

    JsonEncoder encoder= JsonEncoder.withIndent(" ");
    String json= encoder.convert(fichaMap);
    debugPrint(json);
    return json;
  }

  Future<String> _submitToServer(String jsonData,List<Anexo> anexos) async{
      print("SENDING ANEXOS FROM FICHA ${anexos.isNotEmpty ? anexos.first.FichaId : ""}");
      var request= http.MultipartRequest("POST",Uri.parse("https://sivswebapp.azurewebsites.net/api/sincronizarFichas"));
      request.fields['json']= jsonData;
      for(Anexo anexo in anexos){
        File file= File(anexo.url_anexo);
        print("file length: ${file.lengthSync()}");
        String name= anexo.url_anexo.split("/")[anexo.url_anexo.split("/").length -1];
        String mimeType= mime(name);
        mimeType= mimeType != null ? mimeType : "text/plain; charset=UTF-8";
        http.MultipartFile mfile= await http.MultipartFile.fromPath(anexo.tipo, anexo.url_anexo,filename: name,contentType: MediaType.parse(mimeType));
        print(mfile.filename);
        request.files.add(mfile);
      }

      final response= await request.send();
      if(response.statusCode == 200){
        String body= await  response.stream.bytesToString();
        print("OK respones with $body");
        return "OK";
      }
      else{
        String body= await response.stream.bytesToString();
        print("ERROR RESPONSE WITH $body");
        return "ERROR";
      }
  }

  Alert _buildAlertWidget(title,description,{AlertType type}){
    return Alert(
        context: this.context,
        type: type ?? AlertType.success,
        title: title,
        desc: description,
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: (){
              Navigator.pop(context);
            },
            color: Color.fromARGB(255, 48, 127, 226),
          )
        ]
    );
  }
}
