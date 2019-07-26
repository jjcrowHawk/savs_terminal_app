import 'package:flutter/material.dart';
import 'package:terminal_sismos_app/db/models.dart';
import 'package:terminal_sismos_app/widgets/CasaInfoWidget.dart';
import 'package:terminal_sismos_app/widgets/ItemWidget.dart';
import 'package:terminal_sismos_app/widgets/SeccionWidget.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:terminal_sismos_app/widgets/VariableWidget.dart';
import 'package:terminal_sismos_app/utils/keyboard_avoider.dart';





class NuevaFichaPage extends StatefulWidget {

  @override
  _NuevaFichaPageState createState() => _NuevaFichaPageState();
}

class _NuevaFichaPageState extends State<NuevaFichaPage> {
  List<Widget> secciones= new List<Widget>();
  List<Widget> tabs_titles= new List<Widget>();
  final PageController pageController= new PageController();
  CasaInfoWidget infoPage;


  @override
  void initState() {
    super.initState();
    infoPage= new CasaInfoWidget(pageController);
    secciones.add(infoPage);

    Seccion().select().toList((listaSecciones) {
      List<Widget> pages=new List<Widget>();
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
                iWidgets.add(new ItemWidget(item,variable));
              });
            });
            vWidgets.add(VariableWidget(variable, iWidgets));
          });
        });
        pages.add(new SeccionWidget(seccion, vWidgets,this.pageController));
      });
      setState(() {
        secciones= pages;
      });
    });

  }

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
    return Scaffold(
        //resizeToAvoidBottomInset: false,
        //resizeToAvoidBottomPadding: true,
        appBar: new AppBar(
          title:new Text(''),
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
        )
    );
  }


}

/*class NuevaFichaPage extends StatelessWidget {
  List<SeccionWidget> secciones= new List<SeccionWidget>();
  List<Widget> tabs_titles= new List<Widget>();

  @override
  Widget build(BuildContext context) {
    List<Widget> items= List<Widget>();
    items.add(ItemWidget("Number of stories", false));
    items.add(ItemWidget("Material", false));
    items.add(ItemWidget("Use", true));
    items.add(ItemWidget("BLABLA", true));
    secciones.add(SeccionWidget("General Information", items));
    //secciones.add(SeccionWidget("Structural System", items));
    //secciones.add(SeccionWidget("Irregularities", items));
    secciones.add(SeccionWidget("Construction Quality", items));
    secciones.forEach((seccion) =>tabs_titles.add(Text(seccion.title)));

    return DefaultTabController(
        length: secciones.length,
        child: new Scaffold(
            appBar: new AppBar(
              bottom: TabBar(
                tabs: tabs_titles,
              ),
              title: new Text(''),
            ),
            body:TabBarView(
              children: secciones,
            )
        )
    );
  }
}*/

