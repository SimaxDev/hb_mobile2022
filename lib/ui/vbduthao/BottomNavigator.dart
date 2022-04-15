import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hb_mobile2021/common/DTPT/TreeTrinhTiepPT.dart';
import 'package:hb_mobile2021/common/SearchDropdownListServer.dart';
import 'package:hb_mobile2021/common/SmCombobox.dart';
import 'package:hb_mobile2021/common/DTPT/TreeTinhTiepDT.dart';
import 'package:hb_mobile2021/core/services/UserService.dart';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:hb_mobile2021/core/services/VBDuThaoService.dart';

import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/restart.dart';
import 'dart:developer' as Dev;


import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:path/path.dart';


class BottomNav extends StatefulWidget {
  int id;
  final String username;
  final String nam;
  final String MaDonVi;
  final ttDuThao;

  BottomNav({this.id, this.username, this.nam,this.MaDonVi,this.ttDuThao});

  @override
  _BottomNav createState() => _BottomNav(id: id);
}

final GlobalKey<State> _keyLoader = new GlobalKey<State>();

class _BottomNav extends State<BottomNav> {
  int id;
  var detailVBDT;

  bool isLoading = false;
  bool check = false;
  var IDuser = "";
  //int vbdiTrangThaiVB = 0;
  String NguoiSoan = "";
  String NguoiKy = "";
  String NguoiTrinhTiep = "";
  var lstCheck = "";
  String ActionXL = "GetDonViLienThong";
  String ActionXL1 = "GetVBDiByID";
  RxString pdfString = "".obs;
  RxString pdfStringDuyet = "".obs;
  List<ListData> vanbanList = [];
  List vanban = [];
  List lstFileAtt = [];
  List<ListData> lstDataSearch = List<ListData>();
  File selectedfile;
  File selectedfileDuyet;
  var duThao= null;
  String mesDuThao = "";
  String tenDsYKien="";
  TextEditingController _titleController = TextEditingController();


  List dataSource = [
    {"display": "Xanh", "value": "1"},
    {"display": "Đỏ", "value": "2"},
    {"display": "Tím", "value": "3"},
    {"display": "Vàng", "value": "4"},
    {"display": "Lục", "value": "5"},
    {"display": "Lam", "value": "6"},
    {"display": "Chàm", "value": "7"},
    {"display": "Tím", "value": "8"}
  ];

  _BottomNav({this.id});
  Timer _timer;


  void _initializeTimer() {
    _timer = Timer.periodic(const Duration(minutes:35), (_) {
      //rester().logOutALL();
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
  // GetDataDetailVBDT();
    //_initializeTimer();
    duThao = widget.ttDuThao;
    if (mounted) {  setState(() {
      // GetIdUser(widget.username);
     // vbdiTrangThaiVB = trangThaiVB;
      NguoiSoan = vbdiNguoiSoan;
      NguoiTrinhTiep = vbdiNguoiTrinhTiep;
      NguoiKy = vbdiNguoiKy;

      //lstCheck =  lstChiTietDt;

    });}

    check = false;
    super.initState();
  }
  // GetDataDetailVBDT() async {
  //   // if (widget.nam == null) {
  //   //   widget.nam = "2021";
  //   // }
  //   String detailVBDT = await getDataDetailVBDT(
  //       widget.id, "GetVBDTByID", widget.nam, widget.MaDonVi);
  //   if(mounted){
  //     setState(() {
  //       duThao = json.decode(detailVBDT)['OData'];
  //
  //     });
  //   }
  //
  // }
  selectFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'mp4', 'doc'],
      //allowed extension to choose
    );

    if (result != null) {
      //if there is selected file
      selectedfile = File(result.files.single.path);
    }
    if (mounted) {setState(() {
      pdfString.value = basename(selectedfile.path);

    });}

  }


  selectFileDuyet() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'mp4', 'doc'],
      //allowed extension to choose
    );

    if (result != null) {
      //if there is selected file
      selectedfileDuyet = File(result.files.single.path);
    }
    if (mounted) { setState(() {
      pdfStringDuyet.value = basename(selectedfileDuyet.path);

    });}

  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();

  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleUserInteraction,
      onPanDown: _handleUserInteraction,
      onScaleStart: _handleUserInteraction,
      child:BottomAppBar(
      child:Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey[100]),
          color: Colors.white,
        ),
        height: 56.0,
        child:duThao!= null? ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 1,
            itemBuilder: (context, index) {
              return Row(
                children: <Widget>[
                  vbdiCurrentNguoiTrinhID == currentUserID &&
                      vbdiCurrentUserReceived.length > 0 &&
                      vbdiTrangThaiVB != 5 &&
                      vbdiTrangThaiVB != 8 &&
                      vbdiTrangThaiVB != 3 &&
                      vbdiTrangThaiVB != 1 &&
                      vbdiTrangThaiVB != 6
                      ? Container(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton.icon(
                            icon: Icon(Icons.keyboard_return),
                            label: Text('Thu hồi'),
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  AlertDialog(
                                    title: const Text('Thu hồi văn bản'),
                                    content: const Text(
                                        'Bạn có chắc chắn muốn thu hồi văn bản?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () async {
                                          var tendangnhap = sharedStorage
                                              .getString("username");
                                          EasyLoading.show();
                                          var thanhcong = await posThuHoiVBDT(
                                              tendangnhap,
                                              widget.id,
                                              'THUHOIDT',
                                              widget.nam);
                                          EasyLoading.dismiss();
                                          Navigator.of(context).pop();
                                          !isLoading
                                              ? showAlertDialog(
                                              context,
                                              json.decode(
                                                  thanhcong)['Message'])
                                              : Center(
                                              child:
                                              CircularProgressIndicator());
                                        },
                                        child: const Text('Tiếp tục '),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: const Text('Huỷ'),
                                      ),
                                    ],
                                  ),
                            ),
                            textTheme: ButtonTextTheme.primary,
                          )
                        ],
                      ),
                    ),
                  )
                      : SizedBox(),
                  isDuyet && isDuyetTruongPhong
                      ? Container(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton.icon(
                            icon: Icon(Icons.verified_outlined),
                            label: Text('Duyệt'),
                            onPressed: () {
                              onPressButton(context, index + 1);
                            },
                            textTheme: ButtonTextTheme.primary,
                          )
                        ],
                      ),
                    ),
                  )
                      : SizedBox(),

                  isnguoiduyet > 0
                      ? Container(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton.icon(
                            icon: Icon(Icons.verified_outlined),
                            label: Text('Duyệt'),
                            onPressed: () {
                              onPressButton(context, index + 5);
                            },
                            textTheme: ButtonTextTheme.primary,
                          )
                        ],
                      ),
                    ),
                  )
                      : SizedBox(),

                  isDuyet && kyVaPhatHanh
                      ? Container(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton.icon(
                            icon: Icon(Icons.verified_outlined),
                            label: Text('Duyệt'),
                            onPressed: () {
                              onPressButton(context, index + 2);
                            },
                            textTheme: ButtonTextTheme.primary,
                          )
                        ],
                      ),
                    ),
                  )
                      : SizedBox(),
//Chuyển  phát hành
                  (vbdiNguoiSoanID == currentUserID && vbdiTrangThaiVB == 5) ||
                      (vbdiNguoiKyID == currentUserID &&
                          vbdiTrangThaiVB == 5)
                      ? Container(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton.icon(
                            icon: Icon(Icons.assistant_direction),
                            label: Text('Chuyển phát hành'),
                            onPressed: () {
                              onPressButton(context, index + 9);
                            },
                            textTheme: ButtonTextTheme.primary,
                          )
                        ],
                      ),
                    ),
                  )
                      : SizedBox(),

                  //Trình Ký
                  isTrinhKy == true
                      ? Container(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton.icon(
                            icon: Icon(Icons.plumbing),
                            label: Text(' Trình ký'),
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  AlertDialog(
                                    title: const Text('Xác nhận'),
                                    content: const Text(
                                        'Bạn có chắc chắn muốn trình ký?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () async {
                                          var tendangnhap = sharedStorage
                                              .getString("username");
                                          EasyLoading.show();
                                          var thanhcong = await posThuHoiVBDT(
                                              tendangnhap,
                                              widget.id,
                                              'TRINHKY',
                                              widget.nam);
                                          EasyLoading.dismiss();
                                          Navigator.of(context).pop();
                                          !isLoading
                                              ? showAlertDialog(
                                              context,
                                              json.decode(
                                                  thanhcong)['Message'])
                                              : Center(
                                              child:
                                              CircularProgressIndicator());
                                        },
                                        child: const Text('Tiếp tục '),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: const Text('Huỷ'),
                                      ),
                                    ],
                                  ),
                            ),
                            textTheme: ButtonTextTheme.primary,
                          )
                        ],
                      ),
                    ),
                  )
                      : SizedBox(),

                  isDuyetVaPhatHanh && chukyso == 1
                      ? Container(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton.icon(
                            icon: Icon(Icons.next_week_outlined),
                            label: Text('Duyệt và chuyển phát hành'),
                            onPressed: () {
                              onPressButton(context, index + 6);
                            },
                            textTheme: ButtonTextTheme.primary,
                          )
                        ],
                      ),
                    ),
                  )
                      : SizedBox(),

                  // vbdiTrangThaiVB != 1 && vbdiTrangThaiVB != 5 ?
                  Container(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton.icon(
                            icon: Icon(Icons.comment),
                            label: Text('Ý kiến'),
                            onPressed: () {
                              onPressButton(context, index + 8);
                            },
                            textTheme: ButtonTextTheme.primary,
                          )
                        ],
                      ),
                    ),
                  ),

                  ((vbdiDSNguoiTrinhTiep.indexWhere(
                          (x) => x["LookupId"] == currentUserID) >
                      -1) &&
                      (vbdiTrangThaiVB != 6 &&
                          vbdiTrangThaiVB != 3 &&
                          vbdiTrangThaiVB != 5 &&
                          vbdiTrangThaiVB != 4 &&
                          vbdiTrangThaiVB != 1)) ||
                      (vbdiNguoiKy == currentUserID && vbdiTrangThaiVB == 4)
                      ? Container(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton.icon(
                            icon: Icon(Icons.comment),
                            label: Text('Trả về'),
                            onPressed: () {
                              onPressButton(context, index);
                            },
                            textTheme: ButtonTextTheme.primary,
                          )
                        ],
                      ),
                    ),
                  )
                      : SizedBox(),

                  // isTrinhTiep == true && isQTNew == true||
                  vbdiTrangThaiVB == 2 ||
                      vbdiTrangThaiVB == 3 ||
                      (vbdiNguoiSoanID == currentUserID &&
                          vbdiTrangThaiVB == 6)
                      ? Container(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              FlatButton.icon(
                                icon: Icon(Icons.next_plan_outlined),
                                label: Text('Trình tiếp'),
                                onPressed: () {
                                  onPressButton(context, index + 7);
                                },
                                textTheme: ButtonTextTheme.primary,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                      : SizedBox(),

                  (trinhDaCoNgDuyet == true ||
                      trinhLan2 == true ||
                      vbdiTrangThaiVB == 6) &&
                      vbdiNguoiSoanID == currentUserID &&
                      CurrentDonViID == 198
                      ? Container(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              FlatButton.icon(
                                icon: Icon(Icons.undo_rounded),
                                label: Text('Trình lại'),
                                onPressed: () {
                                  onPressButton(context, index + 3);
                                },
                                textTheme: ButtonTextTheme.primary,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                      : SizedBox(),
                  // Container(
                  //   child: InkWell(
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: <Widget>[
                  //         FlatButton.icon(
                  //           icon: Icon(Icons.delete,),
                  //           label: Text('Xoá'),
                  //           onPressed: () {
                  //             setState(() {
                  //               List  data = [];
                  //               data =  duthaoListXoa;
                  //               for(int index  in data){
                  //
                  //               }
                  //               data.indexOf(data[index]);
                  //               data.removeAt(index);
                  //             });
                  //             Navigator.of(context).pop();
                  //           },
                  //           textTheme: ButtonTextTheme.primary,
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              );
            }):Center(child: CircularProgressIndicator(),)) ,),) ;
  }

  List _myActivities = [];
  List<String> _colors = <String>[
    '',
    'Văn bản 1',
    'Văn bản 2',
    'Văn bản 3',
    'Văn bản 4'
  ];
  String _color = '';

  void onPressButton(context, int index) {
    showModalBottomSheet(
         context: context,
        // isScrollControlled: true,
        // isDismissible: true,
        builder: ( context) {
        return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
          return _getBodyPage(context, index);
    });

          });
  }

  void httpJob(AnimationController controller) async {
    controller.forward();

    await Future.delayed(Duration(seconds: 3), () {});

    controller.reset();
  }

  // GetIdUser(String tendangnhap) async {
  //   detailVBDT = await GetInfoUserService(tendangnhap);
  //   IDuser = detailVBDT['IDuser'];
  // }

  Widget _getBodyPage(context, int index ) {
    //int TrangThai  = vanban["vbdiTrangThaiVB"];
    String a = "";

    switch (index) {
      case 0:
        return SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height * .60,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(splashColor: Colors.transparent),
                      child: TextField(
                        autofocus: false,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black),
                        controller: _titleController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.add,
                              color: Colors.black26, size: 22.0),
                          filled: true,
                          fillColor: Color(0x162e91),
                          hintText: 'Nhập ý kiến trả về',
                          contentPadding:
                              EdgeInsets.only(left: 10.0, top: 15.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onChanged: null,
                      ),
                    ),
                  ),
                  // Row(

                  Row(children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      margin: EdgeInsets.only(left: 25),
                      child: FlatButton(
                        child: Text('Đính kèm file...'),
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                        onPressed: () async {
                          FilePickerResult result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'pdf', 'mp4', 'doc'],
                            //allowed extension to choose
                          );

                          if (result != null) {
                            //if there is selected file
                            selectedfile = File(result.files.single.path);
                          }
                          if (mounted) { setState(() {
                            pdfString.value = basename(selectedfile.path);

                            check = true;
                          });}

                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      margin: EdgeInsets.all(10),
                      //show file name here
                      child:
                      Obx(()=>Text(pdfString.value, maxLines: 2,style: TextStyle
                        (color:
                      Colors
                          .black),)
                      ) ,
                    )
                  ],),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.lightBlue[50], width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: TextButton.icon(
                              icon: Icon(Icons.send_and_archive),
                              label: Text(
                                "Trả về",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () async {
                                var ch;
                                String base64PDF = "";
                                if (selectedfile != null) {
                                  List<int> Bytes =
                                      await selectedfile.readAsBytesSync();

                                  base64PDF = await base64Encode(Bytes);
                                }

                                bool isAllSpaces(String input) {
                                  String output = input.replaceAll(' ', '');
                                  if (output == '') {
                                    return true;
                                  }
                                  return false;
                                }

                                String iaa = _titleController.text.trim();
                                if (isAllSpaces(iaa)) {
                                  showAlertDialog(
                                      context, "Nhập ý kiến trả về");
                                } else {
                                  if (mounted) {    setState(() async {
                                    EasyLoading.show();
                                    var tendangnhap =
                                    sharedStorage.getString("username");

                                    var thanhcong = await posTraVeVBDT(
                                        tendangnhap,
                                        widget.id,
                                        'TRAVE',
                                        _titleController.text,
                                        widget.nam,
                                        pdfString.toString(),
                                        base64PDF);
                                    _titleController.text = "";
                                    pdfString.value = "";
                                    base64PDF = "";

                                    EasyLoading.dismiss();
                                    Navigator.of(context).pop();
                                    showAlertDialog(context,
                                        json.decode(thanhcong)['Message']);
                                  });}

                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.lightBlue[50]),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.lightBlue[50], width: 2),
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
                              onPressed: () async {
                                pdfString.value = "";
                                selectedfile = null;
                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.orangeAccent),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        );
        break;

      case 1:
        return SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height * .60,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(splashColor: Colors.transparent),
                      child: TextField(
                        autofocus: false,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black),
                        controller: _titleController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.add,
                              color: Colors.black26, size: 22.0),
                          filled: true,
                          fillColor: Color(0x162e91),
                          hintText: 'Nhập ý kiến ',
                          contentPadding:
                              EdgeInsets.only(left: 10.0, top: 15.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onChanged: null,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.lightBlue[50], width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: TextButton.icon(
                              icon: Icon(Icons.send_and_archive),
                              label: Text(
                                "Gửi",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () async {
                                bool isAllSpaces(String input) {
                                  String output = input.replaceAll(' ', '');
                                  if (output == '') {
                                    return true;
                                  }
                                  return false;
                                }

                                String iaa = _titleController.text.trim();
                                if (isAllSpaces(iaa)) {
                                  showAlertDialog(context, "Nhập ý kiến ");
                                } else {
                                  if (mounted) {setState(() async {
                                    EasyLoading.show();
                                    var tendangnhap =
                                    sharedStorage.getString("username");
                                    var thanhcong = await posDuyetVBDT(
                                        tendangnhap,
                                        widget.id,
                                        'TPAPP',
                                        _titleController.text,
                                        IDuser);
                                    EasyLoading.dismiss();
                                    Navigator.of(context).pop();
                                    _titleController.text = "";
                                    showAlertDialog(context,
                                        json.decode(thanhcong)['Message']);
                                  });}

                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.lightBlue[50]),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.lightBlue[50], width: 2),
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
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.orangeAccent),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        );
        break;
      case 2:
        return SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height * .60,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(splashColor: Colors.transparent),
                      child: TextField(
                        autofocus: false,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black),
                        controller: _titleController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.add,
                              color: Colors.black26, size: 22.0),
                          filled: true,
                          fillColor: Color(0x162e91),
                          hintText: 'Nhập ý kiến ',
                          contentPadding:
                              EdgeInsets.only(left: 10.0, top: 15.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onChanged: null,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.lightBlue[50], width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: TextButton.icon(
                              icon: Icon(Icons.send_and_archive),
                              label: Text(
                                "Gửi",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () async {
                                bool isAllSpaces(String input) {
                                  String output = input.replaceAll(' ', '');
                                  if (output == '') {
                                    return true;
                                  }
                                  return false;
                                }

                                String iaa = _titleController.text.trim();
                                if (isAllSpaces(iaa)) {
                                  showAlertDialog(context, "Nhập ý kiến ");
                                } else {

                                    EasyLoading.show();
                                    var tendangnhap =
                                        sharedStorage.getString("username");
                                    var thanhcong = await posDuyetVBDT(
                                        tendangnhap,
                                        widget.id,
                                        'TPAPP',
                                        _titleController.text,
                                        IDuser);
                                    EasyLoading.dismiss();
                                    Navigator.of(context).pop();
                                    _titleController.text = "";
                                    showAlertDialog(context,
                                        json.decode(thanhcong)['Message']);

                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.lightBlue[50]),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.lightBlue[50], width: 2),
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
                                _titleController.text = "";

                                Navigator.of(context).pop();

                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.orangeAccent),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        );
        break;
      case 3:
        return SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height * .60,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(splashColor: Colors.transparent),
                      child: TextField(
                        autofocus: false,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black),
                        controller: _titleController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.add,
                              color: Colors.black26, size: 22.0),
                          filled: true,
                          fillColor: Color(0x162e91),
                          hintText: 'Nhập ý kiến trình lại',
                          contentPadding:
                              EdgeInsets.only(left: 10.0, top: 15.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onChanged: null,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.lightBlue[50], width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: TextButton.icon(
                              icon: Icon(Icons.send_and_archive),
                              label: Text(
                                "Trình lại",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () async {
                                bool isAllSpaces(String input) {
                                  String output = input.replaceAll(' ', '');
                                  if (output == '') {
                                    return true;
                                  }
                                  return false;
                                }

                                String iaa = _titleController.text.trim();
                                if (isAllSpaces(iaa)) {
                                  showAlertDialog(
                                      context, "Nhập ý kiến trình lại");
                                } else {
                                  EasyLoading.show();
                                  var tendangnhap =
                                      sharedStorage.getString("username");
                                  var thanhcong = await posTrinhlaiVBDT(
                                      tendangnhap,
                                      widget.id,
                                      'TRINHLAI',
                                      _titleController.text,
                                      widget.nam);
                                  _titleController.text = "";
                                  EasyLoading.dismiss();
                                  showAlertDialog(context,
                                      json.decode(thanhcong)['Message']);
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.lightBlue[50]),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.lightBlue[50], width: 2),
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
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.orangeAccent),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        );
        break;
      case 4:
        return SingleChildScrollView(
            child: Padding(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Chọn văn bản ký số',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              new SmComboBox(
                dataSource: dataSource,
                titleText: 'Màu sắc',
                myActivities: _myActivities,
                onSaved: (value) {
                  Dev.log('$value');
                },
              ),
              new FormField(
                builder: (FormFieldState state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      icon: const Icon(FontAwesomeIcons.paintBrush),
                      //labelText: 'Chọn văn bản',
                    ),
                    isEmpty: _color == '',
                    child: new DropdownButtonHideUnderline(
                      child: new DropdownButton(
                        value: _color,
                        isDense: true,
                        onChanged: (String newValue) {
                          if (mounted) { setState(() {
//                                newContact.favoriteColor = newValue;
                            _color = newValue;
                            state.didChange(newValue);
                          });}

                        },
                        items: _colors.map((String value) {
                          return new DropdownMenuItem(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  child: Text("Ký số"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.blueAccent)),
                ),
              )
            ],
          ),
          padding: EdgeInsets.only(left: 15, right: 15),
        ));
        break;
      case 5:
        return SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height * .60,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(splashColor: Colors.transparent),
                      child: TextField(
                        autofocus: false,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black),
                        controller: _titleController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.add,
                              color: Colors.black26, size: 22.0),
                          filled: true,
                          fillColor: Color(0x162e91),
                          hintText: 'Nhập ý kiến trình ký',
                          contentPadding:
                              EdgeInsets.only(left: 10.0, top: 15.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onChanged: null,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.lightBlue[50], width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: TextButton.icon(
                              icon: Icon(Icons.send),
                              label: Text(
                                "Trình ký",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () async {
                                bool isAllSpaces(String input) {
                                  String output = input.replaceAll(' ', '');
                                  if (output == '') {
                                    return true;
                                  }
                                  return false;
                                }

                                String iaa = _titleController.text.trim();
                                if (isAllSpaces(iaa)) {
                                  showAlertDialog(
                                      context, "Nhập ý kiến trình ký");
                                } else {
                                  EasyLoading.show();

                                  var tendangnhap =
                                      sharedStorage.getString("username");
                                  var thanhcong = await posTrinhKyVBDT(
                                      tendangnhap,
                                      widget.id,
                                      'APP',
                                      _titleController.text,
                                      widget.nam);
                                  _titleController.text = "";
                                  EasyLoading.dismiss();
                                  showAlertDialog(context,
                                      json.decode(thanhcong)['Message']);
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.lightBlue[50]),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.lightBlue[50], width: 2),
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
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.orangeAccent),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        );
        break;
      case 6:
        return SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height * .60,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(splashColor: Colors.transparent),
                      child: TextField(
                        autofocus: false,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black),
                        controller: _titleController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.add,
                              color: Colors.black26, size: 22.0),
                          filled: true,
                          fillColor: Color(0x162e91),
                          hintText: 'Nhập ý kiến ban hành',
                          contentPadding:
                              EdgeInsets.only(left: 10.0, top: 15.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onChanged: null,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        margin: EdgeInsets.only(left: 25),
                        child: FlatButton(
                          child: Text('Đính kèm file...'),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          onPressed: () {
                           selectFileDuyet();
                          },
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          margin: EdgeInsets.all(10),
                          //show file name here
                          child: Obx(()=> Text(pdfStringDuyet.value,
                              maxLines: 2),),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.lightBlue[50], width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: TextButton.icon(
                              icon: Icon(Icons.web_asset),
                              label: Text(
                                "Ban hành",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () async {
                                var ch;
                                String base64PDFDDuyet = "";
                                if (selectedfileDuyet != null) {
                                  List<int> Bytes =
                                      await selectedfileDuyet.readAsBytesSync();

                                  base64PDFDDuyet = await base64Encode(Bytes);
                                }

                                bool isAllSpaces(String input) {
                                  String output = input.replaceAll(' ', '');
                                  if (output == '') {
                                    return true;
                                  }
                                  return false;
                                }

                                String iaa = _titleController.text.trim();
                                if (isAllSpaces(iaa)) {
                                  showAlertDialog(
                                      context, "Nhập ý kiến ban hành");
                                } else {
                                  EasyLoading.show();
                                  var tendangnhap =
                                      sharedStorage.getString("username");
                                  var thanhcong = await postChuyenPhatHanh(
                                      tendangnhap,
                                      widget.id,
                                      'DUYETVAPHATHANH',
                                      _titleController.text,
                                      widget.nam,
                                     pdfStringDuyet.toString(),
                                      base64PDFDDuyet);
                                  _titleController.text = "";
                                  pdfStringDuyet.value = "";
                                  base64PDFDDuyet = "";
                                  EasyLoading.dismiss();
                                  showAlertDialog(context,
                                      json.decode(thanhcong)['Message']);
                                  Navigator.of(context).pop;
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.lightBlue[50]),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40, left: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.lightBlue[50], width: 2),
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
                                pdfStringDuyet.value = "";
                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.orangeAccent),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        );
        break;
      case 7:
        return DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(50.0),
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    bottom: TabBar(
                      tabs: [
                        Tab(
                          text: 'Dự thảo',
                        ),
                        Tab(
                          text: 'Phiếu trình',
                        ),
                      ],
                    ),
                  ),
                ),
                body: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: TreeTrinhTiepDT(id: widget.id, nam: widget.nam),
                    ),
                    SingleChildScrollView(
                      child: TreeTrinhTiepPT(id: widget.id, nam: widget.nam),
                    ),
                  ],
                )));

        break;
      case 8:
        return SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height * .60,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(splashColor: Colors.transparent),
                      child: TextField(
                        autofocus: false,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black),
                        controller: _titleController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.add,
                              color: Colors.black26, size: 22.0),
                          filled: true,
                          fillColor: Color(0x162e91),
                          hintText: 'Nhập ý kiến ',
                          contentPadding:
                              EdgeInsets.only(left: 10.0, top: 15.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onChanged: null,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.lightBlue[50], width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: TextButton.icon(
                              icon: Icon(Icons.send_and_archive),
                              label: Text(
                                "Gửi ý kiến",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () async {
                                bool isAllSpaces(String input) {
                                  String output = input.replaceAll(' ', '');
                                  if (output == '') {
                                    return true;
                                  }
                                  return false;
                                }

                                String iaa = _titleController.text.trim();
                                if (isAllSpaces(iaa)) {
                                  showAlertDialog(context, "Nhập ý kiến ");
                                } else {

                                    EasyLoading.show();
                                    var tendangnhap =
                                        sharedStorage.getString("username");
                                    var thanhcong = await posYKienVBDT(
                                        tendangnhap,
                                        widget.id,
                                        'ADDYKien',
                                        _titleController.text,
                                        widget.nam);
                                    EasyLoading.dismiss();
                                    Navigator.of(context).pop();
                                    _titleController.text = "";
                                    showAlertDialog(context,
                                        json.decode(thanhcong)['Message']);

                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.lightBlue[50]),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.lightBlue[50], width: 2),
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
                                _titleController.text = "";
                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.orangeAccent),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        );
        break;
      case 9:
        return SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height * 0.60,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Trích yếu',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        // padding: EdgeInsets.only(left: 22.0),
                        padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                        child: Text(
                          TrichYeuDT,
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 14),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Loại văn bản',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        // padding: EdgeInsets.only(left: 22.0),
                        padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                        child: Text(
                          loaivbDT,
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 14),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Ý kiến',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        // padding: EdgeInsets.only(left: 22.0),
                        // padding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                        child: TextField(
                          autofocus: false,
                          cursorColor: Colors.black,
                          style: TextStyle(color: Colors.black),
                          controller: _titleController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.add,
                                color: Colors.black26, size: 18.0),
                            filled: true,
                            fillColor: Color(0x162e91),
                            hintText: 'Nhập ý kiến ban hành',
                            //contentPadding: EdgeInsets.only( top: 15.0),
                            // focusedBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(color: Colors.black26),
                            //   borderRadius: BorderRadius.circular(25),
                            // ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black26),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onChanged: null,
                        ),
                      ),
                    ],
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Theme(
                  //     data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                  //     child: TextField(
                  //       autofocus: false,
                  //       cursorColor: Colors.black,
                  //       style: TextStyle(color: Colors.black),
                  //       controller: _titleController,
                  //       decoration: InputDecoration(
                  //         prefixIcon: Icon(Icons.add, color: Colors.black26, size: 22.0),
                  //         filled: true,
                  //         fillColor: Color(0x162e91),
                  //         hintText: 'Nhập ý kiến ban hành',
                  //         contentPadding: EdgeInsets.only(left: 10.0, top: 15.0),
                  //         focusedBorder: OutlineInputBorder(
                  //           borderSide: BorderSide(color: Colors.black26),
                  //           borderRadius: BorderRadius.circular(25),
                  //         ),
                  //         enabledBorder: UnderlineInputBorder(
                  //           borderSide: BorderSide(color: Colors.black26),
                  //           borderRadius: BorderRadius.circular(25),
                  //         ),
                  //       ),
                  //       onChanged: null,
                  //     ),
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.lightBlue[50], width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: TextButton.icon(
                              icon: Icon(Icons.check),
                              label: Text(
                                "Đồng ý",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () async {
                                bool isAllSpaces(String input) {
                                  String output = input.replaceAll(' ', '');
                                  if (output == '') {
                                    return true;
                                  }
                                  return false;
                                }

                                String iaa = _titleController.text.trim();
                                if (isAllSpaces(iaa)) {
                                  showAlertDialog(
                                      context, "Nhập ý kiến ban hành");
                                } else {
                                  EasyLoading.show();
                                  var tendangnhap =
                                      sharedStorage.getString("username");
                                  var thanhcong = await postChuyenPhatHanh(
                                      tendangnhap,
                                      widget.id,
                                      'DUYETVAPHATHANH',
                                      _titleController.text,
                                      widget.nam,
                                      "",
                                      "");
                                  _titleController.text = "";
                                  EasyLoading.dismiss();

                                  showAlertDialog(context,
                                      json.decode(thanhcong)['Message']);
                                  Navigator.of(context).pop;
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.lightBlue[50]),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40, left: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.lightBlue[50], width: 2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: TextButton.icon(
                              icon: Icon(Icons.clear),
                              label: Text(
                                "Huỷ",
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
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.orangeAccent),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        );
        break;
      default:
        {
          return SingleChildScrollView(
              // height: MediaQuery.of(context).size.height * .60,
              child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Danh sách người xử lý chính'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SearchServer(
                listData: vanbanList,
                multipleSelection: false,
                title: 'Chọn xlc',
                searchHintText: 'Tìm kiếm',
                onSaved: (value) {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Danh sách người phối hợp'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SearchServer(
                listData: vanbanList,
                multipleSelection: true,
                title: 'Chọn người phối hợp',
                searchHintText: 'Tìm kiếm',
                onSaved: (value) {},
              ),
            ),
          ]));
        }
    }
  }
}
