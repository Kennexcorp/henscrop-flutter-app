class ApiSuccess {
  String _message;

  bool _success;

  Object _data;

  ApiSuccess({String message}) {
    this._message = message;
  }

  String get message => _message;
  set message(String message) => _message = message;

  bool get success => _success;
  set success(bool success) => _success = success;

  Object get data => _data;
  set data(Object data) => _data = data;

  ApiSuccess.fromJson(Map<String, dynamic> json) {
    _message = json['message'];
    _success = json['success'];
    _data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this._message;
    data['success'] = this._success;
    data['data'] = this._data;
    return data;
  }
}
