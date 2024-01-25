

class ContentModel{
  String _id ='';
  String _title = '';
  String _tabId = '';
  int _index = 0;

  int get index => _index;

  set index(int value) {
    _index = value;
  }

  bool _isExpanded = false;

  bool get isExpanded => _isExpanded;

  set isExpanded(bool value) {
    _isExpanded = value;
  }

  ContentModel(this._id,this._title,this._tabId,this._index);

  String get id => _id;
  String get title => _title;
  String get tabId => _tabId;

  set id(String value) {
    _id = value;
  }
  set title(String value) {
    _title = value;
  }

  set tabId(String value) {
    _tabId = value;
  }

  ContentModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _tabId = json['tabId'];
    _index = json['index'];

  }

  Map<String, dynamic> toJson() =>
      {
        'id': _id,
        'title':_title,
        'tabId':_tabId,
        'index':_index,
      };


}