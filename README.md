# spoplusplusfy

Spoplusplusfy - An Orbital Project

Spoplusplusfy is a music streaming application built using Flutter. It features a rich UI for managing playlists, songs, and artists, and provides a seamless music listening experience with advanced audio controls. The app leverages SQLite for local database management and Just Audio for audio playback.

## Introduction

This project is a multi-modal music player

Here is the UI design:

<img width="864" alt="UI" src="https://github.com/dingf3ng/spoplusplusfy/assets/103719642/50b42d64-a76a-4b27-bdc8-f7da158805cc">

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Code Documentation](#code-documentation)
- [Contributing](#contributing)
- [License](#license)

## Features

- Browse and play songs from curated playlists.
- Swipe to change tracks.
- Play, pause, fast-forward, and rewind tracks.
- Search for songs and playlists.
- Manage playlists and add or remove songs.
- View artist information and songs.

## Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/spoplusplusfy.git
   cd spoplusplusfy

2. **Install dependencies:**
   ```bash
   flutter pub get

3. **Install songs**
   unzip folder **songs.zip** in https://drive.google.com/file/d/1cjJYS_tzfEeLd83guGTlnFSXsJ0c0Mcy/view?usp=sharing. Copy the songs folder into the assets folder in the project directory.

3. **Run the app:**
   ```bash
   flutter run

## Usage
Main Page: Displays a list of random playlists. Tap on a playlist to navigate to the player page.
Player Page: Shows the currently playing song and artist. Use swipe gestures to switch tracks and control buttons to play/pause the music.
Search Page: Allows searching for songs and playlists. Provides quick access to settings and user profile.

Project Structure

├── README.md
├── analysis_options.yaml
├── android
│ ├── app
│ ├── build.gradle
│ ├── gradle
│ ├── gradle.properties
│ ├── gradlew
│ ├── gradlew.bat
│ ├── local.properties
│ └── settings.gradle
├── assets
│ ├── database
│ ├── icons
│ ├── images
│ └── songs
├── build
│ ├── 922e83c271242497b412509e05f3f479
│ ├── 9b46fe769667f65dc7b6bbae7e5da17c.cache.dill.track.dill
│ ├── app
│ ├── audio_session
│ ├── just_audio
│ ├── last_build_run.json
│ ├── native_assets
│ ├── path_provider_android
│ ├── sqflite
│ ├── test_cache
│ └── unit_test_assets
├── coverage
│ └── lcov.info
├── fonts
│ ├── GreatVibes-Regular.ttf
│ ├── NotoSans-Bold.ttf
│ ├── NotoSans-BoldItalic.ttf
│ ├── NotoSans-Italic.ttf
│ ├── NotoSans-Light.ttf
│ ├── NotoSans-LightItalic.ttf
│ ├── NotoSans-Medium.ttf
│ ├── NotoSans-MediumItalic.ttf
│ ├── NotoSans-Regular.ttf
│ ├── NotoSans-SemiBold.ttf
│ └── NotoSans-SemiBoldItalic.ttf
├── ios
│ ├── Flutter
│ ├── Podfile
│ ├── Runner
│ ├── Runner.xcodeproj
│ ├── Runner.xcworkspace
│ └── RunnerTests
├── lib
│ ├── Classes
│ ├── Pages
│ ├── Utilities
│ └── main.dart
├── linux
│ ├── CMakeLists.txt
│ ├── flutter
│ ├── main.cc
│ ├── my_application.cc
│ └── my_application.h
├── macos
│ ├── Flutter
│ ├── Podfile
│ ├── Podfile.lock
│ ├── Pods
│ ├── Runner
│ ├── Runner.xcodeproj
│ ├── Runner.xcworkspace
│ └── RunnerTests
├── pubspec.lock
├── pubspec.yaml
├── spoplusplusfy
├── test
│ ├── test_database.dart
│ └── widget_test.dart
├── web
│ ├── favicon.png
│ ├── icons
│ ├── index.html
│ └── manifest.json
└── windows
├── CMakeLists.txt
├── flutter
└── runner



## Classes
Artist: Represents an artist and their associated songs and albums.
DatabaseHelper: Manages the SQLite database for storing playlists and songs.
FollowerManager: Manages the followers and following relationships between Person objects.
Person: Represents a person with attributes like name, gender, age, and portrait.
Playlist: Represents a music playlist with methods to manage it.
PlaylistIterator: Manages the playback of songs in a playlist using Just Audio.
PlaylistSongManager: Manages the relationship between playlists and songs.
Song: Represents a song with attributes like name, artist, and playlist.
Voice: Represents a generic audio entity with an audio source.
Pages
MainPage: The main landing page of the app that displays playlists.
PlayerPage: The player interface for playing songs and controlling playback.
SearchPage: The search interface for finding songs and playlists.

## Code Documentation
Each class and method is documented using DartDoc comments. Below are some examples:

- MainPage
```dart
  /// A stateless widget representing the main page of the application.
  class MainPage extends StatelessWidget {
  /// Fetches a list of random playlists from the database.
  ///
  /// Returns a [Future] that completes with a list of [Playlist] objects.
  Future<List<Playlist>> _getPlaylists() async {
  // Implementation...
  }

  @override
  Widget build(BuildContext context) {
  // Implementation...
  }
  }
```

```dart
/// A stateful widget representing the player page.
class PlayerPage extends StatefulWidget {
  /// The playlist to be played.
  final Playlist playlist;

  PlayerPage({required this.playlist});

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

/// The state for the [PlayerPage] widget.
class _PlayerPageState extends State<PlayerPage> {
  // Implementation...
}
```

## Contributing
We do not accept contributions at this time.

License
This project is licensed under the MIT License. See the LICENSE file for more information.

