import 'dart:async';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:hb_mobile2021/core/services/VbdenService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'dart:convert';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';

class TreeChuyenVBDen extends StatefulWidget {
  final int id;
  final int nam;

  TreeChuyenVBDen({this.id,this.nam});

  @override
  _TreeChuyenVBDenState createState() => _TreeChuyenVBDenState();
}

class _TreeChuyenVBDenState extends State<TreeChuyenVBDen> {
  final TreeController _treeController = TreeController(allNodesExpanded: false);
  String ActionXL1 = "GetTreeDonViV2";
  List chitiet = [];
  List<ListData1> listData;
  var existingItem;
  bool checkedValue = false;
  Map<String, String> lstUser = new Map<String, String>();
  Map<String, String> lstUserCBXDB = new Map<String, String>();
  String valueselected = "";
 Map<String, int> valuesRadio = new Map<String, int>();
  Map<String, bool> values = new Map<String, bool>();
  Map<String, bool> valuesPH = new Map<String, bool>();
  Map<String, bool> valuesXDB = new Map<String, bool>();
  String textXLC = "";
  String textPT = "";
  String textPH = "";
  String textXDB = "";
  String lst;
  double _height;
  double _width;
  DateTime _dateTime;
  DateTime selectedDate = DateTime.now();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  String _setDate;
  String _setDate1;
  bool PH = false;
  bool isClick = true;
  bool isClickPT = true;
  bool isClick1 = true;
  bool isClick2 = true;
  bool isLoading = false;
  String lstUserPH  =  "";
  String lstUserXDB  =  "";
  String lstUserXLC = "";
  String lstUserPT = "";
  String cayPH = "";
  String cayPT = "";
  String cayXLC = "";
  String cayXDB = "";
  String selcb = "";


  @override
  void initState() {
    //_initializeTimer();
    super.initState();
    var tendangnhap = sharedStorage.getString("username");
    GetDataDetailVBDi(tendangnhap);
  }
  @override
  void dispose() {
    super.dispose();
    currentUserID;
    lstUserXLC;
    lstUserXDB ;
    lstUserPT ;
    lstUserPH ;
    selcb ;


    EasyLoading.dismiss();
  }
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));
    if (picked != null)
      if (mounted) {setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      }); }

  }

  int tong = 0;

  Map<String, bool> GetTT(List TT) {
    Map<String, bool> vls = new Map<String, bool>();
    for (int i = 0; i < TT.length; i++) {
      String vl = "";
      if (TT[i]["isUser"]) {
        vl = TT[i]['key'].toString() + "U";
      } else
        vl = TT[i]['key'].toString();
      tong++;
      vls.putIfAbsent(vl, () => false);
      if (TT[i]["children"].length > 0) {
        vls.addAll(GetTT(TT[i]["children"]));
      }
    }
    return vls;
  }

  Future GetDataDetailVBDi(String tendangnhap) async {
    String detailVBDi = await getDataCVBD(tendangnhap, ActionXL1);
    if (mounted) { setState(() {
      chitiet = json.decode(detailVBDi)['OData'][0]['children'];
      values = GetTT(chitiet);
      valuesPH = GetTT(chitiet);
      valuesXDB = GetTT(chitiet);

    });}

  }

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children:
    <Widget>[buildTree()]);
  }

  Widget buildTreePT() {
    var parsedJson;
    try {
           if(chitiet.length>0)
        {
             parsedJson = chitiet;
         }
            else
              {
                  return Center(
                    child: CircularProgressIndicator() ,);
              }

      return TreeView(
        nodes: toTreeNodesRadioPT(parsedJson),
        treeController: _treeController,
      );
    } on FormatException catch (e) {
      return Text(e.message);
    }
  }
  Widget buildTreeCBC() {
    var parsedJson;
    try {
           if(chitiet.length>0)
        {
             parsedJson = chitiet;
         }
            else
              {
                  return Center(
                    child: CircularProgressIndicator() ,);
              }

      return TreeView(
        nodes: toTreeNodesRadio(parsedJson),
        treeController: _treeController,
      );
    } on FormatException catch (e) {
      return Text(e.message);
    }
  }

  Widget buildTreePhu() {
    var parsedJson;
    try {
      if(chitiet.length>0)
      {
        parsedJson = chitiet;
      }
      else{
       return Center(
          child: CircularProgressIndicator() ,);
      }

      return parsedJson != null
          ? TreeView(
              nodes: toTreeNodesPH(parsedJson),
              treeController: _treeController,
            )
          : CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue));
    } on FormatException catch (e) {
      return Text(e.message);
    }
  }
  Widget buildTreePhuXDB() {
    var parsedJson;
    try {
      if(chitiet.length>0)
      {
        parsedJson = chitiet;
      }
      else{
        return Center(
          child: CircularProgressIndicator() ,);
      }

      return parsedJson != null
          ? TreeView(
              nodes: toTreeNodesXDB(parsedJson),
              treeController: _treeController,
            )
          : CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue));
    } on FormatException catch (e) {
      return Text(e.message);
    }
  }

  /// Builds tree or error message out of the entered content.
  Widget buildTree() {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
      // var parsedJson = chitiet;
      return notIsQuanTriNew == true ?
      ((!ispGuiXuLyChinh)
          ?Column(
        // mainAxisAlignment: MainAxisAlignment.end,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Column(
            children: [
              Row(
                children: [
                  Container(

                    margin: EdgeInsets.only(left: 10),
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Text('Phụ trách:', style:
                    TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  FlatButton(
                    onPressed: () {
                      if (mounted) { setState(() {
                        isClickPT = !isClickPT;
                      }); }

                    },
                    child: Padding(padding: EdgeInsets.only(left: 3), child: Container(

                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black38, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.7,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.05,
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Align(
                            child: textPT == "" ? Text(
                              "Chọn cán bộ phục trách",
                              style: TextStyle(
                                  color: Colors.black45
                              ),


                            ) :
                            Text(textPT,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.8)
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,

                            )
                        )
                    ),),
                  ),
                ],
              ),
              isClickPT
                  ? SizedBox()
                  : Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.9,
                child: buildTreePT(),
              ),

              // Container()
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Text(
                      'Phối hợp:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      if (mounted) {setState(() {
                        isClick1 = !isClick1;
                      }); }

                    },
                    child: Padding(padding: EdgeInsets.only(left: 3),
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.7,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.05,
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Align(
                              child: textPH == "" ? Text(
                                "Chọn cán bộ phối hợp",
                                style: TextStyle(
                                    color: Colors.black45
                                ),


                              ) :
                              Text(textPH,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8)
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,

                              )
                          )
                      ),),
                  ),
                ],
              ),

              isClick1
                  ? SizedBox()
                  : Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.9,
                child: buildTreePhu(),
              ),

              // Container()
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Text('Xem để biết:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  FlatButton(
                    onPressed: () {
                      if (mounted) { setState(() {
                        isClick2 = !isClick2;
                      }); }

                    },
                    child: Padding(padding: EdgeInsets.only(left: 3), child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black38, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.7,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.05,
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Align(
                            child: textXDB == "" ? Text(
                              "Chọn cán bộ xem để biết",
                              style: TextStyle(
                                  color: Colors.black45
                              ),


                            ) :
                            Text(textXDB,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.8)
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,

                            )
                        )
                    ),),
                  ),
                ],
              ),

              isClick2
                  ? SizedBox()
                  : Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.9,
                child: buildTreePhuXDB(),
              ),

              // Container()
            ],
          ),
          Container(
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.blueAccent)
            // ),
            child: Padding(
                padding: const EdgeInsets.only( top: 5),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text('Ý kiến:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black38, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.05,
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Theme(
                          data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                          child: TextField(
                            autofocus: false,
                            cursorColor: Colors.black,
                            style: TextStyle(color: Colors.black),
                            controller: _titleController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'Nhập ý kiến',
                              hintStyle: TextStyle(color: Colors.black45),
                              // contentPadding: EdgeInsets.only(left: 10.0, top: 15.0),
                            ),
                            onChanged: null,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.only(top: 20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.lightBlue[50], width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.3,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.06,
                  child:TextButton.icon (
                      icon: Icon(Icons.send_rounded),
                      label: Text("Chuyển",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
                        textAlign:
                        TextAlign.center,),
                      onPressed: () async {
                        var tendangnhap = sharedStorage.getString("username");
                        String userYKien = _titleController.text;
                        var userDuocCHon = "";
                        if(!userDuocCHon.contains(lstUserPT))
                          userDuocCHon += lstUserPT+ "^";
                        if(!userDuocCHon.contains(lstUserXLC))
                          userDuocCHon += lstUserXLC+ "^";
                        for( var item in lstUserXDB.split("^"))
                          if(!userDuocCHon.contains(item))
                            userDuocCHon += item+ "^";
                        for( var item in lstUserPH.split("^"))
                          if(!userDuocCHon.contains(item))
                            userDuocCHon += item + "^";
                        if( userDuocCHon != null && userDuocCHon.length >0)
                        {
                          userDuocCHon =  userDuocCHon.substring(0,userDuocCHon.length-1);
                        }

                        if(cayPH != null && cayPH.length>0)
                        {
                          for(var item in cayPH.split(","))
                            if(cayXDB.contains(item) && item!= null && item
                                .isNotEmpty)
                              selcb += item + ",";
                          if(selcb != null && selcb.length>0)
                            selcb =  selcb.substring(0,selcb.length-1);
                        }

                        EasyLoading.show();
                        var thanhcong =  await postChuyenVBD(tendangnhap, widget.id, "ChuyenVB",userDuocCHon,lstUserXDB,
                            lstUserXLC,
                            lstUserPH,selcb,userYKien,widget.nam,lstUserPT);
                        userDuocCHon = "";
                        lstUserXDB = "";
                        lstUserXLC = "";
                        lstUserPT = "";
                        lstUserPH = "";
                        selcb = "";
                        userYKien = "";

                        EasyLoading.dismiss();
                        Navigator.of(context).pop();
                        showAlertDialog(context, json.decode(thanhcong)['Message']);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue[50]),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      )
                  ),),
              ),
              Padding(padding: EdgeInsets.only(top: 20,left: 20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.lightBlue[50], width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.25,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.06,
                  child:TextButton.icon (
                      icon: Icon(Icons.delete_forever_outlined),
                      label: Text("Đóng",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),textAlign:
                      TextAlign.center,),
                      onPressed: ()  {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      )
                  ),),
              ),

            ],),

        ],
      )
          :Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(

                      margin: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text('Phụ trách:', style:
                      TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    FlatButton(
                      onPressed: () {
                        if (mounted) { setState(() {
                          isClickPT = !isClickPT;
                        }); }

                      },
                      child: Padding(padding: EdgeInsets.only(left: 3), child: Container(

                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.7,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.05,
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Align(
                              child: textPT == "" ? Text(
                                "Chọn cán bộ phục trách",
                                style: TextStyle(
                                    color: Colors.black45
                                ),


                              ) :
                              Text(textPT,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8)
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,

                              )
                          )
                      ),),
                    ),
                  ],
                ),
                isClickPT
                    ? SizedBox()
                    : Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  child: buildTreePT(),
                ),

                // Container()
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(

                      margin: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text('Xử lý chính:', style:
                      TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    FlatButton(
                      onPressed: () {
                        if (mounted) { setState(() {
                          isClick = !isClick;
                        }); }

                      },
                      child: Padding(padding: EdgeInsets.only(left: 3), child: Container(

                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.7,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.05,
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Align(
                              child: textXLC == "" ? Text(
                                "Chọn cán bộ xử lý chính",
                                style: TextStyle(
                                    color: Colors.black45
                                ),


                              ) :
                              Text(textXLC,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8)
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,

                              )
                          )
                      ),),
                    ),
                  ],
                ),
                isClick
                    ? SizedBox()
                    : Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  child: buildTreeCBC(),
                ),

                // Container()
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text(
                        'Phối hợp:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        if (mounted) {setState(() {
                          isClick1 = !isClick1;
                        }); }

                      },
                      child: Padding(padding: EdgeInsets.only(left: 3),
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black38, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.7,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.05,
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Align(
                                child: textPH == "" ? Text(
                                  "Chọn cán bộ phối hợp",
                                  style: TextStyle(
                                      color: Colors.black45
                                  ),


                                ) :
                                Text(textPH,
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.8)
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,

                                )
                            )
                        ),),
                    ),
                  ],
                ),

                isClick1
                    ? SizedBox()
                    : Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  child: buildTreePhu(),
                ),

                // Container()
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text('Xem để biết:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    FlatButton(
                      onPressed: () {
                        if (mounted) { setState(() {
                          isClick2 = !isClick2;
                        }); }

                      },
                      child: Padding(padding: EdgeInsets.only(left: 3), child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.7,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.05,
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Align(
                              child: textXDB == "" ? Text(
                                "Chọn cán bộ xem để biết",
                                style: TextStyle(
                                    color: Colors.black45
                                ),


                              ) :
                              Text(textXDB,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8)
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,

                              )
                          )
                      ),),
                    ),
                  ],
                ),

                isClick2
                    ? SizedBox()
                    : Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  child: buildTreePhuXDB(),
                ),

                // Container()
              ],
            ),
            Container(
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.blueAccent)
              // ),
              child: Padding(
                  padding: const EdgeInsets.only( top: 5),
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: Text('Ý kiến:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * 0.05,
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                            child: TextField(
                              autofocus: false,
                              cursorColor: Colors.black,
                              style: TextStyle(color: Colors.black),
                              controller: _titleController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: 'Nhập ý kiến',
                                hintStyle: TextStyle(color: Colors.black45),
                                // contentPadding: EdgeInsets.only(left: 10.0, top: 15.0),
                              ),
                              onChanged: null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.only(top: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue[50], width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.3,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.06,
                    child:TextButton.icon (
                        icon: Icon(Icons.send_rounded),
                        label: Text("Chuyển",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
                          textAlign:
                          TextAlign.center,),
                        onPressed: () async {
                          var tendangnhap = sharedStorage.getString("username");
                          String userYKien = _titleController.text;
                          var userDuocCHon = "";
                          if(!userDuocCHon.contains(lstUserPT))
                            userDuocCHon += lstUserPT+ "^";
                          if(!userDuocCHon.contains(lstUserXLC))
                            userDuocCHon += lstUserXLC+ "^";
                          for( var item in lstUserXDB.split("^"))
                            if(!userDuocCHon.contains(item))
                              userDuocCHon += item+ "^";
                          for( var item in lstUserPH.split("^"))
                            if(!userDuocCHon.contains(item))
                              userDuocCHon += item + "^";
                          if( userDuocCHon != null && userDuocCHon.length >0)
                          {
                            userDuocCHon =  userDuocCHon.substring(0,userDuocCHon.length-1);
                          }

                          if(cayPH != null && cayPH.length>0)
                          {
                            for(var item in cayPH.split(","))
                              if(cayXDB.contains(item) && item!= null && item
                                  .isNotEmpty)
                                selcb += item + ",";
                            if(selcb != null && selcb.length>0)
                              selcb =  selcb.substring(0,selcb.length-1);
                          }

                          EasyLoading.show();
                          var thanhcong =  await postChuyenVBD(tendangnhap, widget.id, "ChuyenVB",userDuocCHon,lstUserXDB,
                              lstUserXLC,
                              lstUserPH,selcb,userYKien,widget.nam,lstUserPT);
                          userDuocCHon = "";
                          lstUserXDB = "";
                          lstUserXLC = "";
                          lstUserPT = "";
                          lstUserPH = "";
                          selcb = "";
                          userYKien = "";

                          EasyLoading.dismiss();
                          Navigator.of(context).pop();
                          showAlertDialog(context, json.decode(thanhcong)['Message']);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue[50]),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        )
                    ),),
                ),
                Padding(padding: EdgeInsets.only(top: 20,left: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue[50], width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.25,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.06,
                    child:TextButton.icon (
                        icon: Icon(Icons.delete_forever_outlined),
                        label: Text("Đóng",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),textAlign:
                        TextAlign.center,),
                        onPressed: ()  {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        )
                    ),),
                ),

              ],),

          ],
        ))
            :(isQTNew == true?(
          (!ispGuiXuLyChinh)?(
            (groupID == 198
                ?Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(

                      margin: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text('Xử lý chính:', style:
                      TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    FlatButton(
                      onPressed: () {
                        if (mounted) { setState(() {
                          isClick = !isClick;
                        }); }

                      },
                      child: Padding(padding: EdgeInsets.only(left: 3), child: Container(

                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.7,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.05,
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Align(
                              child: textXLC == "" ? Text(
                                "Chọn cán bộ xử lý chính",
                                style: TextStyle(
                                    color: Colors.black45
                                ),


                              ) :
                              Text(textXLC,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8)
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,

                              )
                          )
                      ),),
                    ),
                  ],
                ),
                isClick
                    ? SizedBox()
                    : Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  child: buildTreeCBC(),
                ),

                // Container()
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text(
                        'Phối hợp:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        if (mounted) {setState(() {
                          isClick1 = !isClick1;
                        }); }

                      },
                      child: Padding(padding: EdgeInsets.only(left: 3),
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black38, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.7,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.05,
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Align(
                                child: textPH == "" ? Text(
                                  "Chọn cán bộ phối hợp",
                                  style: TextStyle(
                                      color: Colors.black45
                                  ),


                                ) :
                                Text(textPH,
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.8)
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,

                                )
                            )
                        ),),
                    ),
                  ],
                ),

                isClick1
                    ? SizedBox()
                    : Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  child: buildTreePhu(),
                ),

                // Container()
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text('Xem để biết:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    FlatButton(
                      onPressed: () {
                        if (mounted) { setState(() {
                          isClick2 = !isClick2;
                        }); }

                      },
                      child: Padding(padding: EdgeInsets.only(left: 3), child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.7,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.05,
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Align(
                              child: textXDB == "" ? Text(
                                "Chọn cán bộ xem để biết",
                                style: TextStyle(
                                    color: Colors.black45
                                ),


                              ) :
                              Text(textXDB,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8)
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,

                              )
                          )
                      ),),
                    ),
                  ],
                ),

                isClick2
                    ? SizedBox()
                    : Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  child: buildTreePhuXDB(),
                ),

                // Container()
              ],
            ),
            Container(
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.blueAccent)
              // ),
              child: Padding(
                  padding: const EdgeInsets.only( top: 5),
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: Text('Ý kiến:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * 0.05,
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                            child: TextField(
                              autofocus: false,
                              cursorColor: Colors.black,
                              style: TextStyle(color: Colors.black),
                              controller: _titleController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: 'Nhập ý kiến',
                                hintStyle: TextStyle(color: Colors.black45),
                                // contentPadding: EdgeInsets.only(left: 10.0, top: 15.0),
                              ),
                              onChanged: null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.only(top: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue[50], width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.3,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.06,
                    child:TextButton.icon (
                        icon: Icon(Icons.send_rounded),
                        label: Text("Chuyển",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
                          textAlign:
                          TextAlign.center,),
                        onPressed: () async {
                          var tendangnhap = sharedStorage.getString("username");
                          String userYKien = _titleController.text;
                          var userDuocCHon = "";
                          if(!userDuocCHon.contains(lstUserPT))
                            userDuocCHon += lstUserPT+ "^";
                          if(!userDuocCHon.contains(lstUserXLC))
                            userDuocCHon += lstUserXLC+ "^";
                          for( var item in lstUserXDB.split("^"))
                            if(!userDuocCHon.contains(item))
                              userDuocCHon += item+ "^";
                          for( var item in lstUserPH.split("^"))
                            if(!userDuocCHon.contains(item))
                              userDuocCHon += item + "^";
                          if( userDuocCHon != null && userDuocCHon.length >0)
                          {
                            userDuocCHon =  userDuocCHon.substring(0,userDuocCHon.length-1);
                          }

                          if(cayPH != null && cayPH.length>0)
                          {
                            for(var item in cayPH.split(","))
                              if(cayXDB.contains(item) && item!= null && item
                                  .isNotEmpty)
                                selcb += item + ",";
                            if(selcb != null && selcb.length>0)
                              selcb =  selcb.substring(0,selcb.length-1);
                          }

                          EasyLoading.show();
                          var thanhcong =  await postChuyenVBD(tendangnhap, widget.id, "ChuyenVB",userDuocCHon,lstUserXDB,
                              lstUserXLC,
                              lstUserPH,selcb,userYKien,widget.nam,lstUserPT);
                          userDuocCHon = "";
                          lstUserXDB = "";
                          lstUserXLC = "";
                          lstUserPT = "";
                          lstUserPH = "";
                          selcb = "";
                          userYKien = "";

                          EasyLoading.dismiss();
                          Navigator.of(context).pop();
                          showAlertDialog(context, json.decode(thanhcong)['Message']);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue[50]),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        )
                    ),),
                ),
                Padding(padding: EdgeInsets.only(top: 20,left: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue[50], width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.25,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.06,
                    child:TextButton.icon (
                        icon: Icon(Icons.delete_forever_outlined),
                        label: Text("Đóng",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),textAlign:
                        TextAlign.center,),
                        onPressed: ()  {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        )
                    ),),
                ),

              ],),

          ],
        ):
        Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(

                      margin: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text('Xử lý chính:', style:
                      TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    FlatButton(
                      onPressed: () {
                        if (mounted) { setState(() {
                          isClick = !isClick;
                        }); }

                      },
                      child: Padding(padding: EdgeInsets.only(left: 3), child: Container(

                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.7,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.05,
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Align(
                              child: textXLC == "" ? Text(
                                "Chọn cán bộ xử lý chính",
                                style: TextStyle(
                                    color: Colors.black45
                                ),


                              ) :
                              Text(textXLC,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8)
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,

                              )
                          )
                      ),),
                    ),
                  ],
                ),
                isClick
                    ? SizedBox()
                    : Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  child: buildTreeCBC(),
                ),

                // Container()
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text(
                        'Phối hợp:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        if (mounted) {setState(() {
                          isClick1 = !isClick1;
                        }); }

                      },
                      child: Padding(padding: EdgeInsets.only(left: 3),
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black38, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.7,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.05,
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Align(
                                child: textPH == "" ? Text(
                                  "Chọn cán bộ phối hợp",
                                  style: TextStyle(
                                      color: Colors.black45
                                  ),


                                ) :
                                Text(textPH,
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.8)
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,

                                )
                            )
                        ),),
                    ),
                  ],
                ),

                isClick1
                    ? SizedBox()
                    : Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  child: buildTreePhu(),
                ),

                // Container()
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text('Xem để biết:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    FlatButton(
                      onPressed: () {
                        if (mounted) { setState(() {
                          isClick2 = !isClick2;
                        }); }

                      },
                      child: Padding(padding: EdgeInsets.only(left: 3), child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.7,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.05,
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Align(
                              child: textXDB == "" ? Text(
                                "Chọn cán bộ xem để biết",
                                style: TextStyle(
                                    color: Colors.black45
                                ),


                              ) :
                              Text(textXDB,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8)
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,

                              )
                          )
                      ),),
                    ),
                  ],
                ),

                isClick2
                    ? SizedBox()
                    : Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  child: buildTreePhuXDB(),
                ),

                // Container()
              ],
            ),
            Container(
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.blueAccent)
              // ),
              child: Padding(
                  padding: const EdgeInsets.only( top: 5),
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: Text('Ý kiến:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * 0.05,
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                            child: TextField(
                              autofocus: false,
                              cursorColor: Colors.black,
                              style: TextStyle(color: Colors.black),
                              controller: _titleController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: 'Nhập ý kiến',
                                hintStyle: TextStyle(color: Colors.black45),
                                // contentPadding: EdgeInsets.only(left: 10.0, top: 15.0),
                              ),
                              onChanged: null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.only(top: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue[50], width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.3,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.06,
                    child:TextButton.icon (
                        icon: Icon(Icons.send_rounded),
                        label: Text("Chuyển",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
                          textAlign:
                          TextAlign.center,),
                        onPressed: () async {
                          var tendangnhap = sharedStorage.getString("username");
                          String userYKien = _titleController.text;
                          var userDuocCHon = "";
                          if(!userDuocCHon.contains(lstUserPT))
                            userDuocCHon += lstUserPT+ "^";
                          if(!userDuocCHon.contains(lstUserXLC))
                            userDuocCHon += lstUserXLC+ "^";
                          for( var item in lstUserXDB.split("^"))
                            if(!userDuocCHon.contains(item))
                              userDuocCHon += item+ "^";
                          for( var item in lstUserPH.split("^"))
                            if(!userDuocCHon.contains(item))
                              userDuocCHon += item + "^";
                          if( userDuocCHon != null && userDuocCHon.length >0)
                          {
                            userDuocCHon =  userDuocCHon.substring(0,userDuocCHon.length-1);
                          }

                          if(cayPH != null && cayPH.length>0)
                          {
                            for(var item in cayPH.split(","))
                              if(cayXDB.contains(item) && item!= null && item
                                  .isNotEmpty)
                                selcb += item + ",";
                            if(selcb != null && selcb.length>0)
                              selcb =  selcb.substring(0,selcb.length-1);
                          }

                          EasyLoading.show();
                          var thanhcong =  await postChuyenVBD(tendangnhap, widget.id, "ChuyenVB",userDuocCHon,lstUserXDB,
                              lstUserXLC,
                              lstUserPH,selcb,userYKien,widget.nam,lstUserPT);
                          userDuocCHon = "";
                          lstUserXDB = "";
                          lstUserXLC = "";
                          lstUserPT = "";
                          lstUserPH = "";
                          selcb = "";
                          userYKien = "";

                          EasyLoading.dismiss();
                          Navigator.of(context).pop();
                          showAlertDialog(context, json.decode(thanhcong)['Message']);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue[50]),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        )
                    ),),
                ),
                Padding(padding: EdgeInsets.only(top: 20,left: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue[50], width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.25,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.06,
                    child:TextButton.icon (
                        icon: Icon(Icons.delete_forever_outlined),
                        label: Text("Đóng",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),textAlign:
                        TextAlign.center,),
                        onPressed: ()  {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        )
                    ),),
                ),

              ],),

          ],
        ))
        ):Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(

                      margin: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text('Phụ trách:', style:
                      TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    FlatButton(
                      onPressed: () {
                        if (mounted) { setState(() {
                          isClickPT = !isClickPT;
                        }); }

                      },
                      child: Padding(padding: EdgeInsets.only(left: 3), child: Container(

                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.7,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.05,
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Align(
                              child: textPT == "" ? Text(
                                "Chọn cán bộ phục trách",
                                style: TextStyle(
                                    color: Colors.black45
                                ),


                              ) :
                              Text(textPT,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8)
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,

                              )
                          )
                      ),),
                    ),
                  ],
                ),
                isClickPT
                    ? SizedBox()
                    : Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  child: buildTreePT(),
                ),

                // Container()
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(

                      margin: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text('Xử lý chính:', style:
                      TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    FlatButton(
                      onPressed: () {
                        if (mounted) { setState(() {
                          isClick = !isClick;
                        }); }

                      },
                      child: Padding(padding: EdgeInsets.only(left: 3), child: Container(

                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.7,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.05,
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Align(
                              child: textXLC == "" ? Text(
                                "Chọn cán bộ xử lý chính",
                                style: TextStyle(
                                    color: Colors.black45
                                ),


                              ) :
                              Text(textXLC,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8)
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,

                              )
                          )
                      ),),
                    ),
                  ],
                ),
                isClick
                    ? SizedBox()
                    : Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  child: buildTreeCBC(),
                ),

                // Container()
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text(
                        'Phối hợp:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        if (mounted) {setState(() {
                          isClick1 = !isClick1;
                        }); }

                      },
                      child: Padding(padding: EdgeInsets.only(left: 3),
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black38, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.7,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.05,
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Align(
                                child: textPH == "" ? Text(
                                  "Chọn cán bộ phối hợp",
                                  style: TextStyle(
                                      color: Colors.black45
                                  ),


                                ) :
                                Text(textPH,
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.8)
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,

                                )
                            )
                        ),),
                    ),
                  ],
                ),

                isClick1
                    ? SizedBox()
                    : Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  child: buildTreePhu(),
                ),

                // Container()
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text('Xem để biết:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    FlatButton(
                      onPressed: () {
                        if (mounted) { setState(() {
                          isClick2 = !isClick2;
                        }); }

                      },
                      child: Padding(padding: EdgeInsets.only(left: 3), child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.7,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.05,
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Align(
                              child: textXDB == "" ? Text(
                                "Chọn cán bộ xem để biết",
                                style: TextStyle(
                                    color: Colors.black45
                                ),


                              ) :
                              Text(textXDB,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8)
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,

                              )
                          )
                      ),),
                    ),
                  ],
                ),

                isClick2
                    ? SizedBox()
                    : Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  child: buildTreePhuXDB(),
                ),

                // Container()
              ],
            ),
            Container(
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.blueAccent)
              // ),
              child: Padding(
                  padding: const EdgeInsets.only( top: 5),
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: Text('Ý kiến:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * 0.05,
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                            child: TextField(
                              autofocus: false,
                              cursorColor: Colors.black,
                              style: TextStyle(color: Colors.black),
                              controller: _titleController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: 'Nhập ý kiến',
                                hintStyle: TextStyle(color: Colors.black45),
                                // contentPadding: EdgeInsets.only(left: 10.0, top: 15.0),
                              ),
                              onChanged: null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.only(top: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue[50], width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.3,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.06,
                    child:TextButton.icon (
                        icon: Icon(Icons.send_rounded),
                        label: Text("Chuyển",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
                          textAlign:
                          TextAlign.center,),
                        onPressed: () async {
                          var tendangnhap = sharedStorage.getString("username");
                          String userYKien = _titleController.text;
                          var userDuocCHon = "";
                          if(!userDuocCHon.contains(lstUserPT))
                            userDuocCHon += lstUserPT+ "^";
                          if(!userDuocCHon.contains(lstUserXLC))
                            userDuocCHon += lstUserXLC+ "^";
                          for( var item in lstUserXDB.split("^"))
                            if(!userDuocCHon.contains(item))
                              userDuocCHon += item+ "^";
                          for( var item in lstUserPH.split("^"))
                            if(!userDuocCHon.contains(item))
                              userDuocCHon += item + "^";
                          if( userDuocCHon != null && userDuocCHon.length >0)
                          {
                            userDuocCHon =  userDuocCHon.substring(0,userDuocCHon.length-1);
                          }

                          if(cayPH != null && cayPH.length>0)
                          {
                            for(var item in cayPH.split(","))
                              if(cayXDB.contains(item) && item!= null && item
                                  .isNotEmpty)
                                selcb += item + ",";
                            if(selcb != null && selcb.length>0)
                              selcb =  selcb.substring(0,selcb.length-1);
                          }

                          EasyLoading.show();
                          var thanhcong =  await postChuyenVBD(tendangnhap, widget.id, "ChuyenVB",userDuocCHon,lstUserXDB,
                              lstUserXLC,
                              lstUserPH,selcb,userYKien,widget.nam,lstUserPT);
                          userDuocCHon = "";
                          lstUserXDB = "";
                          lstUserXLC = "";
                          lstUserPT = "";
                          lstUserPH = "";
                          selcb = "";
                          userYKien = "";

                          EasyLoading.dismiss();
                          Navigator.of(context).pop();
                          showAlertDialog(context, json.decode(thanhcong)['Message']);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue[50]),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        )
                    ),),
                ),
                Padding(padding: EdgeInsets.only(top: 20,left: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue[50], width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.25,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.06,
                    child:TextButton.icon (
                        icon: Icon(Icons.delete_forever_outlined),
                        label: Text("Đóng",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),textAlign:
                        TextAlign.center,),
                        onPressed: ()  {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        )
                    ),),
                ),

              ],),

          ],
        ))
            : Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(

                      margin: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text('Phụ trách:', style:
                      TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    FlatButton(
                      onPressed: () {
                        if (mounted) { setState(() {
                          isClickPT = !isClickPT;
                        }); }

                      },
                      child: Padding(padding: EdgeInsets.only(left: 3), child: Container(

                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.7,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.05,
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Align(
                              child: textPT == "" ? Text(
                                "Chọn cán bộ phục trách",
                                style: TextStyle(
                                    color: Colors.black45
                                ),


                              ) :
                              Text(textPT,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8)
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,

                              )
                          )
                      ),),
                    ),
                  ],
                ),
                isClickPT
                    ? SizedBox()
                    : Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  child: buildTreePT(),
                ),

                // Container()
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(

                      margin: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text('Xử lý chính:', style:
                      TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    FlatButton(
                      onPressed: () {
                        if (mounted) { setState(() {
                          isClick = !isClick;
                        }); }

                      },
                      child: Padding(padding: EdgeInsets.only(left: 3), child: Container(

                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.7,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.05,
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Align(
                              child: textXLC == "" ? Text(
                                "Chọn cán bộ xử lý chính",
                                style: TextStyle(
                                    color: Colors.black45
                                ),


                              ) :
                              Text(textXLC,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8)
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,

                              )
                          )
                      ),),
                    ),
                  ],
                ),
                isClick
                    ? SizedBox()
                    : Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  child: buildTreeCBC(),
                ),

                // Container()
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text(
                        'Phối hợp:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        if (mounted) {setState(() {
                          isClick1 = !isClick1;
                        }); }

                      },
                      child: Padding(padding: EdgeInsets.only(left: 3),
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black38, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.7,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.05,
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Align(
                                child: textPH == "" ? Text(
                                  "Chọn cán bộ phối hợp",
                                  style: TextStyle(
                                      color: Colors.black45
                                  ),


                                ) :
                                Text(textPH,
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.8)
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,

                                )
                            )
                        ),),
                    ),
                  ],
                ),

                isClick1
                    ? SizedBox()
                    : Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  child: buildTreePhu(),
                ),

                // Container()
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text('Xem để biết:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    FlatButton(
                      onPressed: () {
                        if (mounted) { setState(() {
                          isClick2 = !isClick2;
                        }); }

                      },
                      child: Padding(padding: EdgeInsets.only(left: 3), child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.7,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.05,
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Align(
                              child: textXDB == "" ? Text(
                                "Chọn cán bộ xem để biết",
                                style: TextStyle(
                                    color: Colors.black45
                                ),


                              ) :
                              Text(textXDB,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8)
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,

                              )
                          )
                      ),),
                    ),
                  ],
                ),

                isClick2
                    ? SizedBox()
                    : Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  child: buildTreePhuXDB(),
                ),

                // Container()
              ],
            ),
            Container(
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.blueAccent)
              // ),
              child: Padding(
                  padding: const EdgeInsets.only( top: 5),
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: Text('Ý kiến:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * 0.05,
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                            child: TextField(
                              autofocus: false,
                              cursorColor: Colors.black,
                              style: TextStyle(color: Colors.black),
                              controller: _titleController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: 'Nhập ý kiến',
                                hintStyle: TextStyle(color: Colors.black45),
                                // contentPadding: EdgeInsets.only(left: 10.0, top: 15.0),
                              ),
                              onChanged: null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.only(top: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue[50], width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.3,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.06,
                    child:TextButton.icon (
                        icon: Icon(Icons.send_rounded),
                        label: Text("Chuyển",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
                          textAlign:
                          TextAlign.center,),
                        onPressed: () async {
                          var tendangnhap = sharedStorage.getString("username");
                          String userYKien = _titleController.text;
                          var userDuocCHon = "";
                          if(!userDuocCHon.contains(lstUserPT))
                            userDuocCHon += lstUserPT+ "^";
                          if(!userDuocCHon.contains(lstUserXLC))
                            userDuocCHon += lstUserXLC+ "^";
                          for( var item in lstUserXDB.split("^"))
                            if(!userDuocCHon.contains(item))
                              userDuocCHon += item+ "^";
                          for( var item in lstUserPH.split("^"))
                            if(!userDuocCHon.contains(item))
                              userDuocCHon += item + "^";
                          if( userDuocCHon != null && userDuocCHon.length >0)
                          {
                            userDuocCHon =  userDuocCHon.substring(0,userDuocCHon.length-1);
                          }

                          if(cayPH != null && cayPH.length>0)
                          {
                            for(var item in cayPH.split(","))
                              if(cayXDB.contains(item) && item!= null && item
                                  .isNotEmpty)
                                selcb += item + ",";
                            if(selcb != null && selcb.length>0)
                              selcb =  selcb.substring(0,selcb.length-1);
                          }

                          EasyLoading.show();
                          var thanhcong =  await postChuyenVBD(tendangnhap, widget.id, "ChuyenVB",userDuocCHon,lstUserXDB,
                              lstUserXLC,
                              lstUserPH,selcb,userYKien,widget.nam,lstUserPT);
                          userDuocCHon = "";
                          lstUserXDB = "";
                          lstUserXLC = "";
                          lstUserPT = "";
                          lstUserPH = "";
                          selcb = "";
                          userYKien = "";

                          EasyLoading.dismiss();
                          Navigator.of(context).pop();
                          showAlertDialog(context, json.decode(thanhcong)['Message']);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue[50]),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        )
                    ),),
                ),
                Padding(padding: EdgeInsets.only(top: 20,left: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue[50], width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.25,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.06,
                    child:TextButton.icon (
                        icon: Icon(Icons.delete_forever_outlined),
                        label: Text("Đóng",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),textAlign:
                        TextAlign.center,),
                        onPressed: ()  {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        )
                    ),),
                ),

              ],),

          ],
        )
        // Column(
        //   // mainAxisAlignment: MainAxisAlignment.end,
        //   // crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     SizedBox(
        //       height: 10,
        //     ),
        //     Column(
        //       children: [
        //         Row(
        //           children: [
        //             Container(
        //
        //               margin: EdgeInsets.only(left: 10),
        //               width: MediaQuery.of(context).size.width * 0.15,
        //               child: Text('Xử lý chính:', style:
        //               TextStyle(fontWeight: FontWeight.bold)),
        //             ),
        //             FlatButton(
        //               onPressed: () {
        //                 if (mounted) { setState(() {
        //                   isClick = !isClick;
        //                 }); }
        //
        //               },
        //               child: Padding(padding: EdgeInsets.only(left: 3), child: Container(
        //
        //                   decoration: BoxDecoration(
        //                     border: Border.all(color: Colors.black38, width: 2),
        //                     borderRadius: BorderRadius.circular(10),
        //                   ),
        //                   width: MediaQuery
        //                       .of(context)
        //                       .size
        //                       .width * 0.7,
        //                   height: MediaQuery
        //                       .of(context)
        //                       .size
        //                       .height * 0.05,
        //                   padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        //                   child: Align(
        //                       child: textXLC == "" ? Text(
        //                         "Chọn cán bộ xử lý chính",
        //                         style: TextStyle(
        //                             color: Colors.black45
        //                         ),
        //
        //
        //                       ) :
        //                       Text(textXLC,
        //                         style: TextStyle(
        //                             color: Colors.black.withOpacity(0.8)
        //                         ),
        //                         maxLines: 2,
        //                         overflow: TextOverflow.ellipsis,
        //
        //                       )
        //                   )
        //               ),),
        //             ),
        //           ],
        //         ),
        //         isClick
        //             ? SizedBox()
        //             : Container(
        //           width: MediaQuery
        //               .of(context)
        //               .size
        //               .width * 0.9,
        //           child: buildTreeCBC(),
        //         ),
        //
        //         // Container()
        //       ],
        //     ),
        //     Column(
        //       children: [
        //         Row(
        //           children: [
        //             Container(
        //               margin: EdgeInsets.only(left: 10),
        //               width: MediaQuery.of(context).size.width * 0.15,
        //               child: Text(
        //                 'Phối hợp:',
        //                 style: TextStyle(fontWeight: FontWeight.bold),
        //               ),
        //             ),
        //             FlatButton(
        //               onPressed: () {
        //                 if (mounted) {setState(() {
        //                   isClick1 = !isClick1;
        //                 }); }
        //
        //               },
        //               child: Padding(padding: EdgeInsets.only(left: 3),
        //                 child: Container(
        //                     decoration: BoxDecoration(
        //                       border: Border.all(color: Colors.black38, width: 2),
        //                       borderRadius: BorderRadius.circular(10),
        //                     ),
        //                     width: MediaQuery
        //                         .of(context)
        //                         .size
        //                         .width * 0.7,
        //                     height: MediaQuery
        //                         .of(context)
        //                         .size
        //                         .height * 0.05,
        //                     padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        //                     child: Align(
        //                         child: textPH == "" ? Text(
        //                           "Chọn cán bộ phối hợp",
        //                           style: TextStyle(
        //                               color: Colors.black45
        //                           ),
        //
        //
        //                         ) :
        //                         Text(textPH,
        //                           style: TextStyle(
        //                               color: Colors.black.withOpacity(0.8)
        //                           ),
        //                           maxLines: 2,
        //                           overflow: TextOverflow.ellipsis,
        //
        //                         )
        //                     )
        //                 ),),
        //             ),
        //           ],
        //         ),
        //
        //         isClick1
        //             ? SizedBox()
        //             : Container(
        //           width: MediaQuery
        //               .of(context)
        //               .size
        //               .width * 0.9,
        //           child: buildTreePhu(),
        //         ),
        //
        //         // Container()
        //       ],
        //     ),
        //     Column(
        //       children: [
        //         Row(
        //           children: [
        //             Container(
        //               margin: EdgeInsets.only(left: 10),
        //               width: MediaQuery.of(context).size.width * 0.15,
        //               child: Text('Xem để biết:', style: TextStyle(fontWeight: FontWeight.bold)),
        //             ),
        //             FlatButton(
        //               onPressed: () {
        //                 if (mounted) { setState(() {
        //                   isClick2 = !isClick2;
        //                 }); }
        //
        //               },
        //               child: Padding(padding: EdgeInsets.only(left: 3), child: Container(
        //                   decoration: BoxDecoration(
        //                     border: Border.all(color: Colors.black38, width: 2),
        //                     borderRadius: BorderRadius.circular(10),
        //                   ),
        //                   width: MediaQuery
        //                       .of(context)
        //                       .size
        //                       .width * 0.7,
        //                   height: MediaQuery
        //                       .of(context)
        //                       .size
        //                       .height * 0.05,
        //                   padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        //                   child: Align(
        //                       child: textXDB == "" ? Text(
        //                         "Chọn cán bộ xem để biết",
        //                         style: TextStyle(
        //                             color: Colors.black45
        //                         ),
        //
        //
        //                       ) :
        //                       Text(textXDB,
        //                         style: TextStyle(
        //                             color: Colors.black.withOpacity(0.8)
        //                         ),
        //                         maxLines: 2,
        //                         overflow: TextOverflow.ellipsis,
        //
        //                       )
        //                   )
        //               ),),
        //             ),
        //           ],
        //         ),
        //
        //         isClick2
        //             ? SizedBox()
        //             : Container(
        //           width: MediaQuery
        //               .of(context)
        //               .size
        //               .width * 0.9,
        //           child: buildTreePhuXDB(),
        //         ),
        //
        //         // Container()
        //       ],
        //     ),
        //     Container(
        //       //   decoration: BoxDecoration(
        //       //     border: Border.all(color: Colors.blueAccent)
        //       // ),
        //       child: Padding(
        //           padding: const EdgeInsets.only( top: 5),
        //           child: Row(
        //             children: [
        //               Container(
        //                 width: MediaQuery.of(context).size.width * 0.15,
        //                 child: Text('Ý kiến:', style: TextStyle(fontWeight: FontWeight.bold)),
        //               ),
        //               Padding(
        //                 padding: EdgeInsets.only(left: 15),
        //                 child: Container(
        //                   decoration: BoxDecoration(
        //                     border: Border.all(color: Colors.black38, width: 2),
        //                     borderRadius: BorderRadius.circular(10),
        //                   ),
        //                   width: MediaQuery.of(context).size.width * 0.7,
        //                   height: MediaQuery.of(context).size.height * 0.05,
        //                   padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        //                   child: Theme(
        //                     data: Theme.of(context).copyWith(splashColor: Colors.transparent),
        //                     child: TextField(
        //                       autofocus: false,
        //                       cursorColor: Colors.black,
        //                       style: TextStyle(color: Colors.black),
        //                       controller: _titleController,
        //                       textAlign: TextAlign.center,
        //                       decoration: InputDecoration(
        //                         hintText: 'Nhập ý kiến',
        //                         hintStyle: TextStyle(color: Colors.black45),
        //                         // contentPadding: EdgeInsets.only(left: 10.0, top: 15.0),
        //                       ),
        //                       onChanged: null,
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           )),
        //     ),
        //     Row(
        //       crossAxisAlignment: CrossAxisAlignment.end,
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Padding(padding: EdgeInsets.only(top: 20),
        //           child: Container(
        //             decoration: BoxDecoration(
        //               border: Border.all(color: Colors.lightBlue[50], width: 2),
        //               borderRadius: BorderRadius.circular(10),
        //             ),
        //             width: MediaQuery
        //                 .of(context)
        //                 .size
        //                 .width * 0.3,
        //             height: MediaQuery
        //                 .of(context)
        //                 .size
        //                 .height * 0.06,
        //             child:TextButton.icon (
        //                 icon: Icon(Icons.send_rounded),
        //                 label: Text("Chuyển",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
        //                   textAlign:
        //                   TextAlign.center,),
        //                 onPressed: () async {
        //                   var tendangnhap = sharedStorage.getString("username");
        //                   String userYKien = _titleController.text;
        //                   var userDuocCHon = "";
        //                   if(!userDuocCHon.contains(lstUserPT))
        //                     userDuocCHon += lstUserPT+ "^";
        //                   if(!userDuocCHon.contains(lstUserXLC))
        //                     userDuocCHon += lstUserXLC+ "^";
        //                   for( var item in lstUserXDB.split("^"))
        //                     if(!userDuocCHon.contains(item))
        //                       userDuocCHon += item+ "^";
        //                   for( var item in lstUserPH.split("^"))
        //                     if(!userDuocCHon.contains(item))
        //                       userDuocCHon += item + "^";
        //                   if( userDuocCHon != null && userDuocCHon.length >0)
        //                   {
        //                     userDuocCHon =  userDuocCHon.substring(0,userDuocCHon.length-1);
        //                   }
        //
        //                   if(cayPH != null && cayPH.length>0)
        //                   {
        //                     for(var item in cayPH.split(","))
        //                       if(cayXDB.contains(item) && item!= null && item
        //                           .isNotEmpty)
        //                         selcb += item + ",";
        //                     if(selcb != null && selcb.length>0)
        //                       selcb =  selcb.substring(0,selcb.length-1);
        //                   }
        //
        //                   EasyLoading.show();
        //                   var thanhcong =  await postChuyenVBD(tendangnhap, widget.id, "ChuyenVB",userDuocCHon,lstUserXDB,
        //                       lstUserXLC,
        //                       lstUserPH,selcb,userYKien,widget.nam,lstUserPT);
        //                   userDuocCHon = "";
        //                   lstUserXDB = "";
        //                   lstUserXLC = "";
        //                   lstUserPT = "";
        //                   lstUserPH = "";
        //                   selcb = "";
        //                   userYKien = "";
        //
        //                   EasyLoading.dismiss();
        //                   Navigator.of(context).pop();
        //                   showAlertDialog(context, json.decode(thanhcong)['Message']);
        //                 },
        //                 style: ButtonStyle(
        //                   backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue[50]),
        //                   foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        //                 )
        //             ),),
        //         ),
        //         Padding(padding: EdgeInsets.only(top: 20,left: 20),
        //           child: Container(
        //             decoration: BoxDecoration(
        //               border: Border.all(color: Colors.lightBlue[50], width: 2),
        //               borderRadius: BorderRadius.circular(15),
        //             ),
        //             width: MediaQuery
        //                 .of(context)
        //                 .size
        //                 .width * 0.25,
        //             height: MediaQuery
        //                 .of(context)
        //                 .size
        //                 .height * 0.06,
        //             child:TextButton.icon (
        //                 icon: Icon(Icons.delete_forever_outlined),
        //                 label: Text("Đóng",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),textAlign:
        //                 TextAlign.center,),
        //                 onPressed: ()  {
        //                   Navigator.of(context).pop();
        //                 },
        //                 style: ButtonStyle(
        //                   backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
        //                   foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        //                 )
        //             ),),
        //         ),
        //
        //       ],),
        //
        //   ],
        // )
        )
       ;

  }

  String tti ;
  String ttiPT ;
  String radioItemHolder;

  List<TreeNode> toTreeNodesPH(dynamic parsedJson) {
    if (parsedJson is Map<String, dynamic>) {
      String title11 = parsedJson['title'];
      return parsedJson.keys
          .map((k) => TreeNode(
              content: Row(
                children: [
                  Icon(Icons.check_box_outline_blank),
                  SizedBox(
                    width: 10,
                  ),
                  Text(title11)
                ],
              ),
              children: toTreeNodesPH(parsedJson[k])))
          .toList();
    }
    if (parsedJson is List<dynamic>) {
      return parsedJson
          .asMap()
          .map((i, element) => MapEntry(
                i,
                TreeNode(
                    content: Row(
                      children: [
                        Center(
                          child: element['isUser'] && tti  !=
                              element['key']&& ttiPT  != element['key']
                              ? Checkbox(
                            value: valuesPH[element['key'].toString() + (element['isUser'] ? "U" : "")],
                            onChanged: (bool value) {

                              if (mounted) {  setState(() {
                                valuesPH[element['key'].toString() + (element['isUser'] ? "U" : "")] = value;
                              }); }

                              if (!(lstUser.length > 0) ||
                                  (lstUser.length > 0 && !lstUser.containsKey(element["key"]))) {
                                lstUser.addAll({element["key"]: element["title"]});
                                bool s = !lstUserPH.toString().contains(element["key"] + ";|" + element["title"]);

                                if (lstUserPH != null &&
                                    !lstUserPH.toString().contains(element["key"] + ";|" + element["title"]))
                                  lstUserPH = lstUserPH + "^" + element["key"] + ";|" + element["title"];
                                else
                                  lstUserPH = element["key"] + ";|" + element["title"];

                                textPH = textPH + "," + element["title"];

                                if (textPH.startsWith(","))
                                  textPH = textPH.substring(1, textPH.length);
                                var UserList = lstUser.toString();
                                // UserList =  lstUser91;
                              }
                              if (!valuesPH[element['key'].toString() + (element['isUser'] ? "U" : "")]) {
                                if (lstUserPH != null &&
                                    lstUserPH.contains("^" + element["key"] + ";|" + element["title"])) {
                                  lstUser.remove(element["key"]);
                                  lstUserPH =
                                      lstUserPH.replaceAll("^" + element["key"] + ";|" + element["title"], "");

                                  if (textPH.endsWith(","))
                                    textPH = textPH.replaceAll(element["title"]+",", "");
                                  else{

                                    textPH = textPH.replaceAll(","+element["title"], "");
                                  }
                                  return textPH = textPH.replaceAll(element["title"], "");
                                } else if (lstUserPH.contains(element["key"] + ";|" + element["title"])) {
                                  lstUser.remove(element["key"]);
                                  lstUserPH = lstUserPH.replaceAll(element["key"] + ";|" + element["title"], "");
                                }
                              }
                              cayPH += element["key"]+",";


                            },
                          )
                              : SizedBox(),
                        ),
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.45,
                          child: Text(parsedJson[i]['title']),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    children: toTreeNodesPH(parsedJson[i]['children'])),
              ))
          .values
          .toList();
    }
    return [TreeNode(content: Text(parsedJson.toString()))];
  }
  List<TreeNode> toTreeNodesXDB(dynamic parsedJson) {
    if (parsedJson is Map<String, dynamic>) {
      String title11 = parsedJson['title'];
      return parsedJson.keys
          .map((k) => TreeNode(
              content: Row(
                children: [
                  Icon(Icons.check_box_outline_blank),
                  SizedBox(
                    width: 10,
                  ),
                  Text(title11)
                ],
              ),
              children: toTreeNodesXDB(parsedJson[k])))
          .toList();
    }
    if (parsedJson is List<dynamic>) {
      return parsedJson
          .asMap()
          .map((i, element) => MapEntry(
                i,
                TreeNode(
                    content: Row(
                      children: [
                        Center(
                          child: element['isUser'] && tti != element['key']
                              && ttiPT != element['key']
                              ? Checkbox(
                            value: valuesXDB[element['key'].toString() + (element['isUser'] ? "U" : "")],
                            onChanged: (bool value) {
                              if (mounted) { setState(() {
                                valuesXDB[element['key'].toString() + (element['isUser'] ? "U" : "")] = value;
                              }); }

                              if (!(lstUserCBXDB.length > 0) ||
                                  (lstUserCBXDB.length > 0 && !lstUserCBXDB.containsKey(element["key"]))) {
                                lstUserCBXDB.addAll({element["key"]: element["title"]});
                                bool s = !lstUserXDB.toString().contains(element["key"] + ";|" + element["title"]);

                                if (lstUserXDB != null &&
                                    !lstUserXDB.toString().contains(element["key"] + ";|" + element["title"]))
                                  lstUserXDB = lstUserXDB + "^" + element["key"] + ";|" + element["title"];
                                else
                                  lstUserXDB = element["key"] + ";|" + element["title"];
                                textXDB = textXDB + "," + element["title"];

                                if (textXDB.startsWith(","))
                                  textXDB = textXDB.substring(1, textXDB.length);
                                var UserList = lstUserCBXDB.toString();
                                // UserList =  lstUser91;
                              }
                              if (!valuesXDB[element['key'].toString() + (element['isUser'] ? "U" : "")]) {
                                if (lstUserXDB != null &&
                                    lstUserXDB.contains("^" + element["key"] + ";|" + element["title"])) {
                                  lstUserCBXDB.remove(element["key"]);
                                  lstUserXDB =
                                      lstUserXDB.replaceAll("^" + element["key"] + ";|" + element["title"], "");

                                  if (textXDB.endsWith(","))
                                    textXDB = textXDB.replaceAll(element["title"]+",", "");
                                  else{

                                    textXDB = textXDB.replaceAll(","+element["title"], "");
                                  }
                                  return textXDB = textXDB.replaceAll(element["title"], "");
                                } else if (lstUserXDB.contains(element["key"] + ";|" + element["title"])) {
                                  lstUserCBXDB.remove(element["key"]);
                                  lstUserXDB = lstUserXDB.replaceAll(element["key"] + ";|" + element["title"], "");
                                }
                              }
                              cayXDB += element["key"]+",";

                            },
                          )
                              : SizedBox(),
                        ),
                        Container(

                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.45,
                          child: Text(parsedJson[i]['title']),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    children: toTreeNodesXDB(parsedJson[i]['children'])),
              ))
          .values
          .toList();
    }
    return [TreeNode(content: Text(parsedJson.toString()))];
  }

  List<TreeNode> toTreeNodesRadio(dynamic parsedJson) {
    if (parsedJson is Map<String, dynamic>) {
      String title11 = parsedJson['title'];
      return parsedJson.keys
          .map((k) => TreeNode(
              content: Row(
                children: [
                  Icon(Icons.radio_button_checked),
                  SizedBox(
                    width: 10,
                  ),
                  Text(title11)
                ],
              ),
              children: toTreeNodesRadio(parsedJson[k])))
          .toList();
    }
    if (parsedJson is List<dynamic>) {
      return parsedJson
          .asMap()
          .map((i, element) => MapEntry(
                i,
                TreeNode(
                    content: Row(
                      children: [
                        Center(
                          child: element['isUser'] &&ttiPT  != element['key']
                              ? Radio(
                           groupValue:tti ,
                            value:element['key'],
                            onChanged: ( _value) {
                              if (mounted) {    setState(() {
                                radioItemHolder = element['title'] ;
                                tti = element['key'];
                                textXLC =  radioItemHolder;
                                lstUserXLC =   element["key"] + ";|" + element["title"];
                                isClick= true;
                              });}


                              cayXLC =  tti;

                                  },
                                )
                              : SizedBox(),
                        ),
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.45,
                          child: Text(parsedJson[i]['title']),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    children: toTreeNodesRadio(parsedJson[i]['children'])
                ),
              ))
          .values
          .toList();
    }
    return [TreeNode(content: Text(parsedJson.toString()))];
  }
  List<TreeNode> toTreeNodesRadioPT(dynamic parsedJson) {
    if (parsedJson is Map<String, dynamic>) {
      String title11 = parsedJson['title'];
      return parsedJson.keys
          .map((k) => TreeNode(
              content: Row(
                children: [
                  Icon(Icons.radio_button_checked),
                  SizedBox(
                    width: 10,
                  ),
                  Text(title11)
                ],
              ),
              children: toTreeNodesRadio(parsedJson[k])))
          .toList();
    }
    if (parsedJson is List<dynamic>) {
      return parsedJson
          .asMap()
          .map((i, element) => MapEntry(
                i,
                TreeNode(
                    content: Row(
                      children: [
                        Center(
                          child: element['isUser']&&tti  != element['key']
                              ? Radio(
                           groupValue:ttiPT ,
                            value:element['key'],
                            onChanged: ( _value) {
                              if (mounted) {    setState(() {
                                radioItemHolder = element['title'] ;
                                ttiPT = element['key'];
                                textPT =  radioItemHolder;
                                lstUserPT =   element["key"] + ";|" +
                                    element["title"];
                                isClickPT= true;
                              });}


                              cayPT =  ttiPT;

                                  },
                                )
                              : SizedBox(),
                        ),
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.45,
                          child: Text(parsedJson[i]['title']),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    children: toTreeNodesRadioPT(parsedJson[i]['children'])
                ),
              ))
          .values
          .toList();
    }
    return [TreeNode(content: Text(parsedJson.toString()))];
  }
}


class ListData1 {
  String text;
  String ID;

  ListData1({@required this.text, @required this.ID});
}