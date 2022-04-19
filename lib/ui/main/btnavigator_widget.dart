import 'dart:async';
import 'dart:io';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hb_mobile2021/core/models/UserJson.dart';
import 'package:hb_mobile2021/core/services/HomePageService.dart';
import 'package:hb_mobile2021/core/services/UserService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/restart.dart';
import 'package:hb_mobile2021/ui/HomePage/HomePage.dart';
import 'package:hb_mobile2021/ui/HomePage/homeVBD.dart';
import 'package:hb_mobile2021/ui/HomePage/trangChu.dart';
import 'package:hb_mobile2021/ui/hoSoCV/index.dart';
import 'package:hb_mobile2021/ui/hoTro.dart';
import 'package:hb_mobile2021/ui/main/lich_canhan.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:hb_mobile2021/ui/vbden/vbden.dart';
import 'package:hb_mobile2021/ui/vbdi/index.dart';
import 'package:hb_mobile2021/ui/vbduthao/DuThao.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MenuRight.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BottomNavigator extends StatefulWidget {

  final String username;
  final int page;
  final String query;
  final String year;
  final int ID;
  final int IDDonVi;
  final index ;
  BottomNavigator({this.username, this.page,this.query,this.year, this.ID,
  this.index,this.IDDonVi});
  @override
  State<StatefulWidget> createState() {
    return BottomNavigatorState();
  }
}

class BottomNavigatorState extends State<BottomNavigator> {

  int _currentIndex  ;
  String _title = 'DEMO VGCA';
  String urlttVB = '';
  String tenUser = "";
  String chucvu = "";
  SharedPreferences sharedStorage;
  int  indexVBLeft ;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  Timer _timer;


  void _initializeTimer() {
    _timer = Timer.periodic(const Duration(minutes: 5), (_) {
      logOut(context);
      _timer.cancel();
    });

  }

  void _handleUserInteraction([_]) {
    // if (!_timer.isActive) {
    //   // This means the user has been logged out
    //   return;
    // }
    //
    // _timer.cancel();
    // _initializeTimer();
  }
  getTTVBDen() async {
    DateTime now = DateTime.now();
    String Yearvb = DateFormat('yyyy').format(now);

    var vbden = await getthongbao(Yearvb);
    var vbdi = await getthongbaoDi(Yearvb);
    var vbdt = await getthongbaoDT(Yearvb);


  }
  @override
  void initState() {
    super.initState();


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
        _currentIndex =  widget.page;
        urlttVB =  widget.query;

      }

    });}
   // getUserInfor();

  }

  @override
  void dispose() {
    super.dispose();


  }


  // getUserInfor() async {
  //   //String url = "http://apimobile.hoabinh.gov.vn/api/Home/GetUser";
  //   String url = "http://ApiMobile.ungdungtructuyen.vn/api/Home/GetUser";
  //   var parts = [];
  //   parts.add('TenDangNhap=' + widget.username);
  //   var formData = parts.join('&');
  //   var response = await http.get(
  //       url +"?" + formData
  //   );
  //   if (response.statusCode == 200) {
  //     var items = json.decode(response.body)['OData'];
  //     if (mounted) { setState(() {
  //       tenUser = items["Title"];
  //       chucvu = items["chucvuCurrentTitle"];
  //     });}
  //
  //     sharedStorage.setString("hotenUser", tenUser);
  //     sharedStorage.setString("chucvu", chucvu);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: body(),

      // bottomNavigationBar: FFNavigationBar(
      //   theme: FFNavigationBarTheme(
      //     barBackgroundColor: Colors.white,
      //     selectedItemBorderColor: Colors.yellow,
      //     selectedItemBackgroundColor: Colors.green,
      //     selectedItemIconColor: Colors.white,
      //     selectedItemLabelColor: Colors.black,
      //   ),
      //   selectedIndex: _currentIndex,
      //   onSelectTab:onTabTapped,
      //   items: [
      //     FFNavigationBarItem(
      //       iconData: Icons.home,
      //       label: 'Trang chủ',
      //     ),
      //     FFNavigationBarItem(
      //       iconData: Icons.library_books,
      //       label: 'Văn bản đến',
      //     ),
      //     FFNavigationBarItem(
      //       iconData: Icons.my_library_books_outlined,
      //       label: 'Văn bản đi',
      //     ),
      //     FFNavigationBarItem(
      //       iconData: Icons.collections_bookmark_outlined,
      //       label: 'Dự thảo/Phiếu trình',
      //     ),
      //     FFNavigationBarItem(
      //       iconData: Icons.collections_bookmark_sharp,
      //       label: 'Hồ sơ công việc',
      //     ),
      //     // FFNavigationBarItem(
      //     //   iconData: Icons.support_agent_outlined,
      //     //   label: 'Hỗ trợ',
      //     // ),
      //   ],
      // ),
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
            title: Text(
             "Trang chủ",
              style: TextStyle(fontWeight: FontWeight.normal,fontSize:10),
            ),
          ),
          BottomNavigationBarItem(
            icon:  new Image.asset("assets/icon/vbden.png",
                color: Colors.black,
                width: MediaQuery.of(context).size
                    .width * 0.045,
                height: MediaQuery.of(context).size.height *
                    0.025, fit: BoxFit.fill),
            title: Text(
             "TB Văn bản đến",
              style: TextStyle(fontWeight: FontWeight.normal,fontSize:10),
            ),
          ),
          BottomNavigationBarItem(
            icon: new Image.asset("assets/icon/vbdiApp.png",
                color: Colors.black,
                width: MediaQuery.of(context).size
                    .width * 0.045,
                height: MediaQuery.of(context).size.height *
                    0.025, fit: BoxFit.fill),
            title: Text(
              "TB Văn bản đi",
              style: TextStyle(fontWeight: FontWeight.normal,fontSize:10),
            ),
          ),
          BottomNavigationBarItem(
            icon: new Image.asset("assets/icon/duthaoApp.png",
                color: Colors.black,
                width: MediaQuery.of(context).size
                    .width * 0.045,
                height: MediaQuery.of(context).size.height *
                    0.025, fit: BoxFit.fill),
            title: Text(
              "TB Dự thảo/PT",
              style: TextStyle(fontWeight: FontWeight.normal,fontSize:10),
            ),
          ),
          BottomNavigationBarItem(
            icon: new Image.asset("assets/icon/hscvApp.png",
                color: Colors.black,
                width: MediaQuery.of(context).size
                    .width * 0.045,
                height: MediaQuery.of(context).size.height *
                    0.025, fit: BoxFit.fill),
            title: Text(
              "TB Hồ sơ CV",
              style: TextStyle(fontWeight: FontWeight.normal,fontSize:10),
            ),
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
      endDrawer: MenuRight(hoten: tenUser,chucvu: chucvu,),endDrawerEnableOpenDragGesture: false,
    );
  }

  Widget body() {


    switch (_currentIndex) {
      case 0:
        return WillPopScope(
            child:  trangChu(returnData: trangthaiVB, username: widget.username,nam:widget.year
            ),
            onWillPop:  () async {
              logOut(context);
              Navigator.pop(context, true);
            }

        );
        break;
      case 1:
        return WillPopScope(
          child: ListVBDen(urlttVB : urlttVB, val: indexVBLeft, username:
          widget.username,nam:widget.year),
          onWillPop:  () async {
            trangthaiVB("",0);
          }

        );
    break;
      case 2:

        return WillPopScope(
            child: VanBanDi(urlttVB : urlttVB, currentIndex: _currentIndex,
                username: widget.username,nam:widget.year),
            onWillPop:  () async {
              trangthaiVB("",0);
            }

        );
        break;
      case 3:
        return WillPopScope(
            child: DuThaoWidget(urlLoaiVB : urlttVB, val: _currentIndex, username: widget.username, pageindex:13,
                nam:widget.year),
            onWillPop:  () async {
              trangthaiVB("",0);
            }

        );
        break;
      case 4:
        return WillPopScope(
            child:  HSCVWidget(urlLoaiVB : urlttVB, val: _currentIndex,
                username: widget.username,nam:widget.year),
            onWillPop:  () async {
              trangthaiVB("",0);
            }

        );

        break;





    }
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
