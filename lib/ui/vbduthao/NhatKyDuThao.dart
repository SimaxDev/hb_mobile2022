import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class NhatKyDuThao extends StatefulWidget {
  NhatKyDuThao({Key? key, required this.idDuThao, required this.username,required this.nam}) : super(key:
  key);
  final int idDuThao;
  final String username;
  String nam;

  @override
  _NhatKyDuThao createState() => _NhatKyDuThao();
}

class _NhatKyDuThao extends State<NhatKyDuThao> {
  List<Widget> listNhatKy = <Widget>[];
  bool isLoading = false;
  String ActionXLGuiNhan = "GetGuiNhanVBDT";
  var tendangnhap = "";

  @override void dispose() {
    // TODO: implement dispose
    super.dispose();
    // if(_timer != null)
    //   _timer.cancel();

  }



  @override
  void initState() {
   // _initializeTimer();
    super.initState();
    this.fetchData();
    this.getBody();
  }

  //Get api
  fetchData() async {
    tendangnhap = sharedStorage!.getString("username")!;
    if (tendangnhap == null || tendangnhap == "") {
      tendangnhap = widget.username;
    }
    if (mounted) {setState(() {
      isLoading = true;
    });}


    if(widget.nam == null)
      {
        DateTime now = DateTime.now();
       String nam1 =  DateFormat('yyyy').format(now) ;
        widget.nam = nam1;
      }


    String url = "/api/ServicesVBDT/GetData";
    var parts = [];
    parts.add('TenDangNhap=' + tendangnhap);
    parts.add('ItemID=' + widget.idDuThao.toString());
    parts.add('ActionXL=' + ActionXLGuiNhan.toString());
    parts.add('SYear=' + widget.nam.toString());
    var formData = parts.join('&');
    ;
    var response = await responseDataPost(url, formData);

    if (response.statusCode == 200) {
      var items = jsonDecode(response.body)['OData'];

      setState(() {
        // nhatKy = items;
        for (var element in items) {
          listNhatKy.add(
            Row(
              children: [
                Row(
                  children: [
                    Column(children: [
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only( left:10,top: 10, bottom: 5),
                            child: Text(
                              (element['infoSentByUser']['Title']),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only( left:10,top: 10, bottom: 5),
                            child: Image(
                              image: AssetImage('assets/t.png'),
                            ),),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                           margin: EdgeInsets.only(top: 10, bottom: 10),
                            alignment: Alignment.center,
                            child:Column(children: [
                              Text  (element['infoUserNameReceived']['Title']),
                            ],),
                          ),

                        ],
                      ),
                      Row(children: [
                        Container(
                          margin: EdgeInsets.only(left:10,top: 5, bottom: 10),
                          child: Image(
                            image: AssetImage('assets/clock.png'),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 5,top: 5, bottom: 15),
                          width: MediaQuery.of(context).size.width * 0.35,
                          alignment: Alignment.topLeft,
                          child: Text(
                            // (element['infoTimeSent'] != '')
                            //     ? (DateFormat('dd/MM/yyyy').format(DateTime.parse(element['infoTimeSent'])) ?? '')
                            //     : '',
                            GetDate(element['infoTimeSent']),
                            style: TextStyle(color: Colors.black38,fontStyle: FontStyle.italic,fontSize: 13),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,

                          ),

                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          alignment: Alignment.topRight,
                        ),


                      ],)
                    ],),

                  ],
                ),
                Divider(),
              ],
            ),
          );
          listNhatKy.add(new Divider());
          setState(() {
            isLoading = false;
          });
        }
      });
    } else {
      listNhatKy = [];
      isLoading = false;
    }
  }

  //t???o list view
  Widget getBody() {
    if (listNhatKy == null || listNhatKy.length == 0) {
      return SizedBox();
      // return Center(child: Text('Kh??ng c?? nh???t k?? g???i nh???n!'));
    } else {
      return ListView(children: <Widget>[
        Container(
          child: Column(
            children: listNhatKy,
          ),
        ),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue)))
          : getBody(),
    );
  }

  String getTrangThai(int trangthai) {
    switch (trangthai) {
      case 15:
        return "??ang x??? l??";
        break;

      case 11:
        return "???? ?????n ";
      case 3:
        return "???? x??? l??";
      case 16:
        return "???? x??? l??";
      case 1:
        return "Ch??a nh???n";
      case 2:
        return "???? nh???n";
      case 13:
        return "???? nh???n";
      case 14:
        return "???? ph??n c??ng";
      case 22:
        return "T??? ch???i";
      case 12:
        return "T??? ch???i";
      case 51:
        return "?????ng ??";
      case 52:
        return "T??? ch???i";
      default:
        return "??ang x??? l??";
        break;
    }
  }
}
String GetDate(String strDt){

  // return DateFormat('yyyy-MM-dd  kk:mm')
  //     .format(DateFormat('yyyy-MM-dd kk:mm').parse(strDt));
  var parsedDate = DateTime.parse(strDt);
  return ("${parsedDate.day}/${parsedDate.month}/${parsedDate.year}  "
      "${parsedDate.hour}:${parsedDate.minute}");
}