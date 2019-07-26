import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:terminal_sismos_app/db/models.dart';

class ItemWidget extends StatefulWidget {
  Itemvariable item;
  Variable parentVar;

  ItemWidget(this.item,this.parentVar);

  @override
  _ItemWidgetState createState() => _ItemWidgetState(this.item,this.parentVar);
}

class _ItemWidgetState extends State<ItemWidget> with AutomaticKeepAliveClientMixin<ItemWidget> {
  Itemvariable item;
  Variable parentVar;
  List<Opcion> opciones;
  final noteController= TextEditingController();
  final textoController= TextEditingController();

  _ItemWidgetState(this.item,this.parentVar);


  @override
  void initState() {
    super.initState();
    print("INIT ITEM WIDGET");
    if(this.opciones == null && (item.tipo == "OpSimple" || item.tipo == "OpMultiple")) {
      item.getOpcions((opciones) {
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

  Widget _optionWidget(){
    if(item.tipo != "Texto" && opciones != null && opciones.length >0) {
      List<String> optionsStrings = opciones.map((opcion) => opcion.nombre)
          .toList();
      if (item.tipo == "OpMultiple") {
        return CheckboxGroup(
            labels: optionsStrings,
            labelStyle: TextStyle(fontSize: 16.0),
            onChange: (bool isChecked, String label, int index) {
              print("This info: $label cheked: $isChecked on index: $index");
            });
      }
      else if (item.tipo == "OpSimple") {
        return RadioButtonGroup(
          labels: optionsStrings,
          labelStyle: TextStyle(fontSize: 16.0),
          onChange: (String label, int index) {
            print("This info: $label on $index");
          },
        );
      }
    }
    else if (item.tipo == "Texto") {
        return Padding(
          padding: const EdgeInsets.all(14.0),
          child: TextField(
            controller: textoController,
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

  Widget _buildNoteWidget(){
    if(item.tipo != "Texto"){
      return  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17.0),
        child: TextField(
          decoration: InputDecoration(hintText: 'Notes'),
          controller: noteController,
        ),
      );
    }
    else{
      return Container();
    }
  }

  Widget _buildItemTitle(){
    if(item.nombre == parentVar.nombre){
      return Container();
    }
    else{
      return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 14.0, top: 14.0),
        child: Text(this.item.nombre,
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
