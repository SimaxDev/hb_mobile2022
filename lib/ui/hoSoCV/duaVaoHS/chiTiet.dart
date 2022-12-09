import 'package:flutter/material.dart';
import 'package:hb_mobile2021/ui/main/viewPDF.dart';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;


class ChiTietHSDuaVao extends StatefulWidget {


  @override
  _ChiTietVBDen createState() => _ChiTietVBDen();
}

class _ChiTietVBDen extends State<ChiTietHSDuaVao> {
  late int ItemId;
  bool isLoading = false;
  bool isLoadingPDF = true;
  var urlFile = null;
  ValueNotifier<String> assetPDFPath = ValueNotifier<String>('');
  ValueNotifier<String> remotePDFpath = ValueNotifier<String>('');

  int year = 0;


  @override
  void dispose(){
    super.dispose();
    // if(_timer != null){
    //   _timer.cancel();
    // }
  }


  @override
  void initState() {
    //_initializeTimer();
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                    child: Align(

                      alignment: Alignment.center,
                      child: Text(
                        'Văn bản đến',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13),
                      ),
                    )),      Tab(
                    child: Align(

                      alignment: Alignment.center,
                      child: Text(
                        'Văn bản đi',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13),
                      ),
                    )),      Tab(
                    child: Align(

                      alignment: Alignment.center,
                      child: Text(
                        'Hồ sơ xư lý văn bản',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13),
                      ),
                    )),      Tab(
                    child: Align(

                      alignment: Alignment.center,
                      child: Text(
                        'Hồ sơ xử lý công việc',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13),
                      ),
                    )),

              ],
            ),
            title: Text('Đưa văn bản, hồ sơ vào hồ sơ'),
          ),
          body:  !isLoading ?TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              //ThongTinVBDen(id:widget.id,username:widget.username),
              ViewPDFVB(),
              ViewPDFVB(),
              ViewPDFVB(),
              ViewPDFVB(),
            ],
          ):Center(
            child: CircularProgressIndicator(),
          ),
        )
    );
  }
}
