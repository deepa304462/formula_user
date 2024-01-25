import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:formula_user/screens/content_item_list.dart';
import 'package:formula_user/screens/subject_detail_screen.dart';
import 'package:formula_user/screens/tab_contents.dart';
import 'package:formula_user/utilities.dart';

import '../models/content_item_model.dart';
import '../models/content_model.dart';
import '../models/tab_model.dart';
import '../res/colours.dart';
import '../res/styles.dart';


class Subjects extends StatefulWidget {

   Subjects({ super.key});

  @override
  State<Subjects> createState() => _SubjectsState();

}



class _SubjectsState extends State<Subjects> {

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
        backgroundColor: Colours.appbar,
        iconTheme: IconThemeData(
            color: Colours.white
        ),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color:Colours.greyLight),
                  borderRadius: BorderRadius.circular(6)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(list[index].name,style: Styles.textWith16bold(Colours.black)),
                      Icon(Icons.arrow_circle_right_outlined,color: Colours.buttonColor2,)
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
    CollectionReference formulatab =
    FirebaseFirestore.instance.collection('formulatab');
    QuerySnapshot querySnapshot = await formulatab.get();

    if (querySnapshot.docs.isNotEmpty) {
      list = querySnapshot.docs
          .map((doc) => TabModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      list.sort((a, b) => a.index.compareTo(b.index));
      setState(() {});
    } else {
      list.add(TabModel("No Tab", "0", 0));
      setState(() {});
    }
  }

}


