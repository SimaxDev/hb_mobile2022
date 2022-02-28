import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:hb_mobile2021/common/VBDi/TreeFromJson.dart';
import 'package:hb_mobile2021/core/models/VanBanDenJson.dart';
import 'package:hb_mobile2021/core/services/VBDiService.dart';
import 'package:hb_mobile2021/core/services/VBDuThaoService.dart';
import 'package:hb_mobile2021/core/services/VbdenService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'dart:convert';

import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';

class TreeTrinhTiepDT extends StatefulWidget {
  final int id;
  final String nam;

  TreeTrinhTiepDT({this.id,this.nam});

  @override
  _TreeTrinhTiepDTState createState() => _TreeTrinhTiepDTState();
}

class _TreeTrinhTiepDTState extends State<TreeTrinhTiepDT> {
  final TreeController _treeController = TreeController(allNodesExpanded: false);
  String ActionXL1 = "GetTreeDonViV2";
  List chitiet = [];
  List<ListData1> listData;
  var existingItem;
  bool checkedValue = false;
  Map<String, String> lstUser = new Map<String, String>();
  String valueselected = "";
  Map<String, bool> values = new Map<String, bool>();
  String textXLC = "";
  String textPD2 = "";
  String textXNK = "";
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
  bool isClick1 = true;
  bool isClick2 = true;
  bool checkTrinhKy = false;
  bool isLoading = false;

  String lstUserNK  =  "";
  String lstUserXLC = "";
  String lstUserPD2 = "";
  String cayPD2 = "";
  String cayXLC = "";
  String cayXNK = "";
  String selcb = "";



  @override
  void initState() {
    super.initState();
    var tendangnhap = sharedStorage.getString("username");
    GetDataDetailVBDi(tendangnhap);
  }
  @override
  void dispose() {
    super.dispose();
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
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
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
    setState(() {
      chitiet = json.decode(detailVBDi)['OData'][0]['children'];
      values = GetTT(chitiet);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[buildTree()]);
  }

  Widget buildTreeCBC() {
    var parsedJson;
    try {
      if(chitiet.length>0)
      {
        parsedJson = chitiet;
      }
      else{
        return CircularProgressIndicator();
      }

      return TreeView(
        nodes: toTreeNodesRadio(parsedJson),
        treeController: _treeController,
      );
    } on FormatException catch (e) {
      return Text(e.message);
    }
  }
  Widget buildTreePD2() {
    var parsedJson;
    try {
      if(chitiet.length>0)
      {
        parsedJson = chitiet;
      }
      else{
        return CircularProgressIndicator();
      }

      return TreeView(
        nodes: toTreeNodesRadio2(parsedJson),
        treeController: _treeController,
      );
    } on FormatException catch (e) {
      return Text(e.message);
    }
  }
  Widget buildTreeNK() {
    var parsedJson;
    try {
      if(chitiet.length>0)
      {
        parsedJson = chitiet;
      }
      else{
        return CircularProgressIndicator();
      }

      return TreeView(
        nodes: toTreeNodesRadioNK(parsedJson),
        treeController: _treeController,
      );
    } on FormatException catch (e) {
      return Text(e.message);
    }
  }

  /// Builds tree or error message out of the entered content.
  Widget buildTree() {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    try {
      var parsedJson = chitiet;
      return SingleChildScrollView(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text('Trích yếu:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.only(left: 17,top:5),
                      width: MediaQuery.of(context).size.width * 0.71,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child:Padding(
                             padding: const EdgeInsets.all(5),
                        child: Text(TrichYeuDT, style: TextStyle(fontSize: 14),textAlign: TextAlign.left,),
                        )

                    ),
                  ],
                ),
                Container(

                  child:  Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text('PD/TT:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          isClick = !isClick;
                        });
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
                                "Chọn cán bộ PD/TT",
                                style: TextStyle(
                                    color: Colors.black45
                                ),


                              ) :
                              Text(textXLC,
                                style: TextStyle(
                                    color: Colors.black45
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,

                              )
                          )
                      ),),
                    ),
                  ],
                ),
                  ),

                isClick
                    ? SizedBox()
                    : Container(
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
                        'PD/TT lần 2:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          isClick1 = !isClick1;
                        });
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
                              child: textPD2 == "" ? Text(
                                "Chọn cán bộ PD/TT lần 2",
                                style: TextStyle(
                                    color: Colors.black45
                                ),


                              ) :
                              Text(textPD2,
                                style: TextStyle(
                                    color: Colors.black45
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
                  child: buildTreePD2(),
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
                      child: Text('NK:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          isClick2 = !isClick2;
                        });
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
                              child: textXNK == "" ? Text(
                                "Chọn cán bộ NK",
                                style: TextStyle(
                                    color: Colors.black45
                                ),


                              ) :
                              Text(textXNK,
                                style: TextStyle(
                                    color: Colors.black45
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
                  child:buildTreeNK(),
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
                        padding: EdgeInsets.only(left: 20),
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
                    child: checkTrinhKy == true ?TextButton.icon (
                        icon: Icon(Icons.send),
                        label: Text("Trình ký",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),textAlign:
                        TextAlign.center,),
                        onPressed: () async {
                          var tendangnhap = sharedStorage.getString("username");
                          String userList = _titleController.text;
                          var userDuocCHon = "";
                          if(!userDuocCHon.contains(lstUserXLC))
                            userDuocCHon += lstUserXLC+ "^";
                          for( var item in lstUserPD2.split("^"))
                            if(!userDuocCHon.contains(item))
                              userDuocCHon += item+ "^";
                          for( var item in lstUserNK.split("^"))
                            if(!userDuocCHon.contains(item))
                              userDuocCHon += item + "^";
                          userDuocCHon =  userDuocCHon.substring(0,userDuocCHon.length-1);
                          userDuocCHon =  userDuocCHon.endsWith("^") ? userDuocCHon.substring(0,userDuocCHon.length-1)
                              : userDuocCHon;


                          EasyLoading.show();
                          var thanhcong =  await postTrinhTiepDT(tendangnhap, widget.id, "TRINHTIEP",userDuocCHon,
                              cayXLC,
                              cayPD2,
                              cayXNK,userList,widget.nam);

                          EasyLoading.dismiss();
                          Navigator.of(context).pop();
                          showAlertDialog(context, json.decode(thanhcong)['Message']);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue[50]),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        )
                    ):TextButton.icon (
                        icon: Icon(Icons.send),
                        label: Text("Trình ký",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),textAlign:
                        TextAlign.center,),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>
                            (Colors.black26),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.black54),
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
        ),
      );
    } on FormatException catch (e) {
      return Text(e.message);
    }
  }

  String tti ;
  String tti1 ;
  String tti2 ;
  String radioItemHolder;
  String radioItemHolder1;
  String radioItemHolder2;


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
                  child: element['isUser'] && tti1 != element['key'] && tti2
                      != element['key']
                      ? Radio(
                    groupValue:tti ,
                    value:element['key'],
                    onChanged: ( _value) {

                      setState(() {
                        radioItemHolder = element['title'] ;
                        tti = element['key'];
                        textXLC =  radioItemHolder;
                        isClick =true;
                      });

                      lstUserXLC =   element["key"] + ";|" + element["title"];
                      cayXLC = element["key"];
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
  List<TreeNode> toTreeNodesRadio2(dynamic parsedJson) {
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
          children: toTreeNodesRadio2(parsedJson[k])))
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
                  child: element['isUser'] && tti != element['key'] && tti2
                      != element['key']
                      ? Radio(
                    groupValue:tti1 ,
                    value:element['key'],
                    onChanged: ( _value) {

                      setState(() {
                        radioItemHolder1 = element['title'] ;
                        tti1 = element['key'];
                        textPD2 =  radioItemHolder1;
                      });

                      lstUserPD2 =   element["key"] + ";|" + element["title"];
                      cayPD2 = element["key"];
                      isClick1 =true;
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
            children: toTreeNodesRadio2(parsedJson[i]['children'])
        ),
      ))
          .values
          .toList();
    }
    return [TreeNode(content: Text(parsedJson.toString()))];
  }
  List<TreeNode> toTreeNodesRadioNK(dynamic parsedJson) {
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
          children: toTreeNodesRadioNK(parsedJson[k])))
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
                  child: element['isUser'] &&tti != element['key'] &&tti1 !=
                      element['key']
                      ? Radio(
                    groupValue:tti2 ,
                    value:element['key'],
                    onChanged: ( _value) {
                      setState(() {
                        radioItemHolder2 = element['title'] ;
                        tti2 = element['key'];
                        textXNK =  radioItemHolder2;
                        isClick2 = true;
                        checkTrinhKy = true;
                      });
                      lstUserNK =   element["key"] + ";|" + element["title"];
                      cayXNK = element["key"];
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
            children: toTreeNodesRadioNK(parsedJson[i]['children'])
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

  factory ListData1.fromJson(Map<String, dynamic> json) {
    return ListData1(ID: (json['key']), text: json['title']);
  }
}
