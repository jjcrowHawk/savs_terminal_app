import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

class CasaInfoPage extends StatefulWidget {
  PageController parentController;


  @override
  _CasaInfoPageState createState() => _CasaInfoPageState(this.parentController);

  CasaInfoPage(this.parentController);
}

class _CasaInfoPageState extends State<CasaInfoPage>  with AutomaticKeepAliveClientMixin<CasaInfoPage>{
  List<Widget> widgets;
  PageController parentController;
  final addressController= TextEditingController();
  final dateController= TextEditingController();
  final sectorController= TextEditingController();
  final bidController= TextEditingController();
  final elevationController= TextEditingController();
  final inspectorController= TextEditingController();
  final bageController= TextEditingController();

  List<TextEditingController> textControllers;
  List<String> labels=["Address","Date","Sector","Building ID","Elevation","Inspector","Building Age"];


  _CasaInfoPageState(this.parentController);

  @override
  void initState() {
    super.initState();
    textControllers=[addressController,dateController,sectorController,bidController,
    elevationController,inspectorController,bageController];
  }


  @override
  void dispose() {
    textControllers.forEach((controller) => {controller.dispose()});
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
      VoidCallback callback;

      if(labels[i] == "Address"){
        enabled= false;
        Geolocator().getCurrentPosition(LocationAccuracy.high).then((position){
          print("Device pos: ${position.longitude} , ${position.latitude}, ${position.altitude}");
          addressController.text= "${position.longitude}, ${position.latitude}";
          elevationController.text= "${position.altitude}";
        });
      }
      if(labels[i] == "Date"){
        textControllers[i].text= new DateFormat("dd-MM-yyyy").format(DateTime.now());
        callback= (){
          print("checking date");
          var controller= textControllers[i];
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
              controller: textControllers[i],
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
          parentController.nextPage(duration: kTabScrollDuration, curve: Curves.easeIn);
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
