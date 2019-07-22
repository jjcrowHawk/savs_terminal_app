import 'package:flutter/material.dart';
import 'package:terminal_sismos_app/widgets/ItemWidget.dart';
import 'package:terminal_sismos_app/widgets/SeccionWidget.dart';
import 'package:page_indicator/page_indicator.dart';

class NuevaFichaPage extends StatefulWidget {

  @override
  _NuevaFichaPageState createState() => _NuevaFichaPageState();
}

class _NuevaFichaPageState extends State<NuevaFichaPage> {
  List<SeccionWidget> secciones= new List<SeccionWidget>();
  List<Widget> tabs_titles= new List<Widget>();
  final PageController pageController= new PageController();


  @override
  void initState() {
    super.initState();
    List<Widget> items= List<Widget>();
    items.add(ItemWidget("Number of stories", false));
    items.add(ItemWidget("Material", false));
    items.add(ItemWidget("Use", true));

    List<Widget> items2= items.toList();
    List<Widget> items3= items.toList();
    List<Widget> items4= items.toList();
    //items.add(ItemWidget("BLABLA", true));
    secciones.add(SeccionWidget("General Information", items));
    secciones.add(SeccionWidget("Structural System", items2));
    secciones.add(SeccionWidget("Irregularities", items3));
    secciones.add(SeccionWidget("Construction Quality", items4));

    secciones.forEach((seccion){
      List<String> tokens= seccion.title.split(" ");
      String title="";
      tokens.forEach((str) => title+= str.substring(0,3) + ". ");
      tabs_titles.add(Text(title));

    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title:new Text(''),
        ),
        body: PageIndicatorContainer(
              pageView: new PageView(
                scrollDirection: Axis.horizontal,
                children: secciones,
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
    /*return DefaultTabController(
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
    );*/
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

