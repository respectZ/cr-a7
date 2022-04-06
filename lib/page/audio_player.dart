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
        // bottom player
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              // Slider bar
              widget._audioPlayer.builderIsPlaying(
                  builder: (context, isPlaying) {
                // kalo is playing pake streambuilder current pos
                if (isPlaying) {
                  return widget._audioPlayer.builderCurrentPosition(
                      builder: (context, position) {
                    widget._audioCurrentDuration = position;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Slider(
                            value: widget._audioCurrentDuration.inSeconds
                                .toDouble(),
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
                            return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Slider(
                                      value: widget
                                          ._audioCurrentDuration.inSeconds
                                          .toDouble(),
                                      max: widget._audioMaxDuration,
                                      onChanged: (value) {},
                                    ),
                                  ),
                                ]);
                          default:
                            if (snapshot.hasData) {
                              var _maxDurationDouble =
                                  (snapshot.data as Playing)
                                      .audio
                                      .duration
                                      .inSeconds
                                      .toDouble();
                              var _maxDuration =
                                  (snapshot.data as Playing).audio.duration;
                              widget._audioMaxDuration = _maxDurationDouble;

                              return Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Slider(
                                        value: widget
                                            ._audioCurrentDuration.inSeconds
                                            .toDouble(),
                                        max: _maxDurationDouble,
                                        onChanged: (value) {
                                          setState(() {
                                            widget._audioCurrentDuration =
                                                Duration(
                                                    seconds: value.toInt());
                                            widget._audioPlayer.seek(
                                                widget._audioCurrentDuration);
                                          });
                                        },
                                      ),
                                    ),
                                  ]);
                            } else {
                              return Text("err");
                            }
                        }
                      });
                }
              }),
              // 2
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // start pos
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                    width: 60,
                    child: widget._audioPlayer.builderIsPlaying(
                        builder: (context, isPlaying) {
                      if (isPlaying) {
                        return widget._audioPlayer.builderCurrentPosition(
                            builder: (context, position) {
                          return Text(getDuration(position));
                        });
                      } else {
                        return Text(getDuration(widget._audioCurrentDuration));
                      }
                    }),
                  ),
                  // button things
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.skip_previous_rounded),
                          FloatingActionButton(onPressed: () {
                            setState(() {
                              widget._audioPlayer.isPlaying.value
                                  ? widget._audioPlayer.pause()
                                  : widget._audioPlayer.play();
                              widget._audioMaxDuration = widget._audioPlayer
                                  .current.value!.audio.duration.inSeconds
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
                    ],
                  ),
                  // end pos
                  Container(
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                    child: StreamBuilder(
                      stream: widget._audioPlayer.current,
                      builder: (builder, snapshot) {
                        if (snapshot.hasData) {
                          return Text(getDuration(
                              (snapshot.data as Playing).audio.duration));
                        } else {
                          return Text("none");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
