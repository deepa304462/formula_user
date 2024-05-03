import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/content_model.dart';
import '../../models/tab_model.dart';
import '../../res/colours.dart';


class AddContentScreen extends StatefulWidget {
 final TabModel list;
  final Function function;
   AddContentScreen(this.list,this.function,{super.key});

  @override
  State<AddContentScreen> createState() => _AddContentScreenState();
}

class _AddContentScreenState extends State<AddContentScreen> {
  final db = FirebaseFirestore.instance;
  TextEditingController _title = TextEditingController();
  TextEditingController _index = TextEditingController();
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        title: const Text("Add Content"),
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
                controller: _title,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Enter Title";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Title',
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
                controller: _index,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Enter Index";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Index',
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

              const SizedBox(
                height: 20,
              ),
          isLoading ?CircularProgressIndicator(color: Colours.appbar,):  ElevatedButton(onPressed: () {
                addFormulaContent();
              },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.green.shade400,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Add Content', style: TextStyle(
                      color: Colors.white
                  ),))
            ],
          ),
        ),
      ),
    );
  }

  void addFormulaContent() async {
    setState(() {
      isLoading = true;
    });
    final docRef = db.collection('formulacontent').doc();

    ContentModel contentModel = ContentModel(
        docRef.id, _title.text,  widget.list.id,int.parse(_index.text));

    await docRef.set(contentModel.toJson()).then(
            (value) {
          Navigator.pop(context);
           widget.function();
        },
        onError: (e){
              log("Error Adding Tab: $e");
              setState(() {
                isLoading = false;
              });


    } );
  }
}


