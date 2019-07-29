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

    Widget mandatory_title= Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 14.0, top: 14.0, bottom: 10.0),
      child: Text(" * Mandatory Field",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
          color: Colors.red,
          //decoration: TextDecoration.underline,
        ),
      ),
    );

    Widget button =
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

    items.add(sec_title);
    items.add(mandatory_title);
    items.add(button);
    items.add(pad);

    this.variableWidgets= items;
  }
  
  @override
  _SeccionWidgetState createState() => _SeccionWidgetState();
}

class _SeccionWidgetState extends State<SeccionWidget> {
  //List<Widget> items;

  //_SeccionWidgetState(this.items);


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.variableWidgets[2].runtimeType == Row){
      widget.variableWidgets.add(widget.variableWidgets.removeAt(2));
      widget.variableWidgets.add(widget.variableWidgets.removeAt(2));
    }

    //Widget pad=Container(height: MediaQuery.of(context).size.height/2);
    //widget.variableWidgets.add(pad);

    return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: widget.variableWidgets
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
