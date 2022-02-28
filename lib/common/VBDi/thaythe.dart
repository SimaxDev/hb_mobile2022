import 'dart:math';
import 'package:flutter/material.dart';
import 'package:responsive_table/DatatableHeader.dart';
import 'package:responsive_table/ResponsiveDatatable.dart';



class DataPage extends StatefulWidget {
  final int id;
  final String nam;

  DataPage({this.id,this.nam});
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  DataTableSource _data = MyData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kindacode.com'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          PaginatedDataTable(

            source: _data,
            header: Text('My Products'),
            columns: [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Name',)),
              DataColumn(label: Text('Price'))
            ],
            //columnSpacing: 100,
            //horizontalMargin: 10,
            rowsPerPage: 8,
            showCheckboxColumn: true,
          ),
        ],
      ),
    );
  }
}

// The "soruce" of the table
class MyData extends DataTableSource {
  // Generate some made-up data
  final List<Map<String, dynamic>> _data = List.generate(
      300,
          (index) => {
        "id": index,
        "title": "Itemsdgbfdm,.bjsdfnvkjdlsvhn dsfj vbsdk,msdhkdsjdsnkfdsjkds"
            ".hnvkds.kvhnds,vdksfvkdjsn $index",
        "price": Random().nextInt(10000)
      });

  bool get isRowCountApproximate => false;
  int get rowCount => _data.length;
  int get selectedRowCount => 0;
  DataRow getRow(int index) {
    return DataRow(
        cells: [
      DataCell(Text(_data[index]['id'].toString())),
      DataCell( Container(
    width: 200, //SET width
    child: Text(_data[index]["title"],maxLines:1,overflow:
    TextOverflow
        .ellipsis,style:
    TextStyle
      (fontSize: 10),))),

      DataCell(Text(_data[index]["price"].toString())),
    ]);
  }
}