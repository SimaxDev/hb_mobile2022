import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';

class NhatKyVBDen extends StatefulWidget
{
  final int id;
  final int nam;


  NhatKyVBDen({required this.id,required this.nam});
  @override
  _NhatKyVBDen createState() =>_NhatKyVBDen();

}


class _NhatKyVBDen extends State<NhatKyVBDen> {
  List<Widget> listNhatKy = <Widget>[];
  //RxBool isLoading = false.obs;
String ActionXLGuiNhan = "GetThongTinGuiNhan";
  var tendangnhap = "";
  bool isLoading =  false;

  @override
  void dispose() {

    // if(_timer != null){
    //   _timer.cancel();
    // }
    super.dispose();
  }


  @override
  void initState() {
    //_initializeTimer();
    super.initState();
    this.fetchData();
    this.getBody();
  }



  fetchData() async {
    // tendangnhap = sharedStorage.getString("username");
    // if(tendangnhap == null || tendangnhap == "")
    //   {
    //     tendangnhap = widget.username;


    String url = "/api/ServicesVBD/GetData";
    var parts = [];
   // parts.add('TenDangNhap=' + tendangnhap);
    parts.add('ItemID=' + widget.id.toString());
    parts.add('ActionXL=' + ActionXLGuiNhan.toString());
    parts.add('SYear='+ widget.nam.toString() );
    var formData = parts.join('&');
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = jsonDecode(response.body)['OData'];
      print('ccd $items');



        //nhatKy = items
        for(var element in items){
          var noinhan =  element['infoGroupNameReceived']['Title'];
          var noinhan1 =  element['infoGroupNameReceivedText'];
          var ten = element['infoSentByUser']['Title'];
          listNhatKy.add(
              SingleChildScrollView(child:
              new Row(
                children: [

                  element['infoUserNameReceived']['Title']!= ""
                      ? Column(children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only( left:10,top: 10, bottom: 5),
                          child: Text(element['infoSentByUser']['Title'] ,
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
                            Text  (element['infoUserNameReceived']['Title']
                               ),
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
                        // child: Text(getTrangThai(element['infoTrangThaiTiepNhan']),
                        //   style: TextStyle(fontWeight: FontWeight.bold),),
                      ),


                    ],)
                  ],):SizedBox(),

                  element['infoUserNameReceived']['Title']
                      == ""&&element['infoGroupNameReceivedText'] == ""
                      ? Column(children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only( left:10,top: 10, bottom: 5),
                          child: Text(element['infoSentByUser']['Title'] ,
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
                          child:Column(

                            children: [
                            Text  (noinhan.split("#")[1].toString(),
                            ),
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
                          (element['infoTimeSent'] != '')
                              ? (DateFormat('dd/MM/yyyy').format(DateTime.parse(element['infoTimeSent'])) ?? '')
                              : '',
                          style: TextStyle(color: Colors.black38,fontStyle: FontStyle.italic,fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,

                        ),

                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        alignment: Alignment.topRight,
                        // child: Text(getTrangThai(element['infoTrangThaiTiepNhan']),
                        //   style: TextStyle(fontWeight: FontWeight.bold),),
                      ),


                    ],)
                  ],):SizedBox(),

                  //noinhan

                      noinhan != ""&&noinhan != null
                      ? Column(children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only( left:10,top: 10, bottom: 5),
                          child: Text(element['infoSentByUser']['Title'] ,
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
                            Text  (noinhan
                            ),
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
                          (element['infoTimeSent'] != '')
                              ? (DateFormat('dd/MM/yyyy').format(DateTime.parse(element['infoTimeSent'])) ?? '')
                              : '',
                          style: TextStyle(color: Colors.black38,fontStyle: FontStyle.italic,fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,

                        ),

                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        alignment: Alignment.topRight,
                        // child: Text(getTrangThai(element['infoTrangThaiTiepNhan']),
                        //   style: TextStyle(fontWeight: FontWeight.bold),),
                      ),


                    ],)
                  ],):SizedBox(),





                  element['infoUserNameReceived']['Title']
                      == "" &&
                      noinhan == ""
                      ? Column(children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only( left:10,top: 10, bottom: 5),
                          child: Text(element['infoSentByUser']['Title'] ,
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
                            Text  (element['infoGroupNameReceivedText']
                                .contains("#")
                                ?element['infoGroupNameReceivedText'].split
        ("#")[1].toString():element['infoGroupNameReceivedText'] ),
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
                          (element['infoTimeSent'] != '')
                              ? (DateFormat('dd/MM/yyyy').format(DateTime.parse(element['infoTimeSent'])) ?? '')
                              : '',
                          style: TextStyle(color: Colors.black38,fontStyle: FontStyle.italic,fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,

                        ),

                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        alignment: Alignment.topRight,
                        // child: Text(getTrangThai(element['infoTrangThaiTiepNhan']),
                        //   style: TextStyle(fontWeight: FontWeight.bold),),
                      ),


                    ],)
                  ],):SizedBox(),




                ],
              ),)
          );

          // listNhatKy.add(new Divider());
        }
        setState(() {
          isLoading = true;
        });


    } else {
      setState(() {
        isLoading = false;
      });
      listNhatKy = [];

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body:Builder(
          builder: (BuildContext context){
            return Container(
              child:  isLoading == false ? Center(child:
              CircularProgressIndicator
                (valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue))) :
              getBody(),
            );
          },
        )




    );

  }

  Widget getBody() {
    if(listNhatKy ==null || listNhatKy.length ==0 )
      {
        return   SizedBox();

    }
    else
    {
      return ListView(
        children: [


          Container(
            child: Column(
              children:
              listNhatKy,
            ),
          )
        ],
      );
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