import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:terminal_sismos_app/db/models.dart';
import 'package:terminal_sismos_app/utils/DemoLocalizations.dart';
import 'package:terminal_sismos_app/widgets/fichaItemListWidget.dart';

class EliminarFichaPage extends StatefulWidget {
  //List<fichaItemListWidget> fichasItemWidgets
  @override
  _EliminarFichaPageState createState() => _EliminarFichaPageState();
}

class _EliminarFichaPageState extends State<EliminarFichaPage> {
  List<fichaItemListWidget> fichasItemWidgets= new List<fichaItemListWidget>();


  deleteFicha(Ficha ficha){
    Alert successAlert= Alert(
      type: AlertType.success,
      context: context,
      title: DemoLocalizations.of(context).localizedValues['exito_eliminar'],
      desc: '',
      buttons: [
        DialogButton(
          child: Text(
            "Accept",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: (){
            Navigator.pop(context);
            setState((){
              for(fichaItemListWidget w in fichasItemWidgets){
                if(w.ficha == ficha){
                  fichasItemWidgets.remove(w);
                  break;
                }
              }
            });
          },
          color: Color.fromARGB(255, 48, 127, 226),
        ),
      ]
    );

    Alert warningAlert= Alert(
      type: AlertType.warning,
      context: context,
      title: DemoLocalizations.of(context).localizedValues['titulo_eliminar'],
      desc: DemoLocalizations.of(context).localizedValues['mensaje_eliminar'],
      buttons: [
        DialogButton(
          child: Text(
            "Accept",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: (){
            ficha.delete().then((result){
              if(result.success){
                Navigator.pop(context);
                successAlert.show();
              }
              else{
                print(result.errorMessage);
              }
            });
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
      ],
    );

    warningAlert.show();
  }

  @override
  void initState() {
    super.initState();

    List<fichaItemListWidget> widgets= new List<fichaItemListWidget>();

    Vivienda().select().toList((viviendas){
      print("THIS VIVIENDAS: $viviendas");
      Ficha().select().toList((fichas){
        for(Vivienda vivienda in viviendas){
          for(Ficha ficha in fichas){
            if(ficha.ViviendaId == vivienda.id){
              widgets.add(fichaItemListWidget(ficha,vivienda,forDelete: true,callBack: deleteFicha,));
              break;
            }
          }
        }
        setState(() {
          print("SETTING STATE from $widgets");
          this.fichasItemWidgets= widgets;
        });
      });
      /*for(int i=0;i<viviendas.length;i++){
        Vivienda vivienda= viviendas[i];
        vivienda.getFichas((fichas){
          print("THIS FICHAS: $fichas");
          for(int i=0; i<fichas.length;i++){
            Ficha ficha= fichas[i];
            widgets.add(fichaItemListWidget(ficha,vivienda));
          };
        });
        if(i == viviendas.length - 1){
          setState(() {
            print("SETTING STATE from $widgets");
            this.fichasItemWidgets= widgets;
          });
        }
      };*/
      print("AFTER ALL");
    });
  }

  @override
  Widget build(BuildContext context) {
    print("WIDGETS: $fichasItemWidgets");
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      //resizeToAvoidBottomPadding: true,
        appBar: new AppBar(
          title:new Text(DemoLocalizations.of(context).localizedValues['eliminar_ficha']),
        ),
        body: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: fichasItemWidgets.length,
            itemBuilder: (context,index){
          return fichasItemWidgets[index];
        }) /*ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: this.fichasItemWidgets
        )*/
    );
  }
}
