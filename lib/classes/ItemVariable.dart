import 'Opcion.dart';
import 'Variable.dart';

class ItemVariable{
  String nombre;
  TipoItem tipo;
  List<Opcion> opciones;
  Variable variable;

  ItemVariable(this.nombre, this.tipo, this.variable): opciones= new List<Opcion>();

}



enum TipoItem{
  OpSimple,
  OpMultiple,
  Texto
}