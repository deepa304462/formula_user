// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:formula_user/res/common.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../res/colours.dart';
// import '../res/styles.dart';
//
//
// class DetailedFormulaScreen extends StatefulWidget {
//   String imageUrl;
//   String pdfUrl;
//   DetailedFormulaScreen(this.imageUrl,this.pdfUrl, {super.key});
//
//   @override
//   State<DetailedFormulaScreen> createState() => _DetailedFormulaScreenState();
// }
//
// class _DetailedFormulaScreenState extends State<DetailedFormulaScreen> with SingleTickerProviderStateMixin{
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//         elevation: 10,
//         toolbarHeight: 40,
//         title: Text("Information",
//         style: Styles.textWith18withBold(Colours.white)),
//           backgroundColor: Colours.appbar,
//           iconTheme: IconThemeData(
//             color: Colours.white
//           ),
//           bottom: TabBar(
//             controller:_tabController ,
//             indicatorColor: Colours.buttonColor2,
//             labelStyle: Styles.textWith16bold(Colours.black),
//             tabs:  [
//               Container(
//                 height: 40,
//                   width: 175,
//                   decoration: BoxDecoration(
//                     color: Colours.white,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: const Tab(text: 'Formula')),
//               Container(
//                   height: 40,
//                   width: 175,
//                   decoration: BoxDecoration(
//                       color: Colours.white,
//                       borderRadius: BorderRadius.circular(8)
//                   ),
//                   child: const Tab(text: 'Solution')),
//             ],
//           ),
//         ),
//       body:  TabBarView(
//         controller: _tabController,
//         children:  [
//           ClipRRect(
//               borderRadius: const BorderRadius.only(
//                   bottomRight: Radius.circular(16),
//                   bottomLeft: Radius.circular(16)),
//               child: GestureDetector(
//                   child: Image.network(widget.imageUrl,))),
//           ClipRRect(
//               borderRadius: const BorderRadius.only(
//                   bottomRight: Radius.circular(16),
//                   bottomLeft: Radius.circular(16)),
//               child: GestureDetector(
//                   child: Common.isPrime ? (widget.pdfUrl.isNotEmpty ? PDFView(filePath: widget.pdfUrl, autoSpacing: true,
//                     pageFling: true,):  Center(child: Text("Solution not available for this formula",style: Styles.textWith18withBold500(Colours.black)),)):Center(child: Text("Solution is available for prime \n        members only 😥",style: Styles.textWith18withBold500(Colours.greyLight700))),)),
//
//
//
//         ],
//       ),
//     );
//
//   }
// }
