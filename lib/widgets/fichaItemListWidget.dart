import 'package:flutter/material.dart';
import 'package:terminal_sismos_app/db/models.dart';
import 'package:terminal_sismos_app/utils/DemoLocalizations.dart';

class fichaItemListWidget extends StatelessWidget {
  Ficha ficha;
  Vivienda vivienda;
  bool forDelete= false;


  fichaItemListWidget(this.ficha, this.vivienda,{this.forDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:15.0),
      child: Container(
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 14),
              child: Image.asset("assets/images/checklist.png",width: 100,height: 100,),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        child: Text(
                          "ID: ",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontFamily: 'Arvo',color: Color.fromARGB(255, 48, 127, 226),fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      Container(
                        child: Text(
                          vivienda.inspeccion_id,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontFamily: 'Arvo',color: Color.fromARGB(255, 48, 127, 226),fontSize: 16),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        child: Text(
                          "INSPECTOR:   ",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontFamily: 'Arvo',color: Color.fromARGB(255, 48, 127, 226),fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      Container(
                        child: Text(
                          ficha.inspector,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontFamily: 'Arvo',color: Color.fromARGB(255, 48, 127, 226),fontSize: 16),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        child: Text(
                          "DATE:    ",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontFamily: 'Arvo',color: Color.fromARGB(255, 48, 127, 226),fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      Container(
                        child: Text(
                          ficha.fecha_inspeccion,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontFamily: 'Arvo',color: Color.fromARGB(255, 48, 127, 226),fontSize: 16),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        child: Text(
                          "SECTOR:    ",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontFamily: 'Arvo',color: Color.fromARGB(255, 48, 127, 226),fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      Container(
                        child: Text(
                          vivienda.sector,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontFamily: 'Arvo',color: Color.fromARGB(255, 48, 127, 226),fontSize: 16),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        child: Text(
                          "${DemoLocalizations.of(context).localizedValues['estado']}:    ",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontFamily: 'Arvo',color: Color.fromARGB(255, 48, 127, 226),fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      Container(
                        child: Text(
                          DemoLocalizations.of(context).localizedValues[ficha.estado] ?? "",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontFamily: 'Arvo',color: Color.fromARGB(255, 48, 127, 226),fontSize: 16),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ],
                  )
                ],
              )
            )
          ],
        ),
        decoration: BoxDecoration(
          border:  Border(bottom: BorderSide(color:Colors.blueAccent,width: 2)),
        ),
        padding: EdgeInsets.only(top:30,bottom:30,left: 0,right: 0),
      ),
    );
  }
}
