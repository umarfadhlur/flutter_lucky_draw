import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_lucky_draw/screens/lucky_draw_page.dart'; // Import your LuckyDrawPage

class AssetVideoPlayerScreen extends StatefulWidget {
  final String category;

  const AssetVideoPlayerScreen({Key? key, required this.category}) : super(key: key);

  @override
  AssetVideoPlayerScreenState createState() => AssetVideoPlayerScreenState();
}

class AssetVideoPlayerScreenState extends State<AssetVideoPlayerScreen> {
  late VideoPlayerController _controller;
  late String video;

  @override
  void initState() {
    super.initState();
    // Determine which video to play based on the category
    if (widget.category == 'Mesin Cuci Aqua 10KG Top Load') {
      video = 'topload.mp4';
    } else if (widget.category == 'AC Sharp Inverter 1/2 PK') {
      video = 'ac.mp4';
    } else {
      video = 'default_video.mp4'; // A default video if needed
    }

    // Initialize the VideoPlayerController
    _controller = VideoPlayerController.asset('assets/$video')
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _controller.play(); // Start playing automatically if desired
        }
      }).catchError((error) {
        // Handle error (e.g., show a message to the user)
        print('Error initializing video: $error');
      });

    // Listen for video end
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LuckyDrawPage(category: widget.category,)),
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
                  fit: BoxFit.cover, // This will stretch the video to fill the screen
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying ? _controller.pause() : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}