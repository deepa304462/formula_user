import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/tab_model.dart';

class AddTabScreen extends StatefulWidget {
  AddTabScreen(this.function,{super.key});

  Function function;
  @override
  State<AddTabScreen> createState() => _AddTabScreenState();
}


class _AddTabScreenState extends State<AddTabScreen> {
  final db = FirebaseFirestore.instance;
  final TextEditingController _tabName = TextEditingController();
  final TextEditingController _index = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        title: const Text("Create Tab",style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Form(
              autovalidateMode: AutovalidateMode.always,
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter Title";
                      }
                      return null;
                    },
                    controller: _tabName,
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter Index";
                      }
                      return null;
                    },
                    controller: _index,
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
                  ElevatedButton(
                    onPressed: () {
                      addTab();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green.shade400,
                      onPrimary: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Add Tab',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void addTab() async {
    setState(() {
      _isLoading = true;
    });

    final docRef = db.collection('formulatab').doc();
    TabModel tabModel = TabModel(_tabName.text, docRef.id,int.parse(_index.text));

    await docRef.set(tabModel.toJson()).then(
          (value) {
        Navigator.pop(context);
        widget.function();
      },
      onError: (e) => log("Error Adding Tab: $e"),
    ).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }
}

