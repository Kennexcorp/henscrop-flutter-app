import 'package:flutter/material.dart';
import 'package:henscrop/services/auth.dart';
import 'package:henscrop/widgets/right_drawer.dart';

class PhotoPage extends StatefulWidget {
  PhotoPage({Key key}) : super(key: key);

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  List<dynamic> _photos;
  bool _loadingPath = true;
  @override
  void initState() {
    super.initState();

    _getPhotos();

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photos'),
      ),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: _loadingPath
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Center(
                    child: const LinearProgressIndicator(),
                  ),
                )
              : _photos != null
                  ? GridView.builder(
                      itemCount: _photos != null && _photos.isNotEmpty
                          ? _photos.length
                          : 0,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0),
                      itemBuilder: (BuildContext context, int index) {
                        return Image.network(
                          _photos[index],
                          fit: BoxFit.fill,
                        );
                      })
                  : Center(
                      child: Text("No videos availiable"),
                    )),
      drawer: const RightDrawer(),
    );
  }

  void _getPhotos() async {
    var result = await getUploadedFiles('/photos');

    setState(() {
      _photos = result['data'];
      _loadingPath = false;
    });
  }
}
