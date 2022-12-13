


import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hb_mobile2021/core/services/VbdenService.dart';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';



class ThuHoiVb extends StatefulWidget {
  final int id;
  final int nam;

  ThuHoiVb({required this.id, required this.nam});

  final String title = "Thu hồi văn bản";

  @override
  ThuHoiVbState createState() => ThuHoiVbState();
}

class ThuHoiVbState extends State<ThuHoiVb> {
  late bool sort;
  late int selectedIndex;
  List listThuHoi = [];
  List listID = [];
  String ActionXL = "GetThongTinGuiNhan";
  bool isLoading = true;

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  bool _checkbox = false;
  Map<String, bool> valuesPH = new Map<String, bool>();
  List _selecteCategorys = [];

  @override
  void initState() {
    super.initState();
    GetData();
  }
  @override
  void dispose(){
    super.dispose();
    listID;

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
    vbhs = await GetHomeThuHoi(ActionXL, widget.nam, widget.id);
    // vbhs = await getDataHomeVBDT(skip, pageSize, ActionXL,widget.urlLoaiVB,year);
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
            flex:8,
            child:getBody(),
          ),
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

                      if(listID ==[]||listID == null|| listID.length==0)
                      {
                        showAlertDialog(context,"Chưa chọn cán bộ nào để thu hồi!");
                      }
                      else{
                        var thanhcong=  null;
                        var thongbao =null ;
                        // await httpJob(controller);
                        EasyLoading.show();
                        //thanhcong= await  postThuHoiVBD(currentUserID,widget.id, "THUHOIVB",listID,widget.nam);
                        showLoading(context);
                        EasyLoading.dismiss();

                        showAlertDialog(context, json.decode(thanhcong)['Message']);


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
      nguoinhan = item['infoUserNameReceived'] != null &&
          item['infoUserNameReceived']['Title'] != null
          ? item['infoUserNameReceived']['Title']
          : 0;
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
                  Flexible(flex: 3,
                  child: Row(children: [
                    Text(
                      "Cán bộ/phòng ban : ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      nguoinhan,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],),)
                  ,
                  Flexible(flex: 1,
                  child:CheckboxListTile(
                    value:_selecteCategorys
                        .contains(item['ID']),
                    onChanged: ( selected) {
                      _onCategorySelected(selected!, item['ID'] );
                    },
                  ) ,),

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
