// ignore_for_file: lines_longer_than_80_chars, library_private_types_in_public_api

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:music/music/music.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ListMusicPage extends StatefulWidget {
  const ListMusicPage({super.key});

  @override
  _ListMusicPageState createState() => _ListMusicPageState();
}

class _ListMusicPageState extends State<ListMusicPage> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  List<File> audioFiles = [];

  @override
  void initState() {
    super.initState();
    _requestPermissions();
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

    // if (!status.isGranted) {
    //   status = android.version.sdkInt < 33 ?  : PermissionStatus.granted;
    //   // status =  await Permission.storage.request() ;
    // }

    // if (status.isGranted) {
    //   await _getAudioFiles();
    // } else {
    //   // Manejar el caso en que el usuario no otorga los permisos
    // }
  }

  Future<void> _getAudioFiles() async {
    List<FileSystemEntity> files = [];
    try {
      files = await _listFiles(await _pickDirectory());
    } catch (e) {
      print('Error al obtener archivos: $e');
    }

    setState(() {
      audioFiles = List<File>.from(files);
    });
  }

  Future<List<FileSystemEntity>> _listFiles(Directory? directory) async {
    List<FileSystemEntity> files = [];
    try {
      for (var entity in directory!.listSync()) {
        if (entity is File && entity.path.endsWith('.mp3')) {
          files.add(entity);
        } else if (entity is Directory) {
          files.addAll(await _listFiles(entity));
        }
      }
    } catch (e) {
      print('Error al listar archivos en ${directory!.path}: $e');
      throw e; // Propagar el error para manejarlo en _getAudioFiles
    }
    return files;
  }

  Future<Directory?> _pickDirectory() async {
    Directory? directory;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (result != null) {
      String filepath = result.files.first.path!;
      var directoryFile = File(filepath);
      print('Directorio seleccionado: ${directoryFile.parent.path}');
      return directory = directoryFile.parent;
      // Ahora puedes trabajar dentro de este directorio
    } else {
      print('No se seleccionó ningún directorio.');
      return directory;
    }
  }

  // Future<List<FileSystemEntity>> _listFiles(Directory directory) async {
  //   List<FileSystemEntity> files = [];
  //   try {
  //     for (var entity in directory.listSync()) {
  //       if (entity is File && entity.path.endsWith('.mp3')) {
  //         files.add(entity);
  //       } else if (entity is Directory) {
  //         files.addAll(await _listFiles(entity));
  //       }
  //     }
  //   } catch (e) {
  //     print('Error al listar archivos: $e');
  //   }
  //   return files;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Archivos de Audio'),
        actions: [
          IconButton(
            icon: Icon(Icons.music_note),
            onPressed: () async {
              await _requestPermissions();
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: audioFiles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(audioFiles[index].path.split('/').last),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MusicPage(filePath: audioFiles[index].path),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
