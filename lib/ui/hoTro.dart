import 'dart:async';
import 'dart:convert';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hb_mobile2021/core/models/UserJson.dart';
import 'package:hb_mobile2021/core/services/UserService.dart';
import 'package:hb_mobile2021/core/services/VBDuThaoService.dart';
import 'package:hb_mobile2021/core/services/VbdenService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/ui/main/MenuRight.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:hb_mobile2021/ui/themMoiHT.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class hoTro extends StatefulWidget {
  const hoTro({Key key,this.username}) : super(key: key);
  final String username;
  @override
  _hoTroState createState() => _hoTroState();
}

class _hoTroState extends State<hoTro> {
  List<String> Year = ["2024","2023","2022","2021", "2020", "2019", "2018", "2017"];
  String dropdownValue ="2022";
  List listHoTro = [];
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  bool isLoading  = true;
  var tendangnhap = "";
   String _url = 'https://zalo.me/g/nvvico303';
  ScrollController _scrollerController = new ScrollController();


  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    if(mounted){
      setState(() {
        getBody();
      });
    }


    return null;
  }


  GetDataVBDT() async {

    // if(widget.urlttVB == null || widget.urlttVB == ""|| widget.nam == null || widget.nam == "" )
    // {
    //   nam = "2021";
    //   vbden= await getDataLeftVBDen(skip, pageSize, ActionXL,widget.urlttVB,nam);
    // }
    // else

   String vbdt= await getDataHoTro("GetYKien",widget.username,currentUserID);
    if (mounted) {
      setState(() {
      // dataList += json.decode(vbden)['OData'];
      listHoTro.addAll(json.decode(vbdt)['OData']);

      isLoading = false;

    });}

  }
  @override
  void initState(){
   // _initializeTimer();
    super.initState();

    GetInfoUserNew();
    GetDataVBDT();
    _scrollerController.addListener(() {

        if (_scrollerController.position.pixels == _scrollerController.position.maxScrollExtent) {
          // GetDataVBDT(dropdownValue);
          // GetDataByKeyYearVBDen(dropdownValue);

        }


    });
  }

  @override
  void dispose(){

    super.dispose();
  }


  UserJson user = new UserJson();
  GetInfoUserNew() async{
    sharedStorage = await SharedPreferences.getInstance();
    setState(() {
      user.Title = sharedStorage.getString("hoten");
      hoVaTen = user.Title;
      user.ChucVu = sharedStorage.getString("chucvu");
    });
    var tendangnhap = sharedStorage.getString("username");
    ten = tendangnhap;

  }
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: new AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: new ClipRect(
            child: new Container(
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: AssetImage("assets/hoabinh.jpg"),
                      fit: BoxFit.cover)),
            ),
          ),
          title: Row(
            children: <Widget>[
              Expanded(flex: 1, child: Container()),
              Container(
                width: 50,
                height: 50,
                child: Image(
                  image: AssetImage("assets/logo_thb.png"),
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Expanded(
                flex: 13,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    BorderedText(
                      strokeWidth: 4.0,
                      strokeColor: Colors.white,
                      child: Text('Tỉnh hoà bình'.toUpperCase(),
                        style: TextStyle(fontSize: 14,color: Colors.orange.shade700,
                          fontWeight: FontWeight.w900,),
                      ),
                    ),
                    // BorderedText(
                    //   strokeWidth: 4.0,
                    //   strokeColor: Colors.white,
                    //   child: Text('V?I M?I NGU?I',
                    //     style: TextStyle(fontSize: 14,color: Colors.orange.shade700,
                    //       fontWeight: FontWeight.w900,),
                    //   ),
                    // ),
                    Text(
                      ('Hỗ trợ'),
                      style: TextStyle(fontSize: 13, color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
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
        endDrawerEnableOpenDragGesture: false,
        endDrawer: MenuRight(
          users: widget.username,
          hoten: user.Title,
          chucvu: user.ChucVu,
        ),

        body:Column(
          children: <Widget>[

            InkWell(
              child:Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.2,
                    image: AssetImage('assets/QRnhom.jpg'),
                  ),

                ),

              ),
              onTap: _launchURL,
            ),
            //

            SizedBox(height: 20,),
            // Center(
            //   child:Text("(Click vào mã QR tham gia nhóm hỗ trợ)",
            //     style: TextStyle(fontWeight: FontWeight.normal, fontSize:
            //     13,fontStyle: FontStyle.italic),) ,),
            Center(
              child:Text("Click hoặc quét mã QR tham gia nhóm hỗ trợ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize:
                18),) ,),
            SizedBox(height: 20,),
            Row( mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(padding: EdgeInsets.only(top: 20,left: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue[50], width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.4,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.06,
                    child:TextButton.icon (
                        icon: Icon(Icons.add),
                        label: Text("Thêm mới",style: TextStyle
                          (fontWeight:
                        FontWeight.bold, fontSize: 16,),textAlign:
                        TextAlign.center,),
                        onPressed: ()  {
                          Get.to(themMoiHT());
                          // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                          //     themMoiHT()));
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty
                              .all<Color>(Colors.blue),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        )
                    ),),
                ),

              ],
            ),
            SizedBox(height: 20,),

            Expanded(child:  getBody())









          ],
        ),
      );



}
Widget getCard(item) {
  bool trangthai = item['isGuiHoTro'] != null ? item['isGuiHoTro'] :false;
  var vbdiNguoiSoanField = item['ykienNguoiDung']['Title'] != null  ?item['ykienNguoiDung']['Title'] :  "" ;
  var vbdiTrichYeuField = item['ykienNoiDung'] != null ?item['ykienNoiDung'] : "";
  var SDT = item['sdtNguoiDungTXT'] != null ? item['sdtNguoiDungTXT']: "";
  var Email = item['mailNguoiDungTXT'] != null ? item['mailNguoiDungTXT'] :"";
  var temp =  DateFormat("yyyy-MM-dd").parse(item['ykienTimeCreated']) != null ?DateFormat("yyyy-MM-dd").parse
    (item['ykienTimeCreated']) : DateFormat("yyyy-MM-dd").parse(item['ykienTimeCreated']);
  var ngaytrinh = DateFormat("dd-MM-yyyy").format(temp);
  return Card(
      elevation: 1.5,
      child: InkWell(
        onTap: () {

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => traLoiHoTro(),
          //   ),
          // );
          // : print('tapped');
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Container(
                  //     padding: EdgeInsets.fromLTRB(5.0, 3, 0, 0),
                  //     width: MediaQuery.of(context).size.width * 0.6,
                  //     child: Text(
                  //       "Nội dung: "+vbdiTrichYeuField,
                  //       maxLines: 3,
                  //       overflow: TextOverflow.ellipsis,
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     )),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  Container(
                      //width: MediaQuery.of(context).size.width * 0.6,
                      padding: EdgeInsets.fromLTRB(5.0, 3, 0, 0),
                      child: Text(
                        "Người gửi:"+" "+vbdiNguoiSoanField+"",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black, fontSize:
                        14, fontWeight: FontWeight.w600),
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    //width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.only(left: 5.0),
                    child: Text(
                      "Số điện thoại: "+SDT,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    //width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.only(left: 5.0),
                    child: Text(
                      "Email: "+Email,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            //   Column(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: <Widget>[
            //       Container(
            //         width: MediaQuery.of(context).size.width * 0.22,
            //         child: trangthai == true ?Text("Đã gửi",
            //             style: new TextStyle(
            //                 fontSize: 13, color:  Colors.red)):Text("Chưa "
            //             "gửi",
            // style: new TextStyle(
            //     fontSize: 13, color: new Color(0xFF26C6DA))),
            //       ),
            //       SizedBox(
            //         height: 25,
            //       ),
            //       Container(
            //         padding: EdgeInsets.only(right: 20.0),
            //         child:Column(children: [
            //           Text(
            //            "Ngày gửi yêu cầu:",
            //             style: TextStyle(fontSize: 13, color: Colors.black,
            //                 fontStyle: FontStyle.italic),
            //             overflow: TextOverflow.ellipsis,
            //           ),
            //           Text(
            //             ngaytrinh,
            //             style: TextStyle(fontSize: 14, color: Colors.black),
            //             overflow: TextOverflow.ellipsis,
            //           ),
            //         ],)
            //       )
            //     ],
            //   ),
            ],
          ),
        ),
      ));
}
  Widget getBody() {

    if ( listHoTro== null ||  listHoTro.length < 0 || isLoading) {
      return Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ));
    } else if ( listHoTro.length  == 0) {
      return Center(
        child: Text("Không có bản ghi"),
      );
    }
    return RefreshIndicator(
      key: refreshKey,
      child: ListView.builder(
        itemCount:  listHoTro == null ? 0 :  listHoTro.length ,
        physics:
        ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {

          return getCard(listHoTro[index]);


        },
        controller: _scrollerController,
      ),
      onRefresh: refreshList,
    );

  }

  void _launchURL() async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }
}

Future<void> _launchURL() async {
 const url = 'https://zalo.me/g/nvvico303';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchURLZalo(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }}