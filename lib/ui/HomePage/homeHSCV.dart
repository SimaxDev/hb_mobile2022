import 'dart:async';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/core/services/hoSoCVService.dart';
import 'package:hb_mobile2021/ui/main/btnavigator_widget.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:hb_mobile2021/ui/vbden/vbden.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hb_mobile2021/core/models/UserJson.dart';
import 'package:hb_mobile2021/core/services/UserService.dart';
import 'package:hb_mobile2021/ui/main/MenuRight.dart';
import 'package:hb_mobile2021/core/services/HomePageService.dart';
import 'dart:convert';

class HomeHSCV extends StatefulWidget {
  final returnData;
  final String username;
  final String nam;

  HomeHSCV({Key key, this.returnData, this.username,this.nam}) : super(key:
  key);

  @override
  State<StatefulWidget> createState() {
    return PageState();
  }
}

class PageState extends State<HomeHSCV> {
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
  String  nam1 =  '2022';
  // lấy năm hiện tại
  String tenDN = "";
  String queryDXL = "";
  String queryDHT = "";
  String queryDTV = "";
  int indexTT = 4;
  int tong = 0;
  int tong1 = 0;
  int tong2 = 0;


  //initial
  @override
  void initState() {
    //_initializeTimer();'
    DateTime now = DateTime.now();
    setState(() {
        nam1 =  DateFormat('yyyy').format(now) ;
    });

    super.initState();
    GetInfoUserNew();
    getHomeVBDen();
    GetDataByKeyYearVBDi();
    GetDataByKeyYearVBDi1();
    GetDataByKeyYearVBDi2();
  }
  GetDataByKeyYearVBDi() async {
    String yeartimkiem = await getDataByKeyTrangThai( ActionXL, "0",nam1
    );
    isLoading = true;
    setState(() {
      HoSoList = json.decode(yeartimkiem)['OData'];
      tong = json.decode(yeartimkiem)['TotalCount'];
      isLoading = false;

    });


  }
  GetDataByKeyYearVBDi1() async {
    String yeartimkiem = await getDataByKeyTrangThai( ActionXL, "1",nam1
    );
    isLoading = true;
    setState(() {
      isLoading = false;
      HoSoList1 = json.decode(yeartimkiem)['OData'];
      tong1 = json.decode(yeartimkiem)['TotalCount'];
    });


  } GetDataByKeyYearVBDi2() async {
    String yeartimkiem = await getDataByKeyTrangThai( ActionXL, "5",nam1
    );   isLoading = true;
    setState(() {
      isLoading = false;
      HoSoList2 = json.decode(yeartimkiem)['OData'];
      tong2 = json.decode(yeartimkiem)['TotalCount'];

    });


  }



  //lấy thông tin user
  UserJson user = new UserJson();

  GetInfoUserNew() async {
    sharedStorage = await SharedPreferences.getInstance();
    if (mounted) {setState(() {
      user.Title = sharedStorage.getString("hoten");
      user.ChucVu = sharedStorage.getString("chucvu");
    });}


  }
  // api mưới gethomevbden
  getHomeVBDen() async {
    DateTime now = DateTime.now();
    String Yearvb = DateFormat('yyyy').format(now);
    isLoading = true;
    var vbden = await getVBDenHomePage(Yearvb);
    var vbdi = await getVBDiHomePage( Yearvb);
    var vbdt = await getVBDTHomePage( Yearvb);
    if(mounted){
      setState(() {
        isLoading = false;
        dataListVBDen = json.decode(vbden);
        dataListVBDi = json.decode(vbdi);
        dataListVBDT = json.decode(vbdt);
      });
    }

  }


  @override
  void dispose() {
    super.dispose();

  }

  //body
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          automaticallyImplyLeading: false,
          title: Text('Hồ sơ công việc'),
          actions: <Widget>[
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.person_outline),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                //tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
            ),
          ],
        ),
        endDrawer: MenuRight(hoten: user.Title,chucvu: user.ChucVu, users: widget.username,),
        endDrawerEnableOpenDragGesture: false,
        body: Column(
          children: [
            Expanded(child: Container(
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.26,
                  child: SingleChildScrollView(child:
                  dataListVBDi == null || dataListVBDi.length < 0 || isLoading ?
                  Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                      )):Column(
                    children: [
                      Card(
                        child: ListTile(
                          title: Text(
                            ttHoSo(0),
                          ),
                          leading: Image(image: AssetImage('assets/icon/folderApp.png'),
                              color: Colors.blue.shade500,width: MediaQuery.of(context).size
                                  .width * 0.05,
                              height: MediaQuery.of(context).size.height *
                                  0.025, fit: BoxFit.fill),
                          trailing: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width* 0.09,
                            height: MediaQuery.of(context).size.height * 0.05,
                            //padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueGrey[100],width: 1),
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.blueAccent,
                            ),
                            child: new Text(tong.toString(), style: new TextStyle
                              (color:
                            Colors.white, fontSize:11.0)),
                          ),
                          onTap: () {
                            Get.offAll(BottomNavigator(query: "isHoSocongviec=true&hscvTrangThaiXuLy=0",page:4) );
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(
                            ttHoSo(1),
                          ),
                          leading: Image(image: AssetImage('assets/icon/folderApp.png'),
                              color: Colors.blue.shade500,width: MediaQuery.of(context).size
                                  .width * 0.05,
                              height: MediaQuery.of(context).size.height *
                                  0.025, fit: BoxFit.fill),
                          trailing: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width* 0.09,
                            height: MediaQuery.of(context).size.height * 0.05,
                            //padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueGrey[100],width: 1),
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.blueAccent,
                            ),
                            child: new Text(tong1.toString(), style: new TextStyle
                              (color:
                            Colors.white, fontSize:11.0)),
                          ),
                          onTap: () {

                            Get.offAll(BottomNavigator(query: "isHoSocongviec=true&hscvTrangThaiXuLy=1",page:4) );
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(
                            ttHoSo(5),
                          ),
                          leading: Image(image: AssetImage('assets/icon/folderApp.png'),
                              color: Colors.blue.shade500,width: MediaQuery.of(context).size
                                  .width * 0.05,
                              height: MediaQuery.of(context).size.height *
                                  0.025, fit: BoxFit.fill),
                          trailing: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width* 0.09,
                            height: MediaQuery.of(context).size.height * 0.05,
                            //padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueGrey[100],width: 1),
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.blueAccent,
                            ),
                            child: new Text(tong2.toString(), style: new TextStyle
                              (color:
                            Colors.white, fontSize:11.0)),
                          ),
                          onTap: () {
                            Get.offAll(BottomNavigator(query: "sHoSocongviec=true&hscvTrangThaiXuLy=5",page:4) );

                          },
                        ),
                      ),

                    ],
                  ),
                  )
              ),
            ))
          ],
        )
      // body: new ListView(
      //   padding: const EdgeInsets.all(0.0),
      //   children: <Widget>[
      //     // Container(
      //     //     padding: const EdgeInsets.all(10.0),
      //     //     //  color: Colors.blue[50],
      //     //     child: Center(
      //     //       child: Text('Văn bản đến'.toUpperCase(), style: new TextStyle(color: Colors.blueAccent, fontSize: 21.0,
      //     //           shadows: [
      //     //             Shadow(
      //     //               blurRadius: 15.0,
      //     //               color: Colors.white,
      //     //               offset: Offset(0.0, 5.0),
      //     //             ),
      //     //           ] ,
      //     //           fontWeight: FontWeight.bold)),
      //     //     )
      //     // ),
      //
      //      // height: MediaQuery.of(context).size.height * 0.26,
      //        GetDataVbDen(),
      //
      //   ],
      // ),
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
    if (dataListVBDen == null|| dataListVBDen.length < 0 || isLoading) {
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
    if (dataListVBDT == null|| dataListVBDT.length < 0 || isLoading) {
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
          leading: Image(image: AssetImage('assets/icon/folderApp.png'),
              color: Colors.blue.shade500,width: MediaQuery.of(context).size
                  .width * 0.05,
              height: MediaQuery.of(context).size.height *
                  0.025, fit: BoxFit.fill),
          trailing: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width* 0.09,
            height: MediaQuery.of(context).size.height * 0.05,
            //padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey[100],width: 1),
              borderRadius: BorderRadius.circular(7),
              color: Colors.blueAccent,
            ),
            child: new Text(count.toString(), style: new TextStyle(color:
            Colors.white, fontSize:11.0)),
          ),
          onTap: () {
            Get.offAll(BottomNavigator(query: "isHoSocongviec=true&hscvTrangThaiXuLy=0",page:4) );

          }
      ),
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