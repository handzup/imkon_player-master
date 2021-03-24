import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:better_player/src/configuration/better_player_data_source.dart';
import 'package:better_player/src/core/better_player_controller.dart';

///Controller used to manage playlist player.
class BetterPlayerPlaylistController {
  ///List of data sources set for playlist.
  final List<BetterPlayerDataSource> _betterPlayerDataSourceList;

  //General configuration of Better Player
  final BetterPlayerConfiguration betterPlayerConfiguration;

  ///Playlist configuration of Better Player
  final BetterPlayerPlaylistConfiguration betterPlayerPlaylistConfiguration;

  ///BetterPlayerController instance
  BetterPlayerController? _betterPlayerController;

  ///Currently playing data source index
  int _currentDataSourceIndex = 0;

  ///Next video change listener subscription
  StreamSubscription? _nextVideoTimeStreamSubscription;

  ///Flag that determines whenever player is changing video
  bool _changingToNextVideo = false;

  BetterPlayerPlaylistController(
    this._betterPlayerDataSourceList, {
    this.betterPlayerConfiguration = const BetterPlayerConfiguration(),
    this.betterPlayerPlaylistConfiguration =
        const BetterPlayerPlaylistConfiguration(),
  })  : assert(
            _betterPlayerDataSourceList != null &&
                _betterPlayerDataSourceList.isNotEmpty,
            "Better Player data source list can't be empty"),
        assert(betterPlayerConfiguration != null, "BetterPlayerConfiguration"),
        assert(betterPlayerPlaylistConfiguration != null,
            "BetterPlayerPlaylistConfiguration can't be null") {
    _setup();
  }

  ///Initialize controller and listeners.
  void _setup() {
    _betterPlayerController = BetterPlayerController(
      betterPlayerConfiguration,
      betterPlayerPlaylistConfiguration: betterPlayerPlaylistConfiguration,
    );
    _currentDataSourceIndex = 0;
    setupDataSource(_currentDataSourceIndex);
    _betterPlayerController!.addEventsListener(_handleEvent);
    _nextVideoTimeStreamSubscription = _betterPlayerController!
        .nextVideoTimeStreamController.stream
        .listen((time) {
      if (time != null && time == 0) {
        _onVideoChange();
      }
    });
  }

  ///Handle video change signal from BetterPlayerController. Setup new data
  ///source based on configuration.
  void _onVideoChange() {
    if (_changingToNextVideo) {
      return;
    }
    final int nextDataSourceId = _getNextDataSourceIndex();
    if (nextDataSourceId == -1) {
      return;
    }
    if (_betterPlayerController!.isFullScreen) {
      _betterPlayerController!.exitFullScreen();
    }
    _changingToNextVideo = true;
    setupDataSource(nextDataSourceId);

    _changingToNextVideo = false;
  }

  ///Handle BetterPlayerEvent from BetterPlayerController. Used to control
  ///startup of next video timer.
  void _handleEvent(BetterPlayerEvent betterPlayerEvent) {
    if (betterPlayerEvent.betterPlayerEventType ==
        BetterPlayerEventType.finished) {
      if (_getNextDataSourceIndex() != -1) {
        _betterPlayerController!.startNextVideoTimer();
      }
    }
  }

  ///Setup data source with index based on [_betterPlayerDataSourceList] provided
  ///in constructor. Index must
  void setupDataSource(int index) {
    assert(
        index != null &&
            index >= 0 &&
            index < _betterPlayerDataSourceList.length,
        "Index must be greater than 0 and less than size of data source "
        "list - 1");
    if (index <= _dataSourceLength) {
      _currentDataSourceIndex = index;
      _betterPlayerController!
          .setupDataSource(_betterPlayerDataSourceList[index]);
    }
  }

  ///Get index of next data source. If current index is less than
  ///[_betterPlayerDataSourceList] size then next element will be picked, otherwise
  ///if loops is enabled then first element of [_betterPlayerDataSourceList] will
  ///be picked, otherwise -1 will be returned, indicating that player should
  ///stop changing videos.
  int _getNextDataSourceIndex() {
    final currentIndex = _currentDataSourceIndex;
    if (currentIndex + 1 < _dataSourceLength) {
      return currentIndex + 1;
    } else {
      if (betterPlayerPlaylistConfiguration.loopVideos) {
        return 0;
      } else {
        return -1;
      }
    }
  }

  ///Get index of currently played source, based on [_betterPlayerDataSourceList]
  int get currentDataSourceIndex => _currentDataSourceIndex;

  ///Get size of [_betterPlayerDataSourceList]
  int get _dataSourceLength => _betterPlayerDataSourceList.length ?? 0;

  ///Get BetterPlayerController instance
  BetterPlayerController? get betterPlayerController => _betterPlayerController;

  ///Cleanup BetterPlayerPlaylistController
  void dispose() {
    _nextVideoTimeStreamSubscription?.cancel();
  }
}