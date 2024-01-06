// ignore_for_file: must_be_immutable

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class AudioPage extends StatefulWidget {
  AudioPage({required this.filePath, super.key});

  String filePath;

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
      (Duration duration) => setState(() {
        currentPosition = duration.inSeconds.toDouble();
      }),
    );

    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        totalDuration = duration.inSeconds.toDouble();
      });
    });
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

    // ignore: lines_longer_than_80_chars
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
      backgroundColor: const Color.fromARGB(255, 44, 72, 95),
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
          'Reproductor Musical',
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
                  widget.filePath.split('/').last,
                  style: const TextStyle(color: Colors.white),
                ),
                const Text(
                  'Artista',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            const Center(
              child: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
            ),
            Column(
              children: [
                Slider(
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
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                await _playPause(widget.filePath);
              },
              child: Text(isPlaying ? 'Pausar' : 'Reproducir'),
            ),
          ],
        ),
      ),
    );
  }
}
