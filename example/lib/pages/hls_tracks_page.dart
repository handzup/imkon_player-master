import 'package:better_player/better_player.dart';
import 'package:better_player_example/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HlsTracksPage extends StatefulWidget {
  @override
  _HlsTracksPageState createState() => _HlsTracksPageState();
}

class _HlsTracksPageState extends State<HlsTracksPage> {
  BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      controlsConfiguration: BetterPlayerControlsConfiguration(
        progressBarPlayedColor: Colors.blue,
        positionStyle: TextStyle(
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            color: Colors.white,
            decoration: TextDecoration.none,
            textBaseline: TextBaseline.alphabetic),
        playWidget: SvgPicture.asset('assets/play.svg'),
        pauseWidget: SvgPicture.asset('assets/pause.svg'),
        qualityWidget: SvgPicture.asset('assets/video_quality.svg'),
        muteIcon: SvgPicture.asset('assets/mute.svg'),
        unMuteIcon: SvgPicture.asset('assets/unmute.svg'),
      ),
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
    );
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network, Constants.hlsTestStreamUrl,
        useHlsSubtitles: true);
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HLS tracks"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Player with HLS stream which loads tracks from HLS."
              " You can choose tracks by using overflow menu (3 dots in right corner).",
              style: TextStyle(fontSize: 16),
            ),
          ),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(controller: _betterPlayerController),
          ),
        ],
      ),
    );
  }
}
