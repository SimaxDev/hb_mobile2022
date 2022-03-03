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

  chuyenVaoHS({this.id});

  @override
  _chuyenVaoHSState createState() => _chuyenVaoHSState();
}

class _chuyenVaoHSState extends State<chuyenVaoHS> {
  double _height;
  double _width;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _titleController1 = TextEditingController();
  bool isClick = true;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  bool toggle = true;
  List dataListThayThe = [];
  String hscv = "";
  bool isLoading = false;
  var jsonSample = "";
  bool showD = true;
  int hosoid;
  String testthuhomerxoa;
  String ActionXL = "GetListHSCV";
  List<dynamic> jsonL = [];
  var columns = [
    JsonTableColumn(
       "hscvNgayMoHoSo",
        label: "Ngày mở hồ sơ",valueBuilder:formatDOB
   ),
    JsonTableColumn("hscvNguoiLap.Title", label: "Người lập"),
    JsonTableColumn("Title", label: "Tên hồ sơ công việc"),
    JsonTableColumn("hscvTrangThaiXuLy", label: "Trạng thái",valueBuilder:ttHoSo),
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
      GetDataHSCV1();
    });
  }
  @override
  void dispose() {
    super.dispose();

    EasyLoading.dismiss();
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

  GetDataByKeyWordHSCV(String text) async {
    var tendangnhap = sharedStorage.getString("username");
    //EasyLoading.show();
    hscv = await getDataByKeyWordHSCV(tendangnhap, ActionXL, text);
    setState(() {
      jsonL = jsonDecode(hscv)['OData'];
     // EasyLoading.dismiss();
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Gửi công việc vào hồ sơ"),
          automaticallyImplyLeading:
      false),
      body: buildTree(),
    );
  }

  Widget buildTree() {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return RefreshIndicator(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Container(
                    // height: MediaQuery.of(context).size.height * .60,
                      child: Column(
                        children: <Widget>[

                          SizedBox(
                            height: 5,
                          ),
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
                                                style: TextStyle(color: Colors.black26),
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

                                                    GetDataByKeyWordHSCV(testthuhomerxoa);
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
                                                  GetDataHSCV1();
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
                          // Container(
                          //   height: 400,
                          //   child: SimpleTable(),),
                          jsonL == null || jsonL.length == 0
                              ? Center(
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                              ))
                              : Container(
                            //height: MediaQuery.of(context).size.height *1,
                              padding: EdgeInsets.only(left: 16,right: 16,bottom: 16),
                              child: Column(
                                children: [
                                  //Decode your json string

//Simply pass this column list to JsonTable
                                  JsonTable(
                                    jsonL,
                                    columns: columns,
                                    allowRowHighlight: true,
                                    rowHighlightColor: Colors.yellow[500].withOpacity(0.7),
                                    paginationRowCount: 10,
                                    onRowSelect: (index, map) {
                                     // print(index);
                                      //print(map);
                                      print(map['ID']);
                                      hosoid =  map['ID'];
                                    },
                                  )
                                ],
                              )
                            // : Center(
                            //     child: Text(getPrettyJSONString(jsonSample)),
                            //   ),
                          )
                        ],
                      )),

                  // Container()
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                                 hosoid);
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
              ),
            ],
          ),
        ),
        onRefresh: onRefresh);
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