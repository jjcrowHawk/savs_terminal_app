import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AnexoPage extends StatefulWidget {
  PageController parentController;
  List<String> imagesUri;


  AnexoPage(this.parentController){
    imagesUri= ["assets/images/imgholder.jpg","assets/images/imgholder.jpg","assets/images/imgholder.jpg","assets/images/imgholder.jpg"];
  }

  @override
  _AnexoPageState createState() => _AnexoPageState();
}

class _AnexoPageState extends State<AnexoPage> {
  List<Widget> widgets;
  Alert alertImgViewer;

  //_AnexoPageState(this.parentController,this.imagesUri);


  @override
  void initState() {
    super.initState();
  }


  Widget _previewImage(int index){
    if(widget.imagesUri[index].contains("assets")){
      return Image.asset(
        widget.imagesUri[index],
        height: 200,
        width: MediaQuery
            .of(context)
            .size
            .width / 2,
      );
    }
    else{
      return Image.file(
        File(widget.imagesUri[index]),
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
      future: retrieveLostData(index),
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
        print("THIS IMAGE URL: "+image.path);
        widget.imagesUri[index]= image.path;
      });
  }

  Future _pickImageFromCamera(int index) async{
    var image = await ImagePicker.pickImage(source: ImageSource.camera,);

    setState(() {
      print("THIS IMAGE URL: "+image.path);
      widget.imagesUri[index]= image.path;
    });
  }

  Future _viewImage(int index) async{
    if(!widget.imagesUri[index].contains("assets")) {
      alertImgViewer = new Alert(
        context: context,
        title: "",
        image: Image.file(
          File(widget.imagesUri[index]),
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.70,
        ),
        buttons: [],
        style: AlertStyle(
          backgroundColor: Colors.transparent,
          alertBorder: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.zero
          ),
        )
      );
      alertImgViewer.show();
    }
  }

  Future  _deleteImage(int index) async{
    if(!widget.imagesUri[index].contains("assets")) {
      setState(() {
        widget.imagesUri[index] = "assets/images/imgholder.jpg";
      });
    }
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

    for(int i=0;i<widget.imagesUri.length;i++) {
      String label= widget.imagesUri[i].contains("asset") ?
      "no image" :
      widget.imagesUri[i].split("/")[widget.imagesUri[i].split("/").length - 1];

      Widget anexWidget = Column(
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
                children: <Widget>[

                  Column(
                    children: <Widget>[

                      Stack(
                        children: [ GestureDetector(
                            child: _buildImagePreview(i),
                            onTap: ()=> _viewImage(i),
                            onHorizontalDragEnd: (dragDetails)=> _deleteImage(i)
                        ),
                          !widget.imagesUri[i].contains("asset") ?
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon:  Image.asset("assets/images/delete.png",color: Color.fromARGB(255, 249, 95, 98),),
                              alignment: Alignment.topRight,
                              onPressed: () => _deleteImage(i),
                            ),
                          ) :
                          Container()
                          ,
                      ]),
                      Container(
                        padding: EdgeInsets.only(top:10.0),
                        width: MediaQuery.of(context).size.width/2,
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          textWidthBasis: TextWidthBasis.parent,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                              //fontFamily: 'Arvo',
                              color: Color.fromARGB(255, 48, 127, 226)
                          ),
                        ),
                      ),
                    ],
                  ),

                  Column(children: <Widget>[

                    Container(
                      width: MediaQuery.of(context).size.width * 0.40,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10, bottom: 20,right: 10),
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
                      width: MediaQuery.of(context).size.width * 0.40,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10, bottom: 10,right:10),
                      child: RaisedButton(

                        onPressed: () {
                          _pickImageFromCamera(i);
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
          widget.parentController.previousPage(duration: kTabScrollDuration, curve: Curves.easeIn);
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

  Future<void> retrieveLostData(int index) async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        widget.imagesUri[index] = response.file.path;
      });
    } else {
      //_retrieveDataError = response.exception.code;
    }
  }
}
