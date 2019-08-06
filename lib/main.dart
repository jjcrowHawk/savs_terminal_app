import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:terminal_sismos_app/db/DBModel.dart';
import 'package:terminal_sismos_app/screens/fichas/ficha_editor.dart';


//Screens
import 'package:terminal_sismos_app/screens/menu.dart';
import 'package:terminal_sismos_app/screens/menu_encuesta.dart';
import 'package:terminal_sismos_app/screens/sincronizacion.dart';
import 'package:terminal_sismos_app/screens/info.dart';
import 'package:terminal_sismos_app/screens/fichas/revisar_ficha.dart';
import 'package:terminal_sismos_app/screens/fichas/nueva_ficha.dart';
import 'package:terminal_sismos_app/screens/fichas/editar_ficha.dart';
import 'package:terminal_sismos_app/screens/fichas/eliminar_ficha.dart';


//Utils
import 'package:terminal_sismos_app/utils/DemoLocalizations.dart';

void main() {
  //debugPaintSizeEnabled = true;
  DbModel().initializeDB((isReady){
    if(isReady == true){
      /*Seccion.withId(1, "General Information", true, false).save().then((value) => print(value));
      //Seccion.withFields("Structural Information", true, false).save().then((value) => print(value));
      Seccion().select().delete();
      Seccion().select().toList((secciones){
        secciones.forEach((Seccion s) => print(s.toMap()));
        print("These secciones: $secciones");
      });
      */
      runApp(MyApp());
    }
  });
  //runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: [
        const DemoLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', ''),
        const Locale('en',''),
      ],
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MenuPage(title: 'Flutter Demo Home Page'),
      routes: <String, WidgetBuilder> {
        '/menu': (BuildContext context) => MenuPage(title: 'page A'),
        '/fichas': (BuildContext context) => MenuEncuestaPage(title: 'page B'),
        '/sincro': (BuildContext context) => SincronizacionPage(),
        '/info': (BuildContext context) => InfoPage(),
        '/fichas/revisar_ficha': (BuildContext context) => RevisarFichaPage(),
        '/fichas/nueva_ficha': (BuildContext context) => NuevaFichaPage(),
        '/fichas/editar_ficha': (BuildContext context) => EditarFichaPage(),
        '/fichas/eliminar_ficha': (BuildContext context) => EliminarFichaPage(),
        //'/fichas/editor/edit': (BuildContext) => FichaEditorPage(),
      },
    );
  }
}