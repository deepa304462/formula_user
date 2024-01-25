
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PdfViewScreen extends StatefulWidget {
  String pdfUrl;
  String documentId;
  Function function;

  PdfViewScreen(this.function,this.pdfUrl,this.documentId, {super.key});

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        title: Text("conclusion ",style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(
            color: Colors.white),
        actions: [TextButton(
          onPressed: (){
            deleteFileFromFirebase(widget.pdfUrl);
          },
          child: Text('Delete PDF',style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),),
        ),],
      ),
      body: PDF(
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
        onError: (error) {
          print(error);
        },
        onPageError: (page, error) {
          print('Error on page $page: $error');
        },
      ).cachedFromUrl(widget.pdfUrl),

    );
  }


  Future<void> deleteFileFromFirebase(String fileUrl) async {
    try {
      Reference storageRef = FirebaseStorage.instance.refFromURL(fileUrl);
      await storageRef.delete();
      deleteFileUrlFromFirestore(widget.documentId);
      print('File deleted successfully');
    } catch (e) {
      deleteFileUrlFromFirestore(widget.documentId);
      print('Error deleting file: $e');
    }
  }
  Future<void> deleteFileUrlFromFirestore(String documentId) async {
    try {
      // Reference the Firestore collection and document that contains the file URL
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('contentItem');
      DocumentReference documentRef = collectionRef.doc(documentId);

      // Update the document to remove the file URL field
      await documentRef.update({
        'pdfUrl': "",
      });
      widget.function();
      Navigator.pop(context);

      print('File URL deleted from Firestore');
    } catch (e) {
      print('Error deleting file URL from Firestore: $e');
    }
  }

}
