import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cerita_rakyat/model/timed_string.dart';
import 'package:flutter/material.dart';

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
              var timing = widget.lyrics!.getTiming();
              for (int i = timing.length - 1; i > -1; i--) {
                if (timing[i].inMilliseconds <= position.inMilliseconds) {
                  widget._idxText = i;
                  break;
                }
              }
              return Text(
                widget.lyrics!.getString()[widget._idxText],
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
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget._audioPlayer.isPlaying.value
                        ? widget._audioPlayer.pause()
                        : widget._audioPlayer.play();
                    widget._audioMaxDuration = widget
                        ._audioPlayer.current.value!.audio.duration.inSeconds
                        .toDouble();
                  });
                },
                child: Icon(widget._audioPlayer.isPlaying.value
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded)),
            Icon(Icons.skip_next_rounded),
          ],
        ),
        // Timer & Slider
        widget._audioPlayer.builderCurrentPosition(
            builder: (context, position) {
          widget._audioCurrentDuration = position;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "${widget._audioCurrentDuration.inSeconds ~/ 60 < 10 ? '0' + (widget._audioCurrentDuration.inSeconds ~/ 60).toString() : widget._audioCurrentDuration.inSeconds ~/ 60}:${widget._audioCurrentDuration.inSeconds % 60 < 10 ? '0' + (widget._audioCurrentDuration.inSeconds % 60).toString() : widget._audioCurrentDuration.inSeconds % 60}"),
              Slider(
                value: widget._audioCurrentDuration.inSeconds.toDouble(),
                max: widget._audioMaxDuration,
                onChanged: (value) {
                  setState(() {
                    widget._audioCurrentDuration =
                        Duration(seconds: value.toInt());
                    widget._audioPlayer.seek(widget._audioCurrentDuration);
                  });
                },
              ),
            ],
          );
        })
      ],
    );
  }
}
