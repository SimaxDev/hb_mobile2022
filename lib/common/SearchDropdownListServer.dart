import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

var styleDropDownItem = TextStyle(fontSize: 15);

class SearchServer extends StatefulWidget {
  final String title;
  final String searchHintText;
  List<ListData> listData;
  ListData listSelect;
  ValueChanged<List<int>> onSaved;
  List<int> selectedValueServer;
  bool multipleSelection;

  SearchServer({
    this.title,
    this.searchHintText,
    this.listSelect,
    this.listData,
    this.onSaved,
    this.selectedValueServer,
    this.multipleSelection});

  @override
  SearchServerState createState() => SearchServerState();
}

class SearchServerState extends State<SearchServer> {
  List<int> selectedItem = [];

  @override
  void initState() {
    super.initState();
    if (widget.selectedValueServer != null) {
      selectedItem = widget.selectedValueServer;
    }
  }

  @override
  void dispose(){
    super.dispose();
    selectedItem;
  widget.listData;
    widget.listSelect;
    widget.onSaved;
    widget.selectedValueServer;
    widget.multipleSelection;
  }

  void parentChange(newString) {
    setState(() {
      selectedItem = newString;
      widget.onSaved(selectedItem);
    });
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
              multipleSelection : widget.multipleSelection
          );
        });
  }



  checkExist(List<int> select){
    List<ListData> selectedItem = [];
    for(int i = 0; i < select.length ; i ++ ){
      var getItem = widget.listData.firstWhere((itemToCheck) => itemToCheck.ID == select[i], orElse: () => null);
      getItem != null ? selectedItem.add(getItem) : selectedItem.add(null);
    }
    return selectedItem;
  }

  @override
  Widget build(BuildContext context) {

    return
      InkWell(
        child: Container(
            height:MediaQuery.of(context).size.height *0.06,
            padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
            margin: EdgeInsets.only(top: 5, bottom: 5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Container(
                  // color: Colors.red,
                    width: MediaQuery.of(context).size.width *0.45,
                    child:  (selectedItem.isEmpty
                        ? Text(widget.title != null ? widget.title : "Chọn ",style: TextStyle(color:
                    Colors
                            .red),) :
                    ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: checkExist(selectedItem).length, itemBuilder: (context, index) {
                      return Card(
                        color: Colors.blue,
                        margin: EdgeInsets.all(4),
                        shape:  RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(45)),
                        ),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                          child: MaterialButton(
                            child: Center(
                              child: Text(checkExist(selectedItem)[index].text, style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      );
                    }))
                ),
                Transform.translate(offset: Offset(6, 0.0),
                child:Container(
                  // width: MediaQuery.of(context).size.width *0.0999,
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
                          setState(() {
                            selectedItem = [];
                          });
                        },
                      )
                    ],
                  ),
                ) ,),

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
  bool multipleSelection;

  DropDownListItem({
    this.customFunction,
    this.searchHintText,
    this.listData,
    this.selectedValue, this.multipleSelection});

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
    if(dataListAll != null) {
      dataListAll.forEach((element) {
        dataList.add(element);
      });
    }
  }

  void filterSearch(String query) {
    if (query.isNotEmpty) {
      List<ListData> lstVanBanSearch = [];
      dataListAll.forEach((element) {
        ListData d = element;
        if (d.text.toString().contains(query)) {
          lstVanBanSearch.add(d);
        }
      });
      setState(() {
        dataList.clear();
        dataList.addAll(lstVanBanSearch);
      });
      return;
    } else {
      setState(() {
        dataList.clear();
        List<ListData> lstVanBanSearchAll = [];
        dataListAll.forEach((element) {
          ListData d = element;
          lstVanBanSearchAll.add(d);
        });
        dataList.addAll(lstVanBanSearchAll);
      });
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
                      Container(
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                          child: Container(
                              child: Text(
                                'X Bỏ chọn tất cả',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black87),
                              )),
                          onPressed: () {
                            setState(() {
                              widget.selectedValue = [];
                            });
                          },
                        ),
                      ),
                      getBody(),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 15, 0, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                widget.customFunction(widget.selectedValue);
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
    var existingItem = widget.selectedValue.firstWhere(
            (itemToCheck) => itemToCheck == item.ID,
        orElse: () => null);
    return InkWell(
        onTap: () {
          if (widget.multipleSelection) {
            if (existingItem != null) {
              setState(() {
                widget.selectedValue.removeWhere((i) => i == item.ID);
              });
            } else {
              setState(() {
                widget.selectedValue.add(item.ID);
              });
            }
          } else {
            setState(() {
              widget.selectedValue.clear();
              widget.selectedValue.add(item.ID);
              widget.customFunction(widget.selectedValue);
            });
            Navigator.of(context).pop();
          }
        },
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: DropdownMenuItem(
            child: widget.multipleSelection
                ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(existingItem != null
                    ?
                  Icons.check_box
                    : Icons.check_box_outline_blank,
                  color: Colors.blue,
                ),
                Padding(padding: EdgeInsets.only(left: 10),child:SizedBox(
                  width: MediaQuery.of(context).size.height * 0.1,
                  child:new Wrap(
                    spacing: 5.0,
                    runSpacing: 5.0,
                    direction: Axis.vertical, // main axis (rows or columns)
                    children: <Widget>[
                      Text(
                        title != null  ? title :  'Loading...',
                        style: styleDropDownItem,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ],
                  ),
                ),)


              ],
            )  : Text(title, style: styleDropDownItem),
          ),
        ));
  }
}

class ListData {
  String text;
  int ID;

  ListData({@required this.text, @required this.ID});

  factory ListData.fromJson(Map<String, dynamic> json) {
    return ListData(ID: (json['ID']), text: json['Title']);
  }
}