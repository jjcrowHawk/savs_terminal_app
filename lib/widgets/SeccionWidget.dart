import 'package:flutter/material.dart';
import 'package:terminal_sismos_app/db/models.dart';
import 'VariableWidget.dart';

class SeccionWidget extends StatefulWidget {
  Seccion seccion;
  List<Widget> variableWidgets;
  PageController parentController;

  SeccionWidget(Seccion seccion,List<Widget> items,PageController pageController){

    this.seccion= seccion;
    this.parentController= pageController;

    Widget sec_title = Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 14.0, top: 14.0, bottom: 10.0),
      child: Text(seccion.nombre,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Color.fromARGB(255, 48, 127, 226)
        ),
      ),
    );

    Widget button = //Expanded(
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children:<Widget>[
      Container(
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.only(left: 20,bottom: 25),
        child: RaisedButton(
          onPressed: (){
              print("going to previous");
              parentController.previousPage(duration: kTabScrollDuration, curve: Curves.easeIn);
          },
          color: Colors.blue,
          textColor: Colors.white,
          child: Container(child: Text("Previous",textAlign: TextAlign.center)),
        ),
      ),
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
      ),
    ]
    ); //);

    Widget pad=Container(height: 300);

    items.insert(0,sec_title);
    items.add(button);
    items.add(pad);

    this.variableWidgets= items;
  }
  
  @override
  _SeccionWidgetState createState() => _SeccionWidgetState(this.seccion,this.variableWidgets,this.parentController);
}

class _SeccionWidgetState extends State<SeccionWidget> {
  bool buttonAdded=false;
  Seccion seccion;
  List<Widget> items;
  PageController parentController;

  _SeccionWidgetState(this.seccion, this.items,this.parentController);


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(items[1].runtimeType == Row){
      items.add(items.removeAt(1));
      items.add(items.removeAt(1));
    }
    /*if(!buttonAdded) {
      Widget button = //Expanded(
      Align(
        alignment: Alignment.bottomRight,
        child: RaisedButton(
          onPressed: null,
          color: Color.fromARGB(255, 48, 127, 226),
          textColor: Colors.white,
          child: Text("Next"),
          padding: EdgeInsets.only(right: 10,bottom: 20),
        ),
      ); //);
      items.add(button);
      buttonAdded= true;
    }
    else{

    }*/

    return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: items
    );
  }

}



/*class SeccionWidget extends StatelessWidget {
  String title;
  List<Widget> items;

  SeccionWidget(this.title,this.items);

  @override
  Widget build(BuildContext context) {
    Widget sec_title=Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 14.0, top: 14.0,bottom: 10.0),
      child: Text(this.title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Color.fromARGB(255, 48, 127, 226)
        ),
      ),
    );

    items.insert(0, sec_title);

    return
          ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: items
          )
    ;

  }

}*/
