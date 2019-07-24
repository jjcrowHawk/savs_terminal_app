import 'package:terminal_sismos_app/classes/Ficha.dart';

import 'package:terminal_sismos_app/classes/ItemVariable.dart';

import 'Opcion.dart';
import 'Respuesta.dart';

class RespuestaOpcionSimple extends Respuesta{
  Opcion opcion;

  RespuestaOpcionSimple(String nota, Ficha ficha, ItemVariable item,this.opcion) : super(nota, ficha, item);
}