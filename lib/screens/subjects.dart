

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:formula_user/screens/subject_detail_screen.dart';
import 'package:formula_user/utilities.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tab_model.dart';
import '../res/ads.dart';
import '../res/colours.dart';
import '../res/common.dart';
import '../res/styles.dart';
import '../subscription_manager.dart';


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
      body: _isLoading?const Center(child: CircularProgressIndicator(),) :Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: (){
                pushToNewRoute(context, SubjectDetail(list[index], (){}));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 12,right: 12,top: 8,bottom: 8),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colours.listBackground,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        spreadRadius: 0,
                        blurRadius: 0,
                        offset: const Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(list[index].name, style: Styles.textWith14withBold(Colours.black)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Icon(Icons.arrow_circle_right_outlined, color: Colours.buttonColor2, size: 20,),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      )
    );
  }

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
    });

    CollectionReference formulatab = FirebaseFirestore.instance.collection('formulatab');
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'formulatab';

    try {
      // Fetch cached data
      String? cachedData = prefs.getString(cacheKey);

      if (cachedData != null) {
        // Load data from cache
        List<dynamic> jsonData = json.decode(cachedData);
        list = jsonData.map((item) => TabModel.fromJson(item)).toList();
      }

      // Fetch data from Firestore
      QuerySnapshot querySnapshot = await formulatab.get(const GetOptions(source: Source.serverAndCache));

      if (querySnapshot.docs.isNotEmpty) {
        List<TabModel> newList = querySnapshot.docs
            .map((doc) => TabModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList();

        // Sort the new data
        newList.sort((a, b) => a.index.compareTo(b.index));

        // Check if new data is different from cached data
        String newJsonData = json.encode(newList.map((item) => item.toJson()).toList());
        if (newJsonData != cachedData) {
          // Update list with new data
          list = newList;
          // Save fetched data to cache
          await prefs.setString(cacheKey, newJsonData);
        }
      } else {
        list.add(TabModel("No Tab", "0", 0));

      }

      // Sort the list
      list.sort((a, b) => a.index.compareTo(b.index));
      // Update the UI with cached data
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching tab data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }


}


