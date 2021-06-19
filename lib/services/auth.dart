import 'dart:convert';
import 'dart:io';

import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

// String _baseUrl = 'http://192.168.1.103:8000/api';
// String _baseUrl = 'http://192.168.43.3:8000/api';
String _baseUrl = 'https://henscorp-api.herokuapp.com/api';
String token;
var uploadStatus;

login(String email, String password) async {
  // ApiResponse _apiResponse = new ApiResponse();

  try {
    final response = await Dio().post('$_baseUrl/login', data: {
      'email': email,
      'password': password,
      'device_name': 'Tecno CD 7'
    });

    return response;
  } on DioError catch (e) {
    return e.response;
  }
}

register(
    {name: String,
    email: String,
    password: String,
    cPassword: String,
    dName: String}) async {
  try {
    final response = await Dio().post(_baseUrl + '/register', data: {
      'name': name,
      'email': email,
      'password': password,
      'c_password': cPassword,
      'device_name': dName
    });

    return response;
  } on DioError catch (e) {
    return e.response;
  }
}

getUser(String id) async {
  await _getToken();
  final response = await Dio()
      .get(_baseUrl + '/user/' + id, options: Options(headers: _setHeaders()));
  print(response.data);

  return response.data;
}

logout() async {
  await _getToken();
  final response = await Dio()
      .post(_baseUrl + '/logout', options: Options(headers: _setHeaders()));

  return response.data;
}

_getToken() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  token = jsonDecode(localStorage.getString('token'));
  // print(token);
}

fetchToken() async {
  _getToken();
  return token;
}

_setHeaders() => {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

Future uploadFiles(List<File> images, url) async {
  List<Object> filesData = new List<Object>();
  Response response;

  await _getToken();

  for (File image in images) {
    filesData.add(MultipartFile.fromFileSync(image.path,
        filename: image.path.split('/').last,
        contentType: new MediaType("image", "jpeg")));
  }

  FormData formData = new FormData.fromMap({
    "photos": filesData,
  });

  try {
    response = await Dio().post(
      '$_baseUrl$url',
      data: formData,
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        // contentType: 'multipart/form-data',
      ),
      onSendProgress: (int sent, int total) {
        print("$sent $total");
      },
    );
  } catch (error) {
    return error;
  }

  return response.statusCode;
}

getUploadedFiles(String url) async {
  var result = await Dio()
      .get('$_baseUrl$url', options: Options(headers: _setHeaders()));

  return result.data;
}

getUploadedVideos() async {
  var result = await Dio()
      .get('$_baseUrl/videos', options: Options(headers: _setHeaders()));

  return result.data;
}
