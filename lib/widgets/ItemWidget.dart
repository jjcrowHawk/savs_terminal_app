import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class ItemWidget extends StatefulWidget {
  String title;
  bool multi;

  ItemWidget(this.title,this.multi);

  @override
  _ItemWidgetState createState() => _ItemWidgetState(this.title,this.multi);
}

class _ItemWidgetState extends State<ItemWidget> with AutomaticKeepAliveClientMixin<ItemWidget> {

  String title;
  bool multi;
  final noteController= TextEditingController();

  _ItemWidgetState(this.title,this.multi);

  Widget _optionWidget(){
    if(multi){
      return CheckboxGroup(
          labels: <String>["1","2",">=3"],
          labelStyle: TextStyle(fontSize: 16.0),
          onChange:  (bool isChecked, String label, int index){
            print("This info: $label cheked: $isChecked on index: $index");
          });
    }
    else{
      return RadioButtonGroup(
        labels: <String>["Option A","Option B","Option C","Option D"],
        labelStyle: TextStyle(fontSize: 16.0),
        onChange: (String label,int index){
          print("This info: $label on $index");
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom:40.0),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 14.0, top: 14.0),
            child: Text(this.title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Color.fromARGB(255, 48, 127, 226)
              ),
            ),
          ),
          _optionWidget(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17.0),
            child: TextField(
              decoration: InputDecoration(hintText: 'Notes'),
              controller: noteController,
            ),
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
