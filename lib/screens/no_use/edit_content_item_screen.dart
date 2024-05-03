import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/content_item_model.dart';
import '../../res/colours.dart';


class EditContentItemScreen extends StatefulWidget {
  ContentItemModel contentItem;
  Function function;
   EditContentItemScreen(this.contentItem,this.function,{super.key});

  @override
  State<EditContentItemScreen> createState() => _EditContentItemScreenState();
}

class _EditContentItemScreenState extends State<EditContentItemScreen> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  late final Reference storageRef;
  File? galleryFile;
  File? pfgFile;
  final picker = ImagePicker();
  final db = FirebaseFirestore.instance;
  var imageUrl;
  var pdfUrl;
  bool _isUploading = false;
  TextEditingController _editedTitle = TextEditingController();
  TextEditingController _editedIndex = TextEditingController();
  @override
  void initState() {
    super.initState();
    _editedTitle.text=widget.contentItem.title;
    _editedIndex.text=widget.contentItem.index.toString();
    storageRef = storage.ref();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        title: const Text("Edit Content",style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(
            color: Colors.white
        ),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _editedTitle,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Enter Title";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(
                    color: Colors.grey[800],
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _editedIndex,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Enter Index";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Index',
                  labelStyle: TextStyle(
                    color: Colors.grey[800],
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.blueGrey.shade500,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: galleryFile == null
                      ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Update Image',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  )
                      : const Text(
                    "Selected",
                    style: TextStyle(color: Colors.white),
                  )),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    pickFile();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.blueGrey.shade500,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: pfgFile == null
                      ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.picture_as_pdf,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Update PDF',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  )
                      : const Text(
                    "Selected",
                    style: TextStyle(color: Colors.white),
                  )),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    if(galleryFile == null){
                      //send old url for image
                      if(pfgFile == null){
                        //send old url for pdf
                        updateFormulaContent();
                      }else{
                        //upload pdf only
                        uploadFile(pfgFile!);
                      }
                    }else{
                      //upload image
                      uploadImage(galleryFile!);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.green.shade400,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child:_isUploading ? CircularProgressIndicator(color: Colours.appbar,) : const Text(
                    'Edit Content',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }
  Future getImage(
      ImageSource img,
      ) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
          () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  Future<String> uploadImage(File file) async {
    setState(() {
      _isUploading = true;
    });
    try {
      String fileName = DateTime.now()
          .millisecondsSinceEpoch
          .toString(); // Generate a unique file name
      Reference uploadRef = storageRef.child(fileName);
      UploadTask uploadTask = uploadRef.putFile(file);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrl = downloadUrl;
      if(pfgFile == null ){
        setState(() {
          _isUploading = false;
        });
        updateFormulaContent();
      }else{
       uploadFile(pfgFile!);
      }

      print('Image uploaded successfully!');
      print(downloadUrl);
      return downloadUrl;
    } catch (error) {
      setState(() {
        _isUploading = false;
      });
      print('Error uploading image: $error');
      return '';
    }finally {

    }
  }

  Future <void> updateFormulaContent() async {
    setState(() {
      _isUploading = true;
    });
    Map<String, dynamic> updatedData = {
      'title': _editedTitle.text,
      'index':int.parse(_editedIndex.text),
      'imageUrl': imageUrl ?? widget.contentItem.imageUrl,
      'pdfUrl': pdfUrl ?? widget.contentItem.pdfUrl,

    };
    try {
      await FirebaseFirestore.instance.collection('contentItem').doc(widget.contentItem.id).update(updatedData);
      print('Data updated successfully!');
      widget.function();
      Navigator.pop(context);
    } catch (error) {
      print('Error updating data: $error');
    }
    setState(() {
      _isUploading = false;
    });
  }

  Future<void> uploadFile(File file) async {
    setState(() {
      _isUploading= true;
    });
    try {
      final firebaseStorageRef = firebase_storage.FirebaseStorage.instance.ref();
      final fileName = DateTime.now().millisecondsSinceEpoch.toString(); // You can set your desired file name here
      final uploadTask = firebaseStorageRef.child(fileName).putFile(file);

      final snapshot = await uploadTask.whenComplete(() => null);

      if (snapshot.state == firebase_storage.TaskState.success) {
        final downloadURL = await snapshot.ref.getDownloadURL();
        print('File uploaded to Firebase Storage. Download URL: $downloadURL');
        //updateFormulaContent(downloadURL);
        pdfUrl = downloadURL;
        updateFormulaContent();
      } else {
        setState(() {
          _isUploading = false;
        });
        print('File upload failed.');
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      print('Error uploading file: $e');
    }finally{
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],// You can specify the file types you want to pick
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        setState(() {
          pfgFile = File(file.path!);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
            const SnackBar(content: Text('Nothing is selected')));
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }
}
