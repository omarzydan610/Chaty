import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SplashVideo extends StatefulWidget {
  const SplashVideo({super.key});

  @override
  _SplashVideoState createState() {
    return _SplashVideoState();
  }
}

class _SplashVideoState extends State<SplashVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/ChatyLogo.mp4')
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _controller.setLooping(false);
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: VideoPlayer(_controller),
        ),
      )),
    );
  }
}
