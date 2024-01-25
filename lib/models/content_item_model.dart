

class ContentItemModel{
  String _id ='';
  String _title = '';
  String _imageUrl = '';
  String _contentId = '';
  String _pdfUrl = '';
  int _index = 0;

  int get index => _index;

  set index(int value) {
    _index = value;
  }

  String get pdfUrl => _pdfUrl;

  set pdfUrl(String value) {
    _pdfUrl = value;
  }

  bool _isExpanded = false;

  bool get isExpanded => _isExpanded;

  set isExpanded(bool value) {
    _isExpanded = value;
  }

  ContentItemModel(this._id,this._title,this._imageUrl,this._contentId,this._pdfUrl,this._index);

  String get id => _id;
  String get title => _title;
  String get imageUrl => _imageUrl;
  String get contentId => _contentId;

  set id(String value) {
    _id = value;
  }
  set title(String value) {
    _title = value;
  }
  set imageUrl(String value) {
    _imageUrl = value;
  }
  set contentId(String value) {
    _contentId = value;
  }

  ContentItemModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _imageUrl = json['imageUrl'];
    _pdfUrl = json['pdfUrl'];
    _contentId = json['contentId'];
    _index = json['index'];

  }

  Map<String, dynamic> toJson() =>
      {
        'id': _id,
        'title':_title,
        'imageUrl':_imageUrl,
        'pdfUrl':_pdfUrl,
        'contentId':_contentId,
        'index':_index,
      };


}