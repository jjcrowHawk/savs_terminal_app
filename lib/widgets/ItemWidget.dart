import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:terminal_sismos_app/db/models.dart';

class ItemWidget extends StatefulWidget {
  Itemvariable item;
  Variable parentVar;
  Map<String,int> responsesMap;
  final noteController= TextEditingController();
  final textoController= TextEditingController();



  ItemWidget(this.item,this.parentVar): responsesMap= new Map<String,int>();

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> with AutomaticKeepAliveClientMixin<ItemWidget> {
  List<Opcion> opciones;

  //_ItemWidgetState(this.item,this.parentVar);


  @override
  void initState() {
    super.initState();
    print("INIT ITEM WIDGET");
    if(this.opciones == null && (widget.item.tipo == "OpSimple" || widget.item.tipo == "OpMultiple")) {
      widget.item.getOpcions((opciones) {
        if(mounted) {
          setState(() {
            this.opciones = opciones;
          });
        }
      });
    }
  }


  @override
  void dispose() {
    super.dispose();
  }

  /**
   * Método que devuelve el widget que representa las opciones a elegir del item
   * o que devuelve un cuadro de texto según sea el caso
   */
  Widget _optionWidget(){
    if(widget.item.tipo != "Texto" && opciones != null && opciones.length >0) {
      List<String> optionsStrings = opciones.map((opcion) => opcion.nombre)
          .toList();
      if (widget.item.tipo == "OpMultiple") {
        return CheckboxGroup(
            labels: optionsStrings,
            labelStyle: TextStyle(fontSize: 16.0),
            onChange: (bool isChecked, String label, int index) {
              if(isChecked){
                print("This info: $label cheked: $isChecked on index: $index with id: ${this.opciones[index].id}");
                widget.responsesMap[label]=  this.opciones[index].id;
              }
              else{
                print("removing This info: $label cheked: $isChecked on index: $index with id: ${this.opciones[index].id}");
                widget.responsesMap.remove(label);
              }
            });
      }
      else if (widget.item.tipo == "OpSimple") {
        return RadioButtonGroup(
          labels: optionsStrings,
          labelStyle: TextStyle(fontSize: 16.0),
          onChange: (String label, int index) {
            print("This info: $label on $index with id: ${this.opciones[index].id}");
            widget.responsesMap[label]=  this.opciones[index].id;
          },
        );
      }
    }
    else if (widget.item.tipo == "Texto") {
        return Padding(
          padding: const EdgeInsets.all(14.0),
          child: TextField(
            controller: widget.textoController,
            maxLines: 4,
            decoration: InputDecoration(labelText: "Enter your answer",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              )
            ),
          ),
        );
    }
    else{
      return Text("NO AVAILABLE OPTIONS");
    }
  }


  /**
   * Método que devuelve el widget que representa el textfield de la nota
   * de la respuesta
   */
  Widget _buildNoteWidget(){
    if(widget.item.tipo != "Texto"){
      return  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17.0),
        child: TextField(
          decoration: InputDecoration(hintText: 'Notes'),
          controller: widget.noteController,
        ),
      );
    }
    else{
      return Container();
    }
  }


  /**
   * Método que construye el widget del título del item
   */
  Widget _buildItemTitle(){
    if(widget.item.nombre == widget.parentVar.nombre){
      return Container();
    }
    else{
      return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 14.0, top: 14.0),
        child: Text(widget.item.nombre,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Color.fromARGB(255, 48, 127, 226)
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom:40.0),
      child: Column(
        children: <Widget>[
          _buildItemTitle(),
          _optionWidget(),
          _buildNoteWidget()
        ],
      ),
    );
  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
