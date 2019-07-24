import 'Anexo.dart';
import 'Respuesta.dart';
import 'Vivienda.dart';

class Ficha{
  String inspector;
  DateTime fecha_inspeccion;
  EstadoFicha estado;
  List<Anexo> anexos;
  List<Respuesta> respuestas;
  Vivienda vivienda;

  Ficha(this.inspector, this.fecha_inspeccion, this.estado,this.vivienda)
      : anexos=new List<Anexo>(),
        respuestas= new List<Respuesta>();



}

enum EstadoFicha{
  Pendiente,
  Finalizada,
  Enviada
}