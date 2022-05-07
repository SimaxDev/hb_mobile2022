import 'dart:async';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hb_mobile2021/common/VBDen/GiaoViec.dart';
import 'package:hb_mobile2021/core/services/HomePageService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/core/services/hoSoCVService.dart';
//import 'package:hb_mobile2021/notification_local_api.dart';
import 'package:hb_mobile2021/restart.dart';
import 'package:hb_mobile2021/ui/HomePage/homeHSCV.dart';
import 'package:hb_mobile2021/ui/HomePage/homeVBD.dart';
import 'package:hb_mobile2021/ui/HomePage/homeVBDT.dart';
import 'package:hb_mobile2021/ui/HomePage/homeVBDi.dart';
import 'package:hb_mobile2021/ui/hoTro.dart';
import 'package:hb_mobile2021/ui/main/lich_canhan.dart';
import 'package:hb_mobile2021/ui/main/menu_chinh.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hb_mobile2021/core/models/UserJson.dart';
import 'package:hb_mobile2021/core/services/UserService.dart';
import 'package:hb_mobile2021/ui/main/MenuRight.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:badges/badges.dart';

class trangChu extends StatefulWidget {
  final returnData;
  final String username;
  final String nam;

  trangChu({Key key, this.returnData, this.username, this.nam})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PageState();
  }
}

class PageState extends State<trangChu> {
  //properties
  List dataListVBDi = [];
  List dataListVBDen = [];
  List dataListVBDT = [];
  bool isLoading = false;
  SharedPreferences sharedStorage;
  String ActionXL = "GetListHSCV";
  List HoSoList = [];
  List HoSoList1 = [];
  List HoSoList2 = [];
  int ThongbaoD = 0;
  int ThongbaoDi = 0;
  int ThongbaoDT = 0;
  // lấy năm hiện tại
  String tenDN = "";
  String queryDXL = "";
  String queryDHT = "";
  String queryDTV = "";
  int indexTT = 4;
  int tong = 0;
  int tong1 = 0;

  int tong2 = 0;
  DateTime now = DateTime.now();

  int yeara = 0;
  var tabStyleWhile = TextStyle(
      fontSize: 14,
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal);
  var tabStyleBlackIT = TextStyle(
      fontSize: 11, fontStyle: FontStyle.normal, color: Color(0xff232D35));

  //initial
  @override
  void initState() {
   // _initializeTimer();
    super.initState();
    GetInfoUserNew();
    getTTVBDen();
    getTTVBDi();
    getTTVBDT();
    String formattedDate = DateFormat('yyyy').format(now);
    yeara = int.parse(formattedDate);
  }


  @override
  void dispose(){
    super.dispose();
      ThongbaoD = 0;
      ThongbaoDi= 0;
      ThongbaoDT= 0;

  }

  GetDataByKeyYearVBDi() async {
    String yeartimkiem = await getDataByKeyTrangThai(
      ActionXL,
      "0",widget.nam
    );
    isLoading = true;
    setState(() {
      HoSoList = json.decode(yeartimkiem)['OData'];
      tong = json.decode(yeartimkiem)['TotalCount'];
      isLoading = false;
    });
  }

  getTTVBDen() async {
    DateTime now = DateTime.now();
    String Yearvb = DateFormat('yyyy').format(now);
    isLoading = true;
    var vbden = await getthongbao(Yearvb);

    if (mounted) {
      setState(() {
        isLoading = false;
        if (vbden != null && vbden != []) {
          ThongbaoD = json.decode(vbden)[0]['Count'];
        }
      });
    }
  }

  getTTVBDi() async {
    DateTime now = DateTime.now();
    String Yearvb = DateFormat('yyyy').format(now);
    isLoading = true;
    var vbdi = await getthongbaoDi(Yearvb);

    if (mounted) {
      setState(() {
        isLoading = false;
        if (vbdi != null && vbdi != []) {
          ThongbaoDi = json.decode(vbdi)[0]['Count'];
        }
      });
    }
  }

  getTTVBDT() async {
    DateTime now = DateTime.now();
    String Yearvb = DateFormat('yyyy').format(now);
    isLoading = true;
    var vbdt = await getthongbaoDT(Yearvb);

    if (mounted) {
      setState(() {
        isLoading = false;
        if (vbdt != null && vbdt != []) {
          ThongbaoDT = json.decode(vbdt)[0]['Count'];
        }
      });
    }
  }

  GetDataByKeyYearVBDi1() async {
    String yeartimkiem = await getDataByKeyTrangThai(
      ActionXL,
      "1",widget.nam
    );
    isLoading = true;
    setState(() {
      isLoading = false;
      HoSoList1 = json.decode(yeartimkiem)['OData'];
      tong1 = json.decode(yeartimkiem)['TotalCount'];
    });
  }

  GetDataByKeyYearVBDi2() async {
    String yeartimkiem = await getDataByKeyTrangThai(
      ActionXL,
      "5",widget.nam
    );
    isLoading = true;
    setState(() {
      isLoading = false;
      HoSoList2 = json.decode(yeartimkiem)['OData'];
      tong2 = json.decode(yeartimkiem)['TotalCount'];
    });
  }

  //lấy thông tin user
  //lấy thông tin user
  UserJson user = new UserJson();

  GetInfoUserNew() async {
    sharedStorage = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        user.Title = sharedStorage.getString("hoten");
        user.ChucVu = sharedStorage.getString("chucvu");
      });
    }
  }

  // api mưới gethomevbden
  getHomeVBDen() async {
    DateTime now = DateTime.now();
    String Yearvb = DateFormat('yyyy').format(now);
    isLoading = true;
    // var vbden = await getVBDentrangChu(Yearvb);
    // var vbdi = await getVBDitrangChu( Yearvb);
    // var vbdt = await getVBDTtrangChu( Yearvb);
    if (mounted) {
      setState(() {
        isLoading = false;
        // dataListVBDen = json.decode(vbden);
        // dataListVBDi = json.decode(vbdi);
        // dataListVBDT = json.decode(vbdt);
      });
    }
  }


  //body
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          // automaticallyImplyLeading: false,
          title: Transform.translate(
            offset: Offset(-10, 0.0),
            child: Text("Trang chủ"),
          ),
          actions: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.ChucVu == null ? "" : user.ChucVu + ":",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  user.Title != null ? user.Title : "",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.person_outline),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                //tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
            ),
          ],
        ),
        endDrawer: MenuRight(
          hoten: user.Title,
          chucvu: user.ChucVu,
          users: widget.username,
        ),
        endDrawerEnableOpenDragGesture: false,
        drawer: Drawer(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: MenuChinh(year: widget.nam),
          ),
        ),
        body: Container(
          //   decoration: new BoxDecoration(
          //       color: Color(0xff0088ff)
          //
          //   ),

          child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: GridView(
                        // padding: EdgeInsets.all(5),
                        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //     crossAxisCount: 2, mainAxisSpacing: 0,
                        //     crossAxisSpacing: 0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                          childAspectRatio: (2 / 1),
                        ),
                        children: <Widget>[
                          itemVBD('assets/icon/vbden.png'),

                          itemVBDi('assets/icon/vbdiApp'
                              '.png'),
                          itemVBDT('assets/icon/duthaoApp'
                              '.png'),

                          Container(
                            margin: EdgeInsets.only(top: 10, left: 5),
                            color: Color(0xffE57373),
                            child: InkWell(
                              onTap: () {

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeHSCV(
                                          username: widget.username,nam:widget.nam
                                      ),
                                    ));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                      'assets/icon/hscvApp'
                                          '.png',
                                      width:
                                      MediaQuery.of(context).size.width * 0.1,
                                      height: MediaQuery.of(context).size.height *
                                          0.05,
                                      fit: BoxFit.fill),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text("Hồ sơ công việc",
                                        textAlign: TextAlign.center,
                                        style: tabStyleWhile),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, right: 5),
                            color: Color(0xff43A047),
                            child: InkWell(
                              onTap: () {

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GiaoViec(
                                          Yearvb: yeara,
                                        )));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                      'assets/icon/giaoviecApp'
                                          '.png',
                                      width:
                                      MediaQuery.of(context).size.width * 0.1,
                                      height: MediaQuery.of(context).size.height *
                                          0.05,
                                      fit: BoxFit.fill),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text("Giao việc",
                                        textAlign: TextAlign.center,
                                        style: tabStyleWhile),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, left: 5),
                            color: Color(0xffFBA922),
                            child: InkWell(
                              onTap: () {

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DynamicEvent(
                                            username: widget.username,
                                            nam: widget.nam)));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                      'assets/icon/lichld'
                                          '.png',
                                      width:
                                      MediaQuery.of(context).size.width * 0.1,
                                      height: MediaQuery.of(context).size.height *
                                          0.05,
                                      fit: BoxFit.fill),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text("Lịch lãnh đạo",
                                        textAlign: TextAlign.center,
                                        style: tabStyleWhile),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, right: 5),
                            color: Color(0xff54A88F),
                            child: InkWell(
                              onTap: () {

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => hoTro(
                                          username: widget.username,nam:widget.nam
                                        )));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                      'assets/icon/hotroApp'
                                          '.png',
                                      width:
                                      MediaQuery.of(context).size.width * 0.1,
                                      height: MediaQuery.of(context).size.height *
                                          0.05,
                                      fit: BoxFit.fill),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text("Hỗ trợ",
                                        textAlign: TextAlign.center,
                                        style: tabStyleWhile),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: Row(
                  //     children: <Widget>[
                  //       Flexible(
                  //           flex: 1,
                  //           fit: FlexFit.loose,
                  //           child: Text("Hệ thống dùng chung của tỉnh ",
                  //               textAlign: TextAlign.center,
                  //               style: TextStyle(
                  //                   color: Color(0xff3064D0), fontSize: 11))
                  //           //Container
                  //           ),
                  //       // SizedBox(
                  //       //   width: 10,
                  //       // ),
                  //       // Flexible(
                  //       //   flex: 1,
                  //       //   fit: FlexFit.tight,
                  //       //   child: InkWell(
                  //       //     onTap: () {
                  //       //       setState(() {
                  //       //         String url =
                  //       //             'https://dichvucong.hoabinh.gov.vn/hoabinh-portal/';
                  //       //         _launchURL(url);
                  //       //       });
                  //       //     },
                  //       //     child: Column(
                  //       //       mainAxisAlignment: MainAxisAlignment.center,
                  //       //       children: <Widget>[
                  //       //         Image.asset('assets/icon/congtt.png',
                  //       //             width: MediaQuery.of(context).size.width *
                  //       //                 0.04,
                  //       //             height:
                  //       //                 MediaQuery.of(context).size.height *
                  //       //                     0.02,
                  //       //             fit: BoxFit.fill),
                  //       //         Text("Dịch vụ công",
                  //       //             textAlign: TextAlign.center,
                  //       //             style: tabStyleBlackIT)
                  //       //       ],
                  //       //     ),
                  //       //   ), //Container
                  //       // ), //Flexible
                  //       SizedBox(
                  //         width: 10,
                  //       ),
                  //       Flexible(
                  //         flex: 1,
                  //         fit: FlexFit.tight,
                  //         child: InkWell(
                  //           onTap: () {
                  //             setState(() {
                  //               String url = 'http://hoabinh.gov.vn/';
                  //               _launchURL(url);
                  //             });
                  //           },
                  //           child: Column(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: <Widget>[
                  //               Image.asset('assets/icon/congttApp.png',
                  //                   width: MediaQuery.of(context).size.width *
                  //                       0.04,
                  //                   height:
                  //                       MediaQuery.of(context).size.height *
                  //                           0.02,
                  //                   fit: BoxFit.fill),
                  //               Text("Cổng thông tin",
                  //                   textAlign: TextAlign.center,
                  //                   style: tabStyleBlackIT)
                  //             ],
                  //           ),
                  //         ), //Container
                  //       ),
                  //       SizedBox(
                  //         width: 10,
                  //       ), //SizedBox
                  //       Flexible(
                  //         flex: 1,
                  //         fit: FlexFit.tight,
                  //         child: InkWell(
                  //           onTap: () {
                  //             setState(() {
                  //               String url =
                  //                   'http://thongtinbaocao.hoabinh.gov.vn/';
                  //               _launchURL(url);
                  //             });
                  //           },
                  //           child: Column(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: <Widget>[
                  //               Image.asset('assets/icon/baocaoApp.png',
                  //                   color: Colors.black,
                  //                   width: MediaQuery.of(context).size.width *
                  //                       0.04,
                  //                   height:
                  //                       MediaQuery.of(context).size.height *
                  //                           0.02,
                  //                   fit: BoxFit.fill),
                  //               Text("HT báo cáo",
                  //                   textAlign: TextAlign.center,
                  //                   style: tabStyleBlackIT)
                  //             ],
                  //           ),
                  //         ), //Container
                  //       ),
                  //       SizedBox(
                  //         width: 10,
                  //       ), //SizedBox
                  //       Flexible(
                  //         flex: 1,
                  //         fit: FlexFit.tight,
                  //         child: InkWell(
                  //           onTap: () {
                  //             setState(() {
                  //               String url = 'http://vpubnd.hoabinh.gov.vn/';
                  //               _launchURL(url);
                  //             });
                  //           },
                  //           child: Column(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: <Widget>[
                  //               Image.asset(
                  //                   'assets/icon/duthaoApp'
                  //                   '.png',
                  //                   color: Colors.black,
                  //                   width: MediaQuery.of(context).size.width *
                  //                       0.04,
                  //                   height:
                  //                       MediaQuery.of(context).size.height *
                  //                           0.02,
                  //                   fit: BoxFit.fill),
                  //               Text("Thư điện tử ",
                  //                   textAlign: TextAlign.center,
                  //                   style: tabStyleBlackIT)
                  //             ],
                  //           ),
                  //         ), //Container
                  //       ),
                  //
                  //       //Flexible
                  //     ], //<Widget>[]
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //   ),
                  // )
                ],
              )),
        ));
  }

  Widget itemVBD(String imagePath) {
    return InkWell(
      onTap: () {

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeVBDen(
                username: widget.username,
              ),
            ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 5),
        //margin: EdgeInsets.only(top:10,right:5),
        color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage(imagePath))),
                    ),
                  ),
                  ThongbaoD == null
                      ? const SizedBox()
                      : Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20)),
                            child: FittedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  ThongbaoD > 99
                                      ? '+9'
                                          '9'
                                      : ThongbaoD.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        )
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text("Văn bản đến",
                  textAlign: TextAlign.center, style: tabStyleWhile),
            )
          ],
        ),
      ),
    );
  }

  Widget itemVBDi(String imagePath) {
    return InkWell(
      onTap: () {

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeVBDi(
                username: widget.username,
              ),
            ));
      },
      child: Container(
        margin: EdgeInsets.only(left: 5),
        color: Color(0xff54A88F),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage(imagePath))),
                    ),
                  ),
                  ThongbaoDi == null
                      ? const SizedBox()
                      : Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20)),
                            child: FittedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  ThongbaoDi > 99
                                      ? '+9'
                                          '9'
                                      : ThongbaoDi.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        )
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text("văn bản đi",
                  textAlign: TextAlign.center, style: tabStyleWhile),
            )
          ],
        ),
      ),
    );
  }

  Widget itemVBDT(String imagePath) {
    return InkWell(
      onTap: () {

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeVBDT(
                username: widget.username,
              ),
            ));
      },
      child: Container(
        margin: EdgeInsets.only(top: 10, right: 5),
        color: Color(0xff9E9E9E),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage(imagePath))),
                    ),
                  ),
                  ThongbaoDT == null
                      ? const SizedBox()
                      : Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20)),
                            child: FittedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  ThongbaoDT > 99
                                      ? '+9'
                                          '9'
                                      : ThongbaoDT.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        )
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text("Dự thảo/Phiếu trình",
                  textAlign: TextAlign.center, style: tabStyleWhile),
            )
          ],
        ),
      ),
    );
  }

  //lấy dữ liệu vb đi
  Widget GetDataVbdi() {
    if (dataListVBDi == null || dataListVBDi.length < 0 || isLoading) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
      ));
    } else if (dataListVBDi.length == 0) {
      return Center(
        child: Text("Không có bản ghi"),
      );
    }
    return ListView.builder(
      itemCount: dataListVBDi == null ? 0 : dataListVBDi.length,
      itemBuilder: (context, index) {
        return getBodyVB(dataListVBDi[index], 2);
      },
    );
  }

  //lấy dữ liệu vb đến
  Widget GetDataVbDen() {
    if (dataListVBDen == null || dataListVBDen.length < 0 || isLoading) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
      ));
    } else if (dataListVBDen.length == 0) {
      return Center(
        child: Text("Không có bản ghi"),
      );
    }
    return ListView.builder(
      itemCount: dataListVBDen == null ? 0 : dataListVBDen.length,
      itemBuilder: (context, index) {
        return getBodyVB(dataListVBDen[index], 1);
      },
    );
  }

  Widget GetDataVbDT() {
    if (dataListVBDT == null || dataListVBDT.length < 0 || isLoading) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
      ));
    } else if (dataListVBDT.length == 0) {
      return Center(
        child: Text("Không có bản ghi"),
      );
    }
    return ListView.builder(
      itemCount: dataListVBDT == null ? 0 : dataListVBDT.length,
      itemBuilder: (context, index) {
        return getBodyVB(dataListVBDT[index], 3);
      },
    );
  }

  //index = 1 : vb den, 2: vb di, 3: vb du thao
  //giao diện 1 dong
  Widget getBodyVB(item, int index) {
    var title = item['Title'] ?? "";
    var count = item['Count'] ?? 0;
    var query = item['query'] ?? "";

    String url = "";
    if (index == 2) {
      // url = "/test/getallvbdi";
    } else if (index == 1) {
      // url = "";
    } else if (index == 3) {
      // url = "";
    }
    return Card(
      child: ListTile(
          title: Text(
            title,
          ),
          leading: Image(image: AssetImage('assets/logo_vb.png')),
          trailing: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.13,
            //padding: const EdgeInsets.all(1),
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueAccent,
            ),
            child: new Text(count.toString(),
                style: new TextStyle(color: Colors.white, fontSize: 13.0)),
          ),
          onTap: () {
            widget.returnData(query, index);
          }),
    );
  }
}

String ttHoSo(id) {
  String tt;
  switch (id) {
    case 0:
      tt = "Đang xử lý";
      break;
    case 1:
      tt = "Đã hoàn thành";
      break;
    case 5:
      tt = "Đã trả về ";
      break;
  }
  return tt;
}

Future<void> _launchURL(String url) async {
  //const url = 'https://motcua.hoabinh.gov.vn/efy-ecs-general/login';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

// body:Container(
//   width: MediaQuery.of(context).size.width,
//   height:  MediaQuery.of(context).size.height,
//   child:
//   SingleChildScrollView(child:  Column(
//     mainAxisSize: MainAxisSize.max,
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//        Container(
//           alignment: Alignment.topRight,
//           margin: EdgeInsets.only(top:10,right: 10),
//           child: Container(
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.lightBlue[50], width: 2),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             width: MediaQuery
//                 .of(context)
//                 .size
//                 .width * 0.25,
//             height: MediaQuery
//                 .of(context)
//                 .size
//                 .height * 0.05,
//             child:TextButton.icon (
//                 icon: Icon(Icons.present_to_all_outlined,color: Colors.black,),
//                 label: Text("Giao việc",style: TextStyle(fontWeight:
//                 FontWeight
//                     .bold, fontSize: 13,color: Colors.black),textAlign:
//                 TextAlign.center,),
//                 onPressed: ()  {
//                   Navigator.of(context).push(MaterialPageRoute
//                     (builder: (context) =>GiaoViec(
//                     Yearvb: yeara ,)
//                   ));
//                   // Get.to(GiaoViec(Yearvb:yeara ));
//                 },
//                 style: ButtonStyle(
//                   //backgroundColor: MaterialStateProperty.all<Color>(Colors
//                   // .orangeAccent),
//                   foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
//                 )
//             ),),
//         ),
//
//       Container(
//
//         // height: MediaQuery.of(context).size.height *
//         //     0.6,
//         color: Colors.white,alignment: Alignment.center,
//         child: GridView(
//
//           padding: EdgeInsets.all(0),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount
//             (childAspectRatio: 1.5,
//               crossAxisCount: 2,  crossAxisSpacing: 15),
//           children: <Widget>[
//             InkWell(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => HomeVBDen(
//                       ),
//                     ));
//               },
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     margin: EdgeInsets.all(15),
//                     child: Image.asset('assets/file.png',
//                         width: MediaQuery.of(context).size.width * 0.15,
//                         height: MediaQuery.of(context).size.height *
//                             0.09, fit: BoxFit.fill),
//                   ),
//                   Text("VĂn bản đến".toUpperCase(),textAlign: TextAlign
//                       .center,
//                       style: tabStyleBlack)
//                 ],
//               ),
//             ),
//             InkWell(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => HomeVBDi(
//                       ),
//                     ));
//               },
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     margin: EdgeInsets.all(15),
//                     child: Image.asset('assets/documentsend.png',
//                         width: MediaQuery.of(context).size.width * 0.15,
//                         height: MediaQuery.of(context).size.height *
//                             0.09,
//                         fit: BoxFit.fill),
//                   ),
//                   Text("VĂn bản đi".toUpperCase(),textAlign: TextAlign
//                       .center,
//                       style: tabStyleBlack)
//                 ],
//               ),
//             ),
//             InkWell(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => HomeVBDT(
//                       ),
//                     ));
//               },
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     margin: EdgeInsets.all(15),
//                     child: Image.asset('assets/draft.png',
//                         width: MediaQuery.of(context).size.width * 0.15,
//                         height: MediaQuery.of(context).size.height *
//                             0.09, fit: BoxFit.fill),
//                   ),
//                   Text("Dự thảo/Phiếu trình".toUpperCase(),textAlign:
//                   TextAlign
//                       .center,
//                       style: tabStyleBlack)
//                 ],
//               ),
//             ),
//
//             InkWell(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => HomeHSCV(
//                       ),
//                     ));
//               },
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     margin: EdgeInsets.all(15),
//                     child: Image.asset('assets/contract.png',
//                         width: MediaQuery.of(context).size.width * 0.15,
//                         height: MediaQuery.of(context).size.height *
//                             0.09, fit: BoxFit.fill),
//                   ),
//                   Text("Hồ sơ công việc".toUpperCase(),textAlign: TextAlign
//                       .center,
//                       style: tabStyleBlack)
//                 ],
//               ),
//             ),
//             InkWell(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => HomeVBDT(
//                       ),
//                     ));
//               },
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     margin: EdgeInsets.all(15),
//                     child: Image.asset('assets/icon/giaonhan.png',
//                         width: MediaQuery.of(context).size.width * 0.15,
//                         height: MediaQuery.of(context).size.height *
//                             0.09, fit: BoxFit.fill),
//                   ),
//                   Text("Giao nhận nhiệm vụ".toUpperCase(),textAlign:
//                   TextAlign
//                       .center,
//                       style: tabStyleBlack)
//                 ],
//               ),
//             ),
//
//
//
//             // InkWell(
//             //   onTap: () {
//             //     Navigator.push(
//             //         context,
//             //         MaterialPageRoute(
//             //           builder: (context) => DSVBContainsBanner(
//             //             donvi: null,
//             //             trangthaihieuluc: 3,
//             //             tieude: 'Hết hiệu lực',
//             //           ),
//             //         ));
//             //   },
//             //   child: Column(
//             //     mainAxisAlignment: MainAxisAlignment.center,
//             //     children: <Widget>[
//             //       Container(
//             //         margin: EdgeInsets.only(top: 15,right:15,bottom:
//             //         15),
//             //         child: Image.asset('assets/icon/het-hieuluc.png',
//             //             width: 100, height: 100, fit: BoxFit.fill),
//             //       ),
//             //       Text("Văn Bản Hết hiệu lực".toUpperCase(),textAlign: TextAlign.center, style: tabStyleBlack)
//             //     ],
//             //   ),
//             // ),
//
//
//           ],
//         ),
//       ),
//
//       Container(
//         child:  GridView(
//
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount
//             (  crossAxisCount: 3,
//             mainAxisSpacing: 5,
//             crossAxisSpacing: 5,),
//           children: <Widget>[
//             InkWell(
//               onTap: () {
//                 String url =  'http://soytehoabinh.gov.vn/';
//                 _launchURL(url);
//               },
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     margin: EdgeInsets.all(15),
//                     child: Image.asset('assets/icon/congtt.png',
//                         width: MediaQuery.of(context).size.width * 0.1,
//                         height: MediaQuery.of(context).size.height *
//                             0.05, fit: BoxFit.fill),
//                   ),
//                   Text("dịch vụ công ".toUpperCase(),textAlign:
//                   TextAlign
//                       .center,
//                       style: tabStyleBlackIT)
//                 ],
//               ),
//             ),
//             InkWell(
//               onTap: () {
//                 String url =  'http://soytehoabinh.gov.vn/';
//                 _launchURL(url);
//               },
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     margin: EdgeInsets.all(15),
//                     child: Image.asset('assets/icon/motcua.png',
//                         width: MediaQuery.of(context).size.width * 0.1,
//                         height: MediaQuery.of(context).size.height *
//                             0.05, fit: BoxFit.fill),
//                   ),
//                   Text("Một cửa".toUpperCase(),textAlign:
//                   TextAlign
//                       .center,
//                       style: tabStyleBlackIT)
//                 ],
//               ),
//             ),
//             InkWell(
//               onTap: () {
//                 String url =  'http://soytehoabinh.gov.vn/';
//                 _launchURL(url);
//               },
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     margin: EdgeInsets.all(15),
//                     child: Image.asset('assets/icon/ytehoabinh.png',
//                         width: MediaQuery.of(context).size.width * 0.1,
//                         height: MediaQuery.of(context).size.height *
//                             0.05, fit: BoxFit.fill),
//                   ),
//                   Text("Bộ y tế".toUpperCase(),textAlign: TextAlign
//                       .center,
//                       style: tabStyleBlackIT)
//                 ],
//               ),
//             ),
//             InkWell(
//               onTap: () {
//                 String url =  'http://soytehoabinh.gov.vn/';
//                 _launchURL(url);
//               },
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     margin: EdgeInsets.all(15),
//                     child: Image.asset('assets/icon/congtt.png',
//                         width: MediaQuery.of(context).size.width * 0.1,
//                         height: MediaQuery.of(context).size.height *
//                             0.05, fit: BoxFit.fill),
//                   ),
//                   Text("dịch vụ công ".toUpperCase(),textAlign:
//                   TextAlign
//                       .center,
//                       style: tabStyleBlackIT)
//                 ],
//               ),
//             ),
//             InkWell(
//               onTap: () {
//                 String url =  'http://soytehoabinh.gov.vn/';
//                 _launchURL(url);
//               },
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     margin: EdgeInsets.all(15),
//                     child: Image.asset('assets/icon/motcua.png',
//                         width: MediaQuery.of(context).size.width * 0.1,
//                         height: MediaQuery.of(context).size.height *
//                             0.05, fit: BoxFit.fill),
//                   ),
//                   Text("Một cửa".toUpperCase(),textAlign:
//                   TextAlign
//                       .center,
//                       style: tabStyleBlackIT)
//                 ],
//               ),
//             ),
//             InkWell(
//               onTap: () {
//                 String url =  'http://soytehoabinh.gov.vn/';
//                 _launchURL(url);
//               },
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     margin: EdgeInsets.all(15),
//                     child: Image.asset('assets/icon/ytehoabinh.png',
//                         width: MediaQuery.of(context).size.width * 0.1,
//                         height: MediaQuery.of(context).size.height *
//                             0.05, fit: BoxFit.fill),
//                   ),
//                   Text("Bộ y tế".toUpperCase(),textAlign: TextAlign
//                       .center,
//                       style: tabStyleBlackIT)
//                 ],
//               ),
//             ),
//             InkWell(
//               onTap: () {
//                 String url =  'http://soytehoabinh.gov.vn/';
//                 _launchURL(url);
//               },
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     margin: EdgeInsets.all(15),
//                     child: Image.asset('assets/icon/congtt.png',
//                         width: MediaQuery.of(context).size.width * 0.1,
//                         height: MediaQuery.of(context).size.height *
//                             0.05, fit: BoxFit.fill),
//                   ),
//                   Text("dịch vụ công ".toUpperCase(),textAlign:
//                   TextAlign
//                       .center,
//                       style: tabStyleBlackIT)
//                 ],
//               ),
//             ),
//             InkWell(
//               onTap: () {
//                 String url =  'http://soytehoabinh.gov.vn/';
//                 _launchURL(url);
//               },
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     margin: EdgeInsets.all(15),
//                     child: Image.asset('assets/icon/motcua.png',
//                         width: MediaQuery.of(context).size.width * 0.1,
//                         height: MediaQuery.of(context).size.height *
//                             0.05, fit: BoxFit.fill),
//                   ),
//                   Text("Một cửa".toUpperCase(),textAlign:
//                   TextAlign
//                       .center,
//                       style: tabStyleBlackIT)
//                 ],
//               ),
//             ),
//             InkWell(
//               onTap: () {
//                 String url =  'http://soytehoabinh.gov.vn/';
//                 _launchURL(url);
//               },
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     margin: EdgeInsets.all(15),
//                     child: Image.asset('assets/icon/ytehoabinh.png',
//                         width: MediaQuery.of(context).size.width * 0.1,
//                         height: MediaQuery.of(context).size.height *
//                             0.05, fit: BoxFit.fill),
//                   ),
//                   Text("Bộ y tế".toUpperCase(),textAlign: TextAlign
//                       .center,
//                       style: tabStyleBlackIT)
//                 ],
//               ),
//             ),
//
//
//
//
//
//
//           ],),)
//
//
//     ],),) ,
// ),
