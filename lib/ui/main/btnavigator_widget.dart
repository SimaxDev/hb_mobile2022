import 'dart:async';
import 'dart:io';
import 'package:hb_mobile2021/core/models/UserJson.dart';
import 'package:hb_mobile2021/core/services/UserService.dart';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
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

  List lstThongTinLConfig = [];

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  getTTVBDen() async {
    DateTime now = DateTime.now();
    String Yearvb = DateFormat('yyyy').format(now);




  }
  @override
  void initState() {
    super.initState();
    GetYear();
   // GetInfoUserNew();
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
        if (widget.query != null) {
          urlttVB =  widget.query!;
        }


      }

    });}
   // getUserInfor();

  }

  @override
  void dispose() {
    super.dispose();


  }

  GetInfoUserNew() async {
    sharedStorage = await SharedPreferences.getInstance();
    sharedStorage.getString("username");
    String  tenUser = "";
    if( tenUser  == ""){
      String?  tenUser=  sharedStorage.getString("username");
    }
    await GetInfoUser(tenUser);
    if (mounted) {
      setState(() {
        user!.Title = sharedStorage.getString("hoten")!;
        user!.ChucVu = sharedStorage.getString("chucvu")!;
      });
    }
  }
  GetInfoUser(String TenDangNhap) async {
    sharedStorage = await SharedPreferences.getInstance();
    if (sharedStorage != null) {
     // isLoading = false;

      if( TenDangNhap  == ""){
        TenDangNhap =  sharedStorage.getString("username")!;
      }
      var item = await GetInfoUserService(TenDangNhap);


      // if(item == null){
      //   {
      //     showAlertDialog(context, "Tài khoản hoặc mật khẩu không đúng");
      //   }
      // }
      tenPhongBan =
      item['CurrentTenPhongBan'] != null ? item['CurrentTenPhongBan'] : "";
      CurrentTenDonVi =
      item['CurrentTenDonVi'] != null ? item['CurrentTenDonVi'] : "";
      OrganName = item['OrganName'] != null ? item['OrganName'] : "";
      notIsQuanTriNew =
      item['notIsQuanTriNew'] != null ? item['notIsQuanTriNew'] : false;
      isQTNew = item['isQTNew'] != null ? item['isQTNew'] : false;
      lstThongTinGroup =
      item['lstThongTinGroup'] != null ? item['lstThongTinGroup'] : [];
      EmailHT = item['userEmail'] != null ? item['userEmail'] : "";
      Telephone =
      item['userDienThoaiDD'] != null ? item['userDienThoaiDD'] : "";
      userGroups = item['userGroups'] != null ? item['userGroups'] : [];
      butPheVBD = item['ListPermissions'] != null &&
          item['ListPermissions']['ButPheVanBan'] != null
          ? item['ListPermissions']['ButPheVanBan']
          : false;
      groupID = item['groupID'] != null ? item['groupID'] : 0;
      lstPhongBanLaVanThuVBDI = item['lstPhongBanLaVanThuVBDI'].length> 0
          ?item['lstPhongBanLaVanThuVBDI']:[] ;
      lstPhongBanLaVanThuVBDEN = item['lstPhongBanLaVanThuVBDEN'].length >
          0 ? item['lstPhongBanLaVanThuVBDEN']: [];
      SiteAction = item['SiteAction'] != null ? item['SiteAction'] : "";

      if (item['ListPermissions'] != null &&
          item['ListPermissions'].length > 0) {
        ThemMoiVanBanDi = item['ListPermissions']['ThemMoiVanBanDi'] != null
            ? item['ListPermissions']['ThemMoiVanBanDi']
            : false;
        ThemVanBanDen = item['ListPermissions']['ThemVanBanDen'] != null
            ? item['ListPermissions']['ThemVanBanDen']
            : false;
        ThemMoiVanBanDuThao = item['ListPermissions']['ThemMoiVanBanDuThao'] != null
            ? item['ListPermissions']['ThemMoiVanBanDuThao']
            : false;
        ThietLapHoiBao = item['ListPermissions']['ThietLapHoiBao'] != null
            ? item['ListPermissions']['ThietLapHoiBao']
            : false;
        CapSoVanBanDi = item['ListPermissions']['CapSoVanBanDi'] != null
            ? item['ListPermissions']['CapSoVanBanDi']
            : false;
        hanXLVBD = item['ListPermissions']['GuiVanBanD'] != null
            ? item['ListPermissions']['GuiVanBanD']
            : false;
        GuiVanBanDi = item['ListPermissions']['GuiVanBanDi'] != null
            ? item['ListPermissions']['GuiVanBanDi']
            : false;
        SuaVanBanDen = item['ListPermissions']['SuaVanBanDen'] != null
            ? item['ListPermissions']['SuaVanBanDen']
            : false;
        GuiVanBan = item['ListPermissions']['GuiVanBan'] != null
            ? item['ListPermissions']['GuiVanBan']
            : false;
        imageCK =item['ListFileAttach'].length >0 &&item['ListFileAttach']!=
            null  &&
            item['ListFileAttach'][0]['Url'] != null
            ? item['ListFileAttach'][0]['Url']
            : "";
        widthKy =item['SignatureWidth']!= null
            ? item['SignatureWidth'].toDouble()
            : 150.0;
        heightKy =item['SignatureHeight']!= null
            ? item['SignatureHeight'].toDouble()
            : 75.0;
      }

      userTenTruyCap =
      item['userTenTruyCap'] != null ? item['userTenTruyCap'] : "";
      CurrentDonViID =
      item['CurrentDonVi'] == null ? 0 : item['CurrentDonVi']['LookupId'];
      ThongTinLConfig =
      item['lstThongTinLConfig'] != null ? item['lstThongTinLConfig'] : [];
      DonViInSiteID =
      item['DonViInSite'] == null ? 0 : item['DonViInSite']['LookupId'];

      ID = item['ID'];
      currentUserID = ID;
      userHasQuyenKyVB = item['lstPBHasVanBan'];

      lstThongTinLConfig = item['lstThongTinLConfig'] != null &&
          item['lstThongTinLConfig'].length > 0
          ? item['lstThongTinLConfig']
          : [];
      for (var i in lstThongTinLConfig) {
        if (i['configType'] == "pGuiXuLyChinh") {
          ispGuiXuLyChinh = true;
        }
      }

      userChucVu = item['userChucVu'].length > 0 &&
          item['userChucVu'][0]['LookupValue'] != null
          ? item['userChucVu'][0]['LookupValue']
          : "";
      user = UserJson.fromJson(item);

      sharedStorage.setString("hoten", user!.Title);
      sharedStorage.setString("chucvu", user!.ChucVu);
    }


  }


  GetYear() async {
    sharedStorage = await SharedPreferences.getInstance();
    var item = await GetYears();
    setState(() {
      if(item != null)
      sharedStorage.setStringList("lstYear", item);
    });


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
