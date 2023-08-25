import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hb_mobile2021/core/services/HomePageService.dart';
import 'package:hb_mobile2021/ui/HomePage/trangChu.dart';
import 'package:hb_mobile2021/ui/hoSoCV/index.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:hb_mobile2021/ui/vbden/vbden.dart';
import 'package:hb_mobile2021/ui/vbdi/index.dart';
import 'package:hb_mobile2021/ui/vbduthao/DuThao.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MenuRight.dart';
import 'package:http/http.dart' as http;

class BottomNavigator extends StatefulWidget {

  final String? username;
  final int? page;
  final String? query;
  final String? year;
  final int? ID;

  final index ;
  BottomNavigator({ this.username,  this.page, this.query, this.year,  this.ID,
  this.index});
  @override
  State<StatefulWidget> createState() {
    return BottomNavigatorState();
  }
}

class BottomNavigatorState extends State<BottomNavigator> {

  late int _currentIndex  ;
  String _title = 'DEMO VGCA';
  String urlttVB = '';
  String tenUser = "";
  String chucvu = "";
  late SharedPreferences sharedStorage;
  DateTime now = DateTime.now();
  String namVB = '2023';



  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  getTTVBDen() async {
    DateTime now = DateTime.now();
    String Yearvb = DateFormat('yyyy').format(now);




  }
  @override
  void initState() {
    super.initState();
    setState(() {
      if(widget.year == null || widget.year == ""){
        DateTime now = DateTime.now();
        String Yearvb = DateFormat('yyyy').format(now);
        namVB  =  Yearvb;
      }

      else{
        namVB = widget.year!;
      }

    });

    EasyLoading.dismiss();
    //getUserInfor();
    _currentIndex = 0;
// if(widget.IDDonVi != null && widget.IDDonVi != ""){
//   GetInfoUser(widget.username);
// }
    if (mounted) {setState(() {
      if(widget.page == null ){


      }
      else{
        _currentIndex =  widget.page!;
        urlttVB =  widget.query!;

      }

    });}
   // getUserInfor();

  }

  @override
  void dispose() {
    super.dispose();


  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: body(),


      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon:  new Image.asset("assets/icon/trangtruApp.png",
                color: Colors.black,
                width: MediaQuery.of(context).size
                    .width * 0.045,
                height: MediaQuery.of(context).size.height *
                    0.025, fit: BoxFit.fill),
            label:
            "Trang chủ",
            // title: Text(
            //  "Trang chủ",
            //   style: TextStyle(fontWeight: FontWeight.normal,fontSize:10),
            // ),
          ),
          BottomNavigationBarItem(
            icon:  new Image.asset("assets/icon/vbden.png",
                color: Colors.black,
                width: MediaQuery.of(context).size
                    .width * 0.045,
                height: MediaQuery.of(context).size.height *
                    0.025, fit: BoxFit.fill),
            label:
            "TB Văn bản đến",
            // title: Text(
            //  "TB Văn bản đến",
            //   style: TextStyle(fontWeight: FontWeight.normal,fontSize:10),
            // ),
          ),
          BottomNavigationBarItem(
            icon: new Image.asset("assets/icon/vbdiApp.png",
                color: Colors.black,
                width: MediaQuery.of(context).size
                    .width * 0.045,
                height: MediaQuery.of(context).size.height *
                    0.025, fit: BoxFit.fill),
            label: "TB Văn bản đi",
            // title: Text(
            //   "TB Văn bản đi",
            //   style: TextStyle(fontWeight: FontWeight.normal,fontSize:10),
            // ),
          ),
          BottomNavigationBarItem(
            icon: new Image.asset("assets/icon/duthaoApp.png",
                color: Colors.black,
                width: MediaQuery.of(context).size
                    .width * 0.045,
                height: MediaQuery.of(context).size.height *
                    0.025, fit: BoxFit.fill),
            label: "TB Dự thảo/PT",
            // title: Text(
            //   "TB Dự thảo/PT",
            //   style: TextStyle(fontWeight: FontWeight.normal,fontSize:10),
            // ),
          ),
          BottomNavigationBarItem(
            icon: new Image.asset("assets/icon/hscvApp.png",
                color: Colors.black,
                width: MediaQuery.of(context).size
                    .width * 0.045,
                height: MediaQuery.of(context).size.height *
                    0.025, fit: BoxFit.fill),
            label:"TB Hồ sơ CV" ,
            // title: Text(
            //   "TB Hồ sơ CV",
            //   style: TextStyle(fontWeight: FontWeight.normal,fontSize:10),
            // ),
          )
          // new BottomNavigationBarItem(
          //   icon:    new Image.asset("assets/icon/trangtruApp.png",
          //       color: Colors.black,
          //       width: MediaQuery.of(context).size
          //           .width * 0.045,
          //       height: MediaQuery.of(context).size.height *
          //           0.025, fit: BoxFit.fill),
          //   label: 'Trang chủ',
          // ),
          // new BottomNavigationBarItem(
          //   icon: new Image.asset("assets/icon/vbden.png",
          //       color: Colors.black,
          //       width: MediaQuery.of(context).size
          //           .width * 0.045,
          //       height: MediaQuery.of(context).size.height *
          //           0.025, fit: BoxFit.fill),
          //   label: 'TB Văn bản đến',
          // ),
          // new BottomNavigationBarItem(
          //   icon: new Image.asset("assets/icon/vbdiApp.png",
          //       color: Colors.black,
          //       width: MediaQuery.of(context).size
          //           .width * 0.045,
          //       height: MediaQuery.of(context).size.height *
          //           0.025, fit: BoxFit.fill),
          //   label: 'TB Văn bản đi',
          // ),
          // new BottomNavigationBarItem(
          //   icon: new Image.asset("assets/icon/duthaoApp.png",
          //       color: Colors.black,
          //       width: MediaQuery.of(context).size
          //           .width * 0.045,
          //       height: MediaQuery.of(context).size.height *
          //           0.025, fit: BoxFit.fill),
          //   label:'TB Dự thảo/PT',
          // ),
          // new BottomNavigationBarItem(
          //   icon: new Image.asset("assets/icon/hscvApp.png",
          //       color: Colors.black,
          //       width: MediaQuery.of(context).size
          //           .width * 0.045,
          //       height: MediaQuery.of(context).size.height *
          //           0.025, fit: BoxFit.fill),
          //   label: 'TB Hồ sơ CV',
          // ),
          // new BottomNavigationBarItem(
          //   icon: new Icon(Icons.support_agent_outlined,color: Colors.red,),
          //   title: new Text('Hỗ trợ',style: TextStyle(color: Colors.red),),
          // ),


        ],
      ),
      endDrawer: MenuRight(hoten: tenUser,chucvu: chucvu, users: '',),endDrawerEnableOpenDragGesture: false,
    );
  }

  Widget? body() {


    switch (_currentIndex) {
      case 0:
        return WillPopScope(
            child:  trangChu(returnData: trangthaiVB, username: widget.username!,nam:namVB
            ),
            onWillPop:  () async {
              logOut(context);
              Navigator.pop(context, true);return true;
            }

        );
        break;
      case 1:
        return WillPopScope(
          child: ListVBDen(urlttVB : urlttVB, username:
          widget.username!,nam:namVB, ),
          onWillPop:  () async {
            trangthaiVB("",0);
            return false;
          }

        );
    break;
      case 2:

        return WillPopScope(
            child: VanBanDi(urlttVB : urlttVB, currentIndex: _currentIndex,
                username: widget.username!,nam:namVB, ),
            onWillPop:  () async {
              trangthaiVB("",0);return true;
            }

        );
        break;
      case 3:
        return WillPopScope(
            child: DuThaoWidget(urlLoaiVB : urlttVB, val: _currentIndex, username: widget.username!, pageindex:13,
                nam:namVB),
            onWillPop:  () async {
              trangthaiVB("",0);return true;
            }

        );
        break;
      case 4:
        return WillPopScope(
            child:  HSCVWidget(urlLoaiVB : urlttVB, val: _currentIndex,
                username: widget.username!,nam:namVB,),
            onWillPop:  () async {
              trangthaiVB("",0);return true;
            }

        );

        break;


    }  return null;
  }

  void trangthaiVB(String ttvb,  int index){
    if (mounted) { setState(() {
      urlttVB = ttvb;
      _currentIndex = index;
    });}

  }



  void onTabTapped(int index) {
    if (mounted) {setState(() {

      _currentIndex = index;

    });}

  }
}
