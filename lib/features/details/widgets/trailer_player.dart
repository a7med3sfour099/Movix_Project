import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';

// Plays YouTube videos in the app with fullscreen support
class TrailerPlayer extends StatefulWidget {
  final String videoKey;

  const TrailerPlayer({super.key, required this.videoKey});

  @override
  State<TrailerPlayer> createState() => _TrailerPlayerState();
}

class _TrailerPlayerState extends State<TrailerPlayer> {
  late final YoutubePlayerController _controller =
  YoutubePlayerController.fromVideoId(
    videoId: widget.videoKey,
    autoPlay: false,
    params: const YoutubePlayerParams(
      // YouTube rejects embeds whose origin is youtube.com (error 152)
      origin: 'https://www.youtube-nocookie.com',
      showFullscreenButton: true,
      strictRelatedVideos: true,
      enableCaption: true,
    ),
  );

  // TEMP debug: remove after the trailer works
  String _debug = '';

  @override
  void initState() {
    super.initState();
    _debug = 'key: ${widget.videoKey}';
    _controller.listen((value) {
      if (!mounted) return;
      setState(() {
        _debug = 'key: ${widget.videoKey} | state: ${value.playerState}'
            '${value.hasError ? ' | error: ${value.error}' : ''}';
      });
    });
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF1E2E29)),
          ),
          clipBehavior: Clip.antiAlias,
            child: YoutubePlayerScaffold(
              controller: _controller,
              aspectRatio: 16 / 9,
              backgroundColor: HomeHeader.darkColor,
              // Keep the app portrait-only, even inside and after fullscreen
              defaultOrientations: const [
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ],
              fullscreenOrientations: const [
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ],
              // Stops accidental fullscreen from a vertical drag on the player
              enableFullScreenOnVerticalDrag: false,
              builder: (context, player) => player,
            ),
        ),
        const SizedBox(height: 8),
        Text(
          _debug,
          style: const TextStyle(color: Color(0xFF7C8B85), fontSize: 11),
        ),
      ],
    );
  }
}