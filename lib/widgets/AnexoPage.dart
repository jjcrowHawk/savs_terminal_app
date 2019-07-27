import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AnexoPage extends StatefulWidget {
  PageController parentController;
  List<String> imagesUri;


  AnexoPage(this.parentController){
    imagesUri= ["assets/images/imgholder.jpg","assets/images/imgholder.jpg","assets/images/imgholder.jpg","assets/images/imgholder.jpg"];
  }

  @override
  _AnexoPageState createState() => _AnexoPageState(this.parentController,this.imagesUri);
}

class _AnexoPageState extends State<AnexoPage> {
  List<Widget> widgets;
  PageController parentController;
  List<String> imagesUri;

  _AnexoPageState(this.parentController,this.imagesUri);


  @override
  void initState() {
    super.initState();
  }


  Widget _previewImage(int index){
    if(imagesUri[index].contains("assets")){
      return Image.asset(
        imagesUri[index],
        height: 200,
        width: MediaQuery
            .of(context)
            .size
            .width / 2,
      );
    }
    else{
      return Image.file(
        File(imagesUri[index]),
        height: 200,
        width: MediaQuery
            .of(context)
            .size
            .width / 2,
      );//Container();
    }
  }

  Widget _buildImagePreview(int index){
    return Platform.isAndroid
        ? FutureBuilder<void>(
      future: retrieveLostData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.done:
            return _previewImage(index);
          default:
            if (snapshot.hasError) {
              return Text(
                'Pick image/video error: ${snapshot.error}}',
                textAlign: TextAlign.center,
              );
            } else {
              return const Text(
                'You have not yet picked an image.',
                textAlign: TextAlign.center,
              );
            }
        }
      },
    ) : _previewImage(index);
  }

  Future _pickImageFromGallery(int index) async{
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        imagesUri[index]= image.path;
      });
  }

  @override
  Widget build(BuildContext context) {
    widgets= new List<Widget>();

    //Building Title
    Widget title = Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 14.0, top: 14.0, bottom: 10.0),
      child: Text("Annexes",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Color.fromARGB(255, 48, 127, 226)
        ),
      ),
    );

    widgets.add(title);

    for(int i=0;i<imagesUri.length;i++) {
      String label= imagesUri[i].contains("asset") ? "no image" :imagesUri[i];

      Widget anexWidget = Column(
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
                children: <Widget>[

                  Column(
                    children: <Widget>[

                      _buildImagePreview(i),
                      Text(
                        label,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            //fontFamily: 'Arvo',
                            color: Color.fromARGB(255, 48, 127, 226)
                        ),
                      ),
                    ],
                  ),

                  Column(children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20, bottom: 20),
                      child: RaisedButton(
                        onPressed: () {
                          _pickImageFromGallery(i);
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Container(child: Text(
                            "Pick from Gallery", textAlign: TextAlign.center)),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20, bottom: 10),
                      child: RaisedButton(
                        onPressed: () {

                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Container(child: Text(
                            "   Take Picture   ", textAlign: TextAlign.center)),
                      ),
                    )
                  ])
                ]
            ),
          )
        ],
      );

      widgets.add(anexWidget);
    }
    //Building next button
    Widget button =
    Container(
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.only(left: 20,top: 50),
      child: RaisedButton(
        onPressed: (){
          print("going to next");
          parentController.previousPage(duration: kTabScrollDuration, curve: Curves.easeIn);
        },
        color: Colors.blue,
        textColor: Colors.white,
        child: Container(child: Text("Previous",textAlign: TextAlign.center)),
      ),
    );
    Widget pad=Container(height: MediaQuery.of(context).size.height/2);

    widgets.add(button);
    widgets.add(pad);

    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children:widgets,
    );
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
          //_imageFile = response.file;
      });
    } else {
      //_retrieveDataError = response.exception.code;
    }
  }
}
