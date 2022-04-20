import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hb_mobile2021/common/SearchDropdownListServer.dart';
import 'package:hb_mobile2021/common/DTPT/TreeThemDT.dart';
import 'package:hb_mobile2021/common/DTPT/TreeThemDTVPUB.dart';
import 'package:hb_mobile2021/core/services/VBDuThaoService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/restart.dart';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:path/path.dart';

class ThemPT extends StatefulWidget {
  const ThemPT({Key key}) : super(key: key);

  @override
  _ThemPTState createState() => _ThemPTState();
}

class _ThemPTState extends State<ThemPT> {
  bool isLoading = false;
  String radioButtonItem = 'ONE';
  int id = 1;
  bool daKy = false;
  bool daDuyet = false;
  bool hoaToc = false;
  List<ListData> vanbanList = [];
  TextEditingController textEditingController = new TextEditingController();
  File selectedfile;

  String formattedDate = "";
  List chitiet1 = [];
  Map<String, bool> values1 = new Map<String, bool>();
  bool clickPB = false;
  String tenPB = "";
  List chua = [];
  String base64PDF = "";
  _onDeleteItemPressed(item) {
    chua.removeAt(item);
    setState(() {});
  }



  @override
  void initState() {
    // TODO: implement initState
    //_initializeTimer();
    super.initState();
    if (mounted) {  setState(() {
      clickPB = clickChon;
    });}

    DateTime now = DateTime.now();
    formattedDate = DateFormat('dd-MM-yyyy').format(now);
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
  void dispose(){
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue)))
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
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                      child: Text(
                        "Cán bộ chú ý. Nếu văn bản có kèm phiếu trình, cần phải nhập đầy đủ các thông tin "
                            "bên dưới",
                        style: TextStyle(fontSize: 14, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.28,
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text(
                            "Phòng chức năng",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                          width: MediaQuery.of(context).size.width * 0.67,
                          margin: EdgeInsets.only(right: 12),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Text(
                            "Văn thư: " + hoVaTen + " - " + tenPhongBan,
                            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
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
                          width: MediaQuery.of(context).size.width * 0.28,
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text(
                            "Ngày trình",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                          width: MediaQuery.of(context).size.width * 0.67,
                          margin: EdgeInsets.only(right: 12),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Text(
                            formattedDate,
                            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
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
                          width: MediaQuery.of(context).size.width * 0.28,
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Vấn đề trình(*)',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.675,

                          margin: EdgeInsets.only(right: 10),
                          // padding: EdgeInsets.fromLTRB(10, 5, 10, 5),

                          child: TextFormField(
                            controller: textEditingController,

                            //onChanged: (newValue) => textEditingController =  newValue as TextEditingController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderSide: new BorderSide(color: Colors.lightBlue)),
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                          width: MediaQuery.of(context).size.width * 0.28,
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Tóm tắt nội dung(*)',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.675,

                          margin: EdgeInsets.only(right: 10),
                          // padding: EdgeInsets.fromLTRB(10, 5, 10, 5),

                          child: TextFormField(
                            controller: textEditingController,

                            //onChanged: (newValue) => textEditingController =  newValue as TextEditingController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderSide: new BorderSide(color: Colors.lightBlue)),
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.28,
                          padding: EdgeInsets.only(left: 15.0, bottom: 20),
                          child: Text(
                            "File đính kèm",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.all(10),
                child: Text(
                  "Chọn cán bộ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  tenLoaiChon: tenPB,
                  clickChon: clickPB,
                )
                    : TreeThemDTVPUB(
                  tenLoaiChon: tenPB,
                  clickChon: clickPB,
                ),
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
                        onPressed: ()  async {

                          var thanhcong = null;
                          bool isAllSpaces(String input) {
                            String output = input.replaceAll(' ', '');
                            if(output == '') {
                              return true;
                            }
                            return false;
                          }
                          var tendangnhap = sharedStorage.getString("username");
                          String iaa =  textEditingController.text.trim();
                          if(isAllSpaces(iaa))
                          {showAlertDialog(context,"Nhập trích yếu");
                          }
                          else
                          {
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(top: 10),
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                              ),
                            )
                            ;
                            //setState(() async {
                            String base64PDF = "";
                            String base64PDF1 = "";
                            var ch ;
                            if (selectedfile != null) {
                              // var bytes1 = await rootBundle.load(selectedfile.path);
                              List<int> Bytes = await  selectedfile.readAsBytesSync();

                              base64PDF =await  base64Encode(Bytes);

                            }
                            // if (selectedfile1 != null) {
                            //   List<int> Bytes = await selectedfile1.readAsBytesSync();
                            //   print(Bytes);
                            //   base64PDF1 = await base64Encode(Bytes);
                            //   print(base64PDF1);
                            //   ch =  await MultipartFile.fromFile(selectedfile1?.path,
                            //       filename: selectedfile1.path.split('/').last ?? 'image.jpeg');
                            // }
                            var userDuocCHon = "";
                            if(!userDuocCHon.contains(ls))
                              userDuocCHon += ls+ "^";
                            for( var item in ls1.split("^"))
                              if(!userDuocCHon.contains(item))
                                userDuocCHon += item+ "^";
                            for( var item in ls2.split("^"))
                              if(!userDuocCHon.contains(item))
                                userDuocCHon += item + "^";
                            userDuocCHon =  userDuocCHon.substring(0,userDuocCHon.length-1);

                            EasyLoading.show();
                            // thanhcong=  await postThemDT(  textEditingController
                            //     .text, idLoaiVB.toString(),cbKy,cbDuyet,cbHoaToc,vNguoiKy.toString(),vNguoiTrinh.toString(),toTrinh.toString()
                            //     ,userDuocCHon,base64PDF1);
                            EasyLoading.dismiss();
                            Navigator.of(context).pop();
                            textEditingController.text = "";
                            showAlertDialog(context, json.decode(thanhcong)['Message']);

                            //
                            //  Navigator.pop(context);
                          }


                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue[50]),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
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
                          if (mounted) {setState(() {
                            textEditingController.text = "";
                            daKy = false;
                            daDuyet = false;
                            hoaToc = false;
                            selectedfile = null;
                          }); }

                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.black12),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.black45),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: TextButton.icon(
                        icon: Icon(Icons.delete_forever),
                        label: Text('Đóng lại', style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
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
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue[50]),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        )),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
