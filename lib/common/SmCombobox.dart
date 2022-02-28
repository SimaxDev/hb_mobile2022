import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class SmComboBox extends StatefulWidget {
  //region Khai báo biến
  final List dataSource;
  final String titleText;
  List myActivities;
  ValueChanged<List<dynamic>> onSaved;
  //endregion

  SmComboBox(
      {Key key,
        this.dataSource,
        this.titleText,
        this.myActivities,
        this.onSaved})
      : super(key: key);

  @override
  _SmComboBoxState createState() => _SmComboBoxState(
      dataSource: dataSource,
      titleText: titleText,
      myActivities: myActivities,
      onSaved: onSaved);
}

class _SmComboBoxState extends State<SmComboBox> {
  //region Khai báo biến
  String _color = '';
  final List dataSource;
  final String titleText;
  List myActivities = [];
  ValueChanged<List<dynamic>> onSaved;

  //endregion
  _SmComboBoxState(
      {@required this.dataSource,
        this.titleText,
        this.myActivities,
        this.onSaved});

  @override
  Widget build(BuildContext context) {
    return FormField(builder: (FormFieldState state) {
      return InputDecorator(
        decoration: InputDecoration(
            icon: const Icon(Icons.text_snippet_outlined), border: InputBorder.none),
        isEmpty: _color == '',
        child: MultiSelectFormField(
          leading: const Icon(Icons.text_snippet_outlined),
         // /autovalidate: false,
          //titleText: titleText,
          //hintText: '',
          dataSource: dataSource ??
              [
                {"display": "Chọn", "value": "-1"}
              ],
          textField: 'display',
          valueField: 'value',
          okButtonLabel: 'OK',
          cancelButtonLabel: 'CANCEL',
          initialValue: myActivities,
          onSaved: (value) {
            if (value == null) return;
            setState(() {
              myActivities = value;
              onSaved(myActivities);
            });
          },
        ),
      );
    });
  }
}