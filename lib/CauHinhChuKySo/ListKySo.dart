// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:hb_mobile2021/CauHinhChuKySo/CreateSignature.dart';
//
//
// import 'package:hb_mobile2021/data/moor_database.dart';
//
// class QuanLyChuKy extends StatefulWidget {
//   @override
//   _QuanLyChuKyState createState() => _QuanLyChuKyState();
// }
//
// class _QuanLyChuKyState extends State<QuanLyChuKy> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Quản lý chữ ký'),
//           actions: [
//             IconButton(
//                 icon: Icon(Icons.add),
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => CreateSignature(),
//                       ));
//                 }),
//           ],
//         ),
//         body: Column(
//           children: <Widget>[
//             Expanded(child: _buildTaskList(context)),
// //            NewTaskInput(),
//           ],
//         ));
//   }
//
//   StreamBuilder<List<Task>> _buildTaskList(BuildContext context) {
//     final database = Provider.of<TaskDatabase>(context);
//     return StreamBuilder(
//       stream: database.watchAllTasks(),
//       builder: (context, AsyncSnapshot<List<Task>> snapshot) {
//         final tasks = snapshot.data ?? List();
//
//         return ListView.builder(
//           itemCount: tasks.length,
//           itemBuilder: (_, index) {
//             final itemTask = tasks[index];
//             return _buildListItem(itemTask, database);
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildListItem(Task itemTask, TaskDatabase database) {
//     return Slidable(
//         actionPane: SlidableDrawerActionPane(),
//         secondaryActions: <Widget>[
//           IconSlideAction(
//             caption: 'Xóa',
//             color: Colors.red,
//             icon: Icons.delete,
//             onTap: () => database.deleteTask(itemTask),
//           )
//         ],
//         child: Container(
//           decoration: BoxDecoration(
//             border: Border(
//               bottom: BorderSide(width: 1.0, color: Colors.black26),
//             ),
//           ),
//           child: CheckboxListTile(
//             title: Image.memory(base64.decode(itemTask.name),
//                 width: 120, height: 180, fit: BoxFit.fill),
// //        subtitle: Text(itemTask.dueDate?.toString() ?? 'No date'),
//             value: itemTask.completed,
//             onChanged: (newValue) {
//               database.updateTask(itemTask.copyWith(completed: newValue));
//             },
//           ),
//         ));
//   }
// }
