import 'package:flutter/material.dart';
import 'package:formula_user/res/db_helper.dart';

import '../models/favorite_model.dart';
import '../res/colours.dart';
import '../res/styles.dart';
import '../utilities.dart';
import 'detailed_formula_screen.dart';

class BookMarksScreen extends StatefulWidget {
  const BookMarksScreen({Key? key}) : super(key: key);

  @override
  State<BookMarksScreen> createState() => _BookMarksScreenState();
}

class _BookMarksScreenState extends State<BookMarksScreen> {
  DBHelper? dbHelper;
  late Future<List<FavoriteModel>> bookMarkList;
  bool _isLoading = false;

  @override
  void initState() {
    dbHelper = DBHelper();
    loadData();
    super.initState();
  }

  loadData() async {
    setState(() {
      _isLoading = true;
    });
    bookMarkList = dbHelper!.getFavoriteList();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        toolbarHeight: 40,
        title: Text("Favorites", style: Styles.textWith18withBold(Colours.white)),
        backgroundColor: Colours.appbar,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : FutureBuilder(
                future: bookMarkList,
                builder: (context, AsyncSnapshot<List<FavoriteModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading data'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data available'));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
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
                                      Colours.buttonColor2,
                                      Colours.buttonColor2,
                                      Colours.buttonColor1,
                                    ],
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  snapshot.data![index].title,
                                                  style: Styles.textWith18withBold(Colours.white),
                                                ),
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
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      pushToNewRoute(
                                        context,
                                        DetailedFormulaScreen(snapshot.data![index].image.toString(),snapshot.data![index].pdf),
                                      );
                                    },
                                    child: Image.network(snapshot.data![index].image.toString()),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
