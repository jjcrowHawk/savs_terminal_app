import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:terminal_sismos_app/db/models.dart';


class ItemEditWidget extends StatefulWidget {
  Itemvariable item;
  Variable parentVar;
  Respuesta respuesta;
  Map<String,int> responsesMap;
  final noteController= TextEditingController();
  final textoController= TextEditingController();
  bool editable=true;
  bool changedValue=false;

  ItemEditWidget(this.item,this.parentVar,this.respuesta,this.editable): responsesMap= new Map<String,int>();

  @override
  _ItemEditWidgetState createState() => _ItemEditWidgetState();
}

class _ItemEditWidgetState extends State<ItemEditWidget> with AutomaticKeepAliveClientMixin<ItemEditWidget>  {
  List<Opcion> opciones;
  String _opEscogida;
  List<String> opcionesEscogidas;

  //_ItemEditWidgetState(this.item,this.parentVar);


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
        //opcionesEscogidas= List<String>();

        if(widget.respuesta !=null && opcionesEscogidas == null) {
          widget.respuesta.getRespuestaopcionmultiples((respomList) {
            if (respomList.isNotEmpty) {
              opcionesEscogidas= List<String>();
              respomList.first.getRespuestaopcionrespuestas((
                  opcionRespuestaList) {
                if (opcionRespuestaList.isNotEmpty) {
                  for (Opcionrespuesta or in opcionRespuestaList) {
                    for (int i = 0; i < opciones.length; i++) {
                      Opcion op = opciones[i];
                      if (or.OpcionId == op.id) {
                        widget.responsesMap[op.nombre]=  op.id;
                        opcionesEscogidas.add(op.nombre);
                        break;
                      }
                    }
                  }
                  setState(() {
                  });
                }
              });
            }
          });
        }


        return CheckboxGroup(
            labels: optionsStrings,
            labelStyle: TextStyle(fontSize: 16.0),
            checked: opcionesEscogidas ?? null,
            onChange: (bool isChecked, String label, int index) {
              if(isChecked){
                opcionesEscogidas.add(label);
                print("This info: $label cheked: $isChecked on index: $index with id: ${this.opciones[index].id}");
                widget.responsesMap[label]=  this.opciones[index].id;
                widget.changedValue=true;
                setState(() {

                });
              }
              else{
                opcionesEscogidas.remove(label);
                widget.changedValue=true;
                print("removing This info: $label cheked: $isChecked on index: $index with id: ${this.opciones[index].id}");
                widget.responsesMap.remove(label);
                setState(() {

                });
              }
            });
      }

      else if (widget.item.tipo == "OpSimple") {


        if(widget.respuesta !=null && _opEscogida == null) {
          widget.respuesta.getRespuestaopcionsimples((resposList) {
            if (resposList.isNotEmpty) {
              String option;
              for (Opcion op in opciones) {
                if (resposList.first.OpcionId == op.id) {
                  widget.responsesMap[op.nombre] = op.id;
                  setState(() {
                    _opEscogida= op.nombre;
                  });
                  //option=op.nombre;
                  break;
                }
              }
              /*setState(() {
                if(option.isNotEmpty){
                  _opEscogida= option;
                }
              });*/
            }
          });


        }


        return RadioButtonGroup(
          labels: optionsStrings,
          picked: _opEscogida!= null ? _opEscogida : null,
          labelStyle: TextStyle(fontSize: 16.0),
          onChange: (String label, int index) {
            print("This info: $label on $index with id: ${this.opciones[index].id}");
            widget.changedValue=true;
            widget.responsesMap.clear();
            widget.responsesMap[label]=  this.opciones[index].id;
            setState(() {
              _opEscogida=label;
            });
          },
        );
      }
    }

    else if (widget.item.tipo == "Texto") {
      if (widget.respuesta != null) {
        widget.respuesta.getRespuestatextos((resptList) {
          if (resptList.isNotEmpty) {
            widget.textoController.text = resptList.first.texto;
          }
        });
      }


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
          onChanged: (text){widget.changedValue=true;},
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
    if(widget.respuesta != null){
      widget.noteController.text= widget.respuesta.nota;
    }

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
