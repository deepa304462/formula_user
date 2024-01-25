import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../models/tab_model.dart';
import '../../utilities.dart';
import 'edit_tab_screen.dart';
import 'add_content.dart';



class FloatingActionButtonMenu extends StatefulWidget {
  TabModel list;
  Function function;

  FloatingActionButtonMenu(this.list,this.function, {super.key});

  @override
  State<FloatingActionButtonMenu> createState() => _FloatingActionButtonMenuState();
}

class _FloatingActionButtonMenuState extends State<FloatingActionButtonMenu> {
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      backgroundColor: Colors.green.shade400,
      iconTheme: IconThemeData(
        color: Colors.white
      ),
      icon: Icons.menu,
      activeIcon: Icons.close,
      spacing: 10.0,
      childPadding: EdgeInsets.all(5.0),
      curve: Curves.easeIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.add),
          label: 'Add content',
          onTap: () {
            // Handle add action
            pushToNewRoute(context, AddContentScreen(widget.list,(){
              widget.function();
            }));
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.edit),
          label: 'Edit Tab',
          onTap: () {
            pushToNewRoute(context, EditTabScreen(widget.list));
            // Handle edit action
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.delete),
          label: 'Delete Tab',
          onTap: () {
            // Handle delete action
            deleteDocument();
          },
        ),
      ],
    );




  }

  void deleteDocument() {
    // Reference to the document you want to delete
    DocumentReference documentRef = FirebaseFirestore.instance.collection('formulatab').doc(widget.list.id);

    // Delete the document
    documentRef.delete()
        .then((value){
      widget.function();
    })
        .catchError((error) => print('Failed to delete document: $error'));
  }
}
