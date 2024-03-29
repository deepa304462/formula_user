import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:formula_user/screens/pdf_view_screen.dart';

import '../res/colours.dart';
import '../res/styles.dart';
import '../utilities.dart';

class SearchBarScreen extends StatefulWidget {
  const SearchBarScreen({super.key});

  @override
  State<SearchBarScreen> createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> searchResults = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        toolbarHeight: 40,
        title: Text("Search here",
            style: Styles.textWith18withBold(Colours.white)),
        backgroundColor: Colours.buttonColor2,
        iconTheme: IconThemeData(
          color: Colours.white
        ),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 40,
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    _performSearch(value);
                  },
                  decoration: InputDecoration(
                    labelText: 'Search',
                    labelStyle: Styles.textWith16bold(Colours.black),
                    hintText: 'Search for items...',
                    hintStyle: Styles.textWith16bold(Colours.black),
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final item = searchResults[index];
                  return  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration:  BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colours.buttonColor2,Colours.buttonColor2,Colours.buttonColor1],
                              ),
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16))
                          ),
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
                                            item['title'],
                                            style:Styles.textWith18withBold(Colours.white),
                                            maxLines: 15,

                                          ),
                                        ),
                                        // (item['pdfUrl'].isEmpty || item['pdfUrl'] == "")? Container(height: 50,) : TextButton(
                                        //     onPressed: () {
                                        //       pushToNewRoute(
                                        //           context, PdfViewScreen((){},item['pdfUrl'],item['id'],));
                                        //     },
                                        //     child: const Row(
                                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //       children: [
                                        //         Icon(
                                        //           Icons.picture_as_pdf,
                                        //           color: Colors.white,
                                        //         ),
                                        //
                                        //       ],
                                        //     )),
                                        const Spacer(flex: 2),
                                        Icon(Icons.favorite,color: Colours.white),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Icon(Icons.share,color: Colours.white),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                    
                                    
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.indigo, width: 1),
                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16),bottomRight: Radius.circular(16))
                              // borderRadius: BorderRadius.circular(16)
                            ),
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(16),bottomLeft: Radius.circular(16)),
                                  child: Image.network(item['imageUrl'])),
                            )
                      ],
                    ),
                  );
                },
              ),
            ),

          ],

        ),
      ),
    );
  }
  void _performSearch(String query) {
    final CollectionReference itemsCollection = FirebaseFirestore.instance.collection('contentItem');
    final String lowercaseQuery = query.toLowerCase();

    itemsCollection.get().then((querySnapshot) {
      setState(() {
        // Filter documents based on case-insensitive search
        searchResults = querySnapshot.docs.where((doc) => doc['title'].toString().toLowerCase().contains(lowercaseQuery)).toList();
      });
    });
  }
}
