

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:formula_user/screens/subject_detail_screen.dart';
import 'package:formula_user/utilities.dart';
import '../models/tab_model.dart';
import '../res/colours.dart';
import '../res/styles.dart';


class Subjects extends StatefulWidget {

   Subjects({ super.key});

  @override
  State<Subjects> createState() => _SubjectsState();

}


class _SubjectsState extends State<Subjects> {
  bool _isLoading = false;


  @override
  initState(){
    getData();
    super.initState();
  }
  final db = FirebaseFirestore.instance;
  List<TabModel> list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        toolbarHeight: 40,
        title: Text("Subjects",
            style: Styles.textWith18withBold(Colours.white)),
        backgroundColor: Colours.buttonColor2,
        iconTheme: IconThemeData(
            color: Colours.white
        ),
      ),
      body: _isLoading?Center(child: CircularProgressIndicator(),) :ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color:Colours.listBackground ,
                  borderRadius: BorderRadius.circular(6)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(list[index].name,style: Styles.textWith14withBold(Colours.black)),
                      Icon(Icons.arrow_circle_right_outlined,color: Colours.buttonColor2,size: 20,)
                    ],
                  ),
                ),
              ),
            ),
            onTap: () {
              pushToNewRoute(context,SubjectDetail(list[index], (){}));

            },
          );
        },
      )
    );
  }

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
    });
    CollectionReference formulatab =
    FirebaseFirestore.instance.collection('formulatab');
    QuerySnapshot querySnapshot = await formulatab.get();

    if (querySnapshot.docs.isNotEmpty) {
      list = querySnapshot.docs
          .map((doc) => TabModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      list.sort((a, b) => a.index.compareTo(b.index));
      setState(() {
        _isLoading = false;
      });
    } else {
      list.add(TabModel("No Tab", "0", 0));
      setState(() {
        _isLoading = false;
      });
    }
  }

}


