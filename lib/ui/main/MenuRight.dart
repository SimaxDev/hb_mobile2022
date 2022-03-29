import 'dart:async';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hb_mobile2021/CauHinhChuKySo/ListKySo.dart';
import 'package:hb_mobile2021/CauHinhChuKySo/SignaturePicker.dart';
import 'package:hb_mobile2021/core/models/UserJson.dart';
import 'package:hb_mobile2021/core/services/UserService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/ui/Login/Login.dart';
import 'package:hb_mobile2021/ui/User/ThongTinUser.dart';
import 'package:hb_mobile2021/ui/User/Edit_pass.dart';
import 'package:hb_mobile2021/ui/main/btnavigator_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'shared.dart';

class MenuRight extends StatefulWidget {
  String users;
  String tendangnhap;
  String hoten;
  String chucvu;

  MenuRight({this.hoten, this.chucvu, this.users});

  @override
  _MenuRightState createState() => _MenuRightState();
}

class _MenuRightState extends State<MenuRight> {
  var tendangnhap;
  Timer _timer;
  List lstThongTinLConfig = [];

  void _initializeTimer() {
    _timer = Timer.periodic(const Duration(minutes: 5), (_) {
      logOut(context);
      _timer.cancel();
    });
  }

  void _handleUserInteraction([_]) {
    if (!_timer.isActive) {
      // This means the user has been logged out
      return;
    }

    _timer.cancel();
    _initializeTimer();
  }

  @override
  void initState() {
    super.initState();
    _initializeTimer();
    if (widget.hoten == null) {
      widget.hoten = "";
    }
    if (widget.chucvu == null) {
      widget.chucvu = "";
    }
    if (widget.users == null) {
      widget.users = "";
    }
  }

  GetInfoUser(String TenDangNhap, donvi) async {
    sharedStorage = await SharedPreferences.getInstance();
    if (sharedStorage != null) {
      // isLoading = false;
      var item = await GetInfoUserServicedoNVi(TenDangNhap, donvi);
      setState(() {
        tenPhongBan = item['CurrentTenPhongBan'] != null
            ? item['CurrentTenPhongBan']
            : "";
        CurrentTenDonVi =
            item['CurrentTenDonVi'] != null ? item['CurrentTenDonVi'] : "";
        OrganName = item['OrganName'] != null ? item['OrganName'] : "";
        notIsQuanTriNew =
            item['notIsQuanTriNew'] != null ? item['notIsQuanTriNew'] : false;
        isQTNew = item['isQTNew'] != null ? item['isQTNew'] : false;
        ThemMoiVanBanDuThao = item['ListPermissions']['ThemMoiVanBanDuThao'] != null
            ? item['ListPermissions']['ThemMoiVanBanDuThao']
            : false;
        lstThongTinGroup =
            item['lstThongTinGroup'] != null ? item['lstThongTinGroup'] : [];
        EmailHT = item['userEmail'] != null ? item['userEmail'] : "";
        Telephone =
            item['userDienThoaiDD'] != null ? item['userDienThoaiDD'] : "";
        userGroups = item['userGroups'] != null ? item['userGroups'] : [];
        // tenPhongBan =  item['CurrentTenPhongBan'];
        butPheVBD = item['ListPermissions'] != null &&
                item['ListPermissions']['ButPheVanBan'] != null
            ? item['ListPermissions']['ButPheVanBan']
            : false;
        groupID = item['groupID'] != null ? item['groupID'] : 0;
        lstPhongBanLaVanThuVBDI = item['lstPhongBanLaVanThuVBDI'];
        lstPhongBanLaVanThuVBDEN = item['lstPhongBanLaVanThuVBDEN'];
        SiteAction = item['SiteAction'] != null ? item['SiteAction'] : "";

        if (item['ListPermissions'] != null &&
            item['ListPermissions'].length > 0) {
          ThemMoiVanBanDi = item['ListPermissions']['ThemMoiVanBanDi'] != null
              ? item['ListPermissions']['ThemMoiVanBanDi']
              : false;
          ThemVanBanDen = item['ListPermissions']['ThemVanBanDen'] != null
              ? item['ListPermissions']['ThemVanBanDen']
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
        }

        userTenTruyCap =
            item['userTenTruyCap'] != null ? item['userTenTruyCap'] : "";
        CurrentDonViID =
            item['CurrentDonVi'] == null ? 0 : item['CurrentDonVi']['LookupId'];
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
          if (i['configType'] == 'pGuiXuLyChinh') {
            ispGuiXuLyChinh = true;
          }
        }

        userChucVu = item['userChucVu'].length > 0 &&
                item['userChucVu'][0]['LookupValue'] != null
            ? item['userChucVu'][0]['LookupValue']
            : "";
        //user = UserJson.fromJson(item);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    BottomNavigator(username: widget.users, IDDonVi: donvi)),
            (Route<dynamic> route) => false);
      });

      // user = jsonToUserJson(item);
      //
      //
      // sharedStorage.setString("hoten", user.Title);
      // sharedStorage.setString("chucvu", user.ChucVu);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void XuLyUserGroups() {}

  GetInfoUserDonVi(int id) async {
    // tendangnhap = sharedStorage.getString("username");
    //
    // if (sharedStorage != null) {
    var item = await GetInfoUserServicedoNVi(widget.users, id);

    // }
  }

  Widget MenuVBDT() {
    // if (userGroups== null|| userGroups.length < 0 ) {
    //   //isLoading = !isLoading;
    //   return Center(
    //       child: CircularProgressIndicator(
    //         valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
    //       ));
    // } else
    if (lstThongTinGroup.length == 0) {
      return Center(
        child: Container(),
      );
    }
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        //controller: _scrollController,
        itemCount: lstThongTinGroup == null ? 0 : lstThongTinGroup.length,
        itemBuilder: (context, index) {
          return Container(
              //margin: EdgeInsets.only(bottom: 10),
              color: Colors.white,
              child: GetBodyMenuVBDDT(lstThongTinGroup[index]));
        });
  }

  Widget GetBodyMenuVBDDT(item) {
    var title = item['TenGroup'] != null ? item['TenGroup'] : "";
    int IDVBDT = item['IDGroup'] != null ? item['IDGroup'] : 0;
    return OrganName == title
        ? Container()
        : ListTile(
            title: Text(
              "+ " + title,
              maxLines: 2,
              style: TextStyle(color: Colors.lightBlue, fontSize: 13),
            ),
            onTap: () {
              // setState(() {
              // GetInfoUserDonVi(IDVBDT);

              GetInfoUser(widget.users, IDVBDT);

              EasyLoading.show();
              //Navigator.pop(context);
            });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleUserInteraction,
      onPanDown: _handleUserInteraction,
      onScaleStart: _handleUserInteraction,
      child: new Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 25.0, left: 5.0),
              color: Colors.blue,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // Material(
                  //   borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  //   elevation: 10,
                  //   child: Padding(padding: EdgeInsets.all(9.0),
                  //     child: Image.asset("assets/logo-user.jpg", height: 85, width: 85),
                  //   ),
                  // ),
                  Container(
                    margin: EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.13,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: new AssetImage("assets/logo-user.jpg"),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      widget.hoten,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              MediaQuery.of(context).textScaleFactor == 2.0
                                  ? MediaQuery.of(context).textScaleFactor * 4
                                  : 20),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      widget.chucvu,
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
            lstThongTinGroup.length > 1
                ? Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Text(
                          OrganName,
                          style: TextStyle(
                            color: Colors.black, fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            // decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 10, left: 10),
                            child: new Text(
                              "- Chọn đơn vị khác để làm việc:",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin:
                                EdgeInsets.only(top: 0, left: 10, right: 10),
                            width: MediaQuery.of(context).size.width,
                            child: MenuVBDT(),
                          ),
                        ],
                      ),
                    ],
                  )
                : Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Text(
                      OrganName,
                      style: TextStyle(
                        color: Colors.black, fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        // decoration: TextDecoration.underline,
                      ),
                    ),
                  ),

            ListTile(
              title: new Text('Thông tin cá nhân'),
              trailing: new IconButton(
                icon: new Icon(Icons.supervised_user_circle_sharp),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ThongtinUser(username: widget.users),
                    ));
              },
            ),

            // ListTile(
            //   title: new Text('Tạo chữ ký'),
            //   // trailing: new Icon(Icons.exit_to_app),
            //   trailing: new IconButton(
            //     icon: new Icon(Icons.create_outlined),
            //   ),
            //   onTap: (){
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => QuanLyChuKy(),
            //         ));
            //   },
            // ),
            // new ListTile(
            //   title: new Text('Tạo chữ bằng hình ảnh'),
            //   // trailing: new Icon(Icons.exit_to_app),
            //   trailing: new IconButton(
            //     icon: new Icon(Icons.analytics_outlined),
            //   ),
            //   onTap: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => SignaturePicker(
            //             title: 'Thêm chữ ký',
            //           ), /*   AddImage(title: "Ảnh chữ ký",),*/
            //         ));
            //   },
            // ),
            ListTile(
              title: new Text('Đổi mật khẩu'),
              trailing: new IconButton(
                icon: new Icon(Icons.lock_outline_rounded),
              ),
              onTap: () {
                var tendangnhap1 = ten;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditPassWord(tendangnhap: widget.users),
                    ));
              },
            ),
            ListTile(
              title: new Text('Đăng xuất'),
              trailing: new IconButton(
                icon: new Icon(Icons.exit_to_app),
              ),
              onTap: () async {
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (BuildContext ctx) => LoginWidget()));
                logOut(context);
                Navigator.pop(context, true);
              },
            ),
          ],
        ),
      ),
    );
  }
}
