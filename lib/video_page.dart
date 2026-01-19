import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'food_item1.dart';

class VideoPage extends StatefulWidget {
  final FoodItem food;

  const VideoPage({super.key, required this.food});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  YoutubePlayerController? _controller;

  /// 🟢 แปลง Shorts -> watch?v=
  String _normalizeYoutubeUrl(String url) {
    if (url.contains('youtube.com/shorts/')) {
      final uri = Uri.parse(url);
      final videoId = uri.pathSegments.last;
      return 'https://www.youtube.com/watch?v=$videoId';
    }
    return url;
  }

  @override
  void initState() {
    super.initState();

    if (widget.food.videoUrl.isEmpty) return;

    final fixedUrl = _normalizeYoutubeUrl(widget.food.videoUrl);
    final videoId = YoutubePlayer.convertUrlToId(fixedUrl);

    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ❌ ไม่มีวิดีโอ
    if (widget.food.videoUrl.isEmpty || _controller == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('วิธีทำ ${widget.food.name}'),
          backgroundColor: Colors.deepOrange,
        ),
        body: const Center(
          child: Text(
            'ไม่สามารถเล่นวิดีโอได้',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: Text('วิธีทำ ${widget.food.name}'),
            backgroundColor: Colors.deepOrange,
          ),
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: player,
          ),
        );
      },
    );
  }
}
