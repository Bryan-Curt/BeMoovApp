class User {
  int id;
  String name;
  String username;
  User({this.id, this.name, this.username});

  User.initial()
      : id = 0,
        name = '',
        username = '';

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    return data;
  }

  bool _modeIsSimple = true;
  bool get modeIsSimple => _modeIsSimple;

  set modeIsSimple(bool newValue) {
    _modeIsSimple = newValue;
    //notifyListeners();
  }
}
