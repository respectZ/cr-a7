import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cerita_rakyat/model/timed_string.dart';
import 'package:flutter/material.dart';

class AudioPlayerPage extends StatefulWidget {
  AudioPlayerPage({Key? key, required this.audioPath}) : super(key: key);

  String audioPath = "";

  final _audioPlayer = AssetsAudioPlayer();
  double _audioMaxDuration = double.infinity;
  late Duration _audioCurrentDuration;

  TimedString _test = TimedString(
      Strings: ["だっだっだ だいじょばない", "ちょっと蛹になって出直すわ"],
      Timing: [Duration(seconds: 0), Duration(seconds: 2, milliseconds: 777)]);
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
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(widget._test.getString()[widget._idxText]),
        ]),
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
        widget._audioPlayer.builderCurrentPosition(
            builder: (context, position) {
          widget._audioCurrentDuration = position;
          // Lyrics
          for (int i = 0; i < widget._test.getTiming().length; i++) {
            if (widget._test.getTiming()[i].inMilliseconds <=
                widget._audioCurrentDuration.inMilliseconds) {
              widget._idxText = i;
            } else {
              break;
            }
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "${widget._audioCurrentDuration.inSeconds ~/ 60 < 10 ? '0' + (widget._audioCurrentDuration.inSeconds ~/ 60).toString() : widget._audioCurrentDuration.inSeconds ~/ 60}:${widget._audioCurrentDuration.inSeconds % 60 < 10 ? '0' + (widget._audioCurrentDuration.inSeconds % 60).toString() : widget._audioCurrentDuration.inSeconds % 60}"),
              Text(
                widget._test.getString()[widget._idxText],
                style: TextStyle(fontFamily: 'Novecento'),
              ),
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
