import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/tab_model.dart';
import '../../utilities.dart';
import '../home_page.dart';


class EditTabScreen extends StatefulWidget {
  TabModel list;
  EditTabScreen(this.list,{super.key});

  @override
  State<EditTabScreen> createState() => _EditTabScreenState();
}

class _EditTabScreenState extends State<EditTabScreen> {
 final  TextEditingController _editedtabName = TextEditingController();
 final  TextEditingController _editIndex = TextEditingController();
 @override
  void initState() {
    super.initState();
    _editedtabName.text=widget.list.name;
    _editIndex.text= widget.list.index.toString();
  }
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        title: const Text("Edit Tab",style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(
            color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                validator: (value) {
                  if(value!.isEmpty){
                    return "Please Edit Title";
                  }
                  return null;
                },
                controller: _editedtabName,
                decoration: InputDecoration(
                  labelText: 'Edit Title',
                  labelStyle: TextStyle(
                    color: Colors.grey[800],
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if(value!.isEmpty){
                    return "Please Edit Index";
                  }
                  return null;
                },
                controller: _editIndex,
                decoration: InputDecoration(
                  labelText: 'Edit Index',
                  labelStyle: TextStyle(
                    color: Colors.grey[800],
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(onPressed: (){
                EditTab(widget.list.id);
                 pushToNewRoute(context, HomePage());
              },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.green.shade400,
                    minimumSize: const Size(double.infinity,50),
                  ),
                  child: const Text('Edit Formula',style: TextStyle(
                      color: Colors.white
                  ),))
            ],
          ),
        ),
      ),
    );
  }

 Future <void> EditTab(String documentId) async {
    Map<String, dynamic> updatedData = {
      'name': _editedtabName.text,
      'index':int.parse(_editIndex.text),
    };
    try {
      await FirebaseFirestore.instance.collection('formulatab').doc(documentId).update(updatedData);
      print('Data updated successfully!');
    } catch (error) {
      print('Error updating data: $error');
    }


  }
}
