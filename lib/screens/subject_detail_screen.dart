

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/content_model.dart';
import '../models/tab_model.dart';
import '../res/colours.dart';
import '../res/styles.dart';
import '../utilities.dart';
import 'no_use/add_content_item_screen.dart';
import 'content_list.dart';
import 'no_use/edit_content.dart';

class SubjectDetail extends StatefulWidget {
  TabModel currentTab;
  SubjectDetail(this.currentTab,this.function, {super.key});
  Function function;

  @override
  State<SubjectDetail> createState() => _SubjectDetailState();
}

class _SubjectDetailState extends State<SubjectDetail> {
  List<ContentModel> list = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getContentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        elevation: 10,
        toolbarHeight: 40,
        titleSpacing: 0,
        title: Text(widget.currentTab.name,
            style: Styles.textWith18withBold(Colours.white)),
        backgroundColor: Colours.buttonColor2,
        iconTheme: IconThemeData(
          color: Colours.white
        ),
      ),
      body: _isLoading ? _buildLoadingIndicator(Colours.buttonColor2) : _buildPanel(),
    );
  }

  Widget _buildLoadingIndicator(Color color) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildPanel() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: ExpansionPanelList(
              elevation: 1,
              expandedHeaderPadding: const EdgeInsets.all(0),
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  list[index].isExpanded = isExpanded;
                });
              },
              children: list.map<ExpansionPanel>((ContentModel item) {
                return ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      onTap: (){
                        setState(() {
                          item.isExpanded = !isExpanded;
                        });
                      },
                      title: Row(
                        children: [
                          Flexible(child: Text(item.title)),
                        ],
                      ),
                      titleTextStyle: Styles.textWith16(Colours.black),
                    );
                  },
                  body: Padding(
                    padding: const EdgeInsets.only(left: 12,right: 12,),
                    child: ContentList(item),
                  ),
                  isExpanded: item.isExpanded,
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

// Add this inside your class
  static const cacheDuration = Duration(hours: 1); // Set your refresh interval here

  Future<void> getContentData() async {
    setState(() {
      _isLoading = true;
    });

    list = [];
    CollectionReference formulacontent = FirebaseFirestore.instance.collection('formulacontent');
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'formulacontent_${widget.currentTab.id}';

    try {
      // Fetch cached data
      String? cachedData = prefs.getString(cacheKey);

      if (cachedData != null) {
        // Load data from cache
        List<dynamic> jsonData = json.decode(cachedData);
        list = jsonData.map((item) => ContentModel.fromJson(item)).toList();

      }

      // Fetch data from Firestore
      QuerySnapshot querySnapshot = await formulacontent
          .where("tabId", isEqualTo: widget.currentTab.id.toString())
          .get(const GetOptions(source: Source.serverAndCache));

      if (querySnapshot.docs.isNotEmpty) {
        List<ContentModel> newList = querySnapshot.docs
            .map((doc) => ContentModel.fromJson(doc.data() as Map<String, dynamic>))
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
        list.add(ContentModel("No Content", "0", "0", 0));

      }

      // Sort the list
      list.sort((a, b) => a.index.compareTo(b.index));
      // Update the UI with cached data
      setState(() {
        _isLoading = false;
      });
      // Debugging: Print contents of list before sorting
      print('Before sorting: $list');
      print('After sorting: $list');
    } catch (e) {
      print("Error fetching content data: $e");
      setState(() {
        _isLoading = false;
      });
    }

    // Update the UI
    setState(() {
      print("list.length: ${list.length}");
    });
  }


}

