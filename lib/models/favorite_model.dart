import 'dart:ui';

class FavoriteModel {
  final String? id;
  final String title;
  final String image;
  final String pdf;


  FavoriteModel(
      {this.id,
      required this.title,
      required this.image,
        required this.pdf,
      });

  FavoriteModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        image = res["image"],
        pdf = res["pdf"];



  Map<String, Object?> toMap(){

    return {
      'id':id,
      "title":title,
      "image":image,
      "pdf":pdf,


    };
  }
}
