import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cerita_rakyat/model/timed_string.dart';
import 'package:flutter/material.dart';

String getDuration(Duration duration) {
  String twoDigits(int i) => i.toString().padLeft(2, '0');
  return "${twoDigits(duration.inSeconds ~/ 60)}:${twoDigits(duration.inSeconds % 60)}";
}

String getCurrentLyric(TimedString lyrics, Duration position) {
  var timing = lyrics.getTiming();
  for (int i = timing.length - 1; i > -1; i--) {
    if (timing[i].inMilliseconds <= position.inMilliseconds) {
      return lyrics.getString()[i];
    }
  }
  return "";
}

class AudioPlayerPage extends StatefulWidget {
  AudioPlayerPage({Key? key, required this.audioPath, this.lyrics})
      : super(key: key);

  String audioPath = "";
  late TimedString? lyrics;

  final _audioPlayer = AssetsAudioPlayer();
  double _audioMaxDuration = double.infinity;
  late Duration _audioCurrentDuration;

  int _idxText = 0;

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayerPage> {
  @override
  void initState() {
    super.initState();
    widget._audioPlayer.open(Audio(widget.audioPath),
        autoStart: false, loopMode: LoopMode.none);
    widget._audioCurrentDuration = widget._audioPlayer.currentPosition.value;
  }

  @override
  void dispose() {
    widget._audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Lyrics
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          widget._audioPlayer.builderCurrentPosition(
              builder: ((context, position) {
            if (widget.lyrics != null) {
              return Text(
                getCurrentLyric(widget.lyrics!, position),
                style: TextStyle(fontSize: 28),
              );
            } else {
              return Text(
                "No Lyrics Availiable.",
                style: TextStyle(fontSize: 28),
              );
            }
          }))
        ]),
        // Audio Control
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.skip_previous_rounded),
            ElevatedButton(onPressed: () {
              setState(() {
                widget._audioPlayer.isPlaying.value
                    ? widget._audioPlayer.pause()
                    : widget._audioPlayer.play();
                widget._audioMaxDuration = widget
                    ._audioPlayer.current.value!.audio.duration.inSeconds
                    .toDouble();
              });
            }, child: widget._audioPlayer.builderIsPlaying(
                builder: (context, isPlaying) {
              if (isPlaying) {
                return Icon(Icons.pause_rounded);
              } else {
                return Icon(Icons.play_arrow_rounded);
              }
            })),
            Icon(Icons.skip_next_rounded),
          ],
        ),
        // Timer & Slider
        widget._audioPlayer.builderIsPlaying(builder: (context, isPlaying) {
          // kalo is playing pake streambuilder current pos
          if (isPlaying) {
            return widget._audioPlayer.builderCurrentPosition(
                builder: (context, position) {
              widget._audioCurrentDuration = position;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 45,
                      child: Text(getDuration(widget._audioCurrentDuration))),
                  Expanded(
                    child: Slider(
                      value: widget._audioCurrentDuration.inSeconds.toDouble(),
                      max: widget._audioMaxDuration,
                      onChanged: (value) {
                        setState(() {
                          widget._audioCurrentDuration =
                              Duration(seconds: value.toInt());
                          widget._audioPlayer
                              .seek(widget._audioCurrentDuration);
                        });
                      },
                    ),
                  ),
                  Text(getDuration(
                      Duration(seconds: widget._audioMaxDuration.toInt()))),
                ],
              );
            });
            // kalo engga pake streambuilder, ngecek audionya udh load -> widget
          } else {
            return StreamBuilder(
                stream: widget._audioPlayer.current,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text("Loading...");
                    default:
                      if (snapshot.hasData) {
                        var _maxDurationDouble = (snapshot.data as Playing)
                            .audio
                            .duration
                            .inSeconds
                            .toDouble();
                        var _maxDuration =
                            (snapshot.data as Playing).audio.duration;

                        return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                  width: 45,
                                  child: Text(getDuration(
                                      widget._audioCurrentDuration))),
                              Expanded(
                                child: Slider(
                                  value: widget._audioCurrentDuration.inSeconds
                                      .toDouble(),
                                  max: _maxDurationDouble,
                                  onChanged: (value) {
                                    setState(() {
                                      widget._audioCurrentDuration =
                                          Duration(seconds: value.toInt());
                                      widget._audioPlayer
                                          .seek(widget._audioCurrentDuration);
                                    });
                                  },
                                ),
                              ),
                              Text(getDuration(_maxDuration)),
                              IconButton(
                                  splashRadius: 15,
                                  onPressed: () => {},
                                  icon: Icon(Icons.settings_rounded))
                            ]);
                      } else {
                        return Text("err");
                      }
                  }
                });
          }
        }),
      ],
    );
  }
}
