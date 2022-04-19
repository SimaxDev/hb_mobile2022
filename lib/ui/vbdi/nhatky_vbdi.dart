import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';

class NhatKyVBDi extends StatefulWidget {
  final int id;
  final String username;
  final int nam;

  NhatKyVBDi({this.id, this.username, this.nam});

  @override
  _NhatKyVBDi createState() => _NhatKyVBDi();
}

class _NhatKyVBDi extends State<NhatKyVBDi> {
  List<Widget> listNhatKy = new List<Widget>();
  RxBool isLoading = false.obs;
  String ActionXLGuiNhan = "GetGuiNhanVBDi";
  var tendangnhap = "";
  Timer _timer;

  void _initializeTimer() {
    _timer = Timer.periodic(const Duration(minutes: 5), (_) {
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
    //_initializeTimer();
    super.initState();
    this.fetchData();
    // this.getBody();

    getBody();
  }

  @override
  void dispose() {
    super.dispose();
    listNhatKy;

  }

  fetchData() async {
    tendangnhap = sharedStorage.getString("username");
    if (tendangnhap == null || tendangnhap == "") {
      tendangnhap = widget.username;
    }
    String url = "/api/ServicesVBDi/GetData";
    var parts = [];
    parts.add('TenDangNhap=' + tendangnhap);
    parts.add('ItemID=' + widget.id.toString());
    parts.add('ActionXL=' + ActionXLGuiNhan.toString());
    parts.add('SYear=' + widget.nam.toString());
    var formData = parts.join('&');
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = jsonDecode(response.body)['OData'];

      isLoading.value = true;
      //nhatKy = items
      for (var element in items) {
        var aaa = element['infoGroupNameReceivedText'] != null
            ? element['infoGroupNameReceivedText'].split('#')[1]
            : "";
        var ten = element['infoSentByUser']['Title'] != null
            ? element['infoSentByUser']['Title']
            : "";
        var infoUserNameReceivedID = element['infoUserNameReceived'] != null
            ? element['infoUserNameReceived']['ID']
            : 0;
        var tenNguoi = element['infoUserNameReceived']['Title'] != null
            ? element['infoUserNameReceived']['Title']
            : "";
        ten == "" || aaa == ""
            ? 0
            : listNhatKy.add(
                SingleChildScrollView(
                  child: Row(
                    children: [
                      Column(
                        children: [
                          infoUserNameReceivedID > 0
                              ? Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(
                                              left: 20, top: 15, bottom: 5),
                                          child: Text(
                                            ten,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          child: Image(
                                            image: AssetImage('assets/t.png'),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.55,
                                          margin: EdgeInsets.only(
                                              left: 10, top: 5, bottom: 10),
                                          alignment: Alignment.center,
                                          child: Column(
                                            children: [
                                              Text(tenNguoi),
                                              getTrangThaiNoiNhan(element[
                                                          'ttThuHoi']) !=
                                                      ""
                                                  ? Text(
                                                      "(" +
                                                          getTrangThaiNoiNhan(
                                                              element[
                                                                  'ttThuHoi']) +
                                                          ")",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: Colors.red),
                                                      overflow:
                                                          TextOverflow.clip,
                                                    )
                                                  : SizedBox()
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 10, top: 5, bottom: 10),
                                          child: Image(
                                            image:
                                                AssetImage('assets/clock.png'),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 5, top: 5, bottom: 15),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35,
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            // (element['infoTimeSent'] != '')
                                            //     ? (DateFormat('dd/MM/yyyy').format(DateTime.parse(element['infoTimeSent'])) ?? '')
                                            //     : '',
                                            GetDate(element['infoTimeSent']
                                                .toString()),
                                            style: TextStyle(
                                                color: Colors.black38,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 13),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          alignment: Alignment.topRight,
                                          child: Text(
                                            getTrangThai(element[
                                                'infoTrangThaiTiepNhan']),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              : Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(
                                              left: 20, top: 15, bottom: 5),
                                          child: Text(
                                            ten,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          child: Image(
                                            image: AssetImage('assets/t.png'),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.55,
                                          margin: EdgeInsets.only(
                                              left: 10, top: 5, bottom: 10),
                                          alignment: Alignment.center,
                                          child: Column(
                                            children: [
                                              Text(aaa),
                                              getTrangThaiNoiNhan(element[
                                                          'ttThuHoi']) !=
                                                      ""
                                                  ? Text(
                                                      "(" +
                                                          getTrangThaiNoiNhan(
                                                              element[
                                                                  'ttThuHoi']) +
                                                          ")",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: Colors.red),
                                                      overflow:
                                                          TextOverflow.clip,
                                                    )
                                                  : SizedBox()
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 10, top: 5, bottom: 10),
                                          child: Image(
                                            image:
                                                AssetImage('assets/clock.png'),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 5, top: 5, bottom: 15),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35,
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            // (element['infoTimeSent'] != '')
                                            //     ? (DateFormat('dd/MM/yyyy').format(DateTime.parse(element['infoTimeSent'])) ?? '')
                                            //     : '',
                                            GetDate(element['infoTimeSent']
                                                .toString()),
                                            style: TextStyle(
                                                color: Colors.black38,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 13),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          alignment: Alignment.topRight,
                                          child: Text(
                                            getTrangThai(element[
                                                'infoTrangThaiTiepNhan']),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleUserInteraction,
      onPanDown: _handleUserInteraction,
      onScaleStart: _handleUserInteraction,
      child: Scaffold(
        body: Obx(() => isLoading == true && listNhatKy != null ||
                    listNhatKy.length != 0
                ? getBody()
                : Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.blue)))
            /* Center(
                child: Text("Không có bản ghi"),
              )*/
            ),
      ),
    );
  }

  Widget getBody() {
    if (listNhatKy == null || listNhatKy.length == 0) {
      return Center(
        child: Text("Không có bản ghi"),
      );
    } else {
      return ListView(
        children: [
          Container(
            child: Column(
              children: listNhatKy,
            ),
          )
        ],
      );
    }
  }

  String getTrangThai(int trangthai) {
    switch (trangthai) {
      case 15:
        return "Đang xử lý";
        break;

      case 11:
        return "Đã đến ";
      case 3:
        return "Đã xử lý";
      case 16:
        return "Đã xử lý";
      case 1:
        return "Chưa nhận";
      case 2:
        return "Đã nhận";
      case 13:
        return "Đã nhận";
      case 14:
        return "Đã phân công";
      case 22:
        return "Từ chối";
      case 12:
        return "Từ chối";
      case 51:
        return "Đồng ý";
      case 52:
        return "Từ chối";
      default:
        return "Đang xử lý";
        break;
    }
  }

  String getTrangThaiNoiNhan(int trangthai) {
    switch (trangthai) {
      case 3:
        return "Đã đồng ý cập nhật";
        break;
      case 2:
        return "Đang yêu cầu cập nhật";
        break;
      case 4:
        return "Từ chối cập nhật";
        break;
      case 5:
        return "Đang yêu cầu thu hồi ";
        break;
      case 6:
        return "Đã đồng ý thu hồi ";
        break;
      case 7:
        return "Từ chối thu hồi ";
        break;
      case 8:
        return "Đang yêu cầu thay thế";
        break;
      case 9:
        return "Đã đồng ý thay thế";
        break;
      case 10:
        return "Từ chối thay thế";
        break;
      case 11:
        return "Đang yêu cầu lấy lại";
        break;
      case 12:
        return "Đã đồng ý lấy lại";
        break;
      case 13:
        return "Từ chối lấy lại";
        break;
      default:
        return "";
        break;
    }
  }

  String GetDate(String strDt) {
    // return DateFormat('yyyy-MM-dd  kk:mm')
    //     .format(DateFormat('yyyy-MM-dd kk:mm').parse(strDt));
    var parsedDate = DateTime.parse(strDt);
    return ("${parsedDate.day}/${parsedDate.month}/${parsedDate.year}  "
        "${parsedDate.hour}:${parsedDate.minute}");
  }
}
