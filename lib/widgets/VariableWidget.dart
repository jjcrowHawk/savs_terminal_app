import 'package:flutter/material.dart';
import 'package:terminal_sismos_app/db/models.dart';

import 'ItemWidget.dart';

class VariableWidget extends StatefulWidget {
  List<Widget> itemWidgets;
  Variable variable;


  VariableWidget(Variable variable, List<Widget> items){
    Widget sec_title = Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 14.0, top: 14.0, bottom: 10.0),
      child: Text(variable.nombre,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            color: Color.fromARGB(255, 48, 127, 226),
            decoration: TextDecoration.underline,
        ),
      ),
    );
    items.insert(0,sec_title);

    this.variable= variable;
    this.itemWidgets= items;
  }

  @override
  _VariableWidgetState createState() => _VariableWidgetState(this.itemWidgets,this.variable);
}

class _VariableWidgetState extends State<VariableWidget> {
  List<Widget> itemWidgets;
  Variable variable;

  _VariableWidgetState(this.itemWidgets, this.variable);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: itemWidgets,
    );
  }
}
