import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/core/services/hoSoCVService.dart';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';
import 'dart:convert';
import 'package:json_table/json_table.dart';

class chuyenVaoHS extends StatefulWidget {
  final int id;
  final String  nam;

  chuyenVaoHS({this.id,this.nam});

  @override
  _chuyenVaoHSState createState() => _chuyenVaoHSState();
}

class _chuyenVaoHSState extends State<chuyenVaoHS> {
  ScrollController _scrollerController = new ScrollController();
  int skip = 1;
  int pageSize = 10;
  int skippage = 0;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _titleController1 = TextEditingController();
  bool isClick = true;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  bool toggle = true;
  List dataListThayThe = [];
  String hscv = "";
  bool isLoading = true;
  var jsonSample = "";
  bool showD = true;
  int hosoid;
  String testthuhomerxoa;
  String ActionXL = "GetListHSCV";
  List<dynamic> jsonL = [];
  List HoSoList = [];
  var tongso = 0;
  bool chckSwitch = false;
  var columns = [
    JsonTableColumn(
       "hscvNgayMoHoSo",
        label: "Ngày mở hồ sơ",valueBuilder:formatDOB
   ),
    JsonTableColumn("hscvNguoiLap.Title" ,label: "Người lập",
        defaultValue: ""
        "NA"),
    JsonTableColumn("Title", label: "Tên hồ sơ công việc",defaultValue: "NA"),
    JsonTableColumn("hscvTrangThaiXuLy", label: "Trạng thái",
        valueBuilder:ttHoSo),
  ];


  Future<Null> onRefresh() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      hscv;
    });

    return null;
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      // if(dropdownValue == null || dropdownValue == ""){
      //   dropdownValue = "2021";
      // }
      // hscv;
      GetDataHSCV();
    });
  }
  @override
  void dispose() {
    super.dispose();

    EasyLoading.dismiss();
  }

  Future GetDataHSCV() async {
    if (tongso != null) if ((tongso - (skip) * pageSize < 0)) {
      pageSize = tongso - (skip - 1) * pageSize;
      chckSwitch = true;
      // return _buildProgressIndicator();

    } else {
      pageSize = 10;
    }

    String vbhs = "";
    vbhs = await getDataHomeHSCV(ActionXL, "intType=-4&hscvTrangThaiXuLy=-1&i"
        "sHoSocongviec=true",skip,pageSize,);
    if (mounted) {
      setState(() {
        HoSoList.addAll(json.decode(vbhs)['OData']);

        // dataList += json.decode(vbden)['OData'];

        tongso = json.decode(vbhs)['TotalCount'];
        isLoading = false;
        _scrollerController.addListener(() {
          if (chckSwitch != true) {
            if (_scrollerController.position.pixels ==
                _scrollerController.position.maxScrollExtent) {
              GetDataHSCV();
              // GetDataByKeyYearVBDen(dropdownValue);
              HoSoList;
            }
          }
        });
      });
    }
    // vbhs = await getDataHomeVBDT(skip, pageSize, ActionXL,widget.urlLoaiVB,year);
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    if (mounted) {
      setState(() {
        HoSoList;

        // GetDataHSCV();
      });
    }

    return null;
  }
  GetDataHSCV1() async {
    //EasyLoading.show();
  var tendangnhap = sharedStorage.getString("username");
  hscv = await getDataByKeyWordHSCV(tendangnhap, ActionXL, "");

  setState(() {
    jsonL = jsonDecode(hscv)['OData'];
    //EasyLoading.dismiss();
  });
  }

  GetDataByKeyWordVBDT(String text) async {
    var tendangnhap = sharedStorage.getString("username");
    String vbtimkiem = await getDataByKeyWordHSCV(tendangnhap, ActionXL, text);
    setState(() {
      HoSoList = json.decode(vbtimkiem)['OData'];
      tongso = json.decode(vbtimkiem)['TotalCount'];
      isLoading == false;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Gửi công việc vào hồ sơ"),
          automaticallyImplyLeading:
      false),
      body:  Container(color: Colors.white,
        child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Container(
                  // height: MediaQuery.of(context).size.height * .60,
                    child: Column(
                      children: <Widget>[


                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,

                          children: [
                            Container(
                              // width: MediaQuery.of(context).size.width * 0.46,
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: Row(
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      height: MediaQuery.of(context).size.height * 0.06,
                                      margin: EdgeInsets.all(10),
                                      // padding: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black26, // Set border color
                                        ), // Set border width
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)), // Set rounded corner radius
                                        // Make rounded corner of border
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width * 0.4,
                                            child: TextField(
                                              autofocus: false,
                                              cursorColor: Colors.black26,
                                              style: TextStyle(color: Colors.black),
                                              controller: _titleController,
                                              decoration: InputDecoration(
                                                hintStyle: TextStyle(fontSize: 17),
                                                hintText: 'Tìm kiếm',
                                                prefixIcon: Icon(Icons.search, color: Colors.black26, size: 20.0),
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(left: 0.0, top: 5.0,),
                                              ),
                                              onChanged: (val) {
                                                setState(() {

                                                  showD = false;
                                                  testthuhomerxoa = val;

                                                  GetDataByKeyWordVBDT(testthuhomerxoa);
                                                });
                                              },
                                            ),
                                          ),
                                          !showD
                                              ? InkWell(
                                            child: Container(
                                              width: MediaQuery.of(context).size.width * 0.07,

                                              child: Text(
                                                "X",
                                                textAlign: TextAlign.end,
                                                style: TextStyle(fontSize: 18, color: Colors.black, fontWeight:
                                                FontWeight.bold),
                                              ),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                _titleController.text = "";
                                                testthuhomerxoa = "";
                                                GetDataHSCV();
                                                showD = true;
                                              });
                                            },
                                          )
                                              : SizedBox()
                                        ],
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),



//                       jsonL == null || jsonL.length == 0
//                           ? Center(
//                           child: CircularProgressIndicator(
//                             valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
//                           ))
//                           : Container(
//                         //height: MediaQuery.of(context).size.height *1,
//                           padding: EdgeInsets.only(left: 16,right: 16,bottom: 16),
//                           child: Column(
//                             children: [
//                               //Decode your json string
//
// //Simply pass this column list to JsonTable
//                               JsonTable(
//                                 jsonL,showColumnToggle: true,
//                                 columns: columns,
//                                 allowRowHighlight: true,
//                                 rowHighlightColor: Colors.yellow[500].withOpacity(0.7),
//                                 paginationRowCount: 10,
//                                 onRowSelect: (index, map) {
//                                   // print(index);
//                                   //print(map);
//                                   print(map['ID']);
//                                   hosoid =  map['ID'];
//                                 },
//                               )
//                             ],
//                           )
//                         // : Center(
//                         //     child: Text(getPrettyJSONString(jsonSample)),
//                         //   ),
//                       )
                      ],
                    )),

                // Container()
              ],
            ),),
          Expanded(flex: 7,
            child: Container(child:bodyContent() ,),
          ),
          Expanded(
            flex: 1,child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, right: 20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.lightBlue[50], width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: TextButton.icon(
                      icon: Icon(Icons.delete_forever_outlined),
                      label: Text(
                        "Đóng",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.lightBlue[50], width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: TextButton.icon(
                      icon: Icon(Icons.send_outlined),
                      label: Text(
                        "Chuyển",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () async {
                        var thanhcong = null;
                        EasyLoading.show();
                        thanhcong =  await postChuyenHS( widget.id, "ChuyenVaoHSCVV2",
                            hosoid,widget.nam);
                        EasyLoading.dismiss();
                        Navigator.of(context).pop();

                        showAlertDialog(context, json.decode(thanhcong)['Message']);

                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue[50]),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      )),
                ),
              ),
            ],
          ) ,
          )
          ,
        ],
      ),)
    );
  }

  int selectedIndex = -1;
  bodyContent() {
       if (HoSoList == null || HoSoList.length < 0 || isLoading) {
      return Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ));
    } else if (HoSoList.length == 0) {
      return Center(
        child: Text("Không có bản ghi"),
      );
    }
    return RefreshIndicator(
        key: refreshKey,
        child: ListView.builder(
          controller: _scrollerController,
          itemCount: HoSoList == null ? 0 : HoSoList.length + 1,
          itemBuilder: (context, index) {
            if (index == HoSoList.length) {
              return _buildProgressIndicator();
            } else {
              return getCard(HoSoList[index]);
            }
          },
        ),
        onRefresh: refreshList);
  }
  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
  Widget getCard(item) {
    var hscvNguoiLap = item['hscvNguoiLap']['Title'] != null
        ? item['hscvNguoiLap']['Title']
        : 0;
    var Title = item['Title'] != null ? item['Title'] : "";
    var sMIDField = item['ID'] != null ? item['ID'] : 0;
    var temp = DateFormat("yyyy-MM-dd").parse(item['hscvNgayMoHoSo']) != null
        ? DateFormat("yyyy-MM-dd").parse(item['hscvNgayMoHoSo'])
        : DateFormat("yyyy-MM-dd").parse(item['hscvNgayMoHoSo']);
    var hscvNgayMoHoSo = DateFormat("dd-MM-yyyy").format(temp);

    var temp1 = item['hscvHanXuLy'] != null
        ? DateFormat("yyyy-MM-dd").parse(item['hscvHanXuLy'])
        : "";
    var hscvHanXuLy;
    if (temp1 != null && temp1 != "") {
      hscvHanXuLy = DateFormat("dd-MM-yyyy").format(temp1);
    }

    return Card(
      child: ListTile(
         selected: selectedIndex == sMIDField? true: false,
        selectedTileColor: Colors.blue[100],
        trailing: Column(children: [
          Text(
          "Ngày mở hồ sơ:" ,
            style: TextStyle(height: 1.5,fontSize: 13,),
          ),
          Text(
            hscvNgayMoHoSo,
            style: TextStyle(height: 1.5,fontSize: 13,),
          ),
        ],),
        title: Text(
          Title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700),
        ),
        subtitle: Row(children: [
          Text(
            "Người lập: ",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.black,height: 1.5,
                fontSize: 16,fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700
               ),
          ),
          Text(
            hscvNguoiLap,
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,fontStyle: FontStyle.italic,
                height: 1.5,
                fontWeight: FontWeight.w600),
          ),
        ],),
        onTap: () {
          setState(() {
            selectedIndex = sMIDField;
            hosoid=sMIDField;
          });
        },
      ),
    );
  }
}

String formatDOB(value){
  return DateFormat('dd-MM-yy')
      .format(DateFormat('yy-MM-dd').parse(value));
  // var parsedDate = DateTime.parse(strDt);
  // return ("${parsedDate.day}/${parsedDate.month}/${parsedDate.year}");
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
    case 2:
      tt = "Đã quá hạn";
      break;
    case 3:
      tt = "Đang dự thảo VB";
      break;
    case 4:
      tt = "Đã được duyệt";
      break;
    case 5:
      tt = "Đã trả về ";
      break;

  }
  return tt;
}