import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AnalyticsConfig {
  final Duration updateInterval;
  final Duration reportInterval;

  const AnalyticsConfig({
    this.updateInterval = const Duration(milliseconds: 500),
    this.reportInterval = const Duration(seconds: 20),
  });
}

class AnalyticsError implements Exception {
  final String message;
  AnalyticsError(this.message);

  @override
  String toString() => 'AnalyticsError: $message';
}

abstract class TeyutoPlayerAnalytics {
  final String token;
  final String apiUrl;
  final AnalyticsConfig config;
  String? videoId;
  dynamic player;
  String? currentAction;
  double secondsPlayed = 0.0;
  Timer? updateTimer;
  bool firstTimeEnter = true;

  TeyutoPlayerAnalytics(this.token, {
    this.apiUrl = "https://api.teyuto.tv/v1",
    this.config = const AnalyticsConfig(),
  });

  void init(dynamic player, String videoId) {
    this.player = player;
    this.videoId = videoId;
    attachEventListeners(player);
    startUpdateInterval();
  }

  void attachEventListeners(dynamic player);

  void startUpdateInterval() {
    updateTimer = Timer.periodic(config.updateInterval, (timer) {
      incrementSeconds();
    });
  }

  void incrementSeconds() {
    if (isPlaying()) {
      secondsPlayed += config.updateInterval.inMilliseconds / 1000;
      if (secondsPlayed >= config.reportInterval.inSeconds) {
        updateTimeVideo(getCurrentTime(), 0);
        secondsPlayed = 0.0;
      }
    }
  }

  Future updateTimeVideo(int time, int end) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/video/?f=action_update'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': videoId,
          'time': time,
          'action': currentAction,
          'end': end,
          'sp': secondsPlayed,
        }),
      );

      if (response.statusCode != 200) {
        throw AnalyticsError('Failed to update time: ${response.body}');
      }
    } catch (e) {
      print('Error updating time: $e');
    }
  }

  Future timeEnter(int time) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/video/?f=action_enter'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': videoId,
          'time': time,
          'firstTime': firstTimeEnter ? 1 : 0,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        currentAction = jsonResponse['0'][0]['action'];
        firstTimeEnter = false;
      } else {
        throw AnalyticsError('Error on time enter: ${response.body}');
      }
    } catch (e) {
      print('Error on time enter: $e');
    }
  }

  void onPlay() {
    timeEnter(getCurrentTime());
  }

  void onPause() {
    updateTimeVideo(getCurrentTime(), 1);
  }

  void onEnded() {
    updateTimeVideo(getDuration(), 1);
  }

  bool isPlaying();
  int getCurrentTime();
  int getDuration();

  void destroy() {
    updateTimer?.cancel();
  }
}