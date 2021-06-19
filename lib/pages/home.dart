import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:henscrop/services/auth.dart';
import 'package:henscrop/widgets/action_button.dart';
import 'package:henscrop/widgets/expandable_fab.dart';
import 'package:henscrop/widgets/faker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:henscrop/widgets/right_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _actionTitles = ['Upload Image', 'Upload Photo', 'Upload Video'];

  // List<Asset> images = List<Asset>();
  List<File> _files;
  bool _loadingPath = false;

  String _message = "";
  var _sent = 0.00;
  // var _total;

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadMedia(fileType) async {
    String error = 'No Error Detected';

    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: fileType,
        allowedExtensions: (fileType == FileType.custom)
            ? ['zip', 'rar', 'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx']
            : null,
      );

      if (result != null) {
        setState(() {
          _loadingPath = true;
          _files = result.paths.map((path) => File(path)).toList();
        });
      } else {
        // User canceled the picker
        print("Selection cancelled");
      }

      switch (fileType) {
        case FileType.image:
          var status = await uploadFiles(_files, '/photos');
          if (status == 200) {
            setState(() {
              _loadingPath = false;
              _message = "Files uploaded Successfuly";
            });
          } else {
            print(status);
            setState(() {
              _message = "Error occured while uploading";
            });
          }
          break;
        case FileType.video:
          await _uploadVideos();
          // if (status == 200) {
          //   setState(() {
          //     _loadingPath = false;
          //     _message = "Files uploaded Successfuly";
          //   });
          // } else {
          //   print(status);
          //   setState(() {
          //     _loadingPath = false;
          //     _message = "Error occured while uploading";
          //   });
          // }
          break;
        default:
          print("invalid file type");
      }
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;
  }

  Widget _builder() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: _loadingPath
            ? LinearProgressIndicator(value: _sent)
            : Text(_message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: _builder(),
        floatingActionButton: ExpandableFab(
          distance: 112.0,
          children: [
            ActionButton(
              onPressed: () => loadMedia(FileType.custom),
              icon: const Icon(Icons.file_copy_sharp),
            ),
            ActionButton(
              onPressed: () => loadMedia(FileType.image),
              icon: const Icon(Icons.insert_photo),
            ),
            ActionButton(
              onPressed: () => loadMedia(FileType.video),
              icon: const Icon(Icons.videocam),
            ),
          ],
        ),
        drawer: const RightDrawer());
  }

  _uploadVideos() async {
    List<Object> filesData = new List<Object>();

    var token = await fetchToken();

    for (File image in _files) {
      filesData.add(MultipartFile.fromFileSync(image.path,
          filename: image.path.split('/').last,
          contentType: new MediaType("video", "mp4")));
    }

    FormData formData = new FormData.fromMap({
      "videos": filesData,
    });

    try {
      var response = await Dio().post(
        'https://henscorp-api.herokuapp.com/api/videos',
        // 'http://192.168.1.103:8000/api/videos',
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          // contentType: 'multipart/form-data',
        ),
        onSendProgress: (int sent, int total) {
          print("$sent $total");
          setState(() {
            _sent = (sent / total) * 100;
          });
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          _loadingPath = false;
          _message = "Video uploaded Successfuly";
        });
      } else {
        setState(() {
          _loadingPath = false;
          _message = "Error occured while uploading";
        });
      }
    } on DioError catch (error) {
      print(error);
    }
  }
}
