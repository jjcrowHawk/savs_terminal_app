import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:terminal_sismos_app/db/models.dart';
import 'package:terminal_sismos_app/utils/DemoLocalizations.dart';
import 'package:terminal_sismos_app/widgets/AnexoPage.dart';
import 'package:terminal_sismos_app/widgets/CasaInfoPage.dart';
import 'package:terminal_sismos_app/widgets/CasaInfoPageEdit.dart';
import 'package:terminal_sismos_app/widgets/ItemEditWidget.dart';
import 'package:terminal_sismos_app/widgets/ItemWidget.dart';
import 'package:terminal_sismos_app/widgets/SeccionWidget.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:terminal_sismos_app/widgets/VariableWidget.dart';

class FichaEditorPage extends StatefulWidget {
  Vivienda vivienda;
  Ficha ficha;



  FichaEditorPage(this.vivienda,this.ficha);

  @override
  _FichaEditorPageState createState() => _FichaEditorPageState();
}

class _FichaEditorPageState extends State<FichaEditorPage> {
  List<Widget> secciones= new List<Widget>();
  List<Widget> tabs_titles= new List<Widget>();
  final PageController pageController= new PageController();
  CasaInfoPageEdit infoPage;
  AnexoPage anexoPage;
  Alert alertContinue;
  Map<String,dynamic> datosFicha= new Map<String,dynamic>();

  @override
  void initState() {
    super.initState();

    /*
    if(widget.vivienda == null || widget.ficha == null) {
      final List args = ModalRoute
          .of(context)
          .settings
          .arguments;
      widget.vivienda = args[0];
      widget.ficha = args[1];
    }*/

    infoPage= new CasaInfoPageEdit(pageController,widget.vivienda,widget.ficha);

    secciones.add(infoPage);


    widget.ficha.getRespuestas((respuestaList) {

      Seccion().select().toList((listaSecciones) {
        List<Widget> pages = new List<Widget>();
        pages.add(infoPage);
        listaSecciones.forEach((seccion) {
          //Retrieving variables for each Seccion
          List<Widget> vWidgets = new List<Widget>();
          seccion.getVariables((listaVariables) {
            listaVariables.forEach((variable) {
              //Retrieving items for each variable
              List<Widget> iWidgets = new List<Widget>();
              variable.getItemvariables((listaItems) {
                listaItems.forEach((item) {
                  bool found= false;
                  for(Respuesta res in respuestaList) {
                    if(res.ItemVariableId == item.id) {
                      iWidgets.add(new ItemEditWidget(item, variable, res, true));
                      found=true;
                      break;
                    }
                  }
                  if(!found){
                    iWidgets.add(new ItemEditWidget(item, variable, null, true));
                  }
                });
              });
              vWidgets.add(VariableWidget(variable, iWidgets));
            });
          });
          pages.add(new SeccionWidget(seccion, vWidgets, this.pageController));
        });
        anexoPage = AnexoPage(this.pageController);
        pages.add(anexoPage);
        setState(() {
          secciones = pages;
        });
      });
    });
  }


  /**
   * Método que devuelve las páginas de las secciones de la ficha
   */
  List<Widget> _buildSeccionPages(){
    if(secciones.length >0){
      return secciones;
    }
    else{
      List<Widget> l= new List<Widget>();
      l.add(Text("DATA NOT AVAILABLE"));
      return l;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child:Scaffold(
          //resizeToAvoidBottomInset: false,
          //resizeToAvoidBottomPadding: true,
          appBar: new AppBar(
            title:new Text(DemoLocalizations.of(context).localizedValues['nueva_ficha']),
          ),
          body: PageIndicatorContainer(
            pageView: new PageView(
              scrollDirection: Axis.horizontal,
              children: _buildSeccionPages(),
              controller: pageController,
            ),
            align: IndicatorAlign.bottom,
            length: secciones.length,
            indicatorSpace: 20.0,
            padding: EdgeInsets.only(top:20),
            indicatorColor: Colors.grey,
            indicatorSelectorColor: Colors.lightBlue,
            shape: IndicatorShape.circle(size:12),
          ),
          floatingActionButton: SpeedDial(
            // both default to 16
            marginRight: 18,
            marginBottom: 20,
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 22.0),
            // this is ignored if animatedIcon is non null
            // child: Icon(Icons.add),
            visible: true,
            // If true user is forced to close dial manually
            // by tapping main button and overlay is not rendered.
            closeManually: false,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            onOpen: () => print('OPENING DIAL'),
            onClose: () => print('DIAL CLOSED'),
            tooltip: 'Speed Dial',
            heroTag: 'speed-dial-hero-tag',
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 8.0,
            shape: CircleBorder(),
            children: [
              SpeedDialChild(
                child: Icon(Icons.save),
                backgroundColor: Colors.blue,
                label: 'Save for later',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () => _saveForm(false),
              ),
              SpeedDialChild(
                child: Icon(Icons.save_alt),
                backgroundColor: Colors.blue,
                label: 'Finish',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () => _saveForm(true),
              ),
            ],
          ),

        )
    );
  }


  /**
   * Método que se ejecuta cuando el usuario presiona el back buttón o el botón
   * de atrás del AppBar
   */
  Future<bool> _onWillPop(){
    alertContinue= Alert(context: context,
      title: "Warning",
      desc: "Are you sure you want to leave? All progress made in this form will be lost.",
      buttons: [
        DialogButton(
          child: Text(
            "Accept",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: (){
            Navigator.pop(context);
            Navigator.pop(context);
          },
          color: Color.fromARGB(255, 48, 127, 226),
        ),
        DialogButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: Color.fromARGB(255, 255, 51, 51)),
      ],);

    return alertContinue.show() ?? false;
  }


  ///
  ///Método para guardar la ficha, hace validaciones y guarda la ficha como FINALIZADA
  ///
  Future _saveForm(bool isFinished) async{
    ProgressDialog waitingDialog=new ProgressDialog(this.context, ProgressDialogType.Normal);
    waitingDialog.setMessage("Saving Form");
    //waitingDialog.show();

    Alert errorAlert= Alert(
        type: AlertType.error,
        context: context,
        title: "Form Saving Error",
        desc: "There was an error trying to save the form. try again!"
    );

    List<String> validationErrors= _validateForm();

    if(isFinished == true && validationErrors.isNotEmpty){
      String errors= validationErrors.join("\n\n");
      Alert errorValidationAlert= Alert(
          type: AlertType.error,
          context: context,
          title: "Form Validation Error",
          desc: "There are some errors on these fields:\n\n $errors",
          style: AlertStyle(

              alertBorder: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.zero
              ),
              descStyle: TextStyle(

                fontSize: 15.5,
              )
          )
      );

      //waitingDialog.hide();
      errorValidationAlert.show();
      return;
    }

    Vivienda vivienda= Vivienda();
    vivienda.inspeccion_id= infoPage.bidController.text;
    vivienda.edad_construccion= int.tryParse(infoPage.bageController.text);
    vivienda.elevacion= double.tryParse(infoPage.elevationController.text);
    vivienda.sector= infoPage.sectorController.text;
    vivienda.direccion= infoPage.addressController.text;
    int viviendaId=  await vivienda.save();
    print("THIS NEW VIVIENDA: ${vivienda.toMap()}");
    if(viviendaId <=0){
      waitingDialog.hide();
      errorAlert.show();
      return;
    }

    Ficha ficha= Ficha();
    ficha.inspector= infoPage.inspectorController.text;
    ficha.fecha_inspeccion= infoPage.dateController.text;
    ficha.activo= true;
    ficha.estado= isFinished ? "Finalizada" : "Pendiente";
    ficha.ViviendaId= viviendaId;
    print("THIS NEW FICHA: ${ficha.toMap()}");
    int idFicha= await ficha.save();
    if(idFicha <=0){
      waitingDialog.hide();
      errorAlert.show();
      return;
    }

    for(int i=0;i < anexoPage.imagesUri.length; i++) {
      if (!anexoPage.imagesUri[i].contains("asset")) {
        String imagePath = anexoPage.imagesUri[i];
        Anexo anexo = new Anexo();
        switch (i) {
          case 0:
            anexo.tipo = "general";
            break;
          case 1:
          case 2:
          case 3:
            anexo.tipo = "specific";
            break;
          default:
            anexo.tipo = "appendix";
            break;
        }
        anexo.url_anexo = imagePath;
        anexo.FichaId = idFicha;
        print("THIS NEW ANEXO: ${anexo.toMap()}");
        int anexId= await anexo.save();
        if(anexId<=0){
          waitingDialog.hide();
          errorAlert.show();
          return;
        }
      }
    }

    for(Widget wid in secciones){
      if(wid.runtimeType == SeccionWidget){
        SeccionWidget secWidget=  wid as SeccionWidget;
        print("THIS SECTION: ${secWidget.seccion.nombre}");
        for(Widget wid_var in secWidget.variableWidgets){
          if(wid_var.runtimeType == VariableWidget) {
            VariableWidget varWidget = wid_var as VariableWidget;
            //if(varWidget.variable.obligatoria) {
            for (Widget wid_item in varWidget.itemWidgets) {
              if (wid_item.runtimeType == ItemWidget) {
                ItemWidget itemWidget = wid_item as ItemWidget;
                Respuesta res= new Respuesta();
                res.nota= itemWidget.noteController.text.isNotEmpty ? itemWidget.noteController.text : null;
                res.activo= true;
                res.ItemVariableId= itemWidget.item.id;
                res.FichaId= idFicha;

                //print("AIUUUUUUUUDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA :'V  ");

                print("${itemWidget.item.nombre} - ${itemWidget.item.tipo}");
                print("${itemWidget.item.tipo == "Texto" ? "ES TEXTO" : "" }");
                print("${itemWidget.item.tipo == "Texto" ? "This item ${itemWidget.item.id} with text ${itemWidget.textoController.text}" : ""}");

                if(itemWidget.item.tipo == "Texto"  && itemWidget.textoController.text.isNotEmpty){
                  int resId= await res.save();
                  if(resId<=0){
                    waitingDialog.hide();
                    errorAlert.show();
                    return;
                  }


                  Respuestatexto rest= new Respuestatexto();
                  rest.texto= itemWidget.textoController.text;
                  rest.RespuestaId= resId;
                  int restId= await rest.save();
                  if(restId <=0){
                    waitingDialog.hide();
                    errorAlert.show();
                    return;
                  }
                  print("THIS NEW RESPUESTA: ${res.toMap()}, ${rest.toMap()}");
                }
                else if(itemWidget.item.tipo == "OpSimple" && itemWidget.responsesMap.isNotEmpty){
                  int resId= await res.save();
                  if(resId<=0){
                    waitingDialog.hide();
                    errorAlert.show();
                    return;
                  }

                  int opId= itemWidget.responsesMap.values.toList()[0];
                  Respuestaopcionsimple resops= new Respuestaopcionsimple();
                  resops.RespuestaId= resId;
                  resops.OpcionId= opId;
                  int resopsId= await resops.save();
                  if(resopsId <=0){
                    waitingDialog.hide();
                    errorAlert.show();
                    return;
                  }
                  print("THIS NEW RESPUESTA: ${res.toMap()}, ${resops.toMap()}");
                }
                else if(itemWidget.item.tipo == "OpMultiple" && itemWidget.responsesMap.isNotEmpty){
                  int resId= await res.save();
                  if(resId<=0){
                    waitingDialog.hide();
                    errorAlert.show();
                    return;
                  }

                  int resopmId= await Respuestaopcionmultiple.withFields(resId, false).save();
                  itemWidget.responsesMap.forEach((label,opId) async{
                    Opcionrespuesta opres= new Opcionrespuesta();
                    opres.OpcionId= opId;
                    opres.RespuestaOpcionMultipleId= resopmId;
                    int opresId= await opres.save();
                    if(opresId <=0){
                      waitingDialog.hide();
                      errorAlert.show();
                      return;
                    }
                    print("THIS NEW RESPUESTA: ${res.toMap()}, ${opres.toMap()}");
                  });
                }
              }
            }
            //}
          }
        }
      }
    }

    waitingDialog.hide();
    Alert successAlert= new Alert(
        title: "Form saved",
        desc: "Your form with id $idFicha was successfuly saved",
        type: AlertType.success,
        context: context,
        buttons: [
          DialogButton(
            child: Text(
              "Close",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: (){
              Navigator.pop(context);
              Navigator.pop(context);
            },
            color: Color.fromARGB(255, 48, 127, 226),
          ),
        ],
        closeFunction: (){
          Navigator.pop(context);
        }
    );
    successAlert.show();
  }


  /**
   * Método que hace validaciones de la ficha, retorna una lista con strings
   * que muestran información de campos inválidos o que no han sido completados
   */
  List<String> _validateForm(){
    List<String> validationErrors= List<String>();

    //Validating Insepction fields
    for(TextEditingController cont in infoPage.textControllers){
      if(cont.text.isEmpty){
        if(cont == infoPage.dateController)
          validationErrors.add("Date field can't be empty");
        else if(cont == infoPage.sectorController)
          validationErrors.add("Sector field can't be empty");
        else if(cont == infoPage.bidController)
          validationErrors.add("Building ID field can't be empty");
        else if(cont == infoPage.inspectorController)
          validationErrors.add("Inspector field can't be empty");
      }
    }

    for(Widget wid in secciones){
      if(wid.runtimeType == SeccionWidget){
        SeccionWidget secWidget=  wid as SeccionWidget;
        for(Widget wid_var in secWidget.variableWidgets){
          if(wid_var.runtimeType == VariableWidget) {
            VariableWidget varWidget = wid_var as VariableWidget;
            if(varWidget.variable.obligatoria) {
              for (Widget wid_item in varWidget.itemWidgets) {
                if (wid_item.runtimeType == ItemWidget) {
                  ItemWidget itemWidget = wid_item as ItemWidget;
                  if(itemWidget.item.tipo == "Texto" && itemWidget.textoController.text.isEmpty){
                    validationErrors.add("Field ${itemWidget.item.nombre} from ${itemWidget.parentVar.nombre} can't be empty");
                  }
                  else if((itemWidget.item.tipo == "OpSimple" || itemWidget.item.tipo == "OpMultiple") &&
                      itemWidget.responsesMap.isEmpty){
                    validationErrors.add("You must select at least one option of field ${itemWidget.item.nombre} from ${itemWidget.parentVar.nombre}");
                  }
                }
              }
            }
          }
        }
      }
    }

    return validationErrors;
  }


}
