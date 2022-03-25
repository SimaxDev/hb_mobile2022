import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:hb_mobile2021/core/services/VbdenService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'dart:convert';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
class TreeThemDTVPUB extends StatefulWidget {
  final int id;
  final String tenLoaiChon;
  final bool clickChon;
  TreeThemDTVPUB({this.id,this.tenLoaiChon,this.clickChon});

  @override
  _TreeThemDTVPUBState createState() => _TreeThemDTVPUBState();
}

class _TreeThemDTVPUBState extends State<TreeThemDTVPUB> {
  final TreeController _treeController = TreeController(allNodesExpanded: false);
  String ActionXL1 = "GetTreeDonViV2";
  List chitiet = [];
  List chitiet1 = [];
  List<ListData1> listData;
  var existingItem;
  bool checkedValue = false;
  Map<String, String> lstUser = new Map<String, String>();
  String valueselected = "";
  Map<String, bool> values = new Map<String, bool>();
  Map<String, bool> values1 = new Map<String, bool>();
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
  bool isLoading = false;

  String lstUserNK  =  "";
  String lstUserXLC = "";
  String lstUserPD2 = "";
  String cayPD2 = "";
  String cayXLC = "";
  String cayXNK = "";
  String selcb = "";
  var parsedJson;
  var chuListDT;



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
  Future GetDataDTPB(String tendangnhap,String Action,String grop) async {
    String detailVBDi = await getDataTreeDT(tendangnhap, Action,grop);
    setState(() {
      chitiet1 = json.decode(detailVBDi)['OData'][0]['children'];
      values1 = GetTT(chitiet1);
    });
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
      try {
        if( widget.clickChon == true)
        {
          if(chitiet.length>0){
            for(var item in chitiet)
            {
              if(item['title'] ==tenPhongBan)
              {
                var tendn1 = sharedStorage.getString("username");
                chuListDT =  item['key'] ;
                GetDataDTPB(tendn1,"GetTreeDonVi",chuListDT);
                parsedJson = chitiet1;
              }

            }
          }
          else {
            return
              Center(child:
              CircularProgressIndicator());
          }
        }
        else
        {

          parsedJson = chitiet;

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
    try {
      if( widget.clickChon == true)
      {
        if(chitiet.length>0){
          for(var item in chitiet)
          {
            if(item['title'] ==tenPhongBan)
            {
              var tendn1 = sharedStorage.getString("username");
              chuListDT =  item['key'] ;
              GetDataDTPB(tendn1,"GetTreeDonVi",chuListDT);
              parsedJson = chitiet1;
            }

          }
        }
        else {
          return
            Center(child:
            CircularProgressIndicator());
        }
      }
      else
      {

        parsedJson = chitiet;

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
    try {
      if( widget.clickChon == true)
      {
        if(chitiet.length>0){
          for(var item in chitiet)
          {
            if(item['title'] ==tenPhongBan)
            {
              var tendn1 = sharedStorage.getString("username");
              chuListDT =  item['key'] ;
              GetDataDTPB(tendn1,"GetTreeDonVi",chuListDT);
              parsedJson = chitiet1;
            }

          }
        }
        else {
          return
            Center(child:
            CircularProgressIndicator());
        }
      }
      else
      {

        parsedJson = chitiet;

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
                                "Chọn cán bộ phê duyệt/trình tiếp",
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
                                "Chọn lãnh đạo ký văn bản",
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
                  child: buildTreeNK(),
                ),

                // Container()
              ],
            ),

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
                Icon(Icons.radio_button_off),
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
                    child: element['isUser']
                        ? Radio(
                      groupValue:tti ,
                      value:element['key'],
                      onChanged: ( _value) {

                        setState(() {
                          radioItemHolder = element['title'] ;
                          tti = element['key'];
                          vNguoiKy = tti;
                          textXLC =  radioItemHolder;
                        });
                        print(radioItemHolder);
                        print("tit" + tti);
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
                  child: element['isUser']
                      ? Radio(
                    groupValue:tti1 ,
                    value:element['key'],
                    onChanged: ( _value) {

                      setState(() {
                        radioItemHolder1 = element['title'] ;
                        tti1 = element['key'];
                        textPD2 =  radioItemHolder1;
                      });
                      print(radioItemHolder1);
                      print("tit" + tti);
                      lstUserPD2 =   element["key"] + ";|" + element["title"];
                      cayPD2 = element["key"];
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
                  child: element['isUser']
                      ? Radio(
                    groupValue:tti2 ,
                    value:element['key'],
                    onChanged: ( _value) {
                      setState(() {
                        radioItemHolder2 = element['title'] ;
                        tti2 = element['key'];
                        textXNK =  radioItemHolder2;
                      });
                      print(radioItemHolder2);
                      print("tit" + tti);
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
