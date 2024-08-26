import 'package:video_player/video_player.dart';
import 'teyuto_player_analytics_base.dart';

class TeyutoPlayerAnalyticsAdapter extends TeyutoPlayerAnalytics {
  late VideoPlayerController _controller;

  TeyutoPlayerAnalyticsAdapter(String channel, String token,
      {String apiUrl = "https://api.teyuto.tv/v1",
      AnalyticsConfig config = const AnalyticsConfig()})
      : super(channel, token, apiUrl: apiUrl, config: config);

  @override
  void attachEventListeners(dynamic player) {
    _controller = player as VideoPlayerController;
    _controller.addListener(_videoPlayerListener);
  }

  void _videoPlayerListener() {
    if (_controller.value.isPlaying) {
      onPlay();
    } else if (_controller.value.position >= _controller.value.duration) {
      onEnded();
    } else {
      onPause();
    }
  }

  @override
  bool isPlaying() {
    return _controller.value.isPlaying;
  }

  @override
  int getCurrentTime() {
    return _controller.value.position.inMilliseconds;
  }

  @override
  int getDuration() {
    return _controller.value.duration.inMilliseconds;
  }

  @override
  void destroy() {
    super.destroy();
    _controller.removeListener(_videoPlayerListener);
  }
}
