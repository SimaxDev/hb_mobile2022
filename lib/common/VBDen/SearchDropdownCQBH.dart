import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


var styleDropDownItem = TextStyle(fontSize: 15);

class SearchServerCQBH extends StatefulWidget {
  final String title;
  final String searchHintText;
  List<ListDataCQBH> listData;
  ListDataCQBH? listSelect;
  ValueChanged<List<int>> onSaved;
  List<int> selectedValueServer;
  bool multipleSelection;

  SearchServerCQBH({
    required this.title,
    required this.searchHintText,
     this.listSelect,
    required this.listData,
    required this.onSaved,
    required this.selectedValueServer,
    required this.multipleSelection});

  @override
  SearchServerCQBHState createState() => SearchServerCQBHState();
}

class SearchServerCQBHState extends State<SearchServerCQBH> {
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
    List<ListDataCQBH> selectedItem = [];
    for(int i = 0; i < select.length ; i ++ ){
      var getItem = widget.listData.firstWhere((itemToCheck) => itemToCheck.ID == select[i], orElse: () => []as ListDataCQBH);
      getItem != null ? selectedItem.add(getItem) : selectedItem.add([]as ListDataCQBH);
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
              border: Border.all(color: Colors.black45),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Row(
             mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                Container(
                  // color: Colors.red,
                    width: MediaQuery.of(context).size.width *0.45,
                    child:  (selectedItem.isEmpty
                        ? Text(widget.title != null ? widget.title : "Chọn ",style: TextStyle(color:
                    Colors
                        .black),) :
                    ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: checkExist(selectedItem).length, itemBuilder: (context, index) {
                      return Card(

                        color: Colors.white,

                       /* shape:  RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(45)),
                        ),*/
                        child: Container(
                         // padding: EdgeInsets.fromLTRB(0,0,0,0),
                          child: MaterialButton(
                            onPressed: () {  },
                            child: Center(
                              child: Text(checkExist(selectedItem)[index].text, style: TextStyle(color: Color(0xff3c4043)),
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
  final List<ListDataCQBH> listData;
  List<int> selectedValue;
  bool multipleSelection;

  DropDownListItem({
    this.customFunction,
    required this.searchHintText,
    required this.listData,
    required this.selectedValue, required this.multipleSelection});

  @override
  State<StatefulWidget> createState() {
    return DropDownListItemState();
  }
}

class DropDownListItemState extends State<DropDownListItem> {
  List<ListDataCQBH> dataList = [];
  List<ListDataCQBH> dataListAll = [];
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
      List<ListDataCQBH> lstVanBanSearch = [];
      dataListAll.forEach((element) {
        ListDataCQBH d = element;
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
        List<ListDataCQBH> lstVanBanSearchAll = [];
        dataListAll.forEach((element) {
          ListDataCQBH d = element;
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
                        child: TextButton(
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
                            TextButton(
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
        orElse: () => -1);
    return InkWell(
        onTap: () {
          if (widget.multipleSelection) {
            if (existingItem != -1) {
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
                Icon(existingItem != -1
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

class ListDataCQBH {
  String text;
  int ID;

  ListDataCQBH({required this.text, required this.ID});

  factory ListDataCQBH.fromJson(Map<String, dynamic> json) {
    return ListDataCQBH(ID: (json['ID']), text: json['Title']);
  }
}