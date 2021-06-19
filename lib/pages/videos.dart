import 'package:flutter/material.dart';
import 'package:henscrop/widgets/right_drawer.dart';
import 'package:videos_player/model/video.model.dart';
import 'package:videos_player/util/theme.util.dart';
import 'package:videos_player/videos_player.dart';
import 'package:videos_player/model/control.model.dart';
import 'package:henscrop/services/auth.dart';

class VideoPage extends StatefulWidget {
  VideoPage({Key key}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  List<NetworkVideo> _videoList;

  @override
  void initState() {
    super.initState();

    _getVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Videos'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _videoList == null || _videoList.length < 1
            ? Center(
                child: Text("No videos availiable"),
              )
            : VideosPlayer(
                networkVideos: _videoList,
                playlistStyle: Style.Style2,
              ),
      ),
      drawer: const RightDrawer(),
    );
  }

  _getVideos() async {
    var _videos = await getUploadedVideos();
    List<NetworkVideo> videos = new List<NetworkVideo>();

    print(_videos['data']);

    for (var video in _videos['data']) {
      videos.add(new NetworkVideo(
          id: video['id'].toString(),
          name: video['name'].substring(0,5) + '...mp4',
          videoUrl: video['url'],
          thumbnailUrl:
              "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerJoyrides.jpg"));
    }

    setState(() {
      _videoList = videos;
    });
  }
}
