[![badge](https://img.shields.io/twitter/follow/teyuto?style=social)](https://twitter.com/intent/follow?screen_name=teyuto) &nbsp; [![badge](https://img.shields.io/github/stars/Teyuto/teyuto-player-sdk?style=social)](https://github.com/Teyuto/teyuto-player-sdk)
![](https://github.com/Teyuto/.github/blob/production/assets/img/banner.png?raw=true)
<h1 align="center">Teyuto Flutter Player Analytics</h1>

A Flutter package for integrating video playback analytics with the Teyuto platform, specifically designed to work with Flutter's official `video_player` package.

## Features

- Seamless integration with Flutter's `video_player` package
- Automatic reporting of playback progress in Teyuto
- Easy-to-use API for Flutter developers
- Support for both authenticated and unauthenticated usage

## Prerequisites

This package requires the `video_player` package. Make sure to add it to your `pubspec.yaml`:

```yaml
dependencies:
  video_player: ^2.7.2 
```

## Installation

Add `teyuto_player_analytics` to your `pubspec.yaml`:

```yaml
dependencies:
  teyuto_player_analytics: ^1.0.0
```

Run `flutter pub get` to install the package.

## Usage

Here's a basic example of how to use the Teyuto Player Analytics package:

```dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:teyuto_player_analytics/teyuto_player_analytics.dart';

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late TeyutoPlayerAnalyticsAdapter _analytics;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network('https://example.com/video.mp4')
      ..initialize().then((_) {
        setState(() {});
      });

    // Initialize with a token (for authenticated use)
    _analytics = TeyutoPlayerAnalyticsAdapter('channel_public', 'user_auth_token');
    
    // Or initialize without a token (for unauthenticated use)
    // _analytics = TeyutoPlayerAnalyticsAdapter('your_channel_id', null);
    
    _analytics.init(_controller, 'video_id');
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayer(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _analytics.destroy();
    super.dispose();
  }
}
```

Note that the `TeyutoPlayerAnalyticsAdapter` constructor now takes two parameters:
1. `channel`: A required String representing your Teyuto channel ID.
2. `token`: An optional String? (nullable String) representing your Teyuto authentication token. If not provided or set to null, the analytics will be sent without authentication.

For more detailed examples, check out the `example` folder in this repository.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.