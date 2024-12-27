import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_lucky_draw/screens/lucky_draw_page.dart';

class AssetVideoPlayerScreen extends StatefulWidget {
  final String category;
  final String videoUrl;

  const AssetVideoPlayerScreen({
    Key? key,
    required this.category,
    required this.videoUrl,
  }) : super(key: key);

  @override
  AssetVideoPlayerScreenState createState() => AssetVideoPlayerScreenState();
}

class AssetVideoPlayerScreenState extends State<AssetVideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _controller.play();
        }
      }).catchError((error) {
        debugPrint("Error initializing video: $error");
      });

    // Menambahkan listener untuk mendeteksi akhir dari video
    _controller.addListener(() {
      if (_controller.value.isInitialized &&
          _controller.value.position == _controller.value.duration) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LuckyDrawPage(
              category: widget.category,
            ),
          ),
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
            ? SizedBox(
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
