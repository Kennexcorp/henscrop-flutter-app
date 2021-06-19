class ApiError {
  String _error;

  bool _success;

  ApiError({String error}) {
    this._error = error;
  }

  String get error => _error;
  set error(String error) => _error = error;

  bool get success => _success;
  set success(bool success) => _success = success;

  ApiError.fromJson(Map<String, dynamic> json) {
    _error = json['error'];
    _success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this._error;
    data['success'] = this._success;
    return data;
  }
}
