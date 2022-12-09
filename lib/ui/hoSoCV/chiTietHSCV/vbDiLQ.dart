import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hb_mobile2021/common/HoSoCV/coQuanBH.dart';
import 'package:hb_mobile2021/common/HoSoCV/loaiVB.dart';
import 'package:hb_mobile2021/core/services/hoSoCVService.dart';
import 'package:hb_mobile2021/ui/vbdi/chi_tiet_van_ban_di.dart';
import 'dart:convert';
import 'package:json_table/json_table.dart';

class vbDiLQ extends StatefulWidget {
  final int id;
  final String nam;

  vbDiLQ({required this.id, required this.nam});

  @override
  _vbDiLQState createState() => _vbDiLQState();
}

class _vbDiLQState extends State<vbDiLQ> {
  TextEditingController _titleController = TextEditingController();
  bool isClick = true;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  bool toggle = true;
  List dataListThayThe = [];
  String hscv = "";
  bool isLoading = true;
  var jsonSample = "";
  List<ListData> vanbanList = [];
  List<ListDataCQ> vanbanListCQ = [];
  var idLoaiVB;
  bool showD = true;
  late int hosoid;
  int nam = 2022;
  late String testthuhomerxoa;
  String ActionXL = "GetVBDiLienQuan";


  // List<dynamic> dataListThayThe = [];
  // var columns = [
  //   JsonTableColumn("hscvMaHoSo", label: "Mã hồ sơ"),
  //   JsonTableColumn("hscvNguoiLap.Title", label: "Người lập"),
  //   JsonTableColumn("Title", label: "Tên hồ sơ công việc"),
  //   JsonTableColumn("hscvTrangThaiXuLy", label: "Trạng thái xử lý",valueBuilder:ttHoSo),
  // ];
  //

  Future<Null> onRefresh() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    if (mounted) {
      setState(() {
        hscv;
      });
    }

    return null;
  }

  @override
  void initState() {
    // _initializeTimer();

    super.initState();
    if (mounted) {
      setState(() {
        nam  =  int.parse(widget.nam);
        GetDataHSCV1("");
      });
    }
  }

  GetDataHSCV1(String query) async {

    hscv = await getDataDetailHSCV1(ActionXL, "", widget.id,nam,query);

    setState(() {
      dataListThayThe = jsonDecode(hscv)['OData'];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Thông tin chi tiết hồ sơ công việc"),
        //automaticallyImplyLeading: false
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            TextField(
              autofocus: true,
              // controller: usernameController,
              cursorColor: Colors.black45,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: new InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Nhập từ khoá tìm kiếm',
                hintStyle: TextStyle(
                  color: Color(0xffC0C0C0),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
                contentPadding:
                const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                  borderRadius: BorderRadius.circular(2),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),  onChanged: (value) {
              if (mounted) {
                setState(() {
                  GetDataHSCV1(value);
                });
              }
            },
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Container(
                  width: _width * 0.3,
                  alignment: Alignment.center,
                  height: _height * 0.05,
                  child: Text("Số ký hiệu",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                ),
                Container(
                  alignment: Alignment.center,
                  width: _width * 0.6,
                  height: _height * 0.05,
                  child: Text(
                    "Trích yếu",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Divider(),
            Expanded(child: buildTree())
          ],
        ),
      ),
    );
  }

  Widget buildTree() {
    if (dataListThayThe == null || dataListThayThe.length < 0 || isLoading) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
      ));
    } else if (dataListThayThe.length == 0) {
      return Center(
        child: Text("Không có bản ghi"),
      );
    }
    return RefreshIndicator(
        key: refreshKey,
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
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget getList(item) {
    var Title = item['vbdiTrichYeu'] != null ? item['vbdiTrichYeu'] : "";
    var hscvMaHoSo = item['vbdiSoKyHieu'] != null ? item['vbdiSoKyHieu'] : "";
    var vbdiIsSentVanBan = item['vbdiIsSentVanBan'] != null ?
    item['vbdiIsSentVanBan'] : false;
    var vbdiDoKhan =
        item['vbdiDoKhan'] != null && item['vbdiDoKhan']['Title'] != null
            ? item['vbdiDoKhan']['Title']
            : "";
    var sMIDField = item['ID'] != null ? item['ID'] : 0;

    return Column(
      children: [
        ListTile(
            leading: Container(
              width: MediaQuery.of(context).size.width * 0.25,
              child:!vbdiIsSentVanBan?  Text(hscvMaHoSo,style: TextStyle(color: Colors.blue),): Text(hscvMaHoSo),
            ),
            title:!vbdiIsSentVanBan? Text(
              Title,
              style: TextStyle(color: Colors.blue),
              maxLines: 2,
            ): Text(
              Title,
              maxLines: 2,
            ),
            trailing: (vbdiDoKhan == "Thượng khẩn" ||
                    vbdiDoKhan == "Khẩn" ||
                    vbdiDoKhan == "Hỏa tốc")
                ? Image(
                    width: MediaQuery.of(context).size.width * 0.1,
                    alignment: Alignment.centerLeft,
                    image: AssetImage('assets/hoatoc.png'))
                : SizedBox(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChiTietVanBanDi(
                    id: sMIDField,
                    nam: widget.nam, username: '', MaDonVi: '',
                  ),
                ),
              );
            }),
        Divider()
      ],
    );
  }
}

String formatDOB(value) {
  return DateFormat('dd-MM-yy').format(DateFormat('yy-MM-dd').parse(value));
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
