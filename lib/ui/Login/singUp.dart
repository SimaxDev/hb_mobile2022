import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hb_mobile2021/core/services/UserService.dart';
import 'package:hb_mobile2021/ui/main/DigLogThongBao.dart';



class singUp extends StatefulWidget {
  const singUp({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<singUp> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordCuController = TextEditingController();
  TextEditingController HoTenController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  bool rememberMe = false;
  bool isLoading = false;
  bool _showPass = true;
  bool _showPass1 = true;
  var user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xCCFFFF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // title: Center(
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Image(
        //         height: 50,
        //         image: AssetImage('assets/logovp.png'),
        //       ),
        //
        //
        //     ],
        //   ),
        // ),
        backgroundColor: Color(0xff3064D0),
      ),
      body: Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("assets/hb-logo.jpg"),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: SafeArea(
        child: Padding(
            padding: EdgeInsets.all(20),
            child:
                // isLoading
                //     ? Center(
                //     child: CircularProgressIndicator(
                //       valueColor:
                //       new AlwaysStoppedAnimation<Color>(Colors.white),
                //     ))
                //     :
                ListView(
              children: <Widget>[
                SizedBox(
                  height: 121.88,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Image(
                    height: 100,
                    image: AssetImage('assets/dangky.png'),
                  ),
                ),
                SizedBox(
                  height: 28.52,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Đăng ký",
                    style: TextStyle(
                      color: Color(0xff021029),
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      // shadows: [
                      //   Shadow(
                      //     blurRadius: 10.0,
                      //     color: Colors.white,
                      //     offset: Offset(5.0, 5.0),
                      //   )
                      // ]
                    ),
                  ),
                ),
                SizedBox(
                  height: 23,
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: new Theme(
                            data: new ThemeData(
                              primaryColor: Colors.black45,
                            ),
                            child: new TextField(
                              controller: HoTenController,
                              cursorColor: Colors.black45,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              decoration: new InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xffC0C0C0), width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                border: new OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.black45)),
                                labelText: 'Họ và tên',
                                labelStyle: TextStyle(
                                  color: Color(0xffC0C0C0),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                ),
                                // prefixIcon: const Icon(
                                //   Icons.person,
                                //   color: Colors.black,
                                // ),
                                prefixText: ' ',
                              ),
                            ),
                          )),


                      Container(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: new Theme(
                            data: new ThemeData(
                              primaryColor: Colors.black45,
                            ),
                            child: new TextField(
                              controller: EmailController,
                              cursorColor: Colors.black45,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              decoration: new InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xffC0C0C0), width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                border: new OutlineInputBorder(
                                    borderSide:
                                    new BorderSide(color: Colors.black45)),
                                labelText: 'Địa chỉ Email',
                                labelStyle: TextStyle(
                                  color: Color(0xffC0C0C0),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                ),
                                // prefixIcon: const Icon(
                                //   Icons.person,
                                //   color: Colors.black,
                                // ),
                                prefixText: ' ',
                              ),
                            ),
                          )),
                      Container(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: new Theme(
                            data: new ThemeData(
                              primaryColor: Colors.black45,
                            ),
                            child: new TextField(
                              controller: usernameController,
                              cursorColor: Colors.black45,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              decoration: new InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xffC0C0C0), width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                border: new OutlineInputBorder(
                                    borderSide:
                                    new BorderSide(color: Colors.black45)),
                                labelText: 'Tên truy cập',
                                labelStyle: TextStyle(
                                  color: Color(0xffC0C0C0),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                ),
                                // prefixIcon: const Icon(
                                //   Icons.person,
                                //   color: Colors.black,
                                // ),
                                prefixText: ' ',
                              ),
                            ),
                          )),
                      Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: [
                          Container(
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: new Theme(
                                data: new ThemeData(
                                  primaryColor: Colors.black45,
                                ),
                                child: new TextField(
                                  obscureText: _showPass,
                                  controller: passwordController,
                                  cursorColor: Colors.black45,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  decoration: new InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xffC0C0C0), width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    border: new OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Colors.white)),
                                    labelText: 'Mật khẩu',
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        color: Color(0xffC0C0C0),
                                        fontSize: 15),
                                    // prefixIcon: const Icon(
                                    //   Icons.lock,
                                    //   color: Colors.black,
                                    // ),
                                  ),
                                ),
                              )),
                          GestureDetector(
                              onTap: onToggleShowPass,
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child: Image(
                                  height: 30,
                                  color: Color(0xffC0C0C0),
                                  image: _showPass
                                      ? AssetImage('assets/logo_eye.png')
                                      : AssetImage('assets/logo_disseye.png'),
                                ),
                              ))
                        ],
                      ),
                      Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: [
                          Container(
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: new Theme(
                                data: new ThemeData(
                                  primaryColor: Colors.black45,
                                ),
                                child: new TextField(
                                  obscureText: _showPass1,
                                  controller: passwordCuController,
                                  cursorColor: Colors.black45,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  decoration: new InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xffC0C0C0), width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    border: new OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Colors.white)),
                                    labelText: 'Nhập lại mật khẩu',
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        color: Color(0xffC0C0C0),
                                        fontSize: 15),
                                    // prefixIcon: const Icon(
                                    //   Icons.lock,
                                    //   color: Colors.black,
                                    // ),
                                  ),
                                ),
                              )),
                          GestureDetector(
                              onTap: onToggleShowPass1,
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child: Image(
                                  height: 30,
                                  color: Color(0xffC0C0C0),
                                  image: _showPass1
                                      ? AssetImage('assets/logo_eye.png')
                                      : AssetImage('assets/logo_disseye.png'),
                                ),
                              ))
                        ],
                      ),
                      Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: [
                          Container(
//                   color: Colors.white,
                            width: MediaQuery.of(context).size.width * 0.885,
                            height: 72,
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: RaisedButton(
                              color:Color(0xff3064D0),
                              shape: RoundedRectangleBorder(
                                  side: new BorderSide(
                                    color: Color(0xff3064D0),
                                  ),
                                  //the outline color
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(10))),
                              child: Text('Đăng ký',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    // color: Colors.white,
                                  )),
                              onPressed: () async {
                                if(
                                usernameController.text==""||usernameController.text== null&&
                                    HoTenController
                                        .text==""||HoTenController.text== null&&
                                    EmailController
                                        .text==""||EmailController.text== null&&
                                    passwordController
                                        .text==""||passwordController.text==
                                        null&&
                                    passwordCuController.text==""||passwordCuController.text== null
                                ){
                                  showAlertDialog(context, "Nhập đầy "
                                      "đủ thông tin đăng ký!");
                                }else{

                                if(usernameController
                                    .text==""||usernameController.text== null){
                                  showAlertDialog(context, "Tài khoản đăng ký"
                                      " không được để trống?");
                                }
                                else {
                                  if (passwordController.text ==
                                      null || passwordController.text
                                      == "" || passwordCuController
                                      .text == null || passwordCuController
                                      .text == "") {
                                    showAlertDialog(context, "Mật khẩu đăng ký"
                                        " không được để trống?");
                                  }
                                  else {
                                    if (passwordController.text !=
                                        passwordCuController.text) {
                                      showAlertDialog(
                                          context, "Nhập lại mật khẩu "
                                          "đăng ký!");
                                      passwordController.text = "";
                                      passwordCuController.text = "";
                                    }
                                    else {
                                      EasyLoading.show();
                                      var thanhcong
                                      = await postCreate
                                        (usernameController.text,
                                        passwordController.text,
                                          EmailController.text);
                                      EasyLoading.dismiss();
                                      Navigator.of(context).pop();
                                      showAlertDialog(context, json.decode(thanhcong)['Message']);
                                    }
                                  }
                                }

                                }



                                // login(usernameController.text.trim(),
                                //     passwordController.text);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                )
              ],
            )),
      )),
    );
  }

  void onToggleShowPass() {
    if (mounted) {
      setState(() {
        _showPass = !_showPass;
      });
    }
  }
  void onToggleShowPass1() {
    if (mounted) {
      setState(() {
        _showPass1 = !_showPass1;
      });
    }
  }
}
