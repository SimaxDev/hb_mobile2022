import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hb_mobile2021/common/HoSoCV/chuyenVaoHS.dart';
import 'package:hb_mobile2021/core/services/callApi.dart';
import 'package:hb_mobile2021/core/services/hoSoCVService.dart';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';
import 'dart:developer' as Dev;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hb_mobile2021/ui/vbduthao/themMoiHS/ThemMoiDT.dart';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
class BottomNavHSCV extends StatefulWidget {
  int id;
  String nam;
  BottomNavHSCV({required this.id,required this.nam});

  @override
  _BottomNavHSCV createState() => _BottomNavHSCV();
}

class _BottomNavHSCV extends State<BottomNavHSCV> with SingleTickerProviderStateMixin {


  late DateTime _dateTime;
  DateTime selectedDate = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  late double _height;
  late double _width;
  late String _setDate;
  late String _setDate1;
  bool isLoading = false;
  List chitiet1 = [];
  ScrollController _scrollerController = new ScrollController();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var refreshKeyDS = GlobalKey<RefreshIndicatorState>();
  String ActionXL = "GetListVBDi";
  final GlobalKey<State> key = new GlobalKey<State>();

  @override
  void initState() {
    setState(() {
      _scrollerController.addListener(() {
        if (_scrollerController.position.pixels == _scrollerController.position.maxScrollExtent) {
        }
      });

    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {

    });
  }

  @override
  void dispose() {
    super.dispose();

    EasyLoading.dismiss();
  }
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text =  DateFormat('dd-MM-yyyy')
            .format(DateFormat('yyyy-MM-dd').parse(selectedDate.toString()));
      });
  }

// l???y danh s??ch ng?????i ph???i h???p


  // h??m t???i l???i trnag
  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);

    await Future.delayed(Duration(seconds: 2));
    setState(() {

    });
    return null;
  }

  Future<Null> refreshListDS() async {
    refreshKeyDS.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      FloatingActionButton;
    });
    return null;
  }

  //  title  bootm
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey[100]!),
        color: Colors.white,
      ),
      height: 56.0,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 1,
          itemBuilder: (context, index) {
            return Row(
              children: <Widget>[

                // (currentDuThao.Count == 0) || ((currentDuThao.Count > 0)
                //     ? currentDuThao[0].vbdiTrangThaiVB.ToString().Equals("1") : false)
                //     ?
                checkKetThucHSCV == true?
                    Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton.icon(
                          icon: Icon(Icons.weekend_rounded),
                          label: Text('K???t th??c HSCV'),
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('K???t Th??c H??? S?? C??ng Vi???c'),
                              content: const Text('B???n c?? ch???c ch???n mu???n k???t '
                                  'th??c h??? s?? c??ng vi???c ???? ch???n'
                                  '?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    //Navigator.of(context).pop();
                                    EasyLoading.show();
                                    var thanhcong = await getDataDetailHSCV( widget.id, "KetThucHSCV");
                                    EasyLoading.dismiss();
                                   Navigator.of(context).pop();
                                    await   showAlertDialog(context, json
                                        .decode
                                    (thanhcong)['Message']);

                                  },
                                  child: const Text('Ti???p t???c '),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Hu???'),
                                ),
                              ],
                            ),
                          ),

                          //textTheme: ButtonTextTheme.primary,
                        )
                      ],
                    ),
                  ),
                ):SizedBox(),

                hscvNguoiLap == currentUserID || hscvNguoiPhuTrach == currentUserID
                ?
                Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton.icon(
                          icon: Icon(Icons.access_time),
                          label: Text('C???p nh???t h???n XL'),
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('C???p nh???t h???n x??? l??'),
                              content: Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Container(
                                      child: Text("H???n x??? l??"),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: InkWell(
                                        onTap: () {
                                          _selectDate(context);
                                        },
                                        child: Container(
                                          width: _width / 2.7,
                                          height: _height / 20,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(color: Colors.grey[200]),
                                          child: TextFormField(
                                            style: TextStyle(fontSize: 14),
                                            textAlign: TextAlign.center,
                                            enabled: false,
                                            keyboardType: TextInputType.text,
                                            controller: _dateController == null ? selectedDate as TextEditingController : _dateController,
                                            // onSaved: (val) {
                                            //   _setDate1 = val;
                                            // },
                                            decoration: InputDecoration(
                                                disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                                // labelText: 'Time',
                                                contentPadding: EdgeInsets.only(bottom: 15.0)),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [

                                    Padding(padding: EdgeInsets.only(left: 10,right: 10,top: 0),
                                      child:   TextButton.icon (
                                          icon: Icon(Icons.send_and_archive),
                                          label: Text('C???p nh???t',style: TextStyle(fontWeight: FontWeight.bold)),
                                          onPressed: () async {
                                            EasyLoading.show();
                                            var tendangnhap = sharedStorage!.getString("username");

                                            var thoiGian = _dateController
                                                .text.toString();
                                            var thanhcong = await
                                            postHanXuLyHSCV(tendangnhap,widget
                                                .id, "HanXuLy",thoiGian, widget.nam );

                                            EasyLoading.dismiss();
                                           Navigator.of(context).pop();
                                            showAlertDialog(context, json.decode(thanhcong)['Message']);
                                          },
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue[50]!),
                                            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                          )
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.only(left: 10,
                                        right: 10,top: 0),
                                      child:   TextButton.icon (
                                        // child: Text("????ng l???i",style: TextStyle(fontWeight: FontWeight.bold),),
                                          icon: Icon(Icons.delete_forever),
                                          label: Text('????ng l???i',style: TextStyle(fontWeight: FontWeight.bold)),
                                          onPressed: () {
                                           Navigator.of(context).pop();
                                          },
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                          )
                                      ),
                                    ),
                                  ],)
                              ],
                            ),
                          ),

                          //textTheme: ButtonTextTheme.primary,
                        )
                      ],
                    ),
                  ),
                ):SizedBox(),

                //Y ki???n
                Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton.icon(
                          icon: Icon(Icons.comment),
                          label: Text('?? ki???n'),
                          onPressed: () {
                            onPressButton(context, 0);
                          }

                          //textTheme: ButtonTextTheme.primary,
                        )
                      ],
                    ),
                  ),
                ),

                // (((currentDuThao.length == 0) || ((currentDuThao.length > 0) ?
                // currentDuThao[0].vbdiTrangThaiVB.ToString().Equals("1") :
                // false))
                //     // &&  (itemHosoContainHS.length !=1)
                // ) ?
                checkChuyenVaoHS == true?
                Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            TextButton.icon(
                              icon: Icon(Icons.ad_units_outlined
                              ),
                              label: Text('Chuy???n v??o h??? s??'),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                    chuyenVaoHS(id:widget.id,nam:widget.nam)));


                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ):SizedBox(),

//so???n v??n b???n d??? th???o
//                 ( currentDuThao.length == 0)?
                checkSoanVBDT == true?
                Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            TextButton.icon(
                              icon: Icon(Icons.ad_units
                              ),
                              label: Text('So???n VBDT',),
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) => ThemMoiDT(nam: '',)),
                                        (Route<dynamic> route) => true);


                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ):SizedBox(),


                Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            TextButton.icon(
                              icon: Icon(Icons.clear
                              ),
                              label: Text('Hu???'),
                              onPressed: () async {
                                EasyLoading.show();
                                await deleteHSCV( widget
                                    .id, "DeleteHSCV");
                                EasyLoading.dismiss();
                               Navigator.of(context).pop();
                              }
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),


                //CHuy???n v??n th??
                hscvTrangThaiXuLy == 1 && ChuyenVT == true?
                Container(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            TextButton.icon(
                                icon: Icon(Icons.send_sharp
                                ),
                                label: Text('Chuy???n v??n th??'),
                              onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Chuy???n v??o h??? s?? cho v??n'
                                      ' th??'),
                                  content: Text("B???n c?? ch???c ch???n mu???n chuy???n"
                                      " v??o h??? s?? c??ng vi???c ???? ch???n?"),
                                  actions: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [

                                        Padding(padding: EdgeInsets.only(left: 10,right: 10,top: 0),
                                          child:   TextButton.icon (
                                              icon: Icon(Icons.send_and_archive),
                                              label: Text('Ti???p t???c',style:
                                              TextStyle(fontWeight: FontWeight.bold)),
                                              onPressed: () async {
                                                EasyLoading.show();
                                                var thanhcong = await
                                                getDataDetailHSCV(widget
                                                    .id, "ChuyenVT" );

                                                EasyLoading.dismiss();
                                               Navigator.of(context).pop();
                                                showAlertDialog(context, json.decode(thanhcong)['Message']);
                                              },
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue[50]!),
                                                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                              )
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.only(left: 10,
                                            right: 10,top: 0),
                                          child:   TextButton.icon (
                                            // child: Text("????ng l???i",style: TextStyle(fontWeight: FontWeight.bold),),
                                              icon: Icon(Icons.delete_forever),
                                              label: Text('????ng l???i',style: TextStyle(fontWeight: FontWeight.bold)),
                                              onPressed: () {
                                               Navigator.of(context).pop();
                                              },
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                              )
                                          ),
                                        ),
                                      ],)
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ):SizedBox(),
                //SizedBox(),

              ],
            );
          }),
    );
  }

  void onPressButton(context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return _getBodyPage( index);
        });
  }



  //treeview chuy???n v??n b???n

  bool isAllSpaces(String input) {
    String output = input.replaceAll(' ', '');
    if(output == '') {
      return true;
    }
    return false;
  }
  // d??? li???u to??n b???
  Widget _getBodyPage( int index) {


    switch (index) {
      case 0:
        return Container(
            height: MediaQuery.of(context).size.height * .60,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                        hintText: 'Nh???p ?? ki???n',
                        contentPadding: EdgeInsets.only(left: 10.0, top: 15.0),
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
                    Padding(padding: EdgeInsets.only(top: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.lightBlue[50]!, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.35,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.06,
                        child:TextButton.icon (
                            icon: Icon(Icons.send),
                            label: Text("G???i ?? ki???n",style: TextStyle
                              (fontWeight:
                            FontWeight.bold, fontSize: 16,),
                              textAlign:
                              TextAlign.center,),
                            onPressed: () async {
                              bool isAllSpaces(String input) {
                                String output = input.replaceAll(' ', '');
                                if(output == '') {
                                  return true;
                                }
                                return false;
                              }
                              var tendangnhap = sharedStorage!.getString("username");
                              String iaa =  _titleController.text.trim();
                              if(isAllSpaces(iaa))
                              {showAlertDialog(context,"Nh???p ?? ki???n");
                              }
                              else {
                                EasyLoading.show();
                                var thanhcong = await postYKienHSCV(tendangnhap,
                                    widget.id, "Ykienxuly", _titleController.text);
                                EasyLoading.dismiss();
                               Navigator.of(context).pop();
                                _titleController.text = "";

                               Navigator.of(context).pop();

                                showAlertDialog(context, json.decode(thanhcong)['Message']);
                              }

                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue[50]!),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                            )
                        ),),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10,left: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.lightBlue[50]!, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.25,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.06,
                        child:TextButton.icon (
                            icon: Icon(Icons.delete_forever_outlined),
                            label: Text("????ng",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),textAlign:
                            TextAlign.center,),
                            onPressed: ()  {
                             Navigator.of(context).pop();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            )
                        ),),
                    ),

                  ],),

              ],
            ));
        break;

    }
    return SizedBox();
  }
}

//d??? li???u v??n b???n
class ListDataVBD {
  String text;
  String ID;

  ListDataVBD({required this.text, required this.ID});

  factory ListDataVBD.fromJson(Map<String, dynamic> json) {
    return ListDataVBD(ID: (json['key']), text: json['title']);
  }
}
