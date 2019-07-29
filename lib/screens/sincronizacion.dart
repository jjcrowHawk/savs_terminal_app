import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:terminal_sismos_app/utils/DemoLocalizations.dart';

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
                onPressed: () async{
                  Alert resultAlert= Alert(
                      context: this.context,
                      type: AlertType.success,
                      title: "Forms synced succesfuly",
                      desc: "All of your forms have been submited to the server",
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
                  ProgressDialog waitingDialog=new ProgressDialog(this.context, ProgressDialogType.Normal);
                  waitingDialog.setMessage("Syncing forms");
                  waitingDialog.show();
                  await Future.delayed(Duration(seconds: 5));
                  if(waitingDialog.isShowing())
                    waitingDialog.hide();
                  resultAlert.show();
                },
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
}
