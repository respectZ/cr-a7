import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cerita_rakyat/model/timed_string.dart';
import 'package:flutter/material.dart';

class AudioPlayerPage extends StatefulWidget {
  AudioPlayerPage({Key? key, required this.audioPath}) : super(key: key);

  String audioPath = "";

  final _audioPlayer = AssetsAudioPlayer();
  double _audioMaxDuration = double.infinity;
  late Duration _audioCurrentDuration;

  final TimedString _test = TimedString(Strings: [
    'だっだっだ だいじょばない',
    'ちょっと蛹になって出直すわ',
    '',
    '愛とか恋とか全部くだらない',
    'がっかりするだけ ダメを知るだけ',
    'あたし馬鹿ね ダサい逆走じゃん',
    'ホントのところはあなたにモテたい',
    '失敗するのにビビってるだけ',
    '加工なしの厳しめの条件じゃ',
    'ちょっと こんな時どんな顔すればいいか教えてほしい ',
    'ちょっと 「愛してる」だとかそんな言葉で壊れてみたい',
    'じれったいな ハロー残念なあたし',
    '困っちゃってイヤイヤ',
    'じれったいな 決まんないの前髪が',
    '怒っちゃってイライラ',
    'だっだっだ 大好きは',
    'もっと可愛くなって 言いたいのに',
    'だっだっだ だいじょばない',
    'ちょっと蛹になって出直すわ',
    'あ...えと、いや...なんでもない',
    '言いたいこと言えたことないや',
    '目と目 止められないの',
    '逸らしちゃって まーた自己嫌悪',
    'じれったいな ハロー残念なあたし',
    '困っちゃってイヤイヤ',
    'じれったいな 入んないのこの靴が',
    '怒っちゃってイライラ',
    '鐘が鳴って 灰になって ',
    'あたしまだ帰りたくないや ',
    '××コースへ 飛び込んでみたいから',
    '',
    'じれったいな ハロー残念なあたし',
    '困っちゃってイヤイヤ',
    'じれったいな 決まんないの前髪が',
    '怒っちゃってる',
    'じれったいな 夜行前のシンデレラ',
    'ビビっちゃってフラフラ',
    'じれったいな ハローをくれたあなたと',
    '踊っちゃってクラクラ',
    'だっだっだ 大好きは',
    'もっと可愛くなって 言いたいのに',
    'だっだっだ だいじょばない',
    'ちょっとお待ちになって王子様',
    'だっだっだ ダメよ 順序とか',
    'もっと仲良くなって そうじゃないの?',
    'だっだっだ まじでだいじょばない',
    'やっぱ蛹になって出直すわ'
  ], Timing: [
    Duration(seconds: 0),
    Duration(seconds: 2, milliseconds: 777),
    Duration(seconds: 6, milliseconds: 200),
    Duration(seconds: 18, milliseconds: 300),
    Duration(seconds: 19, milliseconds: 900),
    Duration(seconds: 21, milliseconds: 800),
    Duration(seconds: 24, milliseconds: 300),
    Duration(seconds: 26, milliseconds: 0),
    Duration(seconds: 27, milliseconds: 710),
    Duration(seconds: 30, milliseconds: 990),
    Duration(seconds: 37, milliseconds: 0),
    Duration(seconds: 42, milliseconds: 520),
    Duration(seconds: 46, milliseconds: 920),
    Duration(seconds: 48, milliseconds: 900),
    Duration(seconds: 52, milliseconds: 820),
    Duration(seconds: 54, milliseconds: 820),
    Duration(seconds: 57, milliseconds: 320),
    Duration(minutes: 1, seconds: 1, milliseconds: 20),
    Duration(minutes: 1, seconds: 3, milliseconds: 420),
    Duration(minutes: 1, seconds: 7, milliseconds: 0),
    Duration(minutes: 1, seconds: 10, milliseconds: 110),
    Duration(minutes: 1, seconds: 13, milliseconds: 70),
    Duration(minutes: 1, seconds: 16, milliseconds: 70),
    Duration(minutes: 1, seconds: 19, milliseconds: 120),
    Duration(minutes: 1, seconds: 23, milliseconds: 120),
    Duration(minutes: 1, seconds: 25, milliseconds: 120),
    Duration(minutes: 1, seconds: 29, milliseconds: 320),
    Duration(minutes: 1, seconds: 31, milliseconds: 620),
    Duration(minutes: 1, seconds: 34, milliseconds: 520),
    Duration(minutes: 1, seconds: 37, milliseconds: 420),
    Duration(minutes: 1, seconds: 42, milliseconds: 20),
    Duration(minutes: 1, seconds: 43, milliseconds: 320),
    Duration(minutes: 1, seconds: 47, milliseconds: 620),
    Duration(minutes: 1, seconds: 49, milliseconds: 420),
    Duration(minutes: 1, seconds: 53, milliseconds: 620),
    Duration(minutes: 1, seconds: 55, milliseconds: 220),
    Duration(minutes: 2, seconds: 0, milliseconds: 20),
    Duration(minutes: 2, seconds: 1, milliseconds: 620),
    Duration(minutes: 2, seconds: 5, milliseconds: 920),
    Duration(minutes: 2, seconds: 7, milliseconds: 720),
    Duration(minutes: 2, seconds: 10, milliseconds: 280),
    Duration(minutes: 2, seconds: 14, milliseconds: 20),
    Duration(minutes: 2, seconds: 16, milliseconds: 220),
    Duration(minutes: 2, seconds: 19, milliseconds: 720),
    Duration(minutes: 2, seconds: 22, milliseconds: 220),
    Duration(minutes: 2, seconds: 26, milliseconds: 20),
    Duration(minutes: 2, seconds: 28, milliseconds: 520)
  ]);
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
          widget._audioPlayer.builderCurrentPosition(
              builder: ((context, position) {
            var timing = widget._test.getTiming();
            for (int i = timing.length - 1; i > -1; i--) {
              if (timing[i].inMinutes >= position.inMilliseconds) {
                widget._idxText = i;
                break;
              }
            }
            return Text(widget._test.getString()[widget._idxText]);
          }))
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
