import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:formula_user/models/favorite_model.dart';
import 'package:formula_user/res/db_helper.dart';
import 'package:formula_user/res/styles.dart';
import 'package:formula_user/screens/detailed_formula_screen.dart';
import 'package:formula_user/screens/pdf_view_screen.dart';

import '../models/content_item_model.dart';
import '../models/content_model.dart';
import '../res/colours.dart';
import '../utilities.dart';

class ContentItemList extends StatefulWidget {
  ContentModel item;

  ContentItemList(this.item, {super.key});

  @override
  State<ContentItemList> createState() => _ContentItemListState();
}

class _ContentItemListState extends State<ContentItemList> {
  List<ContentItemModel> list = [];
  DBHelper? dbHelper;

  @override
  void initState() {
    getContentItemData();
    dbHelper = DBHelper();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colours.buttonColor1,
                          Colours.buttonColor2,
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Center(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      textAlign: TextAlign.center,
                                      maxLines: 5,
                                      list[index].title,
                                      style:
                                          Styles.textWith18withBold(Colours.white)),
                                ),
                                IconButton(
                                    onPressed: (){
                                      dbHelper!.insert(
                                          FavoriteModel(
                                            id: list[index].id,
                                            title: list[index].title,
                                            image: list[index].imageUrl,
                                      )).then((value){
                                        print("data added");
                                      }).onError((error, stackTrace){
                                        print(error.toString());
                                      });

                                    },
                                    icon: const Icon(Icons.favorite_border),
                                    color: Colours.white),
                                IconButton(
                                    onPressed: (){},
                                    icon: const Icon(Icons.share),
                                    color: Colours.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                      /* (list[index].pdfUrl.isEmpty || list[index].pdfUrl == "")? Container(height: 50,) : TextButton(
                          onPressed: () {
                            pushToNewRoute(
                                context, PdfViewScreen((){
                                  getContentItemData();
                            },list[index].pdfUrl,list[index].id));
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.picture_as_pdf,
                                color: Colors.white,
                              ),
                            ],
                          )),*/
                    ],
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.indigo, width: 1),
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16))
                        // borderRadius: BorderRadius.circular(16)
                        ),
                    child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16)),
                        child: GestureDetector(
                          onTap: (){
                            pushToNewRoute(context,  DetailedFormulaScreen(list[index].imageUrl));
                          },
                            child: Image.network(list[index].imageUrl))))
              ],
            ),
          );
        });
  }

  Future<void> getContentItemData() async {
    list = [];
    CollectionReference contentItemRef =
        FirebaseFirestore.instance.collection('contentItem');

    try {
      QuerySnapshot querySnapshot = await contentItemRef
          .where("contentId", isEqualTo: widget.item.id.toString())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          final contentItemModel =
              ContentItemModel.fromJson(doc.data() as Map<String, dynamic>);
          list.add(contentItemModel);
        }
      }
      list.sort((a, b) => a.index.compareTo(b.index));

      setState(() {
        print("list.length: ${list.length}");
      });
    } catch (e) {
      print("Error fetching content data: $e");
    }
  }

  void deleteImage(ContentItemModel item) {
    // Reference to the document you want to delete
    DocumentReference documentRef =
        FirebaseFirestore.instance.collection('contentItem').doc(item.id);

    // Delete the document
    documentRef.delete().then((value) {
      // widget.function();
    }).catchError((error) => print('Failed to delete document: $error'));
  }

  // Future<void> updateImageMetadata(String imageUrl) async {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //
  //   await firestore.collection('contentItem').add({
  //     'imageUrl': imageUrl,
  //     // 'caption': caption,
  //     // Add more fields as needed
  //   });
}
