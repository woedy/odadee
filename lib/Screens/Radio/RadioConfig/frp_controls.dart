import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';
import 'package:flutter_radio_player/models/frp_player_event.dart';
import 'package:odadee/constants.dart';

class FRPPlayerControls extends StatefulWidget {
  final FlutterRadioPlayer flutterRadioPlayer;
  final Function addSourceFunction;
  final Function nextSource;
  final Function prevSource;
  final Function(String status) updateCurrentStatus;

  const FRPPlayerControls({
    Key? key,
    required this.flutterRadioPlayer,
    required this.addSourceFunction,
    required this.nextSource,
    required this.prevSource,
    required this.updateCurrentStatus,
  }) : super(key: key);

  @override
  State<FRPPlayerControls> createState() => _FRPPlayerControlsState();
}

class _FRPPlayerControlsState extends State<FRPPlayerControls> {
  String latestPlaybackStatus = "flutter_radio_stopped";
  String currentPlaying = "N/A";
  double volume = 0.7;
  final nowPlayingTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.flutterRadioPlayer.frpEventStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          FRPPlayerEvents frpEvent =
          FRPPlayerEvents.fromJson(jsonDecode(snapshot.data as String));
          if (kDebugMode) {
            print("====== EVENT START =====");
            print("Playback status: ${frpEvent.playbackStatus}");
            print("Icy details: ${frpEvent.icyMetaDetails}");
            print("Other: ${frpEvent.data}");
            print("====== EVENT END =====");
          }
          if (frpEvent.playbackStatus != null) {
            latestPlaybackStatus = frpEvent.playbackStatus!;
            widget.updateCurrentStatus(latestPlaybackStatus);
          }
          if (frpEvent.icyMetaDetails != null) {
            currentPlaying = frpEvent.icyMetaDetails!;
            nowPlayingTextController.text = frpEvent.icyMetaDetails!;
          }
          var statusIcon = InkWell(
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: LinearGradient(
                      colors: [
                        odaPrimary,
                        odaSecondary
                      ]
                  )
              ),
              child: Center(
                child: Icon(Icons.pause, color: Colors.white, size: 40,),
              ),
            ),
          );
          switch (frpEvent.playbackStatus) {
            case "flutter_radio_playing":
              statusIcon = InkWell(
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      gradient: LinearGradient(
                          colors: [
                            odaPrimary,
                            odaSecondary
                          ]
                      )
                  ),
                  child: Center(
                    child: Icon(Icons.pause, color: Colors.white, size: 40,),
                  ),
                ),
              );
              break;
            case "flutter_radio_paused":
              statusIcon = InkWell(
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      gradient: LinearGradient(
                          colors: [
                            odaPrimary,
                            odaSecondary
                          ]
                      )
                  ),
                  child: Center(
                    child: Icon(Icons.play_arrow, color: Colors.white, size: 40,),
                  ),
                ),
              );
              break;
            case "flutter_radio_loading":
              statusIcon = InkWell(
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      gradient: LinearGradient(
                          colors: [
                            odaPrimary,
                            odaSecondary
                          ]
                      )
                  ),
                  child: Center(
                    child: Icon(Icons.downloading, color: Colors.white, size: 40,),
                  ),
                ),
              );
              break;
            case "flutter_radio_stopped":
              statusIcon =InkWell(
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      gradient: LinearGradient(
                          colors: [
                            odaPrimary,
                            odaSecondary
                          ]
                      )
                  ),
                  child: Center(
                    child: Icon(Icons.stop, color: Colors.white, size: 40,),
                  ),
                ),
              );
              break;
          }
          return Container(
            height: 150,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    //Text(currentPlaying),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        SizedBox(),

                        Image(image: AssetImage("assets/images/back.png"), height: 22),

                        IconButton(
                          iconSize: 50,
                          onPressed: () async {
                            widget.flutterRadioPlayer.playOrPause();
                            resetNowPlayingInfo();
                          },
                          icon: statusIcon,
                        ),
                        Image(image: AssetImage("assets/images/forward.png"), height: 22,),

                        SizedBox(),
                        SizedBox(),

                      ],
                    ),
                   /* Slider(
                      value: volume,
                      onChanged: (value) {
                        setState(() {
                          volume = value;
                          widget.flutterRadioPlayer.setVolume(volume);
                        });
                      },
                    )*/
                  ],
                ),
              ),
            ),
          );
        }
        return const Text("Loading radio ...");
      },
    );
  }

  void resetNowPlayingInfo() {
    currentPlaying = "N/A";
  }
}