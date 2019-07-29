import 'package:flutter/material.dart';
import 'package:terminal_sismos_app/db/models.dart';
import 'package:terminal_sismos_app/utils/DemoLocalizations.dart';
import 'package:terminal_sismos_app/widgets/fichaItemListWidget.dart';

class EditarFichaPage extends StatefulWidget {
  @override
  _EditarFichaPageState createState() => _EditarFichaPageState();
}

class _EditarFichaPageState extends State<EditarFichaPage> {
  List<Widget> fichasItemWidgets= new List<Widget>();

  @override
  void initState() {
    super.initState();

    List<Widget> widgets= new List<Widget>();

    Vivienda().select().toList((viviendas){
      print("THIS VIVIENDAS: $viviendas");
      Ficha().select().estado.not.equals("Enviada").toList((fichas){
        for(Vivienda vivienda in viviendas){
          for(Ficha ficha in fichas){
            if(ficha.ViviendaId == vivienda.id){
              widgets.add(fichaItemListWidget(ficha,vivienda));
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
          title:new Text(DemoLocalizations.of(context).localizedValues['editar_ficha']),
        ),
        body: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: this.fichasItemWidgets
        )
    );
  }

}
