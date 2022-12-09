
import 'dart:convert';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hb_mobile2021/core/services/HomePageService.dart';
import 'package:hb_mobile2021/ui/main/btnavigator_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class MenuChinh extends StatefulWidget {
  
final String year;
MenuChinh({required this.year});
  @override
  _MenuRightBN_DPState createState() => _MenuRightBN_DPState();
}

class _MenuRightBN_DPState extends State<MenuChinh> {

  final styleTitle =
  TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.w600, fontSize:
  12);
  List dataListVBDen = [];
  List dataListVBDi = [];
  List dataListVBDT = [];
  bool isLoadingVBD = false;
  bool isLoadingVBDT = false;
  bool isLoadingVBDi = false;
   int? tappedIndexVBD;
   int? tappedIndexVBDi;
   int? tappedIndexVBDT;

  ScrollController _sc = new ScrollController();

  @override
  void initState() {
   // _initializeTimer();
    super.initState();
    getHomeVBDen();
    getHomeVBDi();
    getHomeVBDT();
  }

  @override
  void dispose(){

    super.dispose();
  }
  getHomeVBDT() async {
    DateTime now = DateTime.now();
    String Yearvb = DateFormat('yyyy').format(now);
    isLoadingVBDT = true;
    var vbdt = await getVBDTHome( Yearvb);
    if(mounted){
      setState(() {
        isLoadingVBDT = false;
        dataListVBDT = json.decode(vbdt);
      });
    }

  }
  getHomeVBDi() async {
    DateTime now = DateTime.now();
    String Yearvb = DateFormat('yyyy').format(now);
    isLoadingVBDi = true;
    var vbdi = await getVBDiHome( Yearvb);

    if(mounted){
      setState(() {
        isLoadingVBDi = false;
        dataListVBDi = json.decode(vbdi);
   });
    }

  }
  getHomeVBDen() async {
    DateTime now = DateTime.now();
    String Yearvb = DateFormat('yyyy').format(now);
    isLoadingVBD = true;
    var vbden = await getVBDenHome(Yearvb);

    if(mounted){
      setState(() {
        isLoadingVBD = false;
        dataListVBDen = json.decode(vbden);

      });
    }

  }
  Widget MenuLeftData() {

    if (dataListVBDen== null|| dataListVBDen.length < 0 || isLoadingVBD) {
      //isLoading = !isLoading;
      return Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ));
    } else if (dataListVBDen.length == 0) {
      return Center(
        child: Container(),
      );}
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        //controller: _scrollController,
        itemCount: dataListVBDen == null ? 0 :dataListVBDen.length,
        itemBuilder: (context, index) {
          return
            Container(
              // height: MediaQuery.of(context).size.height,
              //margin: EdgeInsets.only(bottom: 10),
                color: tappedIndexVBD == index  ? Colors.blue : Colors.white,
                child:GetBodyMenuLeft(dataListVBDen[index]))

          ;
        }
    );

  }
  Widget MenuVBDi() {

    if (dataListVBDi== null|| dataListVBDi.length < 0 || isLoadingVBDi) {
      //isLoading = !isLoading;
      return Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ));
    } else if (dataListVBDi.length == 0) {
      return Center(
        child: Container(),
      );}
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        //controller: _scrollController,
        itemCount: dataListVBDi == null ? 0 :dataListVBDi.length,
        itemBuilder: (context, index) {
          return
            Container(
              // height: MediaQuery.of(context).size.height,
              //margin: EdgeInsets.only(bottom: 10),
                color: tappedIndexVBDi == index  ? Colors.blue : Colors.white,
                child:GetBodyMenuVBDi(dataListVBDi[index]))

          ;
        }
    );

  }
  Widget MenuVBDT() {

    if (dataListVBDT== null|| dataListVBDT.length < 0 || isLoadingVBDT) {
      //isLoading = !isLoading;
      return Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ));
    } else if (dataListVBDT.length == 0) {
      return Center(
        child: Container(),
      );}
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        //controller: _scrollController,
        itemCount: dataListVBDT == null ? 0 :dataListVBDT.length,
        itemBuilder: (context, index) {
          return
            Container(
              // height: MediaQuery.of(context).size.height,
              //margin: EdgeInsets.only(bottom: 10),
                color: tappedIndexVBDT == index  ? Colors.blue : Colors.white,
                child:GetBodyMenuVBDDT(dataListVBDT[index]))

          ;
        }
    );

  }


  Widget GetBodyMenuVBDDT(item) {
    var title = item['Title'];
    var query=  item['query'];
    var IDVBDT=  item['ID'];
    var count = item['Count'] ?? 0;
    return Card(child:ListTile(
        title: Text(
          title,
          maxLines: 2,
        ),
       // leading: Image(image: AssetImage('assets/logo_vb.png')),
        trailing: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.09,
          height: MediaQuery.of(context).size.height * 0.05,
          //padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueGrey[100]!,width: 1),
            borderRadius: BorderRadius.circular(7),
            color: Colors.blueAccent,
          ),

          child: new Text(count.toString(), style: new TextStyle(color:
          Colors.white, fontSize: 11.0)),
        ),
        onTap: () {
          // checker = true;
          // if (mounted) {setState(()   {
          //   //print(dataListVBDen) ;
          //   for( int i= 0 ; i< dataListVBDT.length; i++)
          //   {
          //       tappedIndexVBDT=i  ;
          //
          //       print(tappedIndexVBDT);
          //
          //   }
          //
          //
          // });}

          //  GetDetailMenuLeft(widget.page,query, widget.year);

          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              BottomNavigator(page: 3,username:'' ,index: 0,
                  query : query,year: widget.year,ID :ID )), (Route<dynamic>
          route)
          => false);

          //Navigator.pop(context);
        }
    ));
  }
  Widget GetBodyMenuLeft(item) {
    var title = item['Title'];
    var query=  item['query'];
    var IDVBD=  item['ID'];
    var count = item['Count'] ?? 0;
    return Card(child: ListTile(
        title: Text(
          title,
          maxLines: 2,
        ),
        // leading: Image(image: AssetImage('assets/logo_vb.png')),
        trailing: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.09,
          height: MediaQuery.of(context).size.height * 0.05,
          //padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueGrey[100]!,width: 1),
            borderRadius: BorderRadius.circular(7),
            color: Colors.blueAccent,
          ),
          child: new Text(count.toString(), style: new TextStyle(color:
          Colors.white, fontSize: 11.0)),
        ),
        onTap: () {


          // checker = true;
          // if (mounted) {setState(()   {
          //   //print(dataListVBDen) ;
          //   for( int i= 0 ; i< dataListVBDen.length; i++)
          //   {
          //       tappedIndexVBD = i;
          //   }
          //
          //
          // });}

          //  GetDetailMenuLeft(widget.page,query, widget.year);

          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              BottomNavigator(page: 1,username: '',index: 0,
                  query : query,year: widget.year,ID :ID )), (Route<dynamic>
          route)
          => false);

          //Navigator.pop(context);
        }
    ),);
  }
  Widget GetBodyMenuVBDi(item) {
    var title = item['Title'];
    var query=  item['query'];
    var IDVDi=  item['ID'];
    var count = item['Count'] ?? 0;
    return Card(child:ListTile(
        title: Text(
          title,
          maxLines: 2,
        ),
        //leading: Image(image: AssetImage('assets/logo_vb.png')),
        trailing: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width* 0.09,
          height: MediaQuery.of(context).size.height * 0.05,
          //padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueGrey[100]!,width: 1),
            borderRadius: BorderRadius.circular(7),
            color: Colors.blueAccent,
          ),
          child: new Text(count.toString(), style: new TextStyle(color:
          Colors.white, fontSize:11.0)),
        ),
        onTap: () {
          // checker = true;
          // if (mounted) {setState(()   {
          //   //print(dataListVBDen) ;
          //   for( int i= 0 ; i< dataListVBDi.length; i++)
          //   {
          //       tappedIndexVBDi = i;
          //   }
          //
          //
          // });}

          //  GetDetailMenuLeft(widget.page,query, widget.year);

          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              BottomNavigator(page: 2,username: '',index: 0,
                  query : query,year: widget.year,ID :ID )), (Route<dynamic>
          route)
          => false);

          //Navigator.pop(context);
        }
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors
            .white, //This will change the drawer background to blue.
        //other styles
      ),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          // Container(
          //   color: Colors.white12,
          //   alignment: Alignment.center,
          //   height: MediaQuery.of(context).size.height / 8,
          //   child: DrawerHeader(
          //       child: Container(
          //         child: Text(
          //           "Menu trang chủ".toUpperCase(),
          //           style: TextStyle(
          //             fontSize: 20,
          //           ),
          //         ),
          //       )),
          // ),


          SizedBox(
            width: 10,
          ),

          Container(
            color: Color(0xff2196F3),
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height / 20,
            width: MediaQuery.of(context).size.width ,
            child: Text(
              "Văn bản đến".toUpperCase(),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight
                  .w600, fontSize:
              16),
            ),
          ),

          MenuLeftData(),
          Container(
            color: Color(0xff2196F3),
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height / 20,
            width: MediaQuery.of(context).size.width ,
            child: Text(
              "Văn bản đi".toUpperCase(),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight
                  .w600, fontSize:
              16),
            ),
          ),
          MenuVBDi(),
          Container(
            color: Color(0xff2196F3),
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height / 20,
            width: MediaQuery.of(context).size.width ,
            child: Text(
              "Văn bản dự thảo".toUpperCase(),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight
                  .w600, fontSize:
              16),
            ),
          ),
          MenuVBDT(),
        ],
      ),

    );
  }

}

class CustomIcon extends StatelessWidget {
  final IconData icons;
  final Color bgiconColor;

  CustomIcon({required this.icons, required this.bgiconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 25,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 5),
          color: bgiconColor != null ? bgiconColor : Colors.white,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: FaIcon(icons, size: 15, color: Colors.blue[900]),
        ));
  }
}


