// ignore_for_file: lines_longer_than_80_chars, inference_failure_on_function_return_type, always_declare_return_types, type_annotate_public_apis, library_private_types_in_public_api, unnecessary_statements

import 'package:flutter/material.dart';
import 'package:music/app/config/routes_app.dart';
import 'package:music/utils/constans.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongPage extends StatefulWidget {
  const SongPage({super.key});

  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    final logConfig = LogConfig(logType: LogType.DEBUG);
    _audioQuery.setLogConfig(logConfig);
    checkAndRequestPermissions();
  }

  checkAndRequestPermissions({bool retry = false}) async {
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );

    _hasPermission ? setState(() {}) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Listado de musicas',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0,
      ),
      body: Center(
        child: !_hasPermission
            ? noAccessToLibraryWidget()
            : FutureBuilder<List<SongModel>>(
                future: _audioQuery.querySongs(
                  orderType: OrderType.ASC_OR_SMALLER,
                  uriType: UriType.EXTERNAL,
                  ignoreCase: true,
                ),
                builder: (context, item) {
                  if (item.hasError) return Text(item.error.toString());

                  if (item.data == null) return const CircularProgressIndicator();

                  if (item.data!.isEmpty) return const Text('Nothing found!', style: TextStyle(color: Colors.white));

                  return ListView.builder(
                    itemCount: item.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          item.data![index].title,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          (item.data![index].artist == null || item.data![index].artist!.contains('unknown'))
                              ? 'No Artist'
                              : item.data![index].artist!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: const Icon(Icons.arrow_forward_rounded),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white.withOpacity(0.3),
                          ),
                          child: const Icon(
                            Icons.music_note,
                            color: ConstantsApp.purpleSecondaryColor,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, RoutesApp.audio, arguments: item.data![index]);
                        },
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  Widget noAccessToLibraryWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.redAccent.withOpacity(0.5),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('La aplicación no tiene acceso a la libreria'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => checkAndRequestPermissions(retry: true),
            child: const Text('Allow'),
          ),
        ],
      ),
    );
  }
}
