import 'package:terminal_sismos_app/classes/Ficha.dart';
import 'package:terminal_sismos_app/classes/ItemVariable.dart';
import 'Respuesta.dart';

class RespuestaTexto extends Respuesta{
  String texto;

  RespuestaTexto(String nota, Ficha ficha, ItemVariable item,this.texto) : super(nota, ficha, item);
}