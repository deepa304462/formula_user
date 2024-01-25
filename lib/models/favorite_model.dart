class FavoriteModel {
  final String? id;
  final String title;
  final String image;


  FavoriteModel(
      {this.id,
      required this.title,
      required this.image,
      });

  FavoriteModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        image = res["image"];


  Map<String, Object?> toMap(){

    return {
      'id':id,
      "title":title,
      "image":image

    };
  }
}
