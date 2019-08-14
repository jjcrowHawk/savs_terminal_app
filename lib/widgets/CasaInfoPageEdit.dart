import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:terminal_sismos_app/db/models.dart';

class CasaInfoPageEdit extends StatefulWidget {
  PageController parentController;
  final locationController= TextEditingController();
  final addressController=TextEditingController();
  final dateController= TextEditingController();
  final sectorController= TextEditingController();
  final bidController= TextEditingController();
  final elevationController= TextEditingController();
  final inspectorController= TextEditingController();
  final bageController= TextEditingController();
  List<TextEditingController> textControllers;
  Vivienda vivienda;
  Ficha ficha;


  CasaInfoPageEdit(this.parentController,this.vivienda,this.ficha);

  @override
  _CasaInfoPageEditState createState() => _CasaInfoPageEditState();
}

class _CasaInfoPageEditState extends State<CasaInfoPageEdit>  with AutomaticKeepAliveClientMixin<CasaInfoPageEdit>{
  List<Widget> widgets;
  List<String> labels=["Location","Address","Date","Sector","Building ID","Elevation","Inspector","Building Age"];


  @override
  void initState() {
    super.initState();
    widget.textControllers=[widget.locationController,widget.addressController,widget.dateController,widget.sectorController,widget.bidController,
      widget.elevationController,widget.inspectorController,widget.bageController];

    widget.sectorController.text = (widget.vivienda.sector != null && widget.vivienda.sector.isNotEmpty) ? widget.vivienda.sector : "";
    widget.bidController.text= (widget.vivienda.inspeccion_id != null && widget.vivienda.inspeccion_id.isNotEmpty) ? widget.vivienda.inspeccion_id : "";
    widget.inspectorController.text= (widget.ficha.inspector != null && widget.ficha.inspector.isNotEmpty) ? widget.ficha.inspector : "";
    widget.bageController.text= (widget.vivienda.edad_construccion!= null) ? widget.vivienda.edad_construccion.toString() : "";
    widget.addressController.text= (widget.vivienda.direccion!= null) ? widget.vivienda.direccion : "";
  }


  @override
  void dispose() {
    widget.textControllers.forEach((controller) => {controller.dispose()});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widgets=List<Widget>();

    //Building Title
    Widget title = Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 14.0, top: 14.0, bottom: 10.0),
      child: Text("Inspection Information",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Color.fromARGB(255, 48, 127, 226)
        ),
      ),
    );

    widgets.add(title);

    //Building Fields
    for(int i=0;i<labels.length;i++){
      String textPlaced= "";
      bool enabled= true;
      bool mandatory= (labels[i] == "Date" || labels[i] == "Sector" || labels[i] == "Building ID" || labels[i] == "Inspector");
      VoidCallback callback;

      if(labels[i] == "Location"){
        enabled= false;
        if(false  /*widget.vivienda.direccion != null && widget.vivienda.direccion.isNotEmpty  */) {
          widget.locationController.text= widget.vivienda.direccion;
          widget.elevationController.text= widget.vivienda.elevacion.toString();
        }
        else{
          Geolocator().getCurrentPosition().then((position) {
            print("Device pos: ${position.longitude} , ${position
                .latitude}, ${position.altitude}");
            widget.locationController.text =
            "${position.longitude}, ${position.latitude}";
            widget.elevationController.text = "${position.altitude}";
          });
        }
      }
      if(labels[i] == "Date"){
        widget.textControllers[i].text= (widget.ficha.fecha_inspeccion != null && widget.ficha.fecha_inspeccion.isNotEmpty) ? widget.ficha.fecha_inspeccion: new DateFormat("dd-MM-yyyy").format(DateTime.now());
        callback= (){
          print("checking date");
          var controller= widget.textControllers[i];
          if(labels[i] == "Date"){
            try{
              new DateFormat("dd-MM-yyyy").parse(controller.text);
            }catch(e){
              controller.text= "INVALID DATE FORMAT";
            }
          }
        };
      }

      Widget w= SingleChildScrollView(child:Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 14.0, top: 14.0),
                child: Text(labels[i],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Color.fromARGB(255, 48, 127, 226)
                  ),
                ),
              ),
              mandatory ? Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(left: 14.0, top: 14.0, bottom: 10.0),
                child: Text(" * ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: Colors.red,
                    //decoration: TextDecoration.underline,
                  ),
                ),
              ) : Container(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom:40.0,top:5.0,right: 14.0,left: 14.0),
            child: TextFormField(
              enabled: enabled,
              validator: (value){
                if(labels[i] == "Date"){
                  try{
                    new DateFormat("dd-MM-yyyy").parse(value);
                  }catch(e){
                    return "Enter a valid date (dd-MM-yyyy)";
                  }
                }
                return null;
              },
              onEditingComplete: callback,
              controller: widget.textControllers[i],
              //maxLines: 1,
              decoration: InputDecoration(labelText: "Enter your answer",
                /*border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  )*/
              ),
            ),
          ),
        ],
      ));

      widgets.add(w);
    }

    //Building next button
    Widget button =
    Container(
      alignment: Alignment.bottomRight,
      padding: EdgeInsets.only(right: 20,bottom: 25),
      child: RaisedButton(
        onPressed: (){
          print("going to next");
          widget.parentController.nextPage(duration: kTabScrollDuration, curve: Curves.easeIn);
        },
        color: Colors.blue,
        textColor: Colors.white,
        child: Container(child: Text("Next",textAlign: TextAlign.center)),
      ),
    );
    print("QUERY: ${MediaQuery.of(context).viewInsets.bottom}");
    Widget pad=Container(height: MediaQuery.of(context).size.height/2);

    widgets.add(button);
    widgets.add(pad);

    return ListView(
      //reverse: true,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: widgets,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
