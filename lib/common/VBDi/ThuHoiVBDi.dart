


import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hb_mobile2021/core/services/VBDiService.dart';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';


class ThuHoiVbDi extends StatefulWidget {
  final int id;
  final int nam;

  ThuHoiVbDi({required this.id, required this.nam});

  final String title = "Thu hồi văn bản";

  @override
  ThuHoiVbDiState createState() => ThuHoiVbDiState();
}

class ThuHoiVbDiState extends State<ThuHoiVbDi> {
  late bool sort;
  late int selectedIndex;
  List listThuHoi = [];
  List listID = [];
  String ActionXL = "GetGuiNhanVBDi";
  bool isLoading = true;
  // MultiSelectController controller = new MultiSelectController();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  bool _checkbox = false;
  Map<String, bool> valuesPH = new Map<String, bool>();
  List _selecteCategorys = [];
  TextEditingController yKienController =  TextEditingController();
  late int tti1;
  @override
  void initState() {
    super.initState();
    GetData();
    tti1=0;
  }
  @override
  void dispose(){
    super.dispose();
    listID;
    // controller.isSelecting = false;
    EasyLoading.dismiss();
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    if (mounted) {
      setState(() {
        listThuHoi;

        // GetDataHSCV();
      });
    }

    return null;
  }

  Future GetData() async {
    String vbhs = "";
    vbhs = await GetHomeThuHoiVBDi(ActionXL, widget.nam, widget.id);
    if (mounted) {
      setState(() {
        listThuHoi.addAll(json.decode(vbhs)['OData']);
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body:Column(children: [
          Expanded(
            flex:1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.2,
                  padding: EdgeInsets.only(left: 15.0),
                  child: Row(children: [
                    Text(
                      'Ý kiến',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      '(*)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize:
                      14,color: Colors.red),
                    ),
                  ],)
                ),
                Container(
                  margin: EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black38 ,

                    ),
                    borderRadius: BorderRadius.circular(5),

                  ),
                  height:MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.7,
                  padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                  child: TextFormField(
                    controller:yKienController,
                    //onChanged: (newValue) => vbDen.SoDen =
                    //n.toString(),

                    // initialValue: vbDen.SoDen!= null??vbDen.SoDen,
                    autovalidateMode: AutovalidateMode
                        .onUserInteraction,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    decoration: InputDecoration(
                        disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                        border: InputBorder.none,
                        // labelText: 'Time',
                        contentPadding: EdgeInsets.only(bottom: 20.0, left: 5)),
                  ),
                ),
              ],
            ),
          ),

          Divider(),
          Expanded(
            flex:8,
            child:getBody(),
          ),    Divider(),
          Expanded( // you can use Flexible also
            flex: 1,
            child:Container(
                alignment: Alignment.center,
                child: TextButton.icon (
                  // child: Text("Đóng lại",style: TextStyle(fontWeight: FontWeight.bold),),
                    icon: Icon(Icons.add),
                    label: Text('Thu hồi',style: TextStyle(fontWeight: FontWeight
                        .bold)),
                    onPressed: () async {

                      if(listID ==[]||listID == null )
                      {
                        showAlertDialog(context,"Chưa chọn cán bộ nào để thu hồi!");
                      }
                      else{
                        var thanhcong=  null;
                        var thongbao =null ;
                        // await httpJob(controller);
                        EasyLoading.show();
                        //thanhcong= await  postXuLyXongVBD(widget.id, "Done",
                        // _titleController.text,widget.nam);
                        //showLoading(context);
                        EasyLoading.dismiss();

                        // showAlertDialog(context, json.decode(thanhcong)['Message']);


                        listID = [];
                        Navigator.of(context).pop();

                        ;
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    )
                )
            ),
          ),
        ],) );
  }

  Widget getBody() {
    if (listThuHoi== null ||
        listThuHoi.length < 0 ||
        isLoading == true) {
      return Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ));
    } else if (listThuHoi.length == 0) {
      return Center(
        child: Text("Không có bản ghi"),
      );
    }
    return RefreshIndicator(
        key: refreshKey,
        child: ListView.builder(
            itemCount: listThuHoi == null ? 0 : listThuHoi.length + 1,
            itemBuilder: (context, index) {
              if (index == listThuHoi.length) {
                return _buildProgressIndicator();
              } else {
                return Container(
                  child: getCard(listThuHoi[index]),

                  //change color based on wether the id is selected or not.
                );
              }
            }),
        onRefresh: refreshList);
  }
  void _onCategorySelected(bool selected, category_id) {
    if (selected == true) {
      setState(() {
        _selecteCategorys.add(category_id);
        listID.add(category_id);
      });
    } else {
      setState(() {
        _selecteCategorys.remove(category_id);
        listID.remove(category_id);
      });
    }
  }

  Widget getCard(item) {

    var nguoinhan = "";
    var hscvNgayMoHoSo = "";
    bool infoSentByEmail = false;
    if (listThuHoi != null) {
      var hscvTrangThaiXuLy =
      item['hscvTrangThaiXuLy'] != null ? item['hscvTrangThaiXuLy'] : 0;
      nguoinhan = item['infoGroupNameReceivedText'] != null
          ? item['infoGroupNameReceivedText']
          : "";
      if(nguoinhan != "")
      nguoinhan = nguoinhan.split('#')[1];

      var sMIDField = item['ID'] != null ? item['ID'] : 0;
      infoSentByEmail = item['infoSentByEmail'] != null ?
      item['infoSentByEmail'] :false;
      var temp = DateFormat("yyyy-MM-dd").parse(item['infoTimeSent']) != null
          ? DateFormat("yyyy-MM-dd").parse(item['infoTimeSent'])
          : DateFormat("yyyy-MM-dd").parse(item['infoTimeSent']);
      hscvNgayMoHoSo = DateFormat("dd-MM-yyyy").format(temp);
    }
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [
                  Flexible(flex: 9,
                    child: Row(children: [
                      Text(
                        "Cán bộ/phòng ban : ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width*0.5,
                        child:Text(
                          nguoinhan,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ) ,
                      )
                      ,
                    ],),)
                  ,
                  Flexible(flex: 1,
                    child: Radio<int>(
                      value:item['ID'] ,
                      groupValue:tti1,
                      onChanged: ( _value) {
                        setState(() {
                          tti1=  _value as int;
                        });
                      },
                    ),
                  ),

                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "Ngày gửi : ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    hscvNgayMoHoSo,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
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
}
