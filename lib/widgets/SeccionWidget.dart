import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class SeccionWidget extends StatefulWidget {
  String title;
  List<Widget> items;

  SeccionWidget(String title,List<Widget> items){
    Widget sec_title = Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 14.0, top: 14.0, bottom: 10.0),
      child: Text(title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Color.fromARGB(255, 48, 127, 226)
        ),
      ),
    );
    items.insert(0,sec_title);

    this.title= title;
    this.items= items;
  }
  
  @override
  _SeccionWidgetState createState() => _SeccionWidgetState(this.title,this.items);
}

class _SeccionWidgetState extends State<SeccionWidget> {
  String title;
  List<Widget> items;

  _SeccionWidgetState(this.title, this.items);


  @override
  void initState() {
    Widget sec_title = Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 14.0, top: 14.0, bottom: 10.0),
      child: Text(this.title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Color.fromARGB(255, 48, 127, 226)
        ),
      ),
    );

    //items.insert(0, sec_title);
  }

  @override
  Widget build(BuildContext context) {
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
