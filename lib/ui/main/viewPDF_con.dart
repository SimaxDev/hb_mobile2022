import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hb_mobile2021/ui/main/truong_trung_gian.dart';
import 'package:hb_mobile2021/ui/main/shared.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ViewPDFVB_con extends StatefulWidget {

  final int idDuThao;
  final String viewPDF;


  ViewPDFVB_con({this.idDuThao,this.viewPDF});

  @override
  _ViewPDF createState() => _ViewPDF();
}

class _ViewPDF extends State<ViewPDFVB_con> {

  bool isLoading =  false;
  String localPath = "";
  int i = 0;
  String PDF_URL ="";
  File file;
  var PDF;
  var url;
  List<ListDataP>  ListDataPDF = [];
  SharedPreferences sharedStorage;
  Timer _timer;
  String downloadMessage = "Initalizing...";
  bool _isDownloading = false;
  bool percentageBool = false;
  double percentage = 0;


  void _initializeTimer() {
    _timer = Timer.periodic(const Duration(minutes:5), (_) {
      logOut(context);
      _timer.cancel();
    });

  }

  void _handleUserInteraction([_]) {
    if (!_timer.isActive) {
      // This means the user has been logged out
      return;
    }

    _timer.cancel();
    _initializeTimer();
  }


  Future<String> loadPDF( String urlPDF) async {
 i++;
      url = Uri.parse(urlPDF);
      print(url);
      var response = await http.get(url);
      //var dir = await getApplicationSupportDirectory();//truy cap vao muc
    // chinh
      //File file =  new File(dir.path+"/vanbanmoi.pdf");// tao 1 tep moi
 final filename = urlPDF.substring(urlPDF.lastIndexOf("/") + 1);
 var request = await HttpClient().getUrl(Uri.parse(urlPDF));
 var dir = await getApplicationDocumentsDirectory();
 print("Download files");
 print("${dir.path}/$filename");
 file = File("${dir.path}/$filename");
      // setState(() {
      //   isLoading = true;
      //   file =  new File(dir.path+"/vanbanmoi.pdf");// tao 1 tep moi
      // });
      await file.writeAsBytes(response.bodyBytes,flush: true);
      return file.path;




  }

  fetchData() async {
    if (mounted) { setState(() {
      isLoading = true;

    });}

    var url = Uri.parse("http://apihbmobile.ungdungtructuyen.vn/vbdt/GetbyID/?id=" + widget.idDuThao.toString());
    sharedStorage = await SharedPreferences.getInstance();
    String token = sharedStorage.getString("token");
    var response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer ' + token
    });

    if (response.statusCode == 200) {
      var items = jsonDecode(response.body)['OData'];

      if (mounted) { setState(() {
        // PDF_URL =  items['listFileAttachField']['urlField'];
        // print('pdf ủl $PDF_URL');
        isLoading = false;
      });}

    } else {
      isLoading = false;
    }
  }

  @override
  void initState() {
    _initializeTimer();
    // TODO: implement initState
    super.initState();
    PDF_URL=  pdf;
    if(widget.viewPDF != null ){
      PDF_URL = widget.viewPDF;
    }
    GetPDF(PDF_URL);
    //this.fetchData();
    if(mounted){ setState(() {
      var vanban = Listpdf;
      var lstData = (vanban as List).map((e) => ListDataP.fromJson(e)).toList();
      lstData.forEach((element) {
        ListDataPDF.add(element);

      });
    });}

  }

  @override
  void dispose() {
    // TODO: implement initState
    super.dispose();
   i=0;
  }

  GetPDF(String PDFD) async {

      loadPDF(PDFD).then((value) {
        if (mounted) {    setState(()
        {

          localPath =  value ;


        });}
      });



  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleUserInteraction,
      onPanDown: _handleUserInteraction,
      onScaleStart: _handleUserInteraction,
      child:Scaffold(
      body:
          Stack(children: [
            file!= null? PDFView(filePath: file.path,
                ):Center(child: CircularProgressIndicator()),
      Row(children: [Container(alignment: Alignment.topRight,
        width: MediaQuery.of(context).size.width *0.75,
        height: MediaQuery.of(context).size.height /15,
        // padding: EdgeInsets.all(10),
        margin:  EdgeInsets.only(left: 10,right: 0,top:0),
        // decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.all(Radius
        //         .circular(8))
        // ),

        child:FormField<String>(
          builder: (FormFieldState<String> state) {
            return DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: Text("Chọn bản ghi khác"),
                style: TextStyle(fontSize: 14,color: Colors.black),
                value: PDF,
                isDense: false,
                isExpanded: true,
                onChanged: (newValue) {
                  if(mounted){
                    setState(() {
                      PDF=newValue;

                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => ViewPDFVB_con(viewPDF:newValue)),
                              (Route<dynamic> route) => true);


                      // Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => ViewPDFVB_con(viewPDF:newValue)
                      //         ),
                      //       );

                      // GetDataKeyWord("","","",IDCoQuan);
                    });
                  }
                },
                items: ListDataPDF.map((value) {
                  return DropdownMenuItem<String>(
                      value: value.Url,
                      child:RichText(
                        text: TextSpan(
                          children: [

                            WidgetSpan(
                              child: Image(
                                height: 30,
                                width:20,
                                image: value.Name != null ?value.Name.contains("pdf")
                                    ?AssetImage('assets/pdf.png'):(value.Name
                                    .contains("doc")?AssetImage('assets/doc'
                                    '.png'):(value.Name
                                    .contains("docx")?AssetImage('assets/docx'
                                    '.png'): AssetImage('assets/logo_vb.png'))): AssetImage('assets/logo_vb.png'),

                              ),
                            ),
                            TextSpan(text:value.Name, style: TextStyle(
                                color: Colors.black.withOpacity(0.75),
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 13),

                            ),
                          ],
                        ),
                      )
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
        Container(
          width: MediaQuery.of(context).size.width *0.1,
          height: MediaQuery.of(context).size.height /15,
          margin: EdgeInsets.only(left: 10,top:20),
          alignment: Alignment.topCenter,
          child: IconButton(
            icon:Icon(Icons.download_sharp) ,
            onPressed: () async {


              setState(() {
                _isDownloading = !_isDownloading;

              });
              var dir = await getExternalStorageDirectory();

              Dio dio = Dio();
              dio.download(PDF_URL,
                  '${dir.path}/$namepdf',onReceiveProgress: (actualbytes,
                      totalbytes){
                    percentage =  actualbytes/totalbytes*100;

                    setState(() {
                      percentageBool = true;
                      downloadMessage =  'Downloading... ${percentage.floor()}'
                          ' %';
                      if(percentage <100){

                      }
                      else{
                        setState(() {
                          percentageBool = false;
                        });
                      }
                    });
                  });
              print(downloadMessage??'');
            },
          ),

        ),],),


          percentageBool == true ?  Center(
              child: CircularPercentIndicator(
                  radius: 60.0,
                  lineWidth: 5.0,
                  percent: 0.75,
                  center: new Text(downloadMessage, style: TextStyle(color: Color(0xFF535355))),
                  linearGradient: LinearGradient(begin: Alignment.topRight,end:Alignment.bottomLeft, colors: <Color>    [Color(0xFF1AB600),Color(0xFF6DD400)]),rotateLinearGradient: true,
                  circularStrokeCap: CircularStrokeCap.round)):SizedBox(),
          ],),

    ),);
  }
}
class ListDataP {
  String Name;
  String Url;


  ListDataP({ this.Name,this.Url});

  factory ListDataP.fromJson(Map<String, dynamic> json) {
    return ListDataP( Name: json['Name'],Url: json['Url']);
  }
}