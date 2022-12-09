import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BottomSheetWidget extends StatefulWidget {
  final String idDuThao;

  BottomSheetWidget({Key? key, required this.idDuThao}) : super(key: key);

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 0),
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10, color: Colors.grey[300]!, spreadRadius: 5)
                  ]),
              child: Column(
                children: <Widget>[
//                DecorateTextField(),
                  SheetButton(
                    idDuThao: widget.idDuThao,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DecorateTextField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration.collapsed(hintText: 'Nhập ý kiến'),
      ),
    );
  }
}

class SheetButton extends StatefulWidget {
  SheetButton({Key? key, required this.idDuThao}) : super(key: key);
  final String idDuThao;

  @override
  _SheetButtonState createState() => _SheetButtonState();
}

enum SingingCharacter { ky, kychuyen, trave }

class _SheetButtonState extends State<SheetButton> {
  bool checkingFlight = false;
  bool success = false;

  final TextEditingController _controller = TextEditingController();
  SingingCharacter _character = SingingCharacter.ky;

  Widget build(BuildContext context) {
    return SingleChildScrollView(

      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.05,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 5),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration.collapsed(hintText: 'Nhập ý kiến'),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: ListTile(
                title: const Text('Ký'),
                leading: Radio(
                  value: SingingCharacter.ky,
                  groupValue: _character,
    //onChanged: (SingingCharacter value) {
                  onChanged: ( value) {
                    setState(() {
                      _character = value as SingingCharacter;
                    });
                  },


                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: ListTile(
                title: const Text('Ký và chuyển PH'),
                leading: Radio(
                  value: SingingCharacter.kychuyen,
                  groupValue: _character,
                  //onChanged: (SingingCharacter value) {
                  onChanged: ( value) {
                    setState(() {
                      _character = value as SingingCharacter;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: ListTile(
                title: const Text('Trả về'),
                leading: Radio(
                  value: SingingCharacter.trave,
                  groupValue: _character,
                  //onChanged: (SingingCharacter value) {
                  onChanged: ( value) {
                    setState(() {
                      _character = value as SingingCharacter;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            !checkingFlight
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: MaterialButton(
                      color: Colors.grey[500],
                      onPressed: () async {
                        setState(() {
                          checkingFlight = true;
                        });
                        Send(_controller.text, widget.idDuThao,
                            _character.index);
                        await Future.delayed(Duration(seconds: 1));
                        setState(() {
                          success = true;
                        });
                        await Future.delayed(Duration(microseconds: 500));
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Gửi',
                      ),
                    ),
                  )
                : !success
                    ? CircularProgressIndicator()
                    : Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
          ],
        ),
      ),
    );
  }

  late SharedPreferences sharedStorage;

  Future<void> Send(String ykien, String id, int action) async {
    var apiUrl = Uri.parse("http://qlvbapi.moj.gov.vn/test/XuLyDuThao");
    String trangthai = "";
    if (action == 0) {
      trangthai = "5";
    } else if (action == 1) {
      trangthai = "1";
    } else {
      trangthai = "6";
    }
    sharedStorage = await SharedPreferences.getInstance();
    String? token = sharedStorage.getString("token");

    Map data = {"vbdiTrangThaiVB": trangthai, "id": id, "NoiDungYKien": ykien};
    String body = json.encode(data);

    var response = await http.post(apiUrl, body: data, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer ' + token!
    });

    if (response.statusCode == 200) {
      var items = jsonDecode(response.body);
      _showMyDialog(items['Message']);
    } else {}
  }

  Future<void> _showMyDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông báo!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
