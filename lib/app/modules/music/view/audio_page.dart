// ignore_for_file: must_be_immutable, lines_longer_than_80_chars

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music/utils/constans.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioPage extends StatefulWidget {
  AudioPage({required this.model, super.key});

  SongModel model;

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  double currentPosition = 0;
  double totalDuration = 1;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.onPositionChanged.listen(
      (Duration duration) {
        setState(() {
          currentPosition = duration.inSeconds.toDouble();
          if (currentPosition == totalDuration) {
            isPlaying = false;
          }
        });
      },
    );

    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        totalDuration = duration.inSeconds.toDouble();
      });
    });
    _playPause(widget.model.data);
  }

  Future<void> _playPause(String filePath) async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play(DeviceFileSource(filePath));
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    final formattedDuration = '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';

    return formattedDuration;
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 44, 72, 95),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Reproductor',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: const EdgeInsets.all(50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white.withOpacity(0.3),
              ),
              child: const Icon(
                Icons.music_note,
                color: Colors.white,
                size: 80,
              ),
            ),
            Column(
              children: [
                Text(
                  widget.model.displayName,
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Artista :${(widget.model.artist == null || widget.model.artist!.contains('unknown')) ? 'No Artist' : widget.model.artist!}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const Center(
              child: Icon(
                Icons.favorite_border,
                color: Colors.red,
              ),
            ),
            Column(
              children: [
                Slider(
                  activeColor: Colors.cyan[800],
                  inactiveColor: Colors.grey,
                  max: totalDuration,
                  value: currentPosition,
                  onChanged: (double value) {
                    setState(() {
                      currentPosition = value;
                    });
                  },
                  onChangeEnd: (double value) {
                    audioPlayer.seek(Duration(seconds: value.toInt()));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatDuration(currentPosition.toInt()),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        formatDuration(totalDuration.toInt()),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 20,
                  color: Colors.transparent,
                ),
                InkWell(
                  onTap: () async {
                    await _playPause(widget.model.data);
                  },
                  borderRadius: BorderRadius.circular(100),
                  child: CircleAvatar(
                    backgroundColor: const Color.fromARGB(193, 235, 77, 77),
                    child: Icon(
                      isPlaying ? Icons.pause_sharp : Icons.play_arrow,
                      color: ConstantsApp.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
