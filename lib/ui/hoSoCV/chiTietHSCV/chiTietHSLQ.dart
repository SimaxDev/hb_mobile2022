import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hb_mobile2021/core/services/hoSoCVService.dart';
import 'package:hb_mobile2021/ui/hoSoCV/chiTietHSCV/ThongTinHSCV.dart';
import 'dart:convert';

class chiTietHSLQ extends StatefulWidget {
  final int id;
  final String nam;
  chiTietHSLQ({required this.id,required this.nam});

  @override
  _chiTietHSLQState createState() => _chiTietHSLQState();
}

class _chiTietHSLQState extends State<chiTietHSLQ> {

  TextEditingController _titleController = TextEditingController();
  bool isClick = true;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  bool toggle = true;
  List dataListThayThe = [];
  String hscv = "";
  bool isLoading = false;
  var jsonSample = "";
  bool showD = true;
  late int hosoid;
  late String testthuhomerxoa;
  String ActionXL = "GetHSCVLienQuan";


  Future<Null> onRefresh() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    if (mounted) { setState(() {
      hscv;
    });
    }

    return null;
  }

  @override
  void initState() {
   // _initializeTimer();
    super.initState();
    if (mounted) {  setState(() {

      GetDataHSCV1();
    });}


  }

  GetDataHSCV1() async {
  hscv = await getDataDetailHSCV1(ActionXL,"intType=3&lstIDhoSo=56"
      "",widget.id,widget.nam,"");
  if (mounted) {
    setState(() {
      isLoading = true;
    dataListThayThe = jsonDecode(hscv)['OData'];


  });}

  }



  @override
  Widget build(BuildContext context) {
    double  _height = MediaQuery.of(context).size.height;
    double  _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text("Thông tin chi tiết hồ sơ công việc"),
        //automaticallyImplyLeading: false
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          Row(children: [
            Container(width: _width*0.3,
              alignment: Alignment.center,
              height:_height*0.05,
              child: Text("Mã hồ sơ",style: TextStyle
                (fontSize: 16,fontWeight: FontWeight.w500)),),

            Container(alignment: Alignment.center,
              width: _width*0.6,
              height:_height*0.05,child: Text("Tên hồ sơ",style: TextStyle
                (fontSize: 16,fontWeight: FontWeight.w500)
                ,),),
          ],),

          Divider(),

          Expanded(child: buildTree())

        ],
      ),
    );
  }

  Widget buildTree() {



    if (dataListThayThe== null || dataListThayThe.length < 0 ||
        isLoading==false) {
      return Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ));
    } else if (dataListThayThe.length  == 0) {
      return Center(
        child: Text("Không có bản ghi"),
      );
    }
    return RefreshIndicator(key: refreshKey,
        child: ListView.builder(
         // controller: _scrollerController,
          itemCount: dataListThayThe == null ? 0 : dataListThayThe.length + 1,
          itemBuilder: (context, index) {
            if (index == dataListThayThe.length) {
              return _buildProgressIndicator();
            } else {
              return getList(dataListThayThe[index]);
            }
          },
        ),
        onRefresh: onRefresh);
  
  }
  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),

      child: new Center(
        child: new Opacity(
          opacity: isLoading == false? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget getList(item) {

    var Title = item['Title'] != null ?item['Title'] :"" ;
    var hscvMaHoSo = item['hscvMaHoSo'] != null ?item['hscvMaHoSo'] :"" ;
    var sMIDField = item['ID'] != null ? item['ID']: 0;
    var hscvNguoiLap = item['hscvNguoiLap']['Title'] != null
        ? item['hscvNguoiLap']['Title']
        :"";
    return Column(children: [

      ListTile(

          leading: Container(width: MediaQuery.of(context).size.width*0.25,
            child: Text(hscvMaHoSo,),),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(Title,maxLines: 2,style: TextStyle(
              fontWeight: FontWeight.w500,

            )),
           Row(children: [
             Text('Người lập:',
                 //overflow: TextOverflow.clip,
                 style: TextStyle(
                   fontSize: 14,
                   fontWeight: FontWeight.normal,
                     fontStyle: FontStyle.italic
                 )),
             Text(hscvNguoiLap,
                 //overflow: TextOverflow.clip,
                 style: TextStyle(
                   fontSize: 12,
                   fontWeight: FontWeight.normal,
                   fontStyle: FontStyle.italic,
                   color: Colors.red

                 )),
           ],)
          ],),

          trailing: Icon(Icons.arrow_right),
          onTap: () {Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => thongTinHSCV(
                idHS: sMIDField,nam: widget.nam,
              ),
            ),
          );}

      ) ,Divider()
    ],);
  }



}

String formatDOB(value){
  return DateFormat('dd-MM-yy')
      .format(DateFormat('yy-MM-dd').parse(value));
  // var parsedDate = DateTime.parse(strDt);
  // return ("${parsedDate.day}/${parsedDate.month}/${parsedDate.year}");
}
String ttHoSo(id) {
  String tt='';
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