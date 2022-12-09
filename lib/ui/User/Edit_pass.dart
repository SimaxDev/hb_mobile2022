import 'dart:async';
import 'dart:convert';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hb_mobile2021/core/services/UserService.dart';
import 'package:hb_mobile2021/ui/Login/Login.dart';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';


class EditPassWord extends StatefulWidget {
  String tendangnhap ;
 EditPassWord({Key? key, required this.tendangnhap}) : super(key: key);

  @override
  _EditPassWordState createState() => _EditPassWordState();
}

class _EditPassWordState extends State<EditPassWord> {

  bool isLoading = false;
TextEditingController matKhauCu =  new TextEditingController();
TextEditingController matKhauMoi =  new TextEditingController();
TextEditingController nhapLaiMatKhau =  new TextEditingController();


  @override
  void initState(){
    super.initState();
   // _initializeTimer();
  }

  @override
  void dispose(){
    super.dispose();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Đổi password truy cập')),
        body:
        SingleChildScrollView(
          child: Column(
            children: [

              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.3,
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Tên đăng nhập',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black38 ,

                      ),
                      borderRadius: BorderRadius.circular(10),

                    ),
                    height:MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.6,
                    padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                    child: Text(widget.tendangnhap
                      ,
                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                      textAlign: TextAlign.justify,

                    ),
                  )


                ],
              ),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.3,
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Mật khẩu cũ',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black38 ,

                      ),
                      borderRadius: BorderRadius.circular(10),

                    ),
                    height:MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.6,
                    padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                    child: TextFormField(
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Yêu cầu nhập giá trị cho trường này';
                        }

                      },
                      controller: matKhauCu,
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),

                    ),
                  ),
                ],
              ),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.3,
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Mật khẩu mới',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black38 ,

                      ),
                      borderRadius: BorderRadius.circular(10),

                    ),
                    height:MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.6,
                    padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                    child: TextFormField(
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Yêu cầu nhập giá trị cho trường này';
                        }
                        return null;
                      },
                      obscureText: true,
                      controller: matKhauMoi,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),

                    ),
                  ),


                ],
              ),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.3,
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Nhập lại mật khẩu mới',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black38 ,

                      ),
                      borderRadius: BorderRadius.circular(10),

                    ),
                    height:MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.6,
                    padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                    child: TextFormField(
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Yêu cầu nhập giá trị cho trường này';
                        }
                        return null;
                      },
                      obscureText: true,
                      controller: nhapLaiMatKhau,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),

                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),

              Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent, // background (button) color
                        foregroundColor: Colors.white,  // foreground (text) color
                        shape:  RoundedRectangleBorder(
                            side:new  BorderSide(color: Colors.blue,), //the outline color
                            borderRadius: new BorderRadius.all(new Radius.circular(10)))),
                    child: Text('Cập nhật',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        )),
                    onPressed: () {
                      setState(() async {
                        if(matKhauCu.text != matKhauHT )
                        {
                          showAlertDialog(context, 'Yêu cầu nhập đúng mật khẩu' );
                        }else
                        if(nhapLaiMatKhau.text  != matKhauMoi.text )
                        {
                          showAlertDialog(context, 'Nhập lại mật khẩu không đúng' );
                        }
                        else if(matKhauMoi.text.isEmpty || nhapLaiMatKhau.text.isEmpty)
                        {
                          showAlertDialog(context, 'Yêu cầu các trường không được để trống' );
                        }
                        else
                        {
                          var thanhcong =  null;
                          String tendangnhap = tendangnhapAll;
                          //update data
                          EasyLoading.show();
                          thanhcong=  await postResset(tendangnhap,
                              matKhauMoi.text);
                          EasyLoading.dismiss();
                          showAlertDialog(context, json.decode(thanhcong)['Message']);
                          if( json.decode(thanhcong)['Message'].contains('Ðổi mật khẩu thành công'))
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginWidget(),
                                ));
                          }
                          else
                            Navigator.of(context).pop();




                        }


                        isLoading = true;
                      });
                      // login(usernameController.text.trim(),
                      //     passwordController.text);
                    },
                  )
              ),
            ],

          ),
        )


    );
  }
}
