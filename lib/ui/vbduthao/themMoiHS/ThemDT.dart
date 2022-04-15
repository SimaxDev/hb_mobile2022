import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hb_mobile2021/common/DTPT/TreeLoaiVanBan.dart';
import 'package:hb_mobile2021/common/DTPT/TreeThemDTVPUB.dart';
import 'package:hb_mobile2021/core/services/UserService.dart';
import 'package:hb_mobile2021/core/services/VBDiService.dart';
import 'package:hb_mobile2021/core/services/VBDuThaoService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/restart.dart';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:hb_mobile2021/common/DTPT/TreeThemDT.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

class ThemDT extends StatefulWidget {
  const ThemDT({Key key}) : super(key: key);

  @override
  _ThemDTState createState() => _ThemDTState();
}

class _ThemDTState extends State<ThemDT> {
  bool isLoading = false;
  String radioButtonItem = 'ONE';
  var idLoaiVB;
  int id = 1;
  bool daKy = false;
  bool daDuyet = false;
  bool hoaToc = false;
  bool IdDocument = false;

  List<ListData> vanbanListLoai = [];
  TextEditingController textEditingController = new TextEditingController();
  File selectedfile;
  File selectedfile1;
  String _myCity;
  List citiesList;
  String tenLoaiChon = "";
  String cbKy = "";
  String cbDuyet = "";
  String cbHoaToc = "";
  String DuThaoBo = "";
  Timer _timer;
  String  intuseduyet= "";
  List chua1 = [];
  String base64PDF1 = "";
  List chua = [];
  String base64PDF = "";
  _onDeleteItemPressed(item) {
    chua.removeAt(item);
    setState(() {});
  }
  _onDeleteItemPressed1(item) {
    chua1.removeAt(item);
    setState(() {});
  }

  void _initializeTimer() {
    _timer = Timer.periodic(const Duration(minutes: 5), (_) {
      rester().logOutALL();
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
    GetDataLoaiVB();
   // _initializeTimer();
    super.initState();
    setState(() {
      //this.selectFile();
      tenLoaiChon = tenPhongBan;
    });
    for (var item in ThongTinLConfig) {
      if (item['configType'] == "useduyet") {
        intuseduyet = item['configValue'] ;
      }
    }
  }
  @override
  void dipose(){

    super.dispose();
  }

  GetDataLoaiVB() async {
    String tendangnhap = tendangnhapAll;
    String detailChucVu = await getDataLoaiVB(tendangnhap, "GetListLoaiVB");
    setState(() {
      var vanban = json.decode(detailChucVu)['OData'];
      var lstData = (vanban as List).map((e) => ListData.fromJson(e)).toList();
      List<ListData> lstDataSearch = List<ListData>();
      lstData.forEach((element) {
        lstDataSearch.add(element);
        vanbanListLoai = lstDataSearch;
      });
    });
  }

  selectFile1() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'mp4', 'doc'],
      //allowed extension to choose
    );

    if (result != null) {
      //if there is selected file
      selectedfile1 = File(result.files.single.path);

      if (selectedfile1 != null) {
        // var bytes1 = await rootBundle.load(selectedfile.path);
        List<int> Bytes = await selectedfile1.readAsBytesSync();
        print(Bytes);
        base64PDF1 = await base64Encode(Bytes);
        print("hdaf  " + base64PDF1);
        chua1.add(basename(selectedfile1.path));
      }
    }
    setState(() {});
  }
  selectFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'mp4', 'doc'],
      //allowed extension to choose
    );

    if (result != null) {
      //if there is selected file
      selectedfile = File(result.files.single.path);

      if (selectedfile != null) {
        // var bytes1 = await rootBundle.load(selectedfile.path);
        List<int> Bytes = await selectedfile.readAsBytesSync();
        print(Bytes);
        base64PDF = await base64Encode(Bytes);
        print("hdaf  " + base64PDF);
        chua.add(basename(selectedfile.path));
      }
    }
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleUserInteraction,
      onPanDown: _handleUserInteraction,
      onScaleStart: _handleUserInteraction,
      child: Scaffold(
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue)))
            : ListView(
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black38,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(7),
                        ),

                        // width: MediaQuery
                        //     .of(context)
                        //     .size
                        //     .width * 0.67,
                        child: Column(
                          children: [
                            userHasQuyenKyVB.length > 0
                                ? Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Radio(
                                          value: 1,
                                          groupValue: id,
                                          onChanged: (val) {
                                            setState(() {
                                              clickChon = false;
                                              radioButtonItem = 'ONE';
                                              id = 1;
                                            });
                                          },
                                        ),
                                        Text(
                                          'Dự thảo đơn vị',
                                          style: new TextStyle(fontSize: 14.0),
                                        ),
                                        Radio(
                                          value: 2,
                                          groupValue: id,
                                          onChanged: (val) {
                                            setState(() {
                                              clickChon = true;
                                              radioButtonItem = 'TWO';
                                              id = 2;
                                            });
                                          },
                                        ),
                                        Text(
                                          'Dự thảo PB',
                                          style: new TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                            clickChon
                                ? Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black38,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    width: MediaQuery.of(context).size.width *
                                        0.67,
                                    margin: EdgeInsets.only(right: 12),
                                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    child: Text(
                                      tenLoaiChon,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14),
                                      textAlign: TextAlign.justify,
                                      maxLines: 100,
                                    ),
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.28,
                                  padding: EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    "Người soạn thảo",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black38,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.67,
                                  margin: EdgeInsets.only(right: 12),
                                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Text(
                                    "Văn thư: " + hoVaTen + " - " + tenPhongBan,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14),
                                    textAlign: TextAlign.justify,
                                    maxLines: 100,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.28,
                                  padding: EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    'Loại văn bản(*)',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,

                                    ///height: MediaQuery.of(context).size.height * 0.07,
                                    //width: MediaQuery.of(context).size.width * 0.605,
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    padding:
                                        EdgeInsets.only(left: 0.0, right: 10),
                                    child: TreeLoaiVanBan(
                                      listData: vanbanListLoai,
                                      title: 'Chọn loại văn bản',
                                      onSaved: (value) {
                                        setState(() {
                                          idLoaiVB = value[0];
                                        });
                                      },
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.28,
                                  padding: EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    'Trích yếu*',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.675,

                                  margin: EdgeInsets.only(right: 10),
                                  // padding: EdgeInsets.fromLTRB(10, 5, 10, 5),

                                  child: TextFormField(
                                    controller: textEditingController,

                                    //onChanged: (newValue) => textEditingController =  newValue as TextEditingController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: Colors.lightBlue)),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.28,
                                  padding:
                                      EdgeInsets.only(left: 15.0, bottom: 20),
                                  child: Text(
                                    "Chọn văn bản dự thảo",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 12),
                                  width:
                                  MediaQuery.of(context).size.width * 0.675,

                                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: FlatButton(
                                          child: Text('Đính kèm file...'),
                                          color: Colors.blueAccent,
                                          textColor: Colors.white,
                                          onPressed: () {
                                            selectFile();
                                          },
                                        ),
                                      ),
                                      chua != null && chua!=[] &&chua.length >0
                                          ?  Container
                                        (child:
                                      ListView
                                          .builder(
                                        shrinkWrap: true,
                                        itemCount: chua.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(chua[index],style: TextStyle(
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13),
                                              maxLines:2,),
                                            trailing: IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                size: 18.0,
                                                color: Color(0xffDE3E43),
                                              ),
                                              onPressed: () {
                                                _onDeleteItemPressed(index);
                                              },
                                            ),
                                          );
                                        },
                                      ),):
                                      Text(
                                        "Nên sử dụng file pdf",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  CurrentDonViID == 198 && int.parse(intuseduyet) == 0
                                      ? Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                "DT đã ký",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Checkbox(
                                                value: daKy,
                                                onChanged: (val) {
                                                  setState(() {
                                                    daKy = val;
                                                    cbKy = "1";
                                                  });
                                                }),
                                          ],
                                        )
                                      : Container(),
                                  int.parse(intuseduyet) == 0? Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: Text(
                                          "DT đã duyệt",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Checkbox(
                                          value: daDuyet,
                                          onChanged: (val) {
                                            setState(() {
                                              daDuyet = val;
                                              cbDuyet = "2";
                                            });
                                          }),
                                    ],
                                  ): Container(),
                                ],
                              ),
                            ),
                            CurrentDonViID == 198 && int.parse(intuseduyet) == 0
                                ? Container(
                                    margin:
                                        EdgeInsets.only(left: 15, right: 10),
                                    child: Text(
                                      "Lưu ý: Chỉ tích DT đã duyệt khi dự thảo VB quy trình LĐ Ủy ban ký và DT đã được "
                                      "lãnh đạo duyệt",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.red),
                                    ),
                                  )
                                : Container(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.28,
                                  padding:
                                      EdgeInsets.only(left: 15.0, bottom: 20),
                                  child: Text(
                                    "Tài liệu đính kèm",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 12),
                                  width:
                                  MediaQuery.of(context).size.width * 0.675,

                                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Column(
                                    children: [
                                      Container(
                                        width:
                                        MediaQuery.of(context).size.width *
                                            0.5,
                                        child: FlatButton(
                                          child: Text('Đính kèm file...'),
                                          color: Colors.blueAccent,
                                          textColor: Colors.white,
                                          onPressed: () {
                                            selectFile1();
                                          },
                                        ),
                                      ),
                                      chua1 != null && chua1!=[] &&chua1.length >0
                                          ?  Container
                                        (child:
                                      ListView
                                          .builder(
                                        shrinkWrap: true,
                                        itemCount: chua1.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(chua1[index],style:
                                            TextStyle(
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13),
                                              maxLines:2,),
                                            trailing: IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                size: 18.0,
                                                color: Color(0xffDE3E43),
                                              ),
                                              onPressed: () {
                                                _onDeleteItemPressed1(index);
                                              },
                                            ),
                                          );
                                        },
                                      ),):
                                      Text(
                                        "Nên sử dụng file pdf",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  CurrentDonViID == 198 && int.parse(intuseduyet) == 0
                                      ? Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                "Hỏa "
                                                "tốc",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Checkbox(
                                                value: hoaToc,
                                                onChanged: (val) {
                                                  setState(() {
                                                    hoaToc = val;
                                                    cbHoaToc = "3";
                                                  });
                                                }),
                                          ],
                                        )
                                      : Container(),
                                  CurrentDonViID == 198
                                      ? Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                "DT xin ý kiến",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Checkbox(
                                                value: IdDocument,
                                                onChanged: (val) {
                                                  setState(() {
                                                    IdDocument = val;
                                                    DuThaoBo = "1";
                                                  });
                                                }),
                                          ],
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            CurrentDonViID == 198
                                ? Container(
                                    margin: EdgeInsets.only(
                                        left: 15, right: 10, bottom: 10),
                                    child: Text(
                                      "Lưu ý: Chỉ tích DT xin ý kiến khi dự thảo VB chỉ cần xin ý kiến LĐ không cần phát hành văn bản đi",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.red),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.all(10),
                        child: Text(
                          "Chọn cán bộ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black38,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: groupID == 198
                            ? TreeThemDT(
                                tenLoaiChon: tenLoaiChon, clickChon: clickChon)
                            : TreeThemDTVPUB(
                                tenLoaiChon: tenLoaiChon, clickChon: clickChon),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: TextButton.icon(
                                icon: Icon(Icons.send_and_archive),
                                label: Text(
                                  "Trình ký",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {
                                  var thanhcong = null;
                                  bool isAllSpaces(String input) {
                                    String output = input.replaceAll(' ', '');
                                    if (output == '') {
                                      return true;
                                    }
                                    return false;
                                  }

                                  var tendangnhap =
                                      sharedStorage.getString("username");
                                  String iaa =
                                      textEditingController.text.trim();
                                  if (isAllSpaces(iaa)) {
                                    showAlertDialog(context, "Nhập trích yếu");
                                  } else {
                                    Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.only(top: 10),
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Colors.blueAccent),
                                      ),
                                    );
                                    //setState(() async {
                                    String base64PDF = "";
                                    String base64PDF1 = "";
                                    var ch;
                                    if (selectedfile != null) {
                                      // var bytes1 = await rootBundle.load(selectedfile.path);
                                      List<int> Bytes =
                                          await selectedfile.readAsBytesSync();

                                      base64PDF = await base64Encode(Bytes);
                                    }
                                    if (selectedfile1 != null) {
                                      List<int> Bytes =
                                          await selectedfile1.readAsBytesSync();

                                      base64PDF1 = await base64Encode(Bytes);

                                      ch = await MultipartFile.fromFile(
                                          selectedfile1?.path,
                                          filename: selectedfile1.path
                                                  .split('/')
                                                  .last ??
                                              'image.jpeg');
                                    }
                                    var userDuocCHon = "";
                                    if (!userDuocCHon.contains(ls))
                                      userDuocCHon += ls + "^";
                                    for (var item in ls1.split("^"))
                                      if (!userDuocCHon.contains(item))
                                        userDuocCHon += item + "^";
                                    for (var item in ls2.split("^"))
                                      if (!userDuocCHon.contains(item))
                                        userDuocCHon += item + "^";
                                    if (userDuocCHon != null &&
                                        userDuocCHon != "")
                                      userDuocCHon = userDuocCHon.substring(
                                          0, userDuocCHon.length - 1);

                                    EasyLoading.show();
                                    thanhcong = await postThemDT(
                                        textEditingController.text,
                                        idLoaiVB.toString(),
                                        cbKy,
                                        cbDuyet,
                                        cbHoaToc,
                                        vNguoiKy.toString(),
                                        vNguoiTrinh.toString(),
                                        toTrinh.toString(),
                                        userDuocCHon,
                                        base64PDF1,
                                        base64PDF);
                                    EasyLoading.dismiss();
                                    Navigator.of(context).pop();
                                    textEditingController.text = "";
                                    showAlertDialog(context,
                                        json.decode(thanhcong)['Message']);

                                    //
                                    //  Navigator.pop(context);
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
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: TextButton.icon(
                                icon: Icon(Icons.refresh_outlined),
                                label: Text(
                                  'Nhập lại',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  setState(() {
                                    textEditingController.text = "";
                                    daKy = false;
                                    daDuyet = false;
                                    hoaToc = false;
                                    selectedfile = null;
                                    selectedfile1 = null;
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black12),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black45),
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: TextButton.icon(
                                // child: Text("Đóng lại",style: TextStyle(fontWeight: FontWeight.bold),),
                                icon: Icon(Icons.delete_forever),
                                label: Text('Đóng lại',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
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
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: TextButton.icon(
                                icon: Icon(Icons.check),
                                label: Text(
                                  "Cập nhật/Xin ý kiến dự thảo",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {},
                                style: ButtonStyle(
                                  // backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent),
                                  // foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.lightBlue[50]),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue),
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
