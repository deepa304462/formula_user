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

class TabContents extends StatefulWidget {
  TabModel currentTab;
  TabContents(this.currentTab, this.function, {super.key});
  Function function;

  @override
  State<TabContents> createState() => _TabContentsState();
}

class _TabContentsState extends State<TabContents> {
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
      body: _isLoading ? _buildLoadingIndicator(Colours.appbar) : _buildPanel(),
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
                      onTap: () {
                        setState(() {
                          item.isExpanded = !isExpanded;
                        });
                      },
                      title: Row(
                        children: [
                          Flexible(
                              child: Text(
                            item.title,
                          )),

                        ],
                      ),
                      titleTextStyle: Styles.textWith16(Colours.black),
                    );
                  },
                  body: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: ContentList(item, ),
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

  Future<void> getContentData() async {
    setState(() {
      _isLoading = true;
    });

    list = [];
    CollectionReference formulacontent =
    FirebaseFirestore.instance.collection('formulacontent');
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'formulacontent_${widget.currentTab.id}';
    final cacheTimestampKey = '${cacheKey}_timestamp';

    try {
      // Fetch cached data and timestamp
      String? cachedData = prefs.getString(cacheKey);
      int? cacheTimestamp = prefs.getInt(cacheTimestampKey);

      bool shouldFetchFromFirestore = true;
      const cacheDuration = Duration(hours: 1); // Set your refresh interval here

      if (cacheTimestamp != null) {
        final cacheDateTime = DateTime.fromMillisecondsSinceEpoch(cacheTimestamp);
        if (DateTime.now().difference(cacheDateTime) < cacheDuration) {
          shouldFetchFromFirestore = false;
        }
      }

      if (!shouldFetchFromFirestore && cachedData != null) {
        // Load data from cache
        List<dynamic> jsonData = json.decode(cachedData);
        list = jsonData.map((item) => ContentModel.fromJson(item)).toList();
      } else {
        // Fetch data from Firestore
        QuerySnapshot querySnapshot = await formulacontent
            .where("tabId", isEqualTo: widget.currentTab.id.toString())
            .get(const GetOptions(
            source: Source.serverAndCache
        ));

        if (querySnapshot.docs.isNotEmpty) {
          for (var doc in querySnapshot.docs) {
            final contentModel =
            ContentModel.fromJson(doc.data() as Map<String, dynamic>);
            list.add(contentModel);
          }

          // Save fetched data and timestamp to cache
          String jsonData = json.encode(list.map((item) => item.toJson()).toList());
          await prefs.setString(cacheKey, jsonData);
          await prefs.setInt(cacheTimestampKey, DateTime.now().millisecondsSinceEpoch);
        }
      }

      // Debugging: Print contents of list before sorting
      print('Before sorting: $list');

      list.sort((a, b) => a.index.compareTo(b.index));

      // Debugging: Print contents of list after sorting
      print('After sorting: $list');
    } catch (e) {
      print("Error fetching content data: $e");
    }

    setState(() {
      _isLoading = false;
      print("list.length: ${list.length}");
    });
  }

  void handleClick(String v, ContentModel item) {
    if (v == 'Add Formula') {
      pushToNewRoute(context, AddContentItemScreen(item));
    } else if (v == 'Edit Content') {
      pushToNewRoute(context, EditContentScreen(item));
    } else {
      deleteContent(item);
    }
  }

  void deleteContent(ContentModel item) {
    // Reference to the document you want to delete
    DocumentReference documentRef =
        FirebaseFirestore.instance.collection('formulacontent').doc(item.id);

    // Delete the document
    documentRef.delete().then((value) {
      widget.function();
    }).catchError((error) => print('Failed to delete document: $error'));
  }
}
