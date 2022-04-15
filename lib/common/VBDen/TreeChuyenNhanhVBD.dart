import 'dart:async';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:hb_mobile2021/core/models/VanBanDenJson.dart';
import 'package:hb_mobile2021/core/services/VBDiService.dart';
import 'package:hb_mobile2021/core/services/VbdenService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'dart:convert';

import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';

class TreeChuyenNhanhVBDen extends StatefulWidget {
  final int id;
  final int nam;

  TreeChuyenNhanhVBDen({this.id,this.nam});

  @override
  _TreeChuyenNhanhVBDenState createState() => _TreeChuyenNhanhVBDenState();
}

class _TreeChuyenNhanhVBDenState extends State<TreeChuyenNhanhVBDen> {
  final TreeController _treeController = TreeController(allNodesExpanded: false);
  String ActionXL1 = "GetTreeDonViNoiBoKhacUBND";
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
  bool isClick1 = true;
  bool isClick2 = true;
  bool isLoading = false;
  String lstUserPH  =  "";
  String lstUserXDB  =  "";
  String lstUserXLC = "";
  String cayPH = "";
  String cayXLC = "";
  String cayXDB = "";
  String selcb = "";
  Timer _timer;


  void _initializeTimer() {
    _timer = Timer.periodic(const Duration(minutes:30), (_) {
      logOut(context);
      _timer.cancel();
    });

  }

  void _handleUserInteraction([_]) {
    // if (!_timer.isActive) {
    //   // This means the user has been logged out
    //   return;
    // }
    //
    // _timer.cancel();
    // _initializeTimer();
  }

  @override
  void initState() {
    super.initState();
    //_initializeTimer();
    var tendangnhap = sharedStorage.getString("username");
    GetDataDetailVBDi(tendangnhap);
  }
  @override
  void dispose(){
    super.dispose();
    _timer.cancel();
   tti ="";
    ttPH ="";
    ttXDB ="";
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
      if (mounted) { setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });}

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
    String detailVBDi = await getDataCVB(tendangnhap, ActionXL1);
    if (mounted) { setState(() {
      chitiet = json.decode(detailVBDi)['OData'];
      values = GetTT(chitiet);
      valuesPH = GetTT(chitiet);
      valuesXDB = GetTT(chitiet);

    });}

  }

  // @override
  // Widget build(BuildContext context) {
  //   return Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[buildTree()]);
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _handleUserInteraction,
        onPanDown: _handleUserInteraction,
        onScaleStart: _handleUserInteraction,
        child:
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width ,
            child: buildTree(),
          )


        ]
        ,
      ));


  }



  /// Builds tree or error message out of the entered content.
  Widget buildTree() {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    try {
      var parsedJson = chitiet;
      return SingleChildScrollView(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        child: Text('Chủ trì:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      FlatButton(
                        onPressed: () {
                          if (mounted) { setState(() {
                            isClick = !isClick;
                          });}

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
                                  "Chọn chủ trì",
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
                  isClick
                      ? SizedBox()
                      : Container(
                    child: buildTreeCT(),
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
                          if (mounted) { setState(() {
                            isClick1 = !isClick1;
                          });}

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
                                child: textPH == "" ? Text(
                                  "Chọn phối hợp",
                                  style: TextStyle(
                                      color: Colors.black45
                                  ),


                                ) :
                                Text(textPH,
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
                    child: buildTreePH(),
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
                          if (mounted) {   setState(() {
                            isClick2 = !isClick2;
                          });}

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
                                  "Chọn xem để biết",
                                  style: TextStyle(
                                      color: Colors.black45
                                  ),


                                ) :
                                Text(textXDB,
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
                    child: buildTreeXDB(),
                  ),

                  // Container()
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.only(top: 10),
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
                          icon: Icon(Icons.send_outlined),
                          label: Text("Chuyển",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
                            textAlign:
                            TextAlign.center,),
                          onPressed: () async {
                            var tendangnhap = sharedStorage.getString("username");
                            String userList = _titleController.text;
                            var userDuocCHon = "";
                            if(!userDuocCHon.contains(lstUserXLC))
                              userDuocCHon += lstUserXLC+ "^";
                            for( var item in lstUserXDB.split("^"))
                              if(!userDuocCHon.contains(item))
                                userDuocCHon += item+ "^";
                            for( var item in lstUserPH.split("^"))
                              if(!userDuocCHon.contains(item))
                                userDuocCHon += item + "^";
                            if(userDuocCHon.length >0 && userDuocCHon != null)
                            {
                              userDuocCHon =  userDuocCHon.substring(0,userDuocCHon.length-1);
                            }
                            else
                            {
                              return userDuocCHon;
                            }


                            // if(cayPH != null && cayPH.length>0)
                            // {
                            //   for(var item in cayPH.split(","))
                            //     if(cayXDB.contains(item) && item!= null && item.isNotEmpty)
                            //       selcb += item + ",";
                            //   selcb =  selcb.substring(0,selcb.length-1);
                            // }

                            EasyLoading.show();
                            var thanhcong =  await postChuyenNhanhVBD
                              (tendangnhap, widget.id, "ChuyenVB",userDuocCHon,tti,
                                ttPH, ttXDB,widget.nam);
                            EasyLoading.dismiss();
                            userDuocCHon ="";
                            tti ="";
                            ttPH ="";
                            ttXDB ="";
                           Navigator.of(context).pop();

                             showAlertDialog(context, json.decode(thanhcong)['Message'])
                               ;
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue[50]),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                          )
                      ),),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10,left: 20),
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
  String ttPH ;
  String ttXDB ;
  String radioItemHolder;


  Widget buildTreeCT() {
    var parsedJson;
    try {
      if(chitiet.length>0)
      {
        parsedJson = chitiet;
      }
      else{
        return Center(
          child: CircularProgressIndicator(),
        );

      }

      if (parsedJson== null|| parsedJson.length < 0 || checkedValue) {
        return Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ));
      } else if (parsedJson.length == 0) {
        return
          Container(
              child: Center(child: Text("Không có bản ghi"),)
          );


      }
      return

          TreeView(
            nodes: toTreeNodeCT(parsedJson),
            treeController: _treeController,

    ) ;

    } on FormatException catch (e) {
      return Text(e.message);
    }
  }
  Widget buildTreePH() {
    var parsedJson;
    try {
      if(chitiet.length>0)
      {
        parsedJson = chitiet;
      }
      else{
        return Center(
          child: CircularProgressIndicator(),
        );

      }

      if (parsedJson== null || parsedJson.length < 0 || checkedValue) {
        return Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ));
      } else if (parsedJson.length == 0) {
        return
          Container(
              child: Center(child: Text("Không có bản ghi"),)
          );


      }
      return  TreeView(
        nodes: toTreeNodes(parsedJson),
        treeController: _treeController,

      );
    } on FormatException catch (e) {
      return Text(e.message);
    }
  }
  Widget buildTreeXDB() {
    var parsedJson;
    try {
      if(chitiet.length>0)
      {
        parsedJson = chitiet;
      }
      else{
        return Center(
          child: CircularProgressIndicator(),
        );

      }

      if (parsedJson== null || parsedJson.length < 0 || checkedValue) {
        return Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ));
      } else if (parsedJson.length == 0) {
        return
          Container(
              child: Center(child: Text("Không có bản ghi"),)
          );


      }
      return  TreeView(
        nodes: toTreeNodesXDB(parsedJson),
        treeController: _treeController,

      );
    } on FormatException catch (e) {
      return Text(e.message);
    }
  }
  List<TreeNode> toTreeNodes(dynamic parsedJson) {

    if (parsedJson is Map<String, dynamic>) {
      String title11 = parsedJson['title'];
      return parsedJson.keys
          .map((k) =>
          TreeNode(
              content: Row(children: [
                Icon(Icons.check_box_outline_blank),
                SizedBox(width: 10,),
                Text(title11)
              ],),
              children: toTreeNodes(parsedJson[k])
          )).toList();
    }
    // if (parsedJson is List<dynamic>) {
    //   return
    //     parsedJson
    //         .asMap()
    //         .map((i, element) =>
    //         MapEntry(i,
    //           TreeNode(
    //               content: Row(
    //                 children: [
    //                   Center(
    //                     child: element['isUser']
    //                         ? Checkbox(
    //                       value: values[element['key'].toString() + (element['isUser'] ? "U" : "")],
    //
    //                       onChanged: (bool value) {
    //                         setState(() {
    //                           values[element['key'].toString() + (element['isUser'] ? "U" : "")] = value;
    //                         });
    //                         if (!(lstUser.length > 0) ||
    //                             (lstUser.length > 0 && !lstUser.containsKey(element["key"]))) {
    //                           lstUser.addAll({element["key"]: element["title"]});
    //                           bool s = !lstUserCVBi.toString().contains(element["key"] + ";#" + element["title"]);
    //                           print(s);
    //                           if (lstUserCVBi != null &&
    //                               !lstUserCVBi.toString().contains(element["key"] + ";#" + element["title"]))
    //                             lstUserCVBi = lstUserCVBi + "^" + element["key"] + ";#" + element["title"];
    //                           else
    //                             lstUserCVBi = element["key"] + ";#" + element["title"];
    //                           var UserList = lstUser.toString();
    //                           // UserList =  lstUserCVBi;
    //                         }
    //                         if (!values[element['key'].toString() + "U"])
    //                         {
    //                           if (lstUserCVBi != null &&
    //                               lstUserCVBi.contains("^" + element["key"] + ";#" + element["title"])) {
    //                             lstUser.remove(element["key"]);
    //                             lstUserCVBi =
    //                                 lstUserCVBi.replaceAll("^" + element["key"] + ";#" + element["title"], "");
    //                           } else if (lstUserCVBi.contains(element["key"] + ";#" + element["title"])) {
    //                             lstUser.remove(element["key"]);
    //                             lstUserCVBi = lstUserCVBi.replaceAll(element["key"] + ";#" + element["title"], "");
    //                           }
    //                        }
    //                         print(lstUserCVBi);
    //                       },
    //                     )
    //                         : SizedBox(),
    //                   ),
    //                   Container(
    //                     child: Text(parsedJson[i]['title']),
    //                   ),
    //                   SizedBox(
    //                     width: 10,
    //                   ),
    //                 ],
    //               ),
    //               children: toTreeNodes(parsedJson[i]['children'])),
    //         ))
    //         .values
    //         .toList();
    // }

      if (parsedJson is List<dynamic>) {

        return
          parsedJson
              .asMap()
              .map((i, element) =>
              MapEntry(i,
                  TreeNode(content:
                  Row(
                    children: [
                      tti != element['key']?Checkbox(
                        value: valuesPH[element['key'].toString() + (element['isUser'] ? "U" : "")],
                        onChanged: (bool value) {
                          if (mounted) { setState(() {
                            ttPH= element['key'];
                            valuesPH[element['key'].toString() + (element['isUser'] ? "U" : "")] = value;
                          });}

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
                      ):SizedBox(),
                      // ),
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.45,
                        // width:  MediaQuery.of(context).size.width * 0.45,
                        child:   Text(
                          parsedJson[i]['title'],
                          style: TextStyle(fontSize: 13),
                          maxLines: 3,
                        ),),
                      SizedBox(width: 0,),
                    ],),
                    children:toTreeNodes(parsedJson[i]['children']),

                  )
              ))
              .values
              .toList();
      }


    return [TreeNode(content: Text(parsedJson.toString(),style:TextStyle(fontWeight: FontWeight.bold),),)];
  }
  List<TreeNode> toTreeNodesXDB(dynamic parsedJson) {

    if (parsedJson is Map<String, dynamic>) {
      String title11 = parsedJson['title'];
      // existingItem = chitiet.firstWhere(
      //         (itemToCheck) => itemToCheck == parsedJson['key'],
      //     orElse: () => null);
      return parsedJson.keys
          .map((k) =>
          TreeNode(
              content: Row(children: [
                Icon(Icons.check_box_outline_blank),
                SizedBox(width: 10,),
                Text(title11)
              ],),
              children: toTreeNodes(parsedJson[k])
          )).toList();
    }

      if (parsedJson is List<dynamic>) {

        return
          parsedJson
              .asMap()
              .map((i, element) =>
              MapEntry(i,
                  TreeNode(content:
                  Row(
                    children: [
                      tti != element['key']?
                      Checkbox(
                        value: valuesXDB[element['key'].toString() + (element['isUser'] ? "U" : "")],
                        onChanged: (bool value) {
                          if (mounted) { setState(() {
                            ttXDB = element['key'];
                            valuesXDB[element['key'].toString() + (element['isUser'] ? "U" : "")] = value;
                          });}

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
                      ):SizedBox(),
                      // ),
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.45,
                        // width:  MediaQuery.of(context).size.width * 0.45,
                        child:   Text(
                          parsedJson[i]['title'],
                          style: TextStyle(fontSize: 13),
                          maxLines: 3,
                        ),),
                      SizedBox(width: 0,),
                    ],),
                    children:toTreeNodesXDB(parsedJson[i]['children']),

                  )
              ))
              .values
              .toList();
      }


    return [TreeNode(content: Text(parsedJson.toString(),style:TextStyle(fontWeight: FontWeight.bold),),)];
  }
  List<TreeNode> toTreeNodeCT(dynamic parsedJson) {

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
          children: toTreeNodeCT(parsedJson[k])))
          .toList();
    }

    if (parsedJson is List<dynamic>) {

        return
          parsedJson
              .asMap()
              .map((i, element) =>
              MapEntry(i,
                  TreeNode(content:
                  Row(
                    children: [
                    Radio(
                          groupValue:tti ,
                          value:element['key'],
                          onChanged: ( _value) {
                            if (mounted) { setState(() {
                              radioItemHolder = element['title'] ;
                              tti = element['key'];
                              textXLC =  radioItemHolder;
                              lstUserXLC =   element["key"] + ";|" + element["title"];
                              isClick =true;
                            });}


                            cayXLC =  tti;

                          },
                        ),

                      // ),
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.45,
                        // width:  MediaQuery.of(context).size.width * 0.45,
                        child:   Text(
                          parsedJson[i]['title'],
                          style: TextStyle(fontSize: 13),
                          maxLines: 3,
                        ),),
                      SizedBox(width: 0,),
                    ],),
                      children: toTreeNodeCT(parsedJson[i]['children']),

                  )
              ))
              .values
              .toList();
      }


    return [TreeNode(content: Text(parsedJson.toString(),style:TextStyle(fontWeight: FontWeight.bold),),)];
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
