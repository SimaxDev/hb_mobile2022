import 'dart:async';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hb_mobile2021/core/services/VbdenService.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'package:hb_mobile2021/ui/vbdi/ThongTinVBDi.dart';



class ChonDS extends StatefulWidget {
  const ChonDS({Key key}) : super(key: key);

  @override
  _ChonDSState createState() => _ChonDSState();
}

class _ChonDSState extends State<ChonDS> {
  TextEditingController _titleController = TextEditingController();
  int _radioValue = 0;
  String _setDate;
  bool PH = false;
  bool XDB = false;
  List<bool> checkPH = [];
  List<bool> checkXDB = [];
  List checkXoa = [];
  double _height;
  double _width;
  int id = -1;
  //int ID =  strID;
  DateTime _dateTime;
  DateTime selectedDate = DateTime.now();
  TextEditingController _dateController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    //_initializeTimer();
    var tendangnhap = sharedStorage.getString("username");
    //this.GetDataDetailVBDen(widget.id);
    // this.GetYkienDataVBDen(widget.id);
    //this.GetButPheDataVBDen(widget.id);
   //drawCheckBox();
    fetchData();
    _onRefresh();
    super.initState();

  }
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));
    if (picked != null)
      if (mounted) {setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });}

  }
  fetchData() {
    var lengthItem = lstUsers.length;
    Iterable<String> iterable = lstUsers.values;

    for (int i = 0; i < lengthItem; i++) {
      checkPH.add(false);
    }
    for (int i = 0; i < lengthItem; i++) {
      checkXDB.add(false);
    }



  }
  Future<Null> _onRefresh() {
    Completer<Null> completer = new Completer<Null>();
    Timer timer = new Timer(new Duration(seconds: 1), () {
      completer.complete();
      if (mounted) { setState(() {
        lstUsers;
      });}

    });
    return completer.future;
  }
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    Iterable<String> iterable = lstUsers.values;
    Iterable<int> iterableid = lstUsers.keys;
    return Scaffold(appBar: AppBar(title: Text("Danh sách cán bộ được chọn"),
    ),
      body: SingleChildScrollView(child: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.4,
                // width: 40,
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                child: Text(
                  'Danh sách được chọn',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                )),
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              // width: 20,
              margin: EdgeInsets.only(top: 10),
              alignment: Alignment.center,
              child: Text(
                'XLC',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            Container(
              //  width: 20,
                width: MediaQuery.of(context).size.width * 0.1,
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                child: Text(
                  'PH',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                )),
            Container(
                width: MediaQuery.of(context).size.width * 0.2,
                //  width: 20,
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                child: Text(
                  'XĐB',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                )),
            Container(
                width: MediaQuery.of(context).size.width * 0.1,
                //   width: 20,
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                child: Text(
                  'X',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                )),
          ],
        ),
        Divider(),
        Container(
          //width: 400,
          height: _height / 1,
          child: RefreshIndicator(child: ListView(

              children: [
                Container( decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent)
                ),
                  child: Column(
                      children: <Widget>[
                        for (int i = 0; i < iterable.length; i++)

                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    // width: 40,
                                    margin: EdgeInsets.only(left: 15),
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      iterable.elementAt(i),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width * 0.15,
                                      child: Radio(
                                        groupValue: strID[i],
                                        value:id,
                                        onChanged: (val) {
                                          if (mounted) { setState(() {
                                            val = strID[i];
                                          });}

                                        },
                                      )
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.15,
                                    child:Checkbox(

                                      value: checkPH[i],
                                      onChanged: (bool value) {
                                        if (mounted) { setState(() {
                                          checkPH[i] = value ;
                                        });}

                                      },
                                    ),
                                  ),



                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.15,
                                    alignment: Alignment.centerLeft,
                                    child: Checkbox(
                                      value: checkXDB[i],
                                      onChanged: (bool value) {
                                        setState(() {
                                          checkXDB[i] = value;
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.1,
                                    alignment: Alignment.center,
                                    child: TextButton(
                                      child: Container(
                                          child: Text(
                                            'X',
                                            style: TextStyle(fontSize: 12, color: Colors.black87),
                                          )),
                                      onPressed: ()async  {
                                        var dd = lstUsers.keys.elementAt(i);
                                        lstUsers.remove(dd);
                                        _onRefresh();
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                      ]
                  ),),


                Container( decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent)
                ),
                  child: Text("XĐB: Cán bộ xem để biết | XLC: Cán bộ xử lý chính | PH: Cán bộ phối hợp xử lý "
                      "văn bản",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),),
                Container(decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent)
                ),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        Container(
                          child: Text("Ý kiến",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 40),
                          width: _width / 1.4,
                          height: _height / 20,
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(color: Colors.grey[200]),
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                            child: TextField(
                              autofocus: false,
                              cursorColor: Colors.black,
                              style: TextStyle(color: Colors.black),
                              controller: _titleController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.add, color: Colors.black26, size: 22.0),
                                filled: true,
                                fillColor: Color(0x162e91),

                                hintText: 'Nhập ý kiến',
                                // contentPadding: EdgeInsets.only(left: 10.0, top: 15.0),
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
                        )


                      ],)


                  ),
                ),
                Container(decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent)
                ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Container(
                          child: Text("Hạn xử lý",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: InkWell(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: Container(
                              width: _width / 1.4,
                              height: _height / 20,
                              alignment: Alignment.bottomCenter,
                              decoration: BoxDecoration(color: Colors.grey[200]),
                              child: TextFormField(
                                style: TextStyle(fontSize: 14),
                                textAlign: TextAlign.center,
                                enabled: false,
                                keyboardType: TextInputType.text,
                                controller: _dateController == null ? selectedDate : _dateController,
                                onSaved: (String val) {
                                  _setDate = val;
                                },
                                decoration: InputDecoration(
                                    disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                    // labelText: 'Time',
                                    contentPadding: EdgeInsets.only(bottom: 10.0)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),


                Container(decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent)
                ),
                    child: Row(children: [
                      Container(child: Text("Gửi tin nhắn thông báo",
                        style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),),
                      Checkbox( value: PH, onChanged: (val){
                        setState(() {
                          PH= val;
                        });

                      }),
                    ],)
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: FlatButton(
                        child: Text("Bỏ tất cả"),
                        onPressed: () async {
                          setState(() {
                            lstUsers = [] as Map<int, String> ;
                          });

                        },
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.blueAccent)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: FlatButton(
                        child: Text("Bỏ chọn"),
                        onPressed: () async {},
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.blueAccent)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: FlatButton(
                        child: Text("Chuyển"),
                        onPressed: () async {},
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.blueAccent)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: FlatButton(
                        child: Text("Đóng"),
                        onPressed: () => Navigator.pop(context),

                        color: Colors.blueAccent,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.blueAccent)),
                      ),
                    ),
                  ],
                )
              ]
          ),
            onRefresh: _onRefresh,
          ),
        ),
      ]),),);
  }

}
