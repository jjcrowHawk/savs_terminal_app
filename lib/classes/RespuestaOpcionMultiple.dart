import 'package:terminal_sismos_app/classes/Ficha.dart';

import 'package:terminal_sismos_app/classes/ItemVariable.dart';

import 'Opcion.dart';
import 'Respuesta.dart';

class RespuestaOpcionMultiple extends Respuesta{
  List<Opcion> opciones;

  RespuestaOpcionMultiple(String nota, Ficha ficha, ItemVariable item) :
        opciones=new List<Opcion>(),
        super(nota, ficha, item);


}