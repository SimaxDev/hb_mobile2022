import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

var styleDropDownItem = TextStyle(fontSize: 15);

class TreeLoaiVanBan extends StatefulWidget {
  final String title;
  final String searchHintText;
  List<ListData> listData;
  ListData? listSelect;
  ValueChanged<List<int>> onSaved;
  List<int> selectedValueServer;
  bool multipleSelection;

  TreeLoaiVanBan({
    required this.title,
    required this.searchHintText,
     this.listSelect,
    required this.listData,
    required this.onSaved,
    required this.selectedValueServer,
    required this.multipleSelection});

  @override
  _TreeLoaiVanBan createState() => _TreeLoaiVanBan();
}

class _TreeLoaiVanBan extends State<TreeLoaiVanBan> {
  List<int> selectedItem = [];

  @override
  void initState() {
    super.initState();
    if (widget.selectedValueServer != null) {
      selectedItem = widget.selectedValueServer;
    }
  }

  void parentChange(newString) {
    if (mounted) { setState(() {
      selectedItem = newString;
      widget.onSaved(selectedItem);
    }); }

  }

  void _showDialog(context) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
        MaterialLocalizations.of(context).modalBarrierDismissLabel,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return DropDownListItem(
            customFunction: parentChange,
            searchHintText: widget.searchHintText,
            listData: widget.listData,
            selectedValue: selectedItem,

          );
        });
  }

  @override
  void dispose() {
    super.dispose();

    EasyLoading.dismiss();
  }

  checkExist(List<int> select){
    List<ListData> selectedItem = [];
    for(int i = 0; i < select.length ; i ++ ){
      var getItem = widget.listData.firstWhere((itemToCheck) => itemToCheck.ID == select[i], orElse: () => []as ListData);
      getItem != null ? selectedItem.add(getItem) : selectedItem.add([]as ListData);
    }
    return selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.6;
    return
      InkWell(
        child: Container(
          //height: 40,
          //padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
          // margin: EdgeInsets.only(top: 5, bottom: 5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black38 ,
                width: 1 ,
              ),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  // color: Colors.red,
                    width: MediaQuery.of(context).size.width *0.4599,
                    child:  (selectedItem.isEmpty
                        ? Padding(padding: EdgeInsets.only(left: 10),child: Text(widget.title != null ? widget.title : "Chọn") ,) :
                    ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: checkExist(selectedItem).length, itemBuilder: (context, index) {
                      return Card(
                        color: Colors.blue,
                        //   margin: EdgeInsets.all(4),
                        shape:  RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(45)),
                        ),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                          child: MaterialButton(
                            onPressed: () {  },
                            child: Center(
                              child: Text(checkExist(selectedItem)[index].text, style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ),
                      );
                    }))
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                        child: Icon(Icons.arrow_drop_down),
                        onTap: () {
                          _showDialog(context);
                        },
                      ),
                      InkWell(
                        child: Icon(
                          Icons.clear,
                          color: selectedItem.isNotEmpty
                              ? Colors.black87
                              : Colors.grey,
                        ),
                        onTap: () {
                          if (mounted) { setState(() {
                            selectedItem = [];
                          }); }

                        },
                      )
                    ],
                  ),
                )
              ],
            )
        ),
        onTap: () => _showDialog(context),
      );
  }
}

class DropDownListItem extends StatefulWidget {
  final customFunction;
  final String searchHintText;
  final List<ListData> listData;
  List<int> selectedValue;


  DropDownListItem({
    this.customFunction,
    required this.searchHintText,
    required this.listData,
    required this.selectedValue});

  @override
  State<StatefulWidget> createState() {
    return DropDownListItemState();
  }
}

class DropDownListItemState extends State<DropDownListItem> {
  List<ListData> dataList = [];
  List<ListData> dataListAll = [];
  @override
  void initState() {
    super.initState();
    this.getBody();
    dataListAll = widget.listData;
    if(widget.listData != null) {
      widget.listData.forEach((element) {
        dataList.add(element);
      });
    }
  }

  void filterSearch(String query) {
    if (query.isNotEmpty) {
      List<ListData> lstVanBanSearch = [];
      widget.listData.forEach((element) {
        ListData d = element;
        if (d.text.toLowerCase().contains(query) || d.text.toUpperCase().contains(query)) {
          lstVanBanSearch.add(d);
        }
      });
      if (mounted) {setState(() {
        dataList.clear();
        dataList.addAll(lstVanBanSearch);
      }); }

      return;
    } else {
      if (mounted) {setState(() {
        dataList.clear();
        List<ListData> lstVanBanSearchAll = [];
        widget.listData.forEach((element) {
          ListData d = element;
          lstVanBanSearchAll.add(d);
        });    dataList.addAll(lstVanBanSearchAll);
      });}


    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 25, 10, 10),
          color: Colors.black.withOpacity(0.1),
          child: AnimatedContainer(
            padding: MediaQuery
                .of(context)
                .viewInsets,
            duration: const Duration(milliseconds: 300),
            child: Scaffold(
              body: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(top: 20, bottom: 10),
                          child: Text(
                            widget.searchHintText != null
                                ? widget.searchHintText
                                : 'Tìm kiếm',
                            style: TextStyle(
                                fontSize: 21, fontWeight: FontWeight.bold),
                          )),
                      TextField(
                        autofocus: false,
                        style: TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search,
                              color: Colors.blueGrey, size: 22.0),
                          filled: true,
                          fillColor: Color(0x162e91),
                          hintText: 'Tìm kiếm',
                          hintStyle: TextStyle(fontSize: 16),
                          contentPadding: EdgeInsets.only(
                              left: 10.0, top: 15.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onChanged: (text) {
                          filterSearch(text);
                        },
                      ),
                      getBody(),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 15, 0, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                //widget.customFunction(widget.selectedValue);
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                  child: Text(
                                    'Đóng',
                                    style: TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  )),
                            )
                          ],
                        ),
                      )
                    ]),
              ),
              resizeToAvoidBottomInset: false,
            ),
          ),
        )
    );
  }

  Widget getBody() {
    return (dataList== null)
        ? Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
        ))
        : Expanded(
        child: Scrollbar(
            child: dataList.length == 0
                ? Center(
              child: Text("Không có bản ghi"),
            )
                : ListView.builder(
              padding: EdgeInsets.all(0.0),
              itemCount: dataList == null ? 0 : dataList.length,
              itemBuilder: (context, index) {
                return getCard(dataList[index]);
              },
            )));
  }

  Widget getCard(item) {
    var title = item.text;
    return InkWell(
        onTap: () {

          setState(() {
            widget.selectedValue.clear();
            widget.selectedValue.add(item.ID);
            widget.customFunction(widget.selectedValue);
          });
          Navigator.of(context).pop();
        },
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: DropdownMenuItem(
            child:  Text(title, style: styleDropDownItem),
          ),
        ));
  }
}

class ListData {
  String text;
  int ID;

  ListData({required this.text, required this.ID});

  factory ListData.fromJson(Map<String, dynamic> json) {
    return ListData(ID: (json['ID']), text: json['Title']);
  }
}