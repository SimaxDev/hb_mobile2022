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

class HomeVBDT extends StatefulWidget {
  final returnData;
  final String username;

  HomeVBDT({Key key, this.returnData, this.username}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PageState();
  }
}

class PageState extends State<HomeVBDT> {

  List dataListVBDT = [];
  bool isLoading = false;
  SharedPreferences sharedStorage;


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
    //_initializeTimer();
    super.initState();
    GetInfoUserNew();
    getHomeVBDen();

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
    var vbdt = await getVBDTHomePage( Yearvb);
    if(mounted){
      setState(() {
        isLoading = false;
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
          title: Text('Văn bản dự thảo/Phiếu trình'),
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
              child: GetDataVbDT(),
            ))
          ],
        )
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
            Get.offAll(BottomNavigator(query: query,page:3) );

          }
      ),
    );
  }
}
