

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
        title: Text("Chapters",
            style: Styles.textWith18withBold(Colours.white)),
        backgroundColor: Colours.appbar,
        iconTheme: IconThemeData(
          color: Colours.white
        ),
      ),
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
                      onTap: (){
                        setState(() {
                          item.isExpanded = !isExpanded;
                        });
                      },
                      title: Row(
                        children: [
                          Flexible(child: Text(item.title,)),
                        ],
                      ),
                      titleTextStyle: Styles.textWith16(Colours.black),
                    );
                  },
                  body: Padding(
                    padding: const EdgeInsets.only(left: 12,right: 12),
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

  Future<void> getContentData() async {
    setState(() {
      _isLoading = true;
    });

    list = [];
    CollectionReference formulacontent = FirebaseFirestore.instance.collection('formulacontent');

    try {
      QuerySnapshot querySnapshot = await formulacontent.where("tabId", isEqualTo: widget.currentTab.id.toString()).get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          final contentModel = ContentModel.fromJson(doc.data() as Map<String, dynamic>);
          list.add(contentModel);
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
    DocumentReference documentRef = FirebaseFirestore.instance.collection('formulacontent').doc(item.id);

    // Delete the document
    documentRef
        .delete()
        .then((value) {
      widget.function();
    })
        .catchError((error) => print('Failed to delete document: $error'));
  }
}

