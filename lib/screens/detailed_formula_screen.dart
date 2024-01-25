import 'package:flutter/material.dart';

import '../res/colours.dart';
import '../res/styles.dart';


class DetailedFormulaScreen extends StatefulWidget {
  String imageUrl;
  DetailedFormulaScreen(this.imageUrl, {super.key});

  @override
  State<DetailedFormulaScreen> createState() => _DetailedFormulaScreenState();
}

class _DetailedFormulaScreenState extends State<DetailedFormulaScreen> with SingleTickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        elevation: 10,
        toolbarHeight: 40,
        title: Text("Information",
        style: Styles.textWith18withBold(Colours.white)),
          backgroundColor: Colours.appbar,
          iconTheme: IconThemeData(
            color: Colours.white
          ),
          bottom: TabBar(
            controller:_tabController ,
            indicatorColor: Colours.buttonColor2,
            labelStyle: Styles.textWith16bold(Colours.black),
            tabs:  [
              Container(
                height: 40,
                  width: 175,
                  decoration: BoxDecoration(
                    color: Colours.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Tab(text: 'Formula')),
              Container(
                  height: 40,
                  width: 175,
                  decoration: BoxDecoration(
                      color: Colours.white,
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: const Tab(text: 'Solution')),
            ],
          ),
        ),
      body:  TabBarView(
        controller: _tabController,
        children:  [
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
                      child: Image.network(widget.imageUrl,)))),
          Center(
            child: Text('Screen for Tab 2'),
          ),
        ],
      ),
    );

  }
}
