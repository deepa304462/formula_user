
class TabModel{
  String _name = '';
  String _id = '';
  int _index = 0 ;

  int get index => _index;

  set index(int value) {
    _index = value;
  }

  TabModel(this._name, this._id, this._index);

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  TabModel.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _id = json['id'];
    _index = json['index'];
  }


  Map<String, dynamic> toJson() =>
      {
        'name': _name,
        'id': _id,
        'index':_index,
      };

}