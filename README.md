# Teyuto Player Analytics

A Flutter package for integrating video playback analytics with the Teyuto platform.

## Features

- Track video playback events (play, pause, end)
- Automatic reporting of playback progress
- Customizable update intervals
- Easy integration with Flutter's video_player package

## Getting Started

To use this package, add `teyuto_player_analytics` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  teyuto_player_analytics: ^1.0.0
```

## Usage

Here's a simple example of how to use the Teyuto Player Analytics package:

```dart
import 'package:teyuto_player_analytics/teyuto_player_analytics.dart';
import 'package:video_player/video_player.dart';

// Initialize your VideoPlayerController
final videoPlayerController = VideoPlayerController.network('https://example.com/video.mp4');

// Create an instance of TeyutoPlayerAnalyticsAdapter
final analytics = TeyutoPlayerAnalyticsAdapter('your_teyuto_token');

// Initialize the analytics with your video player and video ID
analytics.init(videoPlayerController, 'your_video_id');

// Make sure to call destroy when disposing
@override
void dispose() {
  videoPlayerController.dispose();
  analytics.destroy();
  super.dispose();
}
```

For a more detailed example, check out the `example` folder in this repository.

## Configuration

You can customize the analytics behavior by passing a custom `AnalyticsConfig` when creating the `TeyutoPlayerAnalyticsAdapter`:

```dart
final config = AnalyticsConfig(
  updateInterval: Duration(milliseconds: 250),
  reportInterval: Duration(seconds: 30),
);

final analytics = TeyutoPlayerAnalyticsAdapter('your_teyuto_token', config: config);
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
```

## CHANGELOG.md

```markdown
## 1.0.0

* Initial release of Teyuto Player Analytics package
* Support for tracking play, pause, and end events
* Automatic reporting of playback progress
* Customizable update and report intervals
* Integration with Flutter's video_player package