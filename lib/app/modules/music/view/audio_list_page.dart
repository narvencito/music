// ignore_for_file: lines_longer_than_80_chars, library_private_types_in_public_api, omit_local_variable_types, prefer_final_locals, inference_failure_on_instance_creation

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:music/app/config/routes_app.dart';
// import 'package:music/app/modules/music/audio.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioListPage extends StatefulWidget {
  const AudioListPage({super.key});

  @override
  _AudioListPageState createState() => _AudioListPageState();
}

class _AudioListPageState extends State<AudioListPage> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  List<File> audioFiles = [];

  @override
  void initState() {
    super.initState();
    // _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    var statusStorage = await Permission.storage.status;
    var statusAudio = await Permission.audio.status;
    //var statusVideo = await Permission.videos.status;
    final android = await deviceInfo.androidInfo;

    if (android.version.sdkInt < 33 && !statusStorage.isGranted) {
      statusStorage = await Permission.storage.request();
      if (statusStorage.isGranted) {
        await _getAudioFiles();
      }
    } else if (!statusAudio.isGranted) {
      statusAudio = await Permission.audio.request();
      if (statusAudio.isGranted) {
        await _getAudioFiles();
      }
    } else {
      await _getAudioFiles();
    }
  }

  Future<void> _getAudioFiles() async {
    List<FileSystemEntity> files = [];
    try {
      files = await _listFiles(await _pickDirectory2());
    } catch (e) {
      // print('Error al obtener archivos: $e');
      rethrow;
    }

    setState(() {
      audioFiles = List<File>.from(files);
    });
  }

  Future<List<FileSystemEntity>> _listFiles(Directory? directory) async {
    List<FileSystemEntity> files = [];
    try {
      for (final entity in directory!.listSync()) {
        if (entity is File && (entity.path.endsWith('.mp3') || entity.path.endsWith('.wav'))) {
          // objectbox.audioList();
          files.add(entity);
        } else if (entity is Directory) {
          files.addAll(await _listFiles(entity));
        }
      }
    } catch (e) {
      rethrow;
    }
    return files;
  }

  Future<Directory?> _pickDirectory2() async {
    Directory? directory;
    String? directoryPath = await FilePicker.platform.getDirectoryPath();

    if (directoryPath != null) {
      var directoryFile = File(directoryPath);
      return Directory(directoryFile.path);
    } else {
      return directory;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Archivos de Audio'),
      ),
      body: audioFiles.isEmpty
          ? Center(
              child: TextButton(
                onPressed: _requestPermissions,
                child: const Text('Seleccione directorio de reproduccion'),
              ),
            )
          : ListFiles(audioFiles: audioFiles),
    );
  }
}

class ListFiles extends StatelessWidget {
  const ListFiles({
    required this.audioFiles,
    super.key,
  });

  final List<File> audioFiles;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: audioFiles.length,
      itemBuilder: (context, index) {
        final file = audioFiles[index];
        return ListTile(
          title: Text(file.path.split('/').last),
          onTap: () {
            Navigator.pushNamed(
              context,
              RoutesApp.audio,
              arguments: file.path,
            );
          },
        );
      },
    );
  }
}
