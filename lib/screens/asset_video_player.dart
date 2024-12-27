import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_lucky_draw/screens/lucky_draw_page.dart'; 

class AssetVideoPlayerScreen extends StatefulWidget {
  final String category;

  const AssetVideoPlayerScreen({Key? key, required this.category})
      : super(key: key);

  @override
  AssetVideoPlayerScreenState createState() => AssetVideoPlayerScreenState();
}

class AssetVideoPlayerScreenState extends State<AssetVideoPlayerScreen> {
  late VideoPlayerController _controller;
  late String video;

  @override
  void initState() {
    super.initState();
    if (widget.category == 'Mesin Cuci Aqua 10KG Top Load') {
      video = 'topload.mp4';
    } else if (widget.category == 'AC Sharp Inverter 1/2 PK') {
      video = 'ac.mp4';
    } else {
      video = 'default_video.mp4';
    }

    _controller = VideoPlayerController.asset('assets/$video')
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _controller.play();
        }
      }).catchError((error) {
        print('Error initializing video: $error');
      });

    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => LuckyDrawPage(
                    category: widget.category,
                  )),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? Container(
                width: double.infinity,
                height: double.infinity,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
