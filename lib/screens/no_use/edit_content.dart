import 'dart:developer';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/content_model.dart';
import '../../utilities.dart';
import '../home_page.dart';
import '../../models/tab_model.dart';

class EditContentScreen extends StatefulWidget {
  ContentModel list;
  EditContentScreen(this.list, {super.key});

  @override
  State<EditContentScreen> createState() => _EditContentScreenState();
}

class _EditContentScreenState extends State<EditContentScreen> {
  final db = FirebaseFirestore.instance;
  final TextEditingController _editedContentTitle = TextEditingController();
  final TextEditingController _editedIndex = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editedContentTitle.text = widget.list.title;
    _editedIndex.text = widget.list.index.toString();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        title: const Text(
          "Update Content",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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
                controller: _editedContentTitle,
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
                controller: _editedIndex,
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
              ElevatedButton(
                  onPressed: () {
                    editFormulaContent(widget.list.id);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green.shade400,
                    onPrimary: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'update Content',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  // void editFormulaContent() async {
  //   final docRef = db.collection('formulacontent').doc();
  //
  //   ContentModel contentModel = ContentModel(
  //       docRef.id, _editedContentTitle.text, _editedContentDescription.text, widget.list.id);
  //
  //   await docRef.set(contentModel.toJson()).then(
  //           (value) {
  //         Navigator.pop(context);
  //         // widget.function();
  //       },
  //       onError: (e) => log("Error Adding Tab: $e"));
  // }

  Future<void> editFormulaContent(String documentId) async {
    print(documentId);
    Map<String, dynamic> updatedData = {
      'title': _editedContentTitle.text,
      'index': int.parse(_editedIndex.text)
    };
    try {
      await FirebaseFirestore.instance
          .collection('formulacontent')
          .doc(documentId)
          .update(updatedData).whenComplete(() {
        pushToNewRoute(context, const HomePage());
      });

      print('Data updated successfully!');
    } catch (error) {
      print('Error updating data: $error');
    }
  }
}
